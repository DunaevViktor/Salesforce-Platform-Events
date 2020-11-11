trigger updateAccountTrigger on Account (after update) {

    List<List<messageClass>> allAccMessages = new List<List<messageClass>>();

    TriggerHelper helper = new TriggerHelper();
    allAccMessages = helper.findUpdatedFields(Trigger.oldMap, Trigger.newMap);
    //System.debug('from tr: ' + allAccMessages);

    //not bulkify!!!
    helper.createEvent(allAccMessages[0]);

}