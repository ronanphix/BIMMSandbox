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

trigger LeadTrigger on Lead (after insert, after update) {

    if (Trigger.isAfter && Trigger.isInsert){
        LeadTriggerHandler.handleAfterInsert();
    }

    if (Trigger.isAfter && Trigger.isUpdate){
        LeadTriggerHandler.handleAfterUpdate();
    }
}