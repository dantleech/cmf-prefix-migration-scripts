Migration scripts for removing the Symfony prefix from SymfonyCmf
=================================================================

The scripts will operate on the bundles in the `bundles` file and replace all
references to `symfony{-,.,_}cmf{-,.,_}` with `cmf{-,.,_}`

1. Copy `bundles.dist` to `bundles`
2. Edit `bundles` and only list the `repo/reponame` s that you want changed
3. Run the following:

````
./scripts/update.sh
./scripts/replace.sh
./scripts/commit.sh
./scripts/push.sh
````

Everytime you run `./scripts/replace` the previous changes will be completly
removed and there will only ever be ONE COMMIT in the log.

The push script will force the push, overwriting the remote version.
