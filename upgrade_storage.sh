#! /bin/bash

function print_error ()
{
    echo -e "\033[1;31mError:\033[0m $@"
    exit 1
}

if [ $# -ne 1 ]; then
    print_error "Bad number of args used"
elif [ $1 = '-b' ] || [ $1 = '-u' ]; then
    MODE=$1
else
    print_error "Bad option used"
fi

if [ ! -f ~/.storage_repo ]; then
    print_error "Miss .storage_repo file"
fi

IFS=$'\t'

while read KEY rest; do
    echo
    echo "Update $KEY repo"
    echo "----------------"
    echo

    install_storage.sh $MODE $KEY
done < ~/.storage_repo
