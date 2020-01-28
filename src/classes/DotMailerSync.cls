/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* DotMailerSync class.
*
* Additional information about this page or component should be added here, if available. Add a
* single line break between the summary and the additional info.  Use as many lines as necessary.
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

public class DotMailerSync {

    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Future method used to post a maximum of 100 leads to DotDigital at endpoint:
    * https://r1-api.dotmailer.com/v2/address-books/853530/contacts.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    leadIds    List of lead Ids to be queried and posted to DotDigital
    * @return   void
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    @Future(Callout=true)
    public static void postLeads(Set<Id> leadIds){

        // query for all leads passed to the future method
        List<Lead> leads = [SELECT Id, Email, FirstName, LastName, Name, PostalCode, Salutation, DotDigitalId__c,
                                    Contact_Outcome__c, Appointment_Status_c__c, Appointment_Start__c,
                                    Appointment_Location__c, Appointment_Type__c,
                                    Date_Time_Assessment_Booked__c, Preferred_Location__c,
                                    Campus__c, Course__c, Course_Area__c, Level_of_Course__c, Date_of_Birth__c,
                                    Enquiry_Type__c, CreatedBy.Name, Main_Address__c, PostCode__c,
                                    Newsletter__c, Nationality__c, Phone, Account__c, LeadSource, UTM_Source__c,
                                    UnitE_Student_Ref__c, Address, Enquiry_Date__c, Entry_Date__c
                            FROM Lead
                            WHERE Id IN :leadIds];

        for (Lead lead : leads){

            // send request
            HttpRequest req     = buildRequest(lead);
            HttpResponse res    = Test.isRunningTest() ? MockHandler.dotDigitalLeadPostMock() : new Http().send(req);

            // assign the id returned, or 'error' IF THE
            if (res.getStatusCode() == 200){
                Map<String,Object> resObjectMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                lead.DotDigitalId__c = String.valueOf((Integer)resObjectMap.get('id'));
            } else {
                lead.DotDigitalId__c = 'ERROR';
            }
        }

        update leads;

    }


    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence description of this Outer Method.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    lead           Lead record used to construct the HttpRequest body
    * @return   HttpRequest    Request containing formatted endpoint, method and body
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static HttpRequest buildRequest(Lead lead){

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://r1-api.dotmailer.com/v2/address-books/' + Label.Dot + '/contacts');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(Label.DotDigitalAPIUser)) );
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{' +
                    '"email":"' + lead.Email + '",' +
                    '"optInType":"Single",' +
                    '"emailType":"Html",' +
                    '"dataFields":[' +
                    '   { key: "FIRSTNAME", value: "' + lead.FirstName + '" },' +
                    '   { key: "LASTNAME", value: "' + lead.LastName + '" },' +
                    '   { key: "FULLNAME", value: "' + lead.Name + '" },' +
                    '   { key: "POSTCODE", value: "' + lead.PostalCode + '" },' +
                    '   { key: "PHONE", value: "' + lead.Phone + '" },' +
                    '   { key: "SALUTATION", value: "' + lead.Salutation + '" },' +
                    '   { key: "APPOINT_OUTCOME", value: "' + lead.Contact_Outcome__c + '" },' +
                    '   { key: "APPOINT_START_DATE", value : "' + lead.Appointment_Start__c + '"},' +
                    '   { key: "APPOINT_START_DAY", value : "' +
                                                    (lead.Appointment_Start__c != null ?
                                                    String.valueOf(lead.Appointment_Start__c.day()) : '') + '"},' +
                    '   { key: "APPOINT_START_TIME", value : "' +
                                                    (lead.Appointment_Start__c != null ?
                                                    String.valueOf(Datetime.valueOf(lead.Appointment_Start__c).time()) : '') + '"},' +
                    '   { key: "APPOINTMENT_LOCATION", value : "' + lead.Appointment_Location__c + '"},' +
                    '   { key: "APPOINTMENT_TYPE", value : "' + lead.Appointment_Type__c + '"},' +
                    '   { key: "ASSESS_DATE", value : "' + lead.Date_Time_Assessment_Booked__c + '"},' +
                    '   { key: "ASSESS_LOCATION", value : "' + lead.Preferred_Location__c + '"},' +
                    '   { key: "ASSESS_OUTCOME", value : "' + lead.Contact_Outcome__c + '"},' +
                    '   { key: "ASSESS_TYPE", value : "' + lead.Enquiry_Type__c + '"},' +
                    '   { key: "DATE_OF_BIRTH_2", value : "' + lead.Date_of_Birth__c + '"},' +
                    '   { key: "ENQUIRY_DATE", value : "' + lead.Enquiry_Date__c + '"},' +
                    '   { key: "ENQUIRY_STATUS", value : "' + lead.Enquiry_Type__c + '"},' +
                    '   { key: "MAIN_ADDRESS", value : "' + lead.Address + '"},' +
                    '   { key: "PREF_COURSE_AREA", value : "' + lead.Course_Area__c + '"},' +
                    '   { key: "PREF_COURSE_LEVEL", value : "' + lead.Level_of_Course__c + '"},' +
                    '   { key: "PREF_COURSE_LOCATION", value : "' + lead.Appointment_Location__c + '"},' +
                    '   { key: "PREF_ENTRY_DATE", value : "' + lead.Entry_Date__c + '"},' +
                    '   { key: "SF_LEADID", value : "' + lead.Id + '"},' +
                    '   { key: "UNITE_STUDENT_REF", value : "' + lead.UnitE_Student_Ref__c + '"}' +
                    '           ]' +
                '}'
        );

        return request;
    }

    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Future method used to post a maximum of 100 opportunities to DotDigital at endpoint:
    * https://r1-api.dotmailer.com/v2/address-books/853530/contacts.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    leadIds    List of opportunity Ids to be queried and posted to DotDigital
    * @return   void
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    @Future(Callout=true)
    public static void postOpportunities(Set<Id> oppIds){

        // query for all leads passed to the future method
        List<Opportunity> opps = [SELECT Id, Application_Status__c, Appointment_Outcome__c, Email2__c,
                                        Account.FirstName, Account.LastName, Account.Name, Account.ShippingPostalCode,
                                        Account.Salutation, DotDigitalId__c, Application_Location__c,
                                        Booking_Type__c, Application_Date__c, Reply_Status__c, AccountId,
                                        Campus__c, Course__c, Course_Area__c, Level_of_Course__c, Account.Date_of_Birth__c,
                                        CreatedBy.Name,Account.Nationality__c, Account.Phone, LeadSource, UTM_Source__c,
                                        Account.UnitE_Student_Ref__c, Enquiry_Date__c, Entry_Date__c,
                                        Application_Outcome__c, Account.PersonMailingAddress
                                    FROM Opportunity
                                    WHERE Id IN :oppIds];

        for (Opportunity opp : opps){

            // send request
            HttpRequest req     = buildRequest(opp);
            HttpResponse res    = Test.isRunningTest() ? MockHandler.dotDigitalOpportunityPostMock() : new Http().send(req);

            system.debug(res.getBody());

            // assign the id returned, or 'error' IF THE
            if (res.getStatusCode() == 200){
                Map<String,Object> resObjectMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                opp.DotDigitalId__c = String.valueOf((Integer)resObjectMap.get('id'));
            } else {
                opp.DotDigitalId__c = 'ERROR';
            }
        }

        update opps;

    }


    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence description of this Outer Method.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    lead           Opportunity record used to construct the HttpRequest body
    * @return   HttpRequest    Request containing formatted endpoint, method and body
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static HttpRequest buildRequest(Opportunity opp){

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://r1-api.dotmailer.com/v2/address-books/853530/contacts');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(Label.DotDigitalAPIUser)) );
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{' +
                '"email":"' + opp.Email2__c + '",' +
                '"optInType":"Single",' +
                '"emailType":"Html",' +
                '"dataFields":[' +
                '   { key: "APP_STATUS", value: "' + opp.Application_Status__c + '" },' +
                '   { key: "APPOINT_OUTCOME", value: "' + opp.Application_Outcome__c + '" },' +
                '   { key: "FIRSTNAME", value: "' + opp.Account.FirstName + '" },' +
                '   { key: "LASTNAME", value: "' + opp.Account.LastName + '" },' +
                '   { key: "FULLNAME", value: "' + opp.Account.Name + '" },' +
                '   { key: "POSTCODE", value: "' + opp.Account.ShippingPostalCode + '" },' +
                '   { key: "PHONE", value: "' + opp.Account.Phone + '" },' +
                '   { key: "SALUTATION", value: "' + opp.Account.Salutation + '" },' +
                '   { key: "REPLY_STATUS", value: "' + opp.Reply_Status__c + '" },' +
                '   { key: "APPOINT_OUTCOME", value: "' + opp.Application_Outcome__c + '" },' +
                '   { key: "APPOINTMENT_TYPE", value : "' + opp.Booking_Type__c + '"},' +
                '   { key: "ASSESS_DATE", value : "' + opp.Application_Date__c + '"},' +
                '   { key: "ASSESS_LOCATION", value : "' + opp.Application_Location__c + '"}' +
                '   { key: "DATE_OF_BIRTH_2", value : "' + opp.Account.Date_of_Birth__c + '"},' +
                '   { key: "MAIN_ADDRESS", value : "' + opp.Account.PersonMailingAddress + '"},' +
                '   { key: "PREF_COURSE_AREA", value : "' + opp.Course_Area__c + '"},' +
                '   { key: "PREF_COURSE_LEVEL", value : "' + opp.Level_of_Course__c + '"},' +
                '   { key: "SF_ACCOUNTID", value : "' + opp.AccountId + '"},' +
                '   { key: "UNITE_STUDENT_REF", value : "' + opp.Account.UnitE_Student_Ref__c + '"}' +
                '           ]' +
                '}'
        );

        return request;
    }

}