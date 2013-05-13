for bundle in `cat bundles`
do
    BUNDLE_NAME=`basename $bundle`
    cd "repos/"$BUNDLE_NAME
    git add ./
    git commit -m "[WIP] Removed symfony_cmf prefix"
    cd -
done
