#! /bin/bash

FUNCTION_DIR=~/.script_function
SCRIPT_DIR=~/.my_script


if [ "$1" = '--clean' ]; then
    echo "-----------------------------------------"
    echo "    Clean storage script and function"
    echo "-----------------------------------------"
    echo

    rm --verbose $SCRIPT_DIR/add_repo.sh
    rm --verbose $SCRIPT_DIR/add_storage.sh
    rm --verbose $SCRIPT_DIR/install_storage.sh
    rm --verbose $SCRIPT_DIR/upgrade_storage.sh


    rm --verbose $FUNCTION_DIR/main_storage_function.sh
    rm --verbose $FUNCTION_DIR/backup_storage_function.sh

    rmdir --verbose $SCRIPT_DIR
    rmdir --verbose $FUNCTION_DIR

    exit 0
fi

if [ ! -d $FUNCTION_DIR ]; then
    mkdir $FUNCTION_DIR
fi

if [ ! -d $SCRIPT_DIR ]; then
    mkdir $SCRIPT_DIR
fi

echo "-----------------------"
echo "    Add main script"
echo "-----------------------"
echo

cp -uv ./add_repo.sh $SCRIPT_DIR
cp -uv ./add_storage.sh $SCRIPT_DIR
cp -uv ./install_storage.sh $SCRIPT_DIR
cp -uv ./upgrade_storage.sh $SCRIPT_DIR

chmod u+x $SCRIPT_DIR/add_repo.sh
chmod u+x $SCRIPT_DIR/add_storage.sh
chmod u+x $SCRIPT_DIR/install_storage.sh
chmod u+x $SCRIPT_DIR/upgrade_storage.sh

echo
echo "---------------------------"
echo "    Add script function"
echo "---------------------------"
echo

cp -uv ./main_storage_function.sh $FUNCTION_DIR
cp -uv ./backup_storage_function.sh $FUNCTION_DIR
