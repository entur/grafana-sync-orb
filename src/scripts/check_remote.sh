#!/bin/bash

DASH_UID="$( < "$DASHBOARD_NAME".json jq ".uid" | sed 's/\"//g' )"
echo "Looking for dashboard with id '$DASH_UID'"
if [ -z "$DASH_UID" ]; then
  echo "No uid found for $DASHBOARD_NAME.json"
  exit 2
fi

HTTP_CODE=$(curl "$GRAFANA_DASHBOARDS_HOST/api/dashboards/uid/$DASH_UID" \
  -H "Authorization: Bearer $GRAFANA_DASHBOARDS_KEY" \
  -H "Content-type: application/json" \
  -o tmp.json -w "%{http_code}"
)

if [ "$HTTP_CODE" == "200" ]; then
  echo "Previous version found. Checking for differences"
  < tmp.json jq -r ".dashboard" > dashboard_external.json

  DIFF="$(! diff -w -I "version" -I "id" dashboard_external.json "$DASHBOARD_NAME".json || :)"
  echo "Diff: $DIFF"

  echo "export IS_UPDATED=\"$([[ -n "$DIFF" ]])\"" >> "$BASH_ENV"
else
  echo "No previous version found. Proceeding to upload"
  echo "export IS_UPDATED=\"0\"" >> "$BASH_ENV"
fi
