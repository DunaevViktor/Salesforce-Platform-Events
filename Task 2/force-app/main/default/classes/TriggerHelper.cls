public with sharing class TriggerHelper {

    public static void giveRecordAccess(List<Account> accounts){

        List<AccountShare> shares = new List<AccountShare>();
    
        for(Account account: accounts){
            Id groupId = searchPublicGroup(account.TeamName__c);
    
            AccountShare share  = new AccountShare(AccountId = account.Id, 
                                                    UserOrGroupId = groupId,
                                                    AccountAccessLevel = 'Read',
                                                    OpportunityAccessLevel = 'Read',
                                                    CaseAccessLevel = 'Read' );
            shares.add(share);
        }
    
        List<Database.SaveResult> saveResults = Database.insert(shares, false);
    
        for (Database.SaveResult sr : saveResults) {
            if (sr.isSuccess()) {
                System.debug('Records successfully shared!');
            }
        }
    }

    public static Id searchPublicGroup(String groupName){
        Group publicGroup = [SELECT Id, Name FROM Group WHERE Name = :groupName LIMIT 1];
        return publicgroup.Id;
    }
}
