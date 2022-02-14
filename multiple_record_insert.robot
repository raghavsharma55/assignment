*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  helper.py

*** Variables ***
${Base_URL}=   http://localhost:8080/

*** Test Cases ***
##Insert multiple records
TC_001_Upload_Multiple_New_Record
    create session  AddData  ${Base_URL}
    ${input_list}=    Create List
    ${body_dict_1}=  create dictionary  natid=1009  name=auto1  gender=M  salary=10000  birthday=05061980  tax=1500
    ${body_dict_2}=  create dictionary  natid=1008  name=auto2  gender=F  salary=12000  birthday=10071981  tax=1200
    ${json_body_1}=  evaluate    json.dumps(${body_dict_1})    json
    ${json_body_2}=  evaluate    json.dumps(${body_dict_2})    json
    ${input_list}=  evaluate  helper.list_of_dict(${json_body_1}, ${json_body_2})  modules=helper
    ${new}=  evaluate  json.dumps(${input_list})  json
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  POST ON SESSION  AddData  /calculator/insertMultiple  data=${new}  headers=${header}
    ${output}=  convert to string  ${response.content}
    should be equal  ${output}  Alright

##This test case should be failing with 400 as there is no data to insert but here is passes
TC_002_Upload_Multiple_Record_with_empty_list
    create session  AddData  ${Base_URL}
    ${input_list}=    Create List
    ${new}=  evaluate  json.dumps(${input_list})  json
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  POST ON SESSION  AddData  /calculator/insertMultiple  data=${new}  headers=${header}
    should be equal  ${response.status_code}  400
