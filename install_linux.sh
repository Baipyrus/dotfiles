#!/bin/bash

if command -v distrobox >/dev/null 2>&1; then
    distrobox create -n dev-tools -i dev-tools_post-install:latest
    distrobox enter -n dev-tools -- bash "./distroboxes/dev-tools.sh"
    distrobox enter -n dev-tools -- bash "./util/linux.sh"
    return
fi

. "./util/linux.sh"
