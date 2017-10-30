#!/bin/bash

# load testing payload from the testing file
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

#
# Test we extract the array of countries and file names.
# We transform all the entries to the strings "county|filename", later it could be used
# in a loop
#
testArrayCountries() {

    # When:
    countries=`extractCountries "$PAYLOAD"`
    arrCountries=($countries)

   
    # Then:
    assertEquals "gb|en-gb.all.json" ${arrCountries[0]}
    assertEquals "ru|ru-ru.all.json" ${arrCountries[1]}
    assertEquals "cy|cy-cy.all.json" ${arrCountries[2]}
}

testDelimeter() {

    # When:
    delimeter=`extractDelimeter "$PAYLOAD"`
    
    # Then:
    assertEquals null $delimeter
}

#
# Test that URL is correctly build
#
testBuildUrlSimple() {

    # Given:
    LINE="gb|en-gb.all.json"
    FORMAT="json"
    PROJECT_ID=3
    BASE_URL="http://localhost:8080"

    # When
    url=`buildUrlToFile "$LINE" "$FORMAT" "$PROJECT_ID" "$BASE_URL"`

    # Then
    assertEquals "http://localhost:8080/api/project/3/file/gb/json" "$url"
}

#
# Empty delimeter ignored
#
testBuildUrlSimpleEmptyDelimenter() {

    # Given:
    LINE="gb|en-gb.all.json"
    FORMAT="json"
    PROJECT_ID=3
    BASE_URL="http://localhost:8080"

    # and:
    DELIMETER="" # <-- will be ignored

    # When
    url=`buildUrlToFile "$LINE" "$FORMAT" "$PROJECT_ID" "$BASE_URL" "$DELIMETER"`

    # Then
    assertEquals "http://localhost:8080/api/project/3/file/gb/json" "$url"
}

#
# Empty delimeter ignored
#
testBuildUrlSimpleNullDelimenter() {

    # Given:
    LINE="gb|en-gb.all.json"
    FORMAT="json"
    PROJECT_ID=3
    BASE_URL="http://localhost:8080"
    DELIMETER=null
    
    # When
    url=`buildUrlToFile "$LINE" "$FORMAT" "$PROJECT_ID" "$BASE_URL" "$DELIMETER"`

    # Then
    assertEquals "http://localhost:8080/api/project/3/file/gb/json" "$url"
}


#
# Test that URL is correctly build, including optional parameter "delimeter"
#
testBuildUrlWithDelimeter() {

    # Given:
    LINE="ru|messages-ru.properties"
    FORMAT="properties"
    PROJECT_ID=10
    BASE_URL="http://localhost:8080"
    DELIMETER="="

    # When
    url=`buildUrlToFile "$LINE" "$FORMAT" "$PROJECT_ID" "$BASE_URL" "$DELIMETER"`

    # Then
    assertEquals "http://localhost:8080/api/project/10/file/ru/properties?delimeter==" "$url"
}

# Load and run shUnit2.
. shunit2