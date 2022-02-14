*** Settings ***
Library  Selenium2Library
#Library  DataDriver  uiTest.csv
#Suite Setup  Open Browser  ${URL}  ${Browser}

*** Variables ***
${URL}=   http://localhost:8080/
${Browser}      Chrome
${csv_upload}       xpath=//input[@class="custom-file-input"]
${refresh_tax_relief}       xpath=//button[@class="btn btn-primary"]
${file_path}    "\\uiTest.csv"
${no_record}        xpath=//h1[contains(text(), "No records at the moment 😢")]
${tax_relief_amount}    xpath=//h1[contains(text(), "Total Tax Relieves")]/following-sibling::p
${table_rows}      xpath=//table[@class="table table-hover table-dark"]/tbody/tr
${dispense_now}     xpath=//a[@class="btn btn-danger btn-block"]
${cash_dispense}    xpath=//div[contains(text(),'Cash dispensed')]

*** Test Cases ***
Test_no_data_on_UI
    Open Browser     ${URL}      ${Browser}
    maximize browser window
    element text should be  ${no_record}    No records at the moment 😢
    close browser

##This test should give a validation message as no cash to dispense
Dispense_cash_with_no_record_present
    Open Browser     ${URL}      ${Browser}
    maximize browser window
    click element   ${dispense_now}
    assert False

Upload_CSV
    Open Browser     ${URL}      ${Browser}
    maximize browser window
    choose file  ${csv_upload}  ${CURDIR}/uiTest.csv
    ${total_rows}=      get element count   ${table_rows}
    element should contain  ${tax_relief_amount}    ${total_rows}
    close browser

Dispense_cash
    Open Browser     ${URL}      ${Browser}
    maximize browser window
    choose file  ${csv_upload}  ${CURDIR}/uiTest.csv
    click element   ${dispense_now}
    element should contain      ${cash_dispense}    Cash dispensed
    close browser






