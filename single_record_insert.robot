*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  helper.py


*** Variables ***
${Base_URL}=   http://localhost:8080/

*** Test Cases ***
TC_001_Upload_New_Record
    create session  AddData  ${Base_URL}
    ${body_dict}=  create dictionary  natid=1009  name=auto1  gender=M  salary=10000  birthday=05061980  tax=1500
    ${json_body}=  evaluate    json.dumps(${body_dict})    json
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  POST ON SESSION  AddData  /calculator/insert  data=${json_body}  headers=${header}
    ${output}=  convert to string  ${response.content}
    should be equal  ${output}  Alright

##This test case passes on API but UI breaks with white Screen. This should be handled to give 400 error and some response message
TC_002_Upload_New_Record_With_ID_As_Null
   create session  AddData  ${Base_URL}
    ${body_dict}=  create dictionary  natid=NULL  name=auto2  gender=M  salary=10000  birthday=05061980  tax=1500
    ${json_body}=  evaluate    json.dumps(${body_dict})    json
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  POST ON SESSION  AddData  /calculator/insert  data=${json_body}  headers=${header}
    should be equal  ${response.status_code}  400
    log to console  ${response.content}

##This test case passes and create a record with duplicate ID but we should put primary key uniqueness restriction
TC_003_Upload_New_Record_With_ID_As_Duplicate
   create session  AddData  ${Base_URL}
    ${body_dict}=  create dictionary  natid=1009  name=auto3  gender=M  salary=10000  birthday=05061980  tax=1500
    ${json_body}=  evaluate    json.dumps(${body_dict})    json
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  POST ON SESSION  AddData  /calculator/insert  data=${json_body}  headers=${header}
    should be equal  ${response.status_code}  400

##This test cases fails with 500 but we should show status as 400 with some message
TC_004_Upload_New_Record_With_tax_As_empty
   create session  AddData  ${Base_URL}
    ${body_dict}=  create dictionary  natid=1010  name=auto4  gender=M  salary=10000  birthday=05061980  tax=
    ${json_body}=  evaluate    json.dumps(${body_dict})    json
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  POST ON SESSION  AddData  /calculator/insert  data=${json_body}  headers=${header}
    shoould be equal  ${response.status_code}  400

##This test cases creates a new DB record across natid but we shouldn't allow empty name & show status as 400 with some message
TC_004_Upload_New_Record_With_name_as_empty
   create session  AddData  ${Base_URL}
    ${body_dict}=  create dictionary  natid=1010  name=  gender=M  salary=10000  birthday=05061980  tax=1500
    ${json_body}=  evaluate    json.dumps(${body_dict})    json
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=  POST ON SESSION  AddData  /calculator/insert  data=${json_body}  headers=${header}
    shoould be equal  ${response.status_code}  400





