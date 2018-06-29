#!/bin/bash
[ "$#" != "2" ] && echo "Usage: $0 [ARTIFACT] [VERSION]" && exit 0
artifact=$1
version=$2
output=${mktemp}
lastVersion="$(scm list snapshots --json -r Production "SYG ::: PROD 9.2 Maintenance" | jq -r .snapshots[].name 2>/dev/null | grep ${artifact}-${version}-Alpha | sort | wc -l)"
echo $((lastVersion+1))
exit 0