public with sharing class TriggerHelper {
    
    public void findUpdatedFields(Map<Id, Account> oldAccounts, Map<Id, Account> newAccounts) {

        SObjectType objType = Schema.getGlobalDescribe().get('Account');
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();

        List<UpdateAccountPE__e> forPublishPE = new List<UpdateAccountPE__e>();

        for(Id accountId: newAccounts.keySet()){
            List<MessageItem> accMessages = new List<MessageItem>();
            Account oldAccount = oldAccounts.get(accountId);
            Account newAccount = newAccounts.get(accountId);

            for(String field: fieldMap.keySet()){
                if(newAccount.get(field) != oldAccount.get(field)) {
                    
                    String forJSON = '' + fieldMap.get(field);
                    String fieldName  = JSON.serialize(forJSON);
                    
                    Object oldValue = oldAccount.get(field);
                    Object newValue = newAccount.get(field);

                    MessageItem mes = new MessageItem(fieldName, oldValue, newValue);
                    accMessages.add(mes);
                }
            }
            forPublishPE.add(createEvent(accMessages, newAccount.Id));
        }

        List<Database.SaveResult> sr = EventBus.publish(forPublishPE);
    }

    public UpdateAccountPE__e createEvent(List<MessageItem> accMessages, Id accountId){

        String info = '';
        for(Integer i=0; i<accMessages.size(); i++){
            info = info + ' ' + accMessages[i].filedName + ': ' + 
            accMessages[i].oldValue + ' -> ' + accMessages[i].newValue;
        }

        UpdateAccountPE__e newEvent = new UpdateAccountPE__e(Info__c = info, AccountId__c = accountId);
        return newEvent;
    }
}