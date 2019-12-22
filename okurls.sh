#!/bin/bash

echo "[~] Find URLs returning HTTP 200"
while read u; do
  STATUS=$(curl -o /dev/null -s -w "%{http_code}" $u)
  echo "$u [$STATUS]"
  sleep 2
done <waybackurls.txt


# don't run on images
# only scripts and links
# broken link checker?
# concurrency?