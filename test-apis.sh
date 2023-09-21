#!/bin/bash
url="http://localhost/api" # the URL to your API

# set JWTs to be re used here
admin_jwt="xxxxxxxxx"
user_jwt="xxxxxxxx"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No color
test_api() {
    # params
    apiName="$1"
    payload="$2"
    expected="$3"
    expected_status="$4"
    uri=$url/$apiName
    echo "Payload: $payload"
    # make the POST request with curl
    response=$(curl -s -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "$payload" "$uri")
    http_status="${response:${#response}-3}"  # Extract the last 3 characters as the HTTP status code
    response_body="${response:0:${#response}-3}"  # Remove the HTTP status code from the response
    echo -e "Response:${YELLOW} $response_body${NC}"
    echo -e "Expected:${YELLOW} $expected${NC}"
    # Check the HTTP status code and print it in the corresponding color
    if ((http_status >= 200 && http_status < 300)); then
        echo -e "HTTP Status: ${BLUE}$http_status${NC} (Expected $expected_status)"
    elif ((http_status >= 400 && http_status < 600)); then
        echo -e "HTTP Status: ${RED}$http_status${NC} (Expected $expected_status)"
    else
        echo -e "HTTP Status: $http_status (Expected $expected_status)"
    fi

    # check the HTTP status code matches the expected code, if it was provided
    if [[ ! -z "$expected_status" ]]; then
        if [[ "$http_status" != "$expected_status" ]]; then
            echo -e "${RED}Test failed (Incorrect status)${NC}"
            return
        fi
    fi
    # Check if the response matches the expected value
    if [[ "$response_body" == "$expected"* ]]; then
        echo -e "${GREEN}Test passed!${NC}"
    else
        echo -e "${RED}Test failed${NC}"
    fi
}

# Here you can put a message providing any instructions to ensure the tests will run properly. This can be useful 
# When you have tests that create data, but don't delete it afterwards. 
echo "
Before running the tests make sure to have deleted any test data from the database. This can be done with:
SQL_QUERY_HERE;
SQL_QUERY_2_HERE;
"
read -p "Press enter to continue"


# Example usage
echo "===Testing login==="
echo "Case 1: Correct parameters"
payload='{"email":"john.smith@email.com","password":"password123"}'
expected='{"msg":"Log in successful"'
test_api "login" "$payload" "$expected" "200"

echo "Case 2: Incorrect password"
payload='{"email":"john.smith@email.com","password":"password1234"}'
expected='{"error":"Incorrect login"'
test_api "login" "$payload" "$expected" "400"
