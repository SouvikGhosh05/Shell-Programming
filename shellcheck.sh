#!/bin/bash
find . -type f -name '*.sh' -o -name '*.bash' -o -name '*.ksh'  | xargs -0 shellcheck --shell=bash
