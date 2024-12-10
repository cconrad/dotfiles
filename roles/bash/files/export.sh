#!/usr/bin/env bash

for file in ~/.config/environment.d/*; do
    xargs -I {} echo 'export {}' < "$file"
done