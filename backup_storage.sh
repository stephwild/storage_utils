#! /bin/bash

# $1 : dir name
# $2 : underline char
function create_dir ()
{
    if [ ! -d $1 ]; then
        DIR_LENGTH=${#1}

        echo -e "Create \"$1\" directory"

        # Here the underline
        for i in `seq 1 $(($DIR_LENGTH + 19))`; do
            echo -n $2
        done

        echo -e "\n"

        mkdir $1
    fi
}

# $1 : dir where file is add
# $2 -- $# : file to add
function add_file_dir ()
{
    IS_UPDATE=0

    for i in `seq 2 $#`; do
        FILE=$(eval echo \${$i})

        if [ ! -f "$DEST_DIR/$1/$FILE" ]; then
            echo -e "Add $FILE file in $DEST_DIR/$1"
            IS_UPDATE=1
        elif [ "$SOURCE_DIR/$1/$FILE" -nt "$DEST_DIR/$1/$FILE" ]; then
            echo -e "Update $FILE file in $DEST_DIR/$1"
            IS_UPDATE=1
        fi

        cp -u $DEBUG "$SOURCE_DIR/$1/$FILE" "$DEST_DIR/$1/$FILE"
    done

    if [ $IS_UPDATE -eq 0 ]; then
        echo -e "$1 directory already up-to-date"
    fi

    echo
}
