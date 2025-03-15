#!/bin/bash
set -euxo pipefail
source config.sh
test -d userspace && rm -rf userspace
test -f userspace.cpio.gz && rm -f userspace.cpio.gz
test -f userspace.tar && rm -f userspace.tar
mkdir -p userspace/{bin,srv}
env CGO_ENABLED=0 go build -o userspace/bin/server server.go
ln -s /bin/server userspace/init
(cd $WEBSITE_FILES && tar cf - .) | (cd userspace/srv && tar xf -)
(cd userspace && find . | cpio -H newc -o | gzip) > userspace.cpio.gz
(cd userspace && tar cf - .) > userspace.tar
