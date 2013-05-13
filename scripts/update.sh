for i  in `cat bundles`
do
    BUNDLE_NAME=`basename $i`
    if [ ! -e "repos/"$BUNDLE_NAME ]
    then
        git clone "https://github.com/"$i repos/$BUNDLE_NAME
        cd repos/$BUNDLE_NAME
        git branch drop_symfony_cmf_prefix origin/master
        git checkout drop_symfony_cmf_prefix
    else
        cd repos/$BUNDLE_NAME
        git fetch origin master
        git branch drop_symfony_cmf_prefix origin/master
        git checkout drop_symfony_cmf_prefix
        git merge origin/master
    fi

    cd -
done
