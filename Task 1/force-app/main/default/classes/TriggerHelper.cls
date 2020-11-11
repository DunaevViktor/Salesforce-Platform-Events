public with sharing class TriggerHelper {
    
    public List<List<messageClass>> findUpdatedFields(Map<Id, Account> oldAccounts, Map<Id, Account> newAccounts) {

        List<List<messageClass>> allAccMessages = new List<List<messageClass>>();

        SObjectType objType = Schema.getGlobalDescribe().get('Account');
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();

        for(Id accountId: newAccounts.keySet()){
            List<messageClass> accMessages = new List<messageClass>();
            Account oldAccount = oldAccounts.get(accountId);
            Account newAccount = newAccounts.get(accountId);

            for(String field: fieldMap.keySet()){
                if(newAccount.get(field) != oldAccount.get(field)) {
                    
                    String forJSON = '' + fieldMap.get(field);
                    String fieldName  = JSON.serialize(forJSON);
                    
                    Object oldValue = oldAccount.get(field);
                    Object newValue = newAccount.get(field);

                    messageClass mes = new messageClass(fieldName, oldValue, newValue);
                    accMessages.add(mes);
                }
            }
            //System.debug('from help: ' + accMessages);
            allAccMessages.add(accMessages);
        }
        return allAccMessages;
    }

    public void createEvent(List<messageClass> accMessages){
        //System.debug(accMessages);
        //Info__c
        String info = '';
        for(Integer i=0; i<accMessages.size(); i++){
            info = info + ' ' + accMessages[i].filedName + ': ' + 
            accMessages[i].oldValue + ' -> ' + accMessages[i].newValue;
        }
        System.debug(info);

        UpdateAccountPE__e newEvent = new UpdateAccountPE__e(Info__c = info);
        Database.SaveResult sr = EventBus.publish(newEvent);

        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
            }
        }
    }
}
