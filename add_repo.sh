#! /bin/sh

function print_usage()
{
    echo 'Here print my Help'
    return 0
}

if [ $# -ne 2 ]; then
    print_usage;
fi

if [ $1 = '--delete' ]; then
    DIR_KEY=$(search_dir_key $2)

    echo "Do you want recursively delete $DIR_KEY.\nRespond with y/n or yes/no: "
    read response

    while 1; do
        if [ $response = 'y' ] || [ $response = 'yes' ]; then
            rm -rf $DIR_KEY
            exit 0
        elif [ $response = 'n' ] || [ $response = 'no' ]; then
            exit 0
        else
            echo "Expect y/n or yes/no"
            read response
        fi
    done
fi

if [ ! -d $1 ]; then
    echo Creating $1 directory
    mkdir $1 || exit 1
fi

if [ ! -d $2 ]; then
    echo Creating $2 directory
    mkdir $2 || exit 1
fi

echo "$1 - $2" >> ~/.storage_repo
