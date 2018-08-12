#!/bin/bash

# check if holiday
if test $(grep $(date +%Y-%m-%d) holiday.txt -ic) -ne 0
then
   # do some tasks
fi