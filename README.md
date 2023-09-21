# api-test-bash
A very basic bash script using cURL for testing web APIs that use JSON for their parameters.

# Requirements
The only requirements to run this script are Bash and curl. Both will be installed by default on any GNU/Linux distro. 

## Windows
The easiest way to run this script on Windows (10 newer) is to install Windows Subsystem for Linux (WSL), and run the script through that.

# Usage
The basic usage of the script is to call the `test_api` function from within the script, then run the script:
```
test_api "<api name>" "<payload>" "<expected response>" "<expected response code>"
```
By default, the script will make a HTTP POST request to `http://localhost/api/<api name>`, this can be changed by modifying the `url` variable at the top of the script.

The script will then read the response, and print out both the expected and actual responses and response codes. If both match, it will tell you the test has passed, if not, it will tell you the test has failed.

## Tips/Recommendations
- If you are testing an API requiring a JWT, I recommend setting some test JWTs that can be re-used at the top of the script. 
- Save your payload and expected response as variables, then call `test_api` with them, this will improve readability. This is what is done in the example test provided.
For example, to test the API called "login" (accessed at `localhost/api/login`, you would add:
```
payload = '{"email":"john.smith@email.com","password":"password123"}'
expected='{"msg":"Log in successful"'
test_api "login" "$payload" "$expected" "200"
```
Note that the expected payload does not have to be given in full, the script will check that the response matches the payload exactly, up to the last character of the expected value given. It then allows for anything past that. For example,
```
Expected:  abcdefgh
Response:  abcdefghijk
```
Will return a success, but
```
Expected:  1abcdefgh
Response:  abcdefgh
```
Will not.

# Contributing
Anyone is welcome to contribute to this script, if you add any new features or find/fix any bugs, feel free to make a pull request so that others can use your changes also.
