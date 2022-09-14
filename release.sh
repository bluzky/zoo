# !/bin/bash

git checkout main
git fetch
git reset --hard origin/main

export MIX_ENV=prod

mix deps.get
mix compile --warnings-as-errors
mix assets.deploy
mix release

_build/dev/rel/zoo/bin/zoo stop
_build/dev/rel/zoo/bin/zoo daemon
