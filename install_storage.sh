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

if [ ! -f $REPO_DIR/.storage_data/${KEY}.data ]; then
    print_error "${KEY}.data is missing in $REPO_DIR/.storage_data.\n\n" \
        "You need to have at least this file in order to know where is your" \
        "'$KEY' storage directory"
fi

STORAGE_BACKUP=$(head -n 1 $REPO_DIR/.storage_data/${KEY}.data)

check_install_option "${@:1}"

# REPO_DIR need to have at least the STORAGE_DIR value for his first line

if [ ! -f $SOURCE_DIR/.storage_data/${KEY}.data ]; then
    print_error "Data config file is missing in '$SOURCE_DIR/.storage_data'." \
        "\n\nYou need to add data files with add_storage.sh script in order" \
        "to use this script or you need to add one in your storage directory"
fi

if [ $(wc -l $SOURCE_DIR/.storage_data/${KEY}.data | cut -d ' ' -f 1) -eq 1 ]; then
    print_error "No data file added\n\nAdd one by using add_storage.sh"
fi

#############################
#    Backup/Update files    #
#############################

# Backup data files
# -----------------

OLD_IFS=$IFS
IFS=$' -\n'

OLD_DIR=$(sed '1d' $SOURCE_DIR/.storage_data/${KEY}.data | head -n 1 \
    | cut -d '-' -f 1)

FILES_DIR=""

sed '1d' $SOURCE_DIR/.storage_data/${KEY}.data | while read directory filename
do
    FILES_DIR+="$filename "

    if [ $OLD_DIR != $directory ]; then
        if is_parent $OLD_DIR $directory; then
            create_dir $directory "="
        else
            create_dir $directory "#"
        fi

        add_file_dir $directory $FILES_DIR
        OLD_DIR=$directory
    fi
done

IFS=$OLD_IFS

# Backup config files of the repo
# -------------------------------

create_dir .storage_data "-"
cp -uv $SOURCE_DIR/.storage_data/${KEY}.data $DEST_DIR/.storage_data
cp -uv $SOURCE_DIR/.storage_data/${KEY}.log $DEST_DIR/.storage_data
