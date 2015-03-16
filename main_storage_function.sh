#! /bin/bash

function search_dir_key ()
{
    if [ ! -f ~/.storage_repo ]; then
        echo -e "\033[1;31mError:\033[0m File '~/.storage_repo' is missing." \
           "Create one by using add_repo.sh"
        exit 1
    fi

    OLD_IFS=$IFS
    IFS=' - '

    while read key path; do
        if [ "$1" = $key ]; then
            SEARCH_DIR_KEY="$path"
            IFS=$OLD_IFS

            return 0
        fi
    done < ~/.storage_repo

    IFS=$OLD_IFS

    echo "The key $1 does not exist."
    echo "Add it with add_repo.sh $1 <name_dir> <storage_dir>"
    exit 1
}

function key_exist ()
{
    if [ ! -f ~/.storage_repo ]; then
        echo -e "\033[1;31mError:\033[0m File '~/.storage_repo' is missing." \
           "Create one by using add_repo.sh"
        exit 1
    fi

    OLD_IFS=$IFS
    IFS=' - '

    while read key path; do
        if [ "$1" = "$key" ]; then
            IFS=$OLD_IFS
            return 0
        fi
    done < ~/.storage_repo

    IFS=$OLD_IFS
    return 1
}

function is_parent ()
{
    if [ $1 = $(dirname $2) ]; then
        return 0
    fi

    return 1
}

function check_install_option ()
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        print_usage
        exit 0
    elif [ $# -ne 2 ]; then
        echo -e "\033[1;31mError:\033[0m Bad number of arguments used\n"
        print_usage
        exit 1
    fi

    if [ "$1" = "-b" ] || [ "$1" = "--backup" ]; then
        SOURCE_DIR=$REPO_DIR
        DEST_DIR=$STORAGE_BACKUP

        echo -e "Backup $KEY repo to storage directory " \
            "[$SOURCE_DIR -> $DEST_DIR]\n"
    elif [ "$1" = "-u" ] || [ "$1" = "--update" ]; then
        SOURCE_DIR=$STORAGE_BACKUP
        DEST_DIR=$REPO_DIR

        echo -e "Update $KEY repo by storage directory " \
           "[ $SOURCE_DIR -> $DEST_DIR ]\n"
    else
        echo -e "\033[1;31mError:\033[0m Bad option \"$1\" used\n"
        print_usage
        exit 1
    fi

    if [ ! -d $SOURCE_DIR ]; then
        echo -e "\033[1;31mError:\033[0m $SOURCE_DIR directory is" \
            "missing.\n\nYou have probably mix up --backup and --update" \
            " options...\n\nSee usage with --help option"
        exit 1
    fi
}
