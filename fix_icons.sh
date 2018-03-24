#!/bin/bash
sudo sed -e "s/dropbox-client-.*=/dropbox-client-$(ps aux | grep dropbox | grep dist | awk '{print $2 }')=/g" -i /usr/share/indicator-application/ordering-override.keyfile
restart unity-panel-service

# To get a list of applications dbus-send --type=method_call --print-reply --dest=com.canonical.indicator.application /com/canonical/indicator/application/service com.canonical.indicator.application.service.GetApplications | grep "object path" | sed 's/_/-/g' | cut -d"/" -f5
