#!/bin/bash

jb install && jb update

echo "Generating dashboard based on newest versions"
jsonnet -J ./vendor "$DASHBOARD_NAME".jsonnet | jq . > dashboard_cci.json

DIFF="$(! diff -w dashboard_cci.json "$DASHBOARD_NAME".json || :)"
echo "Diff: $DIFF"

if [ -n "$DIFF" ]; then
  git config --global user.email "circleci@entur.org"
  git config --global user.name "EnturCircleCi"

  echo "Renaming dashboard_cci.json to $DASHBOARD_NAME.json"
  mv dashboard_cci.json "$DASHBOARD_NAME".json
  git add ./*.json* && git commit -m "[skip ci] Updated generated dashboard due to library changes"
  echo "Committed changed files"
else
  echo "No library updates"
fi
