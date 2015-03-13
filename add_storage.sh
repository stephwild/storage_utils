#! /bin/bash

FUNCTION_DIR=~/.script_function
DEST_DIR=$(realpath $#)

function print_usage()
{
    echo 'Here print my Help'
    exit 0
}

if [ $# -lt 3 || $1 = '--help' || $1 = '-h' ]; then
    print_usage
fi

if [ ! -d ~/.storage_repo ]; then
    echo "You need a repo before adding something to it... Create one by using add_repo.sh"
    exit 1
fi

if [ ! -d $DEST_DIR ]; then
    echo "You can't copy/move your file in '$DEST_DIR' because it's not a" \
    " directory or does not exist"
    exit 1
fi

function get_relative_path ()
{
    $REMAINING_PATH=$2
    $REL_PATH=""

    while $1 != $2; do
        if [ $REMAINING_PATH = '/' ]; then
            echo "Directory '$2' does not belong to $KEY repo"
            exit 1
        fi

        $REL_PATH+=$(basename $REMAINING_PATH)
        $REMAINING_PATH=$(dirname $REMAINING_PATH)
    done

    return $REL_PATH
}

function add_file_dir()
{
    # Loop just to handle directory
    for i in $@; do
        if [ -d $i ]; then
            add_file_dir $(for v in `ls $i`; do echo $i/$v; done) $DEST_DIR
            continue
        fi

        # FILE_REL_PATH is the path give in $# (dest directory) but truncated by DIR_KEY
        $FILE_REL_PATH=$(get_relative_path $DIR_KEY $DEST_DIR)

        echo "$FILE_REL_PATH - $(basename $i)" >>  $DIR_KEY/.storage_data/{$KEY}.data

        if [ $MOVE -eq 1 ]; then
            mv $i $DEST_DIR
            echo "Move $i in $FILE_REL_PATH" | tee > $DIR_KEY/.storage_data/${KEY}.log
        else
            cp $i $DEST_DIR
            echo "Copy $i in $FILE_REL_PATH" | tee > $DIR_KEY/.storage_data/${KEY}.log
        fi
    done
}

if [ $1 = '-m' ] || [ $1 = '--move' ]; then
    MOVE=1
    BEGIN=3
    KEY=$(eval echo \$$2)
else
    MOVE=0
    BEGIN=2
    KEY=$(eval echo \$$1)
fi

if [ ! -d  $FUNCTION_DIR/main_storage_function.sh ]; then
    echo "File 'main_storage_function' does not exist. Add it in $FUNCTION_DIR"
    exit 1
fi

source $FUNCTION_DIR/main_storage_function.sh

DIR_KEY=$(search_dir_key $KEY)

if [ ! -d $DIR_KEY/.storage_data/ ]; then
    mkdir $DIR_KEY/.storage_data || exit 1
fi

# Loop all files: BEGIN to $# - 1 ($# is the destination directory)
for i in `seq $BEGIN $(($# - 1))`; do
    add_file_dir $(eval echo \$$i)
done
