for bundle in `cat bundles`
do
    BUNDLE_NAME=`basename $bundle`
    echo "Pushing "$bundle
    cd "repos/"$BUNDLE_NAME
    git push -f origin drop_symfony_cmf_prefix 
    cd -
done

