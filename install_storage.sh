#! /bin/bash

function print_usage ()
{
    echo -e "Usage:\t$0 OPTION KEY\n"

    echo -e "Description: Backup or update KEY repo.\n"

    echo -e "OPTION\n------\n"
    echo -e "-u | --update :\n\tUpdate your storage repo with Dropbox"
    echo -e "-b | --backup :\n\tBackup your storage repo to Dropbox"
    echo -e "-h | --help : \n\tPrint this usage\n"

    echo -e "Warning: KEY repo must be add with add_repo.sh"
}

function print_error ()
{
    echo -e "\033[1;31mError:\033[0m $@"
    exit 1
}

# Set DEBUG var to '-v' to debug this script
DEBUG=""
KEY=$2
FUNCTION_DIR=~/.script_function

if [ ! -f $FUNCTION_DIR/backup_storage_function.sh ] ||
    [ ! -f $FUNCTION_DIR/main_storage_function.sh ]; then
        print_error "Main script 'backup_storage_function.sh' or/and" \
        "'main_storage_function.sh' is missing.\n\nPut them in '$FUNCTION_DIR' directory."
fi

source $FUNCTION_DIR/main_storage_function.sh
source $FUNCTION_DIR/backup_storage_function.sh

search_dir_key $KEY
REPO_DIR=$SEARCH_DIR_KEY

if [ ! -f $REPO_DIR/.storage_data/${KEY}.storage ]; then
    print_error "${KEY}.storage is missing in $REPO_DIR/.storage_data.\n" \
        "\nYou need to have at least this file in order to know where is your" \
        "'$KEY' storage directory"
fi

STORAGE_BACKUP=$(head -n 1 $REPO_DIR/.storage_data/${KEY}.storage)

check_install_option "$@"

# REPO_DIR need to have at least the STORAGE_DIR value for his first line

if [ ! -f $SOURCE_DIR/.storage_data/${KEY}.data -o \
    $(wc -l $SOURCE_DIR/.storage_data/${KEY}.data | cut -d ' ' -f 1) -eq 0 ]; then
    print_error "You don't have data file to backup\n\nAdd some by using add_storage.sh"
fi

#############################
#    Backup/Update files    #
#############################

# Backup data files
# -----------------

OLD_IFS=$IFS
IFS=$' -\n'

OLD_DIR=$(head -n 1 $SOURCE_DIR/.storage_data/${KEY}.data | cut -d '-' -f 1)

FILES_DIR=""
DIR_CREATED=1

while read directory filename; do
    if [ $OLD_DIR != $directory ]; then
        add_file_dir $OLD_DIR $FILES_DIR
        FILES_DIR=""
        DIR_CREATED=1
    fi

    if [ $DIR_CREATED -eq 1 ]; then
        if is_parent $OLD_DIR $directory &&  [ $OLD_DIR != '/' ]; then
            create_dir $directory "="
        else
            create_dir $directory "#"
        fi

        OLD_DIR=$directory
        DIR_CREATED=0
    fi

    FILES_DIR+="$filename "
done < $SOURCE_DIR/.storage_data/${KEY}.data

add_file_dir $OLD_DIR $FILES_DIR

IFS=$OLD_IFS

# Backup config files of the repo
# -------------------------------

create_dir "/.storage_data/" "-"
cp -uv $SOURCE_DIR/.storage_data/${KEY}.data $DEST_DIR/.storage_data/
cp -uv $SOURCE_DIR/.storage_data/${KEY}.log $DEST_DIR/.storage_data/
