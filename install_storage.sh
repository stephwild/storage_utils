#! /bin/bash

# Set DEBUG var to '-v' to debug this script
DEBUG=""
KEY=$(eval echo \$$1)

source ~/.script_functions/storage_check.sh

STORAGE_BACKUP=$(head -n 1 ~/.storage_repo)
DIRECTORY_BACKUP=$(search_dir_key $KEY)

function print_usage ()
{
    echo -e "Usage:\t$0 OPTION\n\nOPTION\n------\n"

    echo -e "-u | --update :\n\tUpdate your storage repo with Dropbox"
    echo -e "-b | --backup :\n\tBackup your storage repo to Dropbox"
    echo -e "-h | --help : \n\tPrint this usage"

    exit 1
}

SCRIPT_DIR=~/.pretty_script

if [ ! -f $SCRIPT_DIR/backup_function.sh ] || [ ! -f $SCRIPT_DIR/dropbox_option.sh ]; then
     echo -e "\033[1;31mError:\033[0m Main script \"backup_function.sh\" or/and" \
     "\"dropbox_option.sh\" is missing... Put them in \"$SCRIPT_DIR\" directory."
     exit 1
fi

source $SCRIPT_DIR/dropbox_option.sh
source $SCRIPT_DIR/backup_function.sh

option_check_out $@

if [ ! -f $SOURCE_DIR/.storage_data/${KEY}.data ]; then
    echo -e "\033[1;31mError:\033[0m documentation data files are missing.\n\nYou" \
    "need to configure a \"documentation.data\" file in" \
    "\"$SOURCE_DIR/.script_data\" to use this script. This file will be used" \
    "to know wich files will be backed up or updated.\nIt must contain the" \
    "environment variables used in \"install_documentation.sh\"."
    exit 1
fi

source $SOURCE_DIR/.storage_data/${KEY}.data

IFS=' - '

while read directory filename is_updated; do
    FILES_DIR+=' filename'

    if [ $OLD_DIR != $directory ]; then
        create_dir $directory "="
        add_file_dir $directory $FILES_DIR
        OLD_DIR=$directory
    fi
done

create_dir $DEST_DIR "#"
add_file_dir "" "vocabulary" "TODO"

create_dir "$DEST_DIR/coding" "="
add_file_dir "coding" $CODING

create_dir "$DEST_DIR/electronic" "="
add_file_dir "electronic" $ELECTRONIC

create_dir "$DEST_DIR/encryption" "="
add_file_dir "encryption" $ENCRYPTION

create_dir "$DEST_DIR/file_format" "="
add_file_dir "file_format" $FILE_FORMAT

create_dir "$DEST_DIR/fun" "="
add_file_dir "fun" $FUN

create_dir "$DEST_DIR/hacking" "="
add_file_dir "hacking" $HACKING

create_dir "$DEST_DIR/linux_system" "="
add_file_dir "linux_system" $LINUX_SYSTEM

create_dir "$DEST_DIR/network" "="
add_file_dir "network" $NETWORK

create_dir "$DEST_DIR/unsorted" "="
add_file_dir "unsorted" $UNSORTED

create_dir "$DEST_DIR/.script_data" "="
add_file_dir ".script_data" "documentation.data"
