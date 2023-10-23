#!/bin/zsh

# custom home: https://github.com/tylerdotrar/mkdocs-coverpage (but - header only, no content)

# e.g.:  sh ~/dev/Docs-ApiLogicServer/docs.sh
echo "\n*** Org Docs ***\n"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd $SCRIPT_DIR
# echo $pwd
source venv/bin/activate  # req'd for mkdocs
cd .
mkdocs serve
popd
