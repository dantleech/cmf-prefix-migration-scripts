#!/bin/bash

function cmf_replace {
    perl -pi -e 's/symfony_cmf_/cmf_/g' $1
    perl -pi -e 's/symfony_cmf./cmf./g' $1
    perl -pi -e 's/symfony-cmf-/cmf-/g' $1
}

for bundle in `cat bundles`
do
    BUNDLE_NAME=`basename $bundle`

    echo "Updating bundle "$bundle"..."
    cd "repos/"$BUNDLE_NAME

    git reset --hard
    git checkout master
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
    done

    echo " -- Replacing RSTs"
    for file in `find ./ -name "*.rst"`
    do
        cmf_replace $file
    done
    cd -
done
