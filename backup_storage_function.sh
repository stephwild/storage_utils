#! /bin/bash

# $1 : dir name
# $2 : underline char
function create_dir ()
{
    if [ ! -d ${DEST_DIR}$1 ]; then
        DIR_LENGTH=$((9 + ${#1}))

        echo "Create \"\$DEST_DIR$1\" directory"

        # Here the underline
        for i in `seq 1 $(($DIR_LENGTH + 19))`; do
            echo -n $2
        done

        echo
        mkdir -p ${DEST_DIR}$1
    fi
}

# $1 : dir where file is add
# $2 -- $# : file to add
function add_file_dir ()
{
    IS_UPDATE=0

    for i in `seq 2 $#`; do
        FILE=$(eval echo \${$i})

        if [ ! -f "${SOURCE_DIR}${1}$FILE" ]; then
            echo "Warning: \$SOURCE_DIR${1}$FILE is missing. You probably" \
            "remove it without update_storage.sh"
            continue
        fi

        diff "${SOURCE_DIR}${1}$FILE" "${DEST_DIR}${1}$FILE" > /dev/null 2>&1

        if [ $(echo $?) -ne 0 ]; then
            if [ ! -f "${DEST_DIR}${1}$FILE" ]; then
                echo -e "\033[32mAdd $FILE file in \$DEST_DIR$1\033[0m"
                IS_UPDATE=1
            elif [ "${SOURCE_DIR}${1}$FILE" -nt "${DEST_DIR}${1}$FILE" ]; then
                echo -e "\033[33mUpdate $FILE file in \$DEST_DIR$1\033[0m"
                IS_UPDATE=1
            fi

            cp -u $DEBUG "${SOURCE_DIR}${1}$FILE" "${DEST_DIR}${1}$FILE"
        fi
    done

    if [ $IS_UPDATE -eq 0 ]; then
        echo -e "\033[34;1m\$DEST_DIR$1 directory already up-to-date\033[0m"
    fi

    echo
}
