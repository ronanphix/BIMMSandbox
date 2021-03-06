/**
 * Created by ronanwilliams on 2020-01-03.
 */

/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Opportunity trigger.
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ronan Williams   <ronanw@phixtechnologies.com>
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

trigger OpportunityTrigger on Opportunity(after insert, after update) {

    if (Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.handleAfterInsert();
    }

    if (Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.handleAfterUpdate();
    }
}