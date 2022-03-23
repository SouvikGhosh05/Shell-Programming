#!/bin/bash

set -e				                    #exit on error
set -u				                    #raise exception on exporting to undefined path
set -x				                    #prints the lines of commands on terminal while it's been executed (mainly used for debugging)

echo "$@"				                  #take all the command line arguments as a array

echo $#			                      #show the number of command line arguments given

python3 --version>/dev/null 2>&1  #to ditch the output and the error both for this command
python --version 2>/dev/null      #to ditch the error only for this command

echo $?				                    #show the exit code of the last command
