#!/bin/bash

if command -v distrobox >/dev/null 2>&1; then
    distrobox create -n dev-tools -p -i quay.io/fedora/fedora:latest
    distrobox enter -n dev-tools -- bash "./distroboxes/dev-tools.sh"
    distrobox enter -n dev-tools -- bash "./util/linux.sh"
    exit
fi

. "./util/linux.sh"
