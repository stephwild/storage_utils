#! /bin/bash

# Set DEBUG var to '-v' to debug this script
DEBUG=""
KEY=$(eval echo \$$2)

REPO_DIR=$(search_dir_key $KEY)

# REPO_DIR need to have at least the STORAGE_DIR value for his first line
if [ ! -d $REPO_DIR/.storage_data/${KEY}.data ]; then
    echo "\033[1;31mError:\033[0m ${KEY}.data is missing"
    exit 1
fi

STORAGE_BACKUP=$(head -n 1 $REPO_DIR/.storage_data/${KEY}.data)

FUNCTION_DIR=~/.function_script

function print_usage ()
{
    echo -e "Usage:\t$0 OPTION KEY\n\n"

    echo -e "Backup or update KEY repo."
    echo -e "Warning: KEY repo must be add with add_repo.sh\n\n"

    echo -e "OPTION\n------\n"
    echo -e "-u | --update :\n\tUpdate your storage repo with Dropbox"
    echo -e "-b | --backup :\n\tBackup your storage repo to Dropbox"
    echo -e "-h | --help : \n\tPrint this usage"
}

if [ ! -f $FUNCTION_DIR/backup_storage_function.sh ] ||
    [ ! -f $FUNCTION_DIR/main_storage_function.sh ]; then
     echo -e "\033[1;31mError:\033[0m Main script \"backup_storage_function.sh\" or/and" \
     "\"main_storage_function.sh\" is missing... Put them in \"$FUNCTION_DIR\" directory."
     exit 1
fi

source $FUNCTION_DIR/main_storage_function.sh
source $FUNCTION_DIR/backup_storage_function.sh

check_install_option $@

if [ ! -f $SOURCE_DIR/.storage_data/${KEY}.data ]; then
    echo -e "\033[1;31mError:\033[0m Data config file is missing.\n\nYou" \
    "need to add data files with add_storage.sh script in order to use this script"
    exit 1
fi

#############################
#    Backup/Update files    #
#############################

# Backup data files
# -----------------

IFS=' - '
FILES_DIR=""

while read directory filename; do
    FILES_DIR+="filename "

    if [ $OLD_DIR != $directory ]; then
        if is_parent $OLD_DIR $directory; then
            create_dir $directory "="
        else
            create_dir $directory "#"
        fi

        add_file_dir $directory $FILES_DIR
        OLD_DIR=$directory
    fi
done < $SOURCE_DIR/.storage_data/${KEY}.data

# Backup config files of the repo
# -------------------------------

create_dir .storage_data "-"
cp -uv $SOURCE_DIR/.storage_data/${KEY}.data $DEST_DIR/.storage_data
cp -uv $SOURCE_DIR/.storage_data/${KEY}.log $DEST_DIR/.storage_data
