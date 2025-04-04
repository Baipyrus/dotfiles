#!/bin/bash

# Set bash PS1 prompt with colors and container instead of host, if applicable
if [ -n "$CONTAINER_ID" ]; then
    export PS1="\[\e[1;32m\]\u@\[\e[1;34m\]$CONTAINER_ID \[\e[1;33m\]\W\[\e[0m\]\$ "
else
    export PS1="\[\e[1;32m\]\u@\[\e[1;34m\]\h \[\e[1;33m\]\W\[\e[0m\]\$ "
fi
