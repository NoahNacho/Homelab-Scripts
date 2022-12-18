#!/bin/bash
message="hello"
msg_content=\"$message\"

## discord webhook
url='' #webhook url
curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg_content}" $url
