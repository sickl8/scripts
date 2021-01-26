#!/bin/bash

unset $(env | awk -F '=' '{print $1}' | sed 's/$/ /g' | tr -d '\n' && echo)
