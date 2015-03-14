#! /bin/bash

FUNCTION_DIR=~/.script_function

function print_usage ()
{
    echo 'Here print my Help'
}

function print_error ()
{
    echo -e "\033[1;31mError:\033[0m $1"
    exit 1
}

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
    print_usage
    exit 0
elif [ $1 = '--delete' -a $# -ne 2 ] || [ $1 != '--delete' -a $# -ne 3 ]; then
    echo -e "\033[1;31mError:\033[0m Bad option or arguments used\n"
    print_usage;
    exit 1
fi

if [ ! -f $FUNCTION_DIR/main_storage_function.sh ]; then
    print_error "You don't have file 'main_storage_function.sh' in $FUNCTION_DIR"
fi

source $FUNCTION_DIR/main_storage_function.sh

# Delete Option
# -------------

function confirm_delete ()
{
    echo -ne "Do you want to delete too $1 ?\nRespond with y/n or yes/no: "
    read response

    while true; do
        if [ $response = 'y' ] || [ $response = 'yes' ]; then
            rm -rf $1
            break
        elif [ $response = 'n' ] || [ $response = 'no' ]; then
            break
        else
            echo -n "Expect y/n or yes/no: "
            read response
        fi
    done
}

if [ "$1" = '--delete' ]; then
    search_dir_key $2
    DIR_KEY=$SEARCH_DIR_KEY

    if [ ! -f $DIR_KEY/.storage_data/${2}.data ]; then
        print_error "Miss '$DIR_KEY/.storage_data/${2}.data' file"
    fi

    sed -i "/^$2 -/d" ~/.storage_repo
    echo "Key '$2' removed from ~/.storage_repo\n"

    STORAGE_DIR=$(head -n 1 $DIR_KEY/.storage_data/${2}.data)

    confirm_delete $DIR_KEY && echo
    confirm_delete $STORAGE_DIR

    exit 0
fi

# Add a repo
# ----------

touch ~/.storage_repo

# $1 = KEY, $2 = KEY_DIR, $3 = STORAGE_DIR
if ! key_exist $1; then

    if [ ! -d "$2" ]; then
        echo "Creating '$2' directory ['$1' KEY directory]"
        mkdir $2 || exit 1
    fi

    if [ ! -d "$3" ]; then
        echo "Creating '$3' directory [storage directory]"
        mkdir $3 || exit 1
    fi

    if [ ! -d "$2/.storage_data" ]; then
        echo "Creating '.storage_data' in KEY directory"
        mkdir $2/.storage_data
    fi

    echo "Create initial $2/.storage_data/${1}.data file"
    echo $(realpath $3) > $2/.storage_data/${1}.data

    echo "Add '$1' repo in '$2' [KEY='$1', KEY_DIR='$2', STORAGE_DIR='$3']"
    echo "$1 - $(realpath $2)" >> ~/.storage_repo
else
    print_error "'$1' repo already exist"
fi
