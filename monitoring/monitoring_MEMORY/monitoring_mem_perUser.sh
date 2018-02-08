#!/bin/bash

pmap `pgrep -u natasa`

# more summarised:

pmap `pgrep -u natasa` | grep 'total'
