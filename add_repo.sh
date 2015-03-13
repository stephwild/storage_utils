#! /bin/bash

FUNCTION_DIR=~/.script_function

function print_usage ()
{
    echo 'Here print my Help'
}

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
    print_usage
    exit 0
elif [ $# -ne 2 ]; then
    echo -e "\033[1;31mError:\033[0m Bad option or arguments used\n"
    print_usage;
    exit 1
fi

if [ ! -f $FUNCTION_DIR/main_storage_function.sh ]; then
    echo -e "\033[1;31mError:\033[0m You don't have file" \
    "'main_storage_function.sh' in $FUNCTION_DIR"
    exit 1
fi

source $FUNCTION_DIR/main_storage_function.sh

# Delete Option
# -------------

if [ "$1" = '--delete' ]; then
    search_dir_key $2
    DIR_KEY=$SEARCH_DIR_KEY

    sed -i "/^$2 -/d" ~/.storage_repo
    echo "Key '$2' removed from ~/.storage_repo"

    echo -ne "Do you want to delete too $DIR_KEY ?\nRespond with y/n or yes/no: "
    read response

    while true; do
        if [ $response = 'y' ] || [ $response = 'yes' ]; then
            rm -rf $DIR_KEY
            exit 0
        elif [ $response = 'n' ] || [ $response = 'no' ]; then
            exit 0
        else
            echo -n "Expect y/n or yes/no: "
            read response
        fi
    done
fi

# Add a repo
# ----------

touch ~/.storage_repo

# $1 = KEY, $2 = KEY_DIR
if ! key_exist $1; then

    if [ ! -d "$2" ]; then
        echo "Creating '$2' directory"
        mkdir $2 || exit 1
    fi

    echo "Add '$1' repo in '$2' [KEY='$1', KEY_DIR='$2']"
    echo "$1 - $(realpath $2)" >> ~/.storage_repo
else
    echo -e "\033[1;31mError:\033[0m '$1' repo already exist"
    exit 1
fi
