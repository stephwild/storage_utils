#! /bin/bash

FUNCTION_DIR=~/.script_function
DEST_DIR=$(realpath $(eval echo \$$#))

function print_usage()
{
    echo 'Here print my Help'
    exit 0
}

function print_error ()
{
    echo -e "\033[1;31mError:\033[0m $1"
    exit 1
}

function create_if_missing_dir ()
{
    if [ ! -d $1 ]; then
        echo "Create $1 directory"
        mkdir $1
    fi
}

function get_relative_path ()
{
    REMAINING_PATH=$2
    REL_PATH=""

    while [ $1 != $REMAINING_PATH ]; do
        if [ $REMAINING_PATH = '/' ]; then
            print_error "Directory '$2' does not belong to '$KEY' repo"
        fi

        REL_PATH="$(basename $REMAINING_PATH)/$REL_PATH"
        REMAINING_PATH=$(dirname $REMAINING_PATH)
    done

    REL_PATH="/$REL_PATH"
}

function add_file_dir()
{
    # Loop just to handle directory
    for i in $@; do
        filename_i=$(basename $i)

        # FILE_REL_PATH is the path give in $# (dest directory) but truncated by DIR_KEY
        # and where the subdirectories is added
        FILE_REL_PATH=${REL_PATH}${SUB_DIR}

        if [ -d $i ]; then
            OLD_SUB_DIR=$SUB_DIR
            SUB_DIR="${SUBDIR}$filename_i/"

            create_if_missing_dir ${DIR_KEY}${FILE_REL_PATH}$filename_i
            add_file_dir $(for v in `ls $i`; do echo $i/$v; done)

            SUB_DIR=$OLD_SUB_DIR
            continue
        fi

        echo "$FILE_REL_PATH - $filename_i" >>  $DIR_KEY/.storage_data/${KEY}.data

        if [ $MOVE -eq 1 ]; then
            mv $i ${DIR_KEY}$FILE_REL_PATH
        else
            cp $i ${DIR_KEY}$FILE_REL_PATH
        fi

        echo "Add $filename_i in $FILE_REL_PATH" | tee >> $DIR_KEY/.storage_data/${KEY}.log
    done
}

if [ $# -lt 3 ] || [ $1 = '--help' ] || [ $1 = '-h' ]; then
    print_usage
fi

if [ ! -f ~/.storage_repo ]; then
    print_error "You need a repo before adding something to it... Create one by using add_repo.sh"
fi

if [ ! -f  $FUNCTION_DIR/main_storage_function.sh ]; then
    print_error "File 'main_storage_function' does not exist. Add it in $FUNCTION_DIR"
fi

# For search_dir_key function
source $FUNCTION_DIR/main_storage_function.sh

if [ $1 = '-m' ] || [ $1 = '--move' ]; then
    MOVE=1
    BEGIN=3
    KEY=$2
else
    MOVE=0
    BEGIN=2
    KEY=$1
fi

search_dir_key $KEY
DIR_KEY=$SEARCH_DIR_KEY

if [ ! -f $DIR_KEY/.storage_data/${KEY}.storage ]; then
    echo "Warning: File '$DIR_KEY/.storage_data/${KEY}.storage' does not exist"
fi

create_if_missing_dir $DIR_KEY/.storage_data
create_if_missing_dir $DEST_DIR

# Get env var $REL_PATH: destination dir of the file relative to $DIR_KEY
get_relative_path $DIR_KEY $DEST_DIR

# Loop all files: BEGIN to $# - 1 ($# is the destination directory)
for i in `seq $BEGIN $(($# - 1))`; do
    SUB_DIR=""
    add_file_dir $(eval echo \$$i)
done

sort $DIR_KEY/.storage_data/${KEY}.data > $DIR_KEY/.storage_data/.tmp && \
    mv $DIR_KEY/.storage_data/.tmp $DIR_KEY/.storage_data/${KEY}.data
