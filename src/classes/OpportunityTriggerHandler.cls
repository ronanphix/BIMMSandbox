/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* OpportunityTriggerHandler class.
*
* Used to execute contextual logic from the Opportunity trigger.
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

public with sharing class OpportunityTriggerHandler {

    public static Boolean afterInsertRun = false;
    public static Boolean afterUpdateRun = false;

    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Handler for trigger logic to be executed in the after insert context.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void handleAfterInsert(){

        // Opportunity ids split into two batches if there are more than 100 records in the trigger
        // to avoid callout limits
        if (!afterInsertRun && !System.isFuture()){
            Set<Id> oppIdsBatchOne = new Set<Id>();
            Set<Id> oppIdsBatchTwo = new Set<Id>();

            for (Object oppObj : Trigger.new){
                Opportunity o = (Opportunity)oppObj;
                if (o.Email2__c != null){
                    if (oppIdsBatchOne.size() < 100){
                        oppIdsBatchOne.add(o.Id);
                    } else {
                        oppIdsBatchTwo.add(o.Id);
                    }
                }
            }

            if (!oppIdsBatchOne.isEmpty()){
                DotMailerSync.postOpportunities(oppIdsBatchOne);
            }
            if (!oppIdsBatchTwo.isEmpty()){
                DotMailerSync.postOpportunities(oppIdsBatchTwo);
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
    public static void handleAfterUpdate(){

        // Opportunity ids split into two batches if there are more than 100 records in the trigger
        // to avoid callout limits
        if (!afterUpdateRun && !System.isFuture()){
            Set<Id> oppIdsBatchOne = new Set<Id>();
            Set<Id> oppIdsBatchTwo = new Set<Id>();

            for (Object oppObj : Trigger.new){
                Opportunity o = (Opportunity)oppObj;
                if (o.Email2__c != null){
                    if (oppIdsBatchOne.size() < 100){
                        oppIdsBatchOne.add(o.Id);
                    } else {
                        oppIdsBatchTwo.add(o.Id);
                    }
                }
            }

            if (!oppIdsBatchOne.isEmpty()){
                DotMailerSync.postOpportunities(oppIdsBatchOne);
            }
            if (!oppIdsBatchTwo.isEmpty()){
                DotMailerSync.postOpportunities(oppIdsBatchTwo);
            }
        }

        afterUpdateRun = true;
    }


}