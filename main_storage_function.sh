#! /bin/bash

function search_dir_key()
{
    IFS=' - '

    while read key path; do
        if [ $key = $KEY ]; then
            return $path
        fi
    done < ~/.storage_repo

    echo "The key $KEY does not exist"
    exit 1
}

function check_install_option()
{
    if [ $# -ne 1 ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
        print_usage
    fi

    if [ $1 = "-b" ] || [ $1 = "--backup" ]; then
        SOURCE_DIR=~/$DIRECTORY_BACKUP
        DEST_DIR=~/$STORAGE_BACKUP/$(basename $DIRECTORY_BACKUP)
        echo -e "Backup your $DIRECTORY_BACKUP data in Dropbox directory [$SOURCE_DIR]\n"
    elif [ $1 = "-u" ] || [ $1 = "--update" ]; then
        SOURCE_DIR=~/$STORAGE_BACKUP/$(basename $DIRECTORY_BACKUP)
        DEST_DIR=~/$DIRECTORY_BACKUP
        echo -e "Update your $DIRECTORY_BACKUP data in $DIRECTORY_BACKUP directory [$SOURCE_DIR]\n"
    else
        echo -e "\033[1;31mError:\033[0m Bad option \"$1\" used\n"
        print_usage
    fi

    if [ ! -d $SOURCE_DIR ]; then
        echo -e "\033[1;31mError:\033[0m $DIRECTORY_BACKUP directory [$SOURCE_DIR] is" \
            "missing.\n\nYou have probably mix up --backup and --update options" \
            "...\n\nSee usage with --help option"
        exit 1
    fi
}
