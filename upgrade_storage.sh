#! /bin/bash

function print_error ()
{
    echo -e "\033[1;31mError:\033[0m $@"
    exit 1
}

function print_usage ()
{
    echo -e "Usage:\t$(basename $0) OPTION\n"

    echo -e "Description: Backup or update all repo.\n"

    echo -e "OPTION\n------\n"
    echo -e "-u | --update :\n\tUpdate your storage repo with Dropbox"
    echo -e "-b | --backup :\n\tBackup your storage repo to Dropbox"
    echo -e "-h | --help : \n\tPrint this usage\n"
}

function option_checking_handler ()
{
    if [ $# -eq 0 ] || [ $1 = '-h' -o $1 = '--help' ]; then
        print_usage
        exit 0
    elif [ $# -ne 1 ]; then
        print_error "Bad number of args used"
    elif [ $1 = '-b' -o $1 = '--backup' ] || [ $1 = '-u' -o $1 = '--update' ]; then
        MODE=$1
    else
        print_error "Bad option used"
    fi
}

option_checking_handler $@

if [ ! -f ~/.storage_repo ]; then
    print_error "Miss .storage_repo file"
fi

IFS=$'\t'

# There always have a MODE set (this is ensure by option error checking)
if [ $MODE = '-b' ]; then
    ACTION='Backup'
else
    ACTION='Update'
fi

echo "$ACTION all repo"
echo "==============="

while read KEY rest; do
    echo
    echo "$ACTION $KEY repo"
    echo "----------------"
    echo

    install_storage.sh $MODE $KEY
done < ~/.storage_repo
