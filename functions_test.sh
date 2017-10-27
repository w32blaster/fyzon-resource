#!/bin/bash

# load testing payload
PAYLOAD=$(<payload.json)
source ./functions.sh

#
# Test that URL is correctly extracted
# from payload
#
testUrlExtracted() {

    # When:
    url=`extractUrl "$PAYLOAD"`

    # Then:
    assertEquals "http://ci.myhost:8083" "$url"
}

#
# Test that the Project id is correctly extracted from payload
#
testProjectIdExtracted() {

    # When:
    projectId=`extractProjectId "$PAYLOAD"`

    # Then:
    assertEquals 303 $projectId
}

#
# Test that the Format is correctly extracted
#
testFormatExtracted() {

    # When:
    extractedFormat=`extractFormat "$PAYLOAD"`

    # Then
    assertEquals "json" $extractedFormat
}

# Load and run shUnit2.
. shunit2