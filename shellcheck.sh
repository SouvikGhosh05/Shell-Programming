#!/bin/bash
find . -type f -name '*.sh' -o -name '*.bash' -o -name '*.ksh'  | xargs shellcheck --shell=bash
