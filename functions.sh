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
# Extract delimeter from the payload
#
#
function extractDelimeter() {
    delimeter=$(echo "$1" | jq -r '(.params.delimeter)')
    echo $delimeter
}

#
# Extract format for the exported data
#
function extractFormat() {
    exportFormat=$(echo "$1" | jq -r '(.params.format // "json")')
    echo $exportFormat
}

#
# Extract countries.
# We want to get as result array of strings in format "country|fyzonURL", 
# later it would be easy to download them in a loop
# 
# Playground: https://jqplay.org/s/Dt53PSGbUq
#
function extractCountries() {
    countries=$(echo "$1" | jq -r '.params.countries[]|to_entries|map(.key + "|" + .value)|.[]')
    echo "${countries[@]}"
}

#
# Download one file from Fyzon, this command cound be called in the loop
# 
# @param line extracted from extractCountries() function, such as "gb|messages-gb.properties"
# @param format. Expected "json", "properties" etc...
# @param project_id
# @param base url of Fyzon
# @param delimeter (optional)
#
function buildUrlToFile() {

    # extract the first part of the line before "|"
    country="${1%|*}"

    #delimeter=[ -z "$FORMAT" ] && FORMAT='properties'
    if [ -n "$5" ]; then
        delimeterArg="?delimeter=$5"
    else
        delimeterArg=""
    fi

    echo "$4/api/project/$3/file/$country/$2$delimeterArg"
}