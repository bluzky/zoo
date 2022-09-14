# !/bin/bash

git checkout master
git fetch
git reset --hard origin/master

export MIX_ENV=prod

mix assets.deploy
mix release

_build/dev/rel/zoo/bin/zoo stop
_build/dev/rel/zoo/bin/zoo daemon
