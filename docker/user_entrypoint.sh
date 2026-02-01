#!/bin/bash

export SHELL="/bin/bash"

echo 'export PS1='\''\[\e[0m\][\[\e[34m\]\w\[\e[0m\]] > '\''' >> ~/.bashrc
exec $@
