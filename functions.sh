#!/bin/bash

#
# Extract URL from the payload
# We expect, this value should be declared like that:
#
# - name: fyzon
#   type: fyzon-resource
#   source:
#     url: "http://ci.my.host"
#
# @param payload
#
function extractUrl() {
    url=$(echo "$1" | jq -r '(.source.url )')
    echo $url
}

#
# Extract project ID from the payload
#
#
function extractProjectId() {
    project_id=$(echo "$1" | jq -r '(.params.project_id // 1)')
    echo $project_id
}

#
# Extract format for the exported data
#
function extractFormat() {
    exportFormat=$(echo "$1" | jq -r '(.params.format // "json")')
    echo $exportFormat
}