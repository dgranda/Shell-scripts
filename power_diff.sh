#!/bin/bash
#################################################
# Advanced diff v0.11 - 25/09/2007
# It compares archives (zip, jar, tar.gz, tar.bz2) recursively
# so when a compressed file is found, it is uncompressed
# and files inside compared as well
# Diff output is: diff_[file1]_vs_[file2]_[timestamp].txt
#################################################
TEMP="$HOME/borrar"
BIN_FILES="$TEMP/bin_files"
num_loop=0
MAX_LOOPS=5
# Extracts content from compressed file ($1) to temporary location ($2)
function extract {
   if [ ! -d $2 ]; then
      mkdir -p $2
      # Added support for other compression types: bz2, tar.gz
      # No support for more than 1 tar package inside compressed file
      format=`file $1 | awk '{ print $2 }' | tr "[:upper:]" "[:lower:]"`
      case $format in
         "zip")
            unzip -q $1 -d $2
         ;;
         "bzip2")
            # Modified for non GNU tar compatibility            
            # tar -xjf $1 -C $2
            bzip2 -d -c $1 | (cd $2;tar xf - )
         ;;
         "gzip")
            # Modified for non GNU tar compatibility
            # tar -xzf $1 -C $2
            gzip -d -c $1 | (cd $2;tar xf - )
         ;;
         *)
            echo ""
            echo "No valid file format encountered ($1): $format"
            return -1
      esac
   fi
}
# Returns 1 if there are more files to compare, 0 otherwise
# TO DO: optimize
function loop {
   echo -n "Uncompressing content... "
   if [ $num_loop -lt 1 ]; then
      EXT_DIR1=`echo "$TEMP/$1" | sed s/\[\.\]/_/g`
      EXT_DIR2=`echo "$TEMP/$2" | sed s/\[\.\]/_/g`
   else
      EXT_DIR1=`echo "$1" | sed s/\[\.\]/_/g`
      EXT_DIR2=`echo "$2" | sed s/\[\.\]/_/g`
   fi
   extract $1 $EXT_DIR1
   # Check if file format is supported
   if [ $? -eq 255 ]; then
      remove_temp
      exit -1
   fi
   extract $2 $EXT_DIR2
   if [ $? -eq 255 ]; then
      remove_temp
      exit -1
   fi
   echo "OK"
   FILE1=`basename "$1"`
   FILE2=`basename "$2"`
   OUTPUT=diff_"$FILE1"_vs_"$FILE2"_`date +%H%M%S_%d%m%y`.txt
   diff -br -U0 $EXT_DIR1 $EXT_DIR2 > $OUTPUT
   if [ ! -s $OUTPUT ]; then
      echo "No differences found"
      #rm -f $OUTPUT
      return 0
   else
      grep -i binary $OUTPUT | awk '{ if(NF eq 6)print($3" "$5);}' > $BIN_FILES
      if [ -s $BIN_FILES ]; then
         echo "Found `wc -w $BIN_FILES | awk '{ print $1 }'` more binary files to compare"
         return 1
      else
         return 0
      fi
   fi
}
function remove_temp {
   echo -n "Removing temporal files... "
   rm -f $BIN_FILES
   if [ -d $TEMP ]; then
      rm -rf $TEMP
   fi
   echo "OK"
}
###############################
# Here start the main program #
###############################
if [ $# -lt 2 ]; then
   echo "Usage: `basename $0` file1 file2"
   exit -1
fi
if [ $1 == $2 ]; then
   echo "Files are the same, no need to diff them"
   exit 0
fi
loop $1 $2
if [ $? -gt 0 ]; then
   while read line; do
      let num_loop+=1
      if [ $num_loop -gt $MAX_LOOPS ]; then
         echo "$NUM_LOOPS loops reached. Maybe you enter into an infinite loop, increase MAX_LOOPS variable otherwise. Exiting"
         exit -1
      fi
      TEMP1=`echo "$line" | cut -d " " -f1`
      TEMP2=`echo "$line" | cut -d " " -f2`
      echo "   `echo "$TEMP1" | awk -F/ '{ print $(NF-num)"/"$NF}' num=$num_loop` <=> `echo "$TEMP2" | awk -F/ '{ print $(NF-num)"/"$NF}' num=$num_loop`"
      loop $TEMP1 $TEMP2
   done < $BIN_FILES
fi

# Removing useless paths from output file
sed "s|$TEMP/||g" $OUTPUT > tmp
mv tmp $OUTPUT

remove_temp

exit 0
