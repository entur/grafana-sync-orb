#!/bin/bash

echo "Verifying input"
if [ ! -s "$DASHBOARD_PATH/$DASHBOARD_NAME.json" ]; then
  echo "File $DASHBOARD_PATH/$DASHBOARD_NAME.json does not exist or was empty"
  exit 1
fi
if [ -z "$FOLDER_UID" ]; then
  echo "Folder uid is required!"
  exit 1
fi
if [ -z "$GRAFANA_DASHBOARDS_KEY" ]; then
  echo "Api key stored in \$GRAFANA_DASHBOARDS_KEY is required!"
  exit 1
fi
if [ -z "$GRAFANA_DASHBOARDS_HOST" ]; then
  echo "Host stored in \$GRAFANA_DASHBOARDS_HOST is required!"
  exit 1
fi
