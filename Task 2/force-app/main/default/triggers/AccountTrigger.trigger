trigger AccountTrigger on Account (after insert, after update) {

    if(Trigger.isInsert){
        TriggerHelper.giveRecordAccess(Trigger.new);
    }

    if(Trigger.isUpdate){
        TriggerHelper.changeRecordAccess(Trigger.oldMap, Trigger.new);
    }

}