#! /bin/sh

function print_usage()
{
    echo 'Here print my Help'
    return 0
}

if [ $# -ne 2 ]; then
    print_usage;
fi

if [ ! -d ~/.storage_repo ]; then
    echo "Use '--create' option to build ~/.storage_repo (repo location go in
    this directory."
fi

if [ $1 = '--create' ]; then
    if [ ! -d $2 ]; then
        echo "$2 is not a directory or does not exist"
        exit 1
    fi

    echo $2 > ~/.storage_repo
fi

if [ ! -d $2 ]; then
    echo Creating $2 directory
    mkdir $2 || exit 1
fi

echo "$1 - $2" >> ~/.storage_repo
