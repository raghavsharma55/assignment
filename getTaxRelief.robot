*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  helper.py


*** Variables ***
${Base_URL}=   http://localhost:8080/

*** Test Cases ***
Get_tax_relief_with_no_data
    create session  GetData  ${Base_URL}
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  GET ON SESSION  GetData  /calculator/taxRelief  headers=${header}
    ${output}=  convert to string  ${response.content}
    ${status_code}=     convert to string   ${response.status_code}
    should be equal  ${status_code}        200
    should be equal  ${output}  []

Get_tax_relief_with_some_data
    create session  GetData  ${Base_URL}
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  GET ON SESSION  GetData  /calculator/taxRelief  headers=${header}
    ${status_code}=     convert to string   ${response.status_code}
    should be equal  ${status_code}        200
    should not be equal     ${response.content}     []
