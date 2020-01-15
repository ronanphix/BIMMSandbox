/**
 * Created by ronanwilliams on 2020-01-15.
 */

({
    doInit :function(C){

        var getMappings = C.get('c.getMappings');
        getMappings.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS'){
                var resMap = response.getReturnValue();
                resMap.RECORDS.forEach(function(record){
                    record.EnquiryField__c      = {label:'cd',value:'dsf'};
                    record.ApplicationField__c  = {label:'sdf',value:'dfs'};
                    record.BookingField__c      = {label:'sdf',value:'sdf'};
                });
                console.log(resMap.RECORDS);
                C.set('v.mappings',resMap.RECORDS);
                C.set('v.enquiry',resMap.ENQUIRY);
                C.set('v.application',resMap.APPLICATION);
                C.set('v.booking',resMap.BOOKING);
            }
        });
        $A.enqueueAction(getMappings);
    }


});