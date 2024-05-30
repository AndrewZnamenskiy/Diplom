#!/bin/bash

req_counter="$(awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr |  awk '!/(127.0.0.1)/ {print $1}' | awk '{ sum += $1 } END { print sum }')"
echo $req_counter
