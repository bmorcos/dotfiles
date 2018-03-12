#!/bin/bash
sudo sed -e "s/dropbox-client-.*=/dropbox-client-$(ps aux | grep dropbox | grep dist | awk '{print $2 }')=/g" -i /usr/share/indicator-application/ordering-override.keyfile
restart unity-panel-service
