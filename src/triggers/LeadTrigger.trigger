/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Lead trigger.
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ronan Williams   <ronanw@phixtechnologies.com>
* @modifiedBy     Ronan Williams   <ronanw@phixtechnologies.com>
* @maintainedBy   Ronan Williams   <ronanw@phixtechnologies.com>
* @version        1.0
* @created        4-2-2020
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* vX.X            Ronan Williams
* YYYY-MM-DD      TBC.
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {


    if (Trigger.isBefore){

        LeadTriggerHandler.handleBeforeInsert(Trigger.new);


    }






    // todo: revise this logic to work in loop
    if (Trigger.isAfter){
        if (Trigger.isInsert){
            LeadTriggerHandler.handleAfterInsert(Trigger.new);
        }

        if (Trigger.isUpdate){
            LeadTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

}