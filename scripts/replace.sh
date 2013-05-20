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

    if [ $BUNDLE_NAME == 'BlockBundle-ASDASD' ]
    then
        git branch drop_symfony_cmf_prefix rmsint/block_context
    else 
        git branch drop_symfony_cmf_prefix origin/master
    fi

    git checkout drop_symfony_cmf_prefix

    echo " -- Replacing YAMLs"
    for file in `find ./ -name "*.yml"`
    do
        cmf_replace $file
        cmf_rename $file
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

    echo " -- Replacing Directories"
    for directory in `find ./ -type d`
    do
        cmf_rename $directory
    done

    echo " -- Replacing TWIGs"
    for file in `find ./ -name "*.twig"`
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
