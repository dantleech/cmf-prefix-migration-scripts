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
        perl -pi -e 's/symfony_cmf./cmf./g' $FILENAME
        perl -pi -e 's/symfony-cmf-/cmf-/g' $FILENAME
    fi
}

function cmf_rename {
    FILENAME=$1
    RENAMED=`echo $FILENAME | perl -pi -e 's/SymfonyCmf(.*)Extension/Cmf$1Extension/g'`

    if [ $FILENAME != $RENAMED ]
    then
        git mv $FILENAME $RENAMED
        echo " > renamed "$RENAMED
    fi
}

for bundle in `cat bundles`
do
    BUNDLE_NAME=`basename $bundle`

    echo "Updating bundle "$bundle"..."
    cd "repos/"$BUNDLE_NAME

    # Discard any irrelevant changes
    git reset --hard
    git checkout master

    # Drop-recreate the branch, discard old changes
    git branch -D drop_symfony_cmf_prefix
    git branch drop_symfony_cmf_prefix origin/master
    git checkout drop_symfony_cmf_prefix

    echo " -- Replacing YAMLs"
    for file in `find ./ -name "*.yml"`
    do
        cmf_replace $file
    done

    echo " -- Replacing XMLs"
    for file in `find ./ -name "*.xml"`
    do
        cmf_replace $file
    done

    echo " -- Replacing PHPs"
    for file in `find ./ -name "*.php"`
    do
        cmf_replace $file
        cmf_rename $file
    done

    echo " -- Replacing RSTs"
    for file in `find ./ -name "*.rst"`
    do
        cmf_replace $file
    done
    cd -
done
