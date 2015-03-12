#! /bin/bash

function print_usage()
{
    echo 'Here print my Help'
    exit 0
}

if [ $# -lt 3 || $1 = '--help' || $1 = '-h' ]; then
    print_usage
fi

if [ ! -d ~/.storage_repo ]; then
    echo You need a repo before adding something to it... Create one by using add_repo.sh
    exit 1
fi

if [ ! -d $# ]; then
    echo "You can't copy/move your file in '$#' because it's not a directory"
    exit 1
fi

if [ $1 = '-m' ] || [ $1 = '--move' ]; then
    MOVE=1
    BEGIN=3
    KEY=$(eval echo \$$2)
else
    MOVE=0
    BEGIN=2
    KEY=$(eval echo \$$1)
fi

# Contain search_dir_key function
source ~/.script_functions/storage_check.sh

DIR_KEY=$(search_dir_key $KEY)

if [ ! -d $DIR_KEY/.storage_data/ ]; then
    mkdir $DIR_KEY/.storage_data || exit 1
fi

for i in `seq $(eval echo \${$BEGIN}) $#`; do

    if [ -d $i ]; then
        echo $i is a directory. Do not copy anything ! Use '-r' or '--recursive' \
            options for that.
        continue
    fi

    echo "$# - $(basename $i) - 1" >>  $DIR_KEY/.storage_data/{$KEY}.data

    if [ $MOVE -eq 1 ]; then
        mv $i $(eval echo \${$#})
        echo "Move $i in $# [$KEY]" | tee > $DIR_KEY/.storage_data/${KEY}.log
    else
        cp $i $(eval echo \${$#})
        echo "Copy $i in $# [$KEY]" | tee > $DIR_KEY/.storage_data/${KEY}.log
    fi
done
