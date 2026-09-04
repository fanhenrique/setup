#!/bin/bash


THEME_DIR=./theme
SDDM_THEMES_DIR=/usr/share/sddm/themes/
SDDM_CONFIG_PATH=/etc/sddm.conf.d/sddm.conf

# if [[ -z $THEME_SOURCE ]]; then
#     echo "Improperly configured! THEME_SOURCE should be set!"
#     exit 1
# fi

if [[ -z $THEME_DIR ]]; then
    echo "Improperly configured! ${THEME_DIR} should be set!"
    exit 1
fi

if [[ ! -d $SDDM_THEMES_DIR ]]; then 
    echo -e "\e[31;02m$SDDM_THEMES_DIR doesn't exist! Please, create it manually or edit SDDM_THEMES_DIR variable"
    exit 1
fi

# git clone $THEME_SOURCE .theme_temp || (echo -e "\e31;02mFailed to fetch git repo at $THEME_SOURCE.\e[0m" && exit 1)

if [[ ! -d $THEME_DIR ]]; then
    echo "'${THEME_DIR}' is not found!"
    exit 1k
fi

cp -rv $THEME_DIR $SDDM_THEMES_DIR || (echo "Failed to copy theme to '${SDDM_THEMES_DIR}'!" && exit 1)
echo "Theme successfully installed!"

if [[ $1 == "current" ]]; then
    for file in `echo "$SDDM_CONFIG_PATH" | tr ':' '\n'`; do
        if [[ -f $file ]]; then
            sed -i "s/Current=.*/Current=$THEME_DIR/" $file || (echo -e "\e[31;02mFailed to edit $file.\e[0m" && exit 1)
            exit 0
        fi
    done
    echo -e "\e[33;02mFailed to set theme as current. Try to edit sddm configuration manually.\e[0m"
fi
