#!/bin/bash

/tf/rover/launchpad.sh | grep resource_group: > rg 
cat rg | awk -F ":" '{print $2}' | awk -F "-" '{print $1}' > new_prefix
