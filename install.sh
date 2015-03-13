#! /bin/sh

FUNCTION_DIR=~/.script_function
SCRIPT_DIR=~/.my_script

if [ ! -d $FUNCTION_DIR ]; then
    mkdir $FUNCTION_DIR
fi

if [ ! -d $SCRIPT_DIR ]; then
    mkdir $SCRIPT_DIR
fi

echo
echo "-----------------------"
echo "    Add main script"
echo "-----------------------"
echo

cp -uv ./add_repo.sh $SCRIPT_DIR
cp -uv ./add_storage.sh $SCRIPT_DIR
cp -uv ./install_storage.sh $SCRIPT_DIR

chmod u+x $SCRIPT_DIR/add_repo.sh
chmod u+x $SCRIPT_DIR/add_storage.sh
chmod u+x $SCRIPT_DIR/install_storage.sh

echo
echo "---------------------------"
echo "    Add script function"
echo "---------------------------"
echo

cp -uv ./main_storage_function.sh $FUNCTION_DIR
cp -uv ./backup_storage_function.sh $FUNCTION_DIR
