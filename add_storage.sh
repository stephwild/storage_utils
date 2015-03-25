#! /bin/bash

FUNCTION_DIR=~/.script_function

function print_usage()
{
    echo -e "Usage:\t$(basename $0) [OPTION] KEY FILE... DIRECTORY\n"
    echo -e "Description: Copy FILES to DIRECTORY\n"
    echo -e "OPTION\n------\n"
    echo -e "-m | --move:\n\tMove instead of copy"
    echo -e "-h | --help:\n\tPrint Usage"
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

            create_if_missing_dir $DIR_KEY/$FILE_REL_PATH/$filename_i
            add_file_dir $(for v in `ls $i`; do echo $i/$v; done)

            SUB_DIR=$OLD_SUB_DIR
            continue
        fi

        echo -e "$FILE_REL_PATH\t$filename_i" >>  $DIR_KEY/.storage_data/${KEY}.data

        if [ $MOVE -eq 1 ]; then
            mv $i ${DIR_KEY}$FILE_REL_PATH
        else
            cp $i ${DIR_KEY}$FILE_REL_PATH
        fi

        echo "Add '$filename_i' in $FILE_REL_PATH" | tee --append $DIR_KEY/.storage_data/${KEY}.log
    done
}

if [ "$1" = '--help' ] || [ "$1" = '-h' ]; then
    print_usage
    exit 0
elif [ $# -lt 3 ]; then
    echo -e "\033[1;31mError:\033[0m Bad number of options/arguments\n"
    print_usage
    exit 1
fi

if [ ! -f ~/.storage_repo ]; then
    print_error "You need a repo before adding something to it... Create one by using add_repo.sh"
fi

if [ ! -f  $FUNCTION_DIR/main_storage_function.sh ]; then
    print_error "File 'main_storage_function' does not exist. Add it in $FUNCTION_DIR"
fi

DEST_DIR=$(realpath $(eval echo \$$#))

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
    FILE_LOOKED=$(eval echo \$$i)

    if [ ! -d $FILE_LOOKED ]; then
        add_file_dir $FILE_LOOKED
    else
        for i in $(ls $FILE_LOOKED); do
            add_file_dir $FILE_LOOKED/$i
        done
    fi
done

sort $DIR_KEY/.storage_data/${KEY}.data > $DIR_KEY/.storage_data/.tmp && \
    mv $DIR_KEY/.storage_data/.tmp $DIR_KEY/.storage_data/${KEY}.data
