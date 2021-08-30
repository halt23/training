#!/bin/sh
# rsync-training.sh
#
# Use this script after running rst-to-myst.
#
# It synchronizes all documentation files from the original training directory
# to the rsync-training directory where they can be built.
#
# Then you can build both .rst and .md docs to compare side-by-side.
#
# To run this script, change directory to the script, then issue the following
# command:
#
# ./rsync-training.sh
#
# A detailed activity log is appended to ./rsync-training.log.
#
# NOTE: To escape spaces in directory names, you need to use double-quotes
# around the rsync command argument variable.
#
# Common options from https://download.samba.org/pub/rsync/rsync.html
#
#      --delete                delete extraneous files from dest dirs
#      --force                 force deletion of dirs even if not empty
#  -g, --group                 preserve group
#  -o, --owner                 preserve owner (super-user only)
#  -p, --perms                 preserve permissions
#  -r, --recursive             recurse into directories
#  -t, --times                 preserve modification times
#  -v, --verbose               increase verbosity
#  -z, --compress              compress file data during the transfer
#  -C, --cvs-exclude           auto-ignore files in the same way CVS does
#  -O, --omit-dir-times        omit directories from --times

cwd=".."
date=`date "+DATE: %Y-%m-%d %H:%M:%S"`

# Copy all files needed to build docs except *.md
opts="-gioprtvzCO \
    --include-from=$cwd/rst2myst/rsync-training-include.txt \
    --exclude-from=$cwd/rst2myst/rsync-training-exclude.txt \
    --delete --force"
# Move *.md only and delete source
optsmd="-gioprtvzCO \
    --include-from=$cwd/rst2myst/rsync-training-md-include.txt \
    --exclude-from=$cwd/rst2myst/rsync-training-md-exclude.txt \
    --delete --force --remove-source-files"

# set the log file
log="$cwd/rst2myst/rsync-training.log"

# set source and destination
src="$cwd/"
dest="$cwd/rst2myst/training"

echo "#### $date ####" >> $log
echo "" >> $log

echo "--- Move all files needed to build docs except *.md ---" >> $log
echo "rsync $opts $src $dest >> $log 2>&1" >> $log
echo "" >> $log
rsync $opts $src $dest >> $log 2>&1
echo "" >> $log
echo "" >> $log
echo "--- Move *.md only and delete source ---" >> $log
echo "rsync $optsmd $src $dest >> $log 2>&1" >> $log
rsync $optsmd $src $dest >> $log 2>&1
echo "" >> $log
echo "" >> $log
echo "" >> $log
