*** Settings ***
Library        RequestsLibrary
Resource       ../../resources/common.resource
Variables      ../../resources/variables.py
Suite Setup    Create Token    ${url}

*** Test Cases ***
Create booking
    ${headers}    Create Dictionary    Content-Type=${Content_Type}

    ${body}    Evaluate    json.loads(open('./fixtures/json/booking1.json').read())

    ${response}    POST    url=${url}/booking    json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]                 ${firstname}                 
    Should Be Equal    ${response_body}[booking][lastname]                  ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]                ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]               ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]    ${bookingdates}[checkout]  
    Should Be Equal    ${response_body}[booking][additionalneeds]           ${additionalneeds}

Get booking
    Get booking Id    ${url}    ${firstname}    ${lastname}

    ${response}    GET    url=${url}/booking/${booking_id}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]                 ${firstname}                 
    Should Be Equal    ${response_body}[lastname]                  ${lastname}
    Should Be Equal    ${response_body}[totalprice]                ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]               ${depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]  
    Should Be Equal    ${response_body}[additionalneeds]           ${additionalneeds}

Update booking
    Get booking Id    ${url}    ${firstname}    ${lastname}

    ${headers}    Create Dictionary    Content-Type=${Content_Type}    Cookie=token=${token}

    ${body}    Create Dictionary    firstname=${firstname}    lastname=${lastname}    totalprice=90    depositpaid=True    bookingdates=${bookingdates}    additionalneeds=${additionalneeds}
    
    ${response}    PUT    url=${url}/booking/${booking_id}    json=${body}    headers=${headers}   

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]                 ${firstname}                 
    Should Be Equal    ${response_body}[lastname]                  ${lastname}
    Should Be Equal    ${response_body}[totalprice]                ${{int(90)}}
    Should Be Equal    ${response_body}[depositpaid]               ${{bool(True)}}
    Should Be Equal    ${response_body}[bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]  
    Should Be Equal    ${response_body}[additionalneeds]           ${additionalneeds}

Partial Update booking
    Get booking Id    ${url}    ${firstname}    ${lastname}

    ${headers}    Create Dictionary    Content-Type=${Content_Type}    Cookie=token=${token}

    ${body}    Create Dictionary    additionalneeds=Dinner

    ${response}    PATCH    url=${url}/booking/${booking_id}    json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]                 ${firstname}                 
    Should Be Equal    ${response_body}[lastname]                  ${lastname}
    Should Be Equal    ${response_body}[totalprice]                ${{int(90)}}
    Should Be Equal    ${response_body}[depositpaid]               ${{bool(True)}}
    Should Be Equal    ${response_body}[bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]  
    Should Be Equal    ${response_body}[additionalneeds]           Dinner

Delete Booking
    Get booking Id    ${url}    ${firstname}    ${lastname}

    ${headers}    Create Dictionary    Content-Type=${Content_Type}    Cookie=token=${token}

    ${response}    DELETE    url=${url}/booking/${booking_id}    headers=${headers}

    Status Should Be    201
   


