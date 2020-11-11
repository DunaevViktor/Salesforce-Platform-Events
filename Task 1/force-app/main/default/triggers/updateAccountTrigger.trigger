trigger updateAccountTrigger on Account (after update) {
    TriggerHelper helper = new TriggerHelper();
    helper.findUpdatedFields(Trigger.oldMap, Trigger.newMap);
}