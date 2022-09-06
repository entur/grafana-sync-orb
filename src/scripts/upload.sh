#!/bin/bash

echo "$IS_UPDATED"

if [[ "0" == "$IS_UPDATED" ]]; then
  echo "Updating remote dashboard"

  GIT_COMMIT_DESC="$(git log --format=oneline -n 1)"
  echo "{
        \"dashboard\": $(jq . "$DASHBOARD_NAME".json),
        \"folderUid\": \"$FOLDER_UID\",
        \"overwrite\": true,
        \"message\": \"$GIT_COMMIT_DESC\"
  }" > body.json
  curl "$GRAFANA_DASHBOARDS_HOST"/api/dashboards/db -d @body.json \
        -H "Authorization: Bearer $GRAFANA_DASHBOARDS_KEY" \
        -H "Content-type: application/json"
  exit $?
fi
