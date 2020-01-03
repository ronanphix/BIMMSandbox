/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* LeadTriggerHandler class.
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

public with sharing class LeadTriggerHandler {


    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence description of this Outer Method.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    NAME    DESCRIPTION (MENTION PARAMETER TYPE IN DESCRIPTION)
    * @param    NAME    DESCRIPTION (MENTION PARAMETER TYPE IN DESCRIPTION)
    * @return   TYPE    DESCRIPTION (MENTION LIKELY VALUES IN DESCRIPTION)
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void handleAfterInsert(){
        if (Trigger.new.size() < 100){
            DotMailerSync.postLeads(Trigger.newMap.keySet());
        }
    }


    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence description of this Outer Method.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    NAME    DESCRIPTION (MENTION PARAMETER TYPE IN DESCRIPTION)
    * @param    NAME    DESCRIPTION (MENTION PARAMETER TYPE IN DESCRIPTION)
    * @return   TYPE    DESCRIPTION (MENTION LIKELY VALUES IN DESCRIPTION)
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void handleAfterUpdate(){


        system.debug(Trigger.new);

    }


}