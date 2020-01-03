/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* MockHandler class.
*
* Used to contain mock REST API responses.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ronan Williams   <ronanw@phixtechnologies.com>
* @maintainedBy   Ronan Williams   <ronanw@phixtechnologies.com>
* @version        1.0
* @created        03/01/2020
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* vX.X            Ronan Williams
* YYYY-MM-DD      TBC.
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public with sharing class MockHandler {

    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Sample HttpResponse object used in test method context.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @return   HttpResponse    Returns sample Http Response with JSON body from DotDigital
    *                           https://r1-api.dotmailer.com/v2/address-books/853530/contacts
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static HttpResponse dotDigitalLeadPostMock(){

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"id":1}');
        return mockResponse;
    }

    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Sample HttpResponse object used in test method context.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @return   HttpResponse    Returns sample Http Response with JSON body from DotDigital
    *                           https://r1-api.dotmailer.com/v2/address-books/853530/contacts
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static HttpResponse dotDigitalOpportunityPostMock(){

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"id":1}');
        return mockResponse;
    }

}