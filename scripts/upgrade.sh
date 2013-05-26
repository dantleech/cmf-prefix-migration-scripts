#!/bin/bash

# This script operates on the file "bundles"
# For each bundle replacing the symfony-cmf prefix
# as detailed in the function below.

function cmf_replace {
    FILENAME=$1
    if [ $FILENAME == "./.travis.yml" ]
    then
        echo "Ignoring "$FILENAME
    else
        perl -pi -e 's/symfony_cmf_/cmf_/g' $FILENAME
        perl -pi -e 's/symfony_cmf\./cmf\./g' $FILENAME
        perl -pi -e 's/symfony_cmf-/cmf-/g' $FILENAME
        perl -pi -e 's/symfony-cmf-/cmf-/g' $FILENAME
        perl -pi -e 's/SymfonyCmf([A-Z])/Cmf$1/g' $FILENAME
    fi
}

function cmf_rename {
    FILENAME=$1
    RENAMED=`echo $FILENAME | perl -pi -e 's/SymfonyCmf([A-Za-z\.]+)$/Cmf$1/g'`

    if [ $FILENAME != $RENAMED ]
    then
        git mv $FILENAME $RENAMED
        echo " > renamed "$FILENAME" to "$RENAMED
    fi
}

function find_files {
    PATTERN=$1
    find ./ -name "$PATTERN" | grep -v vendor | grep -v cache
}

echo " -- Replacing YAMLs"
for file in `find_files *.yml`
do
    cmf_replace $file
    cmf_rename $file
done

echo " -- Replacing XMLs"
for file in `find_files *.xml`
do
    cmf_replace $file
done

echo " -- Replacing PHPs"
for file in `find_files *.php`
do
    cmf_replace $file
    cmf_rename $file
done

echo " -- Replacing Directories"
for directory in `find ./ -type d | grep -v vendor`
do
    cmf_rename $directory
done

echo " -- Replacing TWIGs"
for file in `find_files *.twig`
do
    cmf_replace $file
    cmf_rename $file
done

echo " -- Replacing RSTs"
for file in `find_files *.rst`
do
    cmf_replace $file
done
