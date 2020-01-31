/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* LeadTriggerHandler class.
*
* Used to execute contextual logic from the Lead trigger.
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

public with sharing class LeadTriggerHandler {

    public static Boolean afterInsertRun = false;
    public static Boolean afterUpdateRun = false;

    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Handler for trigger logic to be executed in the before context.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void handleBeforeInsert(List<Lead> triggerNew){


        // fetch the record type Id of the person account
        String recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Student_Account').getRecordTypeId();

        // if the lead is not linked to an account, check if an account exists
        Set<String> leadEmails = new Set<String>();

        for (Lead l : triggerNew){
            if (l.Account__c == null && l.Email != null && l.Email != ''){
                leadEmails.add(l.Email);
            }
        }

        // declare map of email to account records used to determine appropriate account
        // for each lead record
        Map<String,Account> accountsMap     = new Map<String,Account>();

        // declare map of new email to account records used to determine appropriate account
        // for each lead record
        Map<String,Account> newAccountsMap  = new Map<String,Account>();

        // query for all accounts with matching emails and add to the map
        for (Account account : [SELECT Id, PersonEmail
                                FROM Account
                                WHERE PersonEmail != NULL
                                AND PersonEmail
                                IN :leadEmails]){
            accountsMap.put(account.PersonEmail, account);
        }

        // iterate over all leads in the trigger and if missing an account,
        // either assign them to the existing account or create a new one
        for (Lead l : triggerNew){
            if (l.Account__c == null){
                system.debug('account is null');
                if (accountsMap.containsKey(l.Email)){
                    system.debug('match found');

                    l.Account__c = accountsMap.get(l.Email).Id;
                } else {

                    system.debug('creating new ');

                    newAccountsMap.put(l.Email, new Account(
                        RecordTypeId    = recordTypeId,
                        FirstName       = l.FirstName,
                        LastName        = l.LastName,
                        Email__c        = l.Email
                    ));

                    system.debug('acc email is ' + l.Email);
                }
            }
        }

        if (!newAccountsMap.isEmpty()){
            system.debug('inserting new ');

            insert newAccountsMap.values();
        }

        for (Lead l : triggerNew){
            if (l.Account__c == null && newAccountsMap.containsKey(l.Email)){
                system.debug('assigning ');

                l.Account__c = newAccountsMap.get(l.Email).Id;
            }
        }

    }




    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Handler for trigger logic to be executed in the after insert context.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void handleAfterInsert(List<Lead> triggerNew){

        // lead ids split into two batches if there are more than 100 records in the trigger
        // to avoid callout limits
        if (!afterInsertRun && !System.isFuture()){
            Set<Id> leadIdsBatchOne = new Set<Id>();
            Set<Id> leadIdsBatchTwo = new Set<Id>();

            for (Lead l : triggerNew){
                if (l.Email != null){
                    if (leadIdsBatchOne.size() < 100){
                        leadIdsBatchOne.add(l.Id);
                    } else {
                        leadIdsBatchTwo.add(l.Id);
                    }
                }
            }

            if (!leadIdsBatchOne.isEmpty()){
                DotMailerSync.postLeads(leadIdsBatchOne);
            }
            if (!leadIdsBatchTwo.isEmpty()){
                DotMailerSync.postLeads(leadIdsBatchTwo);
            }
        }

        afterInsertRun = true;
    }


    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Handler for trigger logic to be executed in the after insert context.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void handleAfterUpdate(List<Lead> triggerNew, Map<Id,Lead> triggerOldMap){

        // lead ids split into two batches if there are more than 100 records in the trigger
        // to avoid callout limits
        if (!afterUpdateRun && !System.isFuture()){
            Set<Id> leadIdsBatchOne = new Set<Id>();
            Set<Id> leadIdsBatchTwo = new Set<Id>();

            for (Lead l : triggerNew){
                if (l.Email != null && l.DotDigitalId__c == null){
                    if (leadIdsBatchOne.size() < 100){
                        leadIdsBatchOne.add(l.Id);
                    } else {
                        leadIdsBatchTwo.add(l.Id);
                    }
                }
            }

            if (!leadIdsBatchOne.isEmpty()){
                DotMailerSync.postLeads(leadIdsBatchOne);
            }
            if (!leadIdsBatchTwo.isEmpty()){
                DotMailerSync.postLeads(leadIdsBatchTwo);
            }
        }

        afterUpdateRun = true;
    }


}