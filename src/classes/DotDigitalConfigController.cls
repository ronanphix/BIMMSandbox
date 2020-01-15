/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* DotDigitalConfigController class.
*
* Additional information about this page or component should be added here, if available. Add a
* single line break between the summary and the additional info.  Use as many lines as necessary.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ronan Williams   <ronanw@phixtechnologies.com>
* @maintainedBy   Ronan Williams   <ronanw@phixtechnologies.com>
* @version        1.0
* @created        15/01/2020
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* vX.X            Ronan Williams
* YYYY-MM-DD      TBC.
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


public with sharing class DotDigitalConfigController {
    
    @AuraEnabled
    public static Object getMappings(){

        Map<String,Object> resMap = new Map<String,Object>();

        // add existing metadata configuration records
        resMap.put('RECORDS',[SELECT Id, ApplicationField__c, BookingField__c, EnquiryField__c, Field__c, Priority__c
                                FROM DotDigitalMapping__mdt]);

        // add all Lead (Enquiry) fields to a map
        List<Object> enquiryFields = new List<Object>();
        Map<String,SObjectField> enquiry = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap();
        for(String str: enquiry.keySet()){
            if (enquiry.get(str).getDescribe().isUpdateable()){
                enquiryFields.add(new Map<String,String>{'label' => enquiry.get(str).getDescribe().getLabel(), 'value' => str});
            }
        }
        resMap.put('ENQUIRY', enquiryFields);

        // add all Opportunity (Application) fields to a map
        List<Object> applicationFields = new List<Object>();
        Map<String,SObjectField> application = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
        for(String str: application.keySet()){
            if (application.get(str).getDescribe().isUpdateable()){
                applicationFields.add(new Map<String,String>{'label' => application.get(str).getDescribe().getLabel(), 'value' => str});
            }
        }
        resMap.put('APPLICATION', enquiryFields);

        // add all Appointment__c (Booking) fields to a map
        List<Object> bookingFields = new List<Object>();
        Map<String,SObjectField> booking = Schema.getGlobalDescribe().get('Appointment__c').getDescribe().fields.getMap();
        for(String str: booking.keySet()){
            if (booking.get(str).getDescribe().isUpdateable()){
                bookingFields.add(new Map<String,String>{'label' => booking.get(str).getDescribe().getLabel(), 'value' => str});
            }
        }
        resMap.put('BOOKING', enquiryFields);

        return resMap;
        
        
        
    }
    

}