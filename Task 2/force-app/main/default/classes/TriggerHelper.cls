public with sharing class TriggerHelper {

    private static final String READ_ACCESS = 'Read';

    public static void giveRecordAccess(List<Account> accounts){

        List<Id> accountIds = getAccountIds(accounts);
        List<AccountShare> sharesToDelete = getAccountShares(accountIds);
        Database.delete(sharesToDelete, false);

        List<AccountShare> shares = new List<AccountShare>();
        List<Group> groups = getPublicGroups();

        Map<String, Group> mapOfGroups = new Map<String, Group>();
        for(Group gr: groups){
            mapOfGroups.put(gr.Name, gr);
        }

        for(Account account: accounts){
            Group publicGroup = mapOfGroups.get(account.TeamName__c);

            AccountShare share  = new AccountShare(AccountId = account.Id,
                                                    UserOrGroupId = publicGroup.Id,
                                                    AccountAccessLevel = READ_ACCESS, 
                                                    OpportunityAccessLevel = READ_ACCESS,
                                                    CaseAccessLevel = READ_ACCESS );
            shares.add(share);          
        }
    
        List<Database.SaveResult> saveResults = Database.insert(shares, false);
    
        for (Database.SaveResult sr : saveResults) {
            if (sr.isSuccess()) {
                System.debug('Records successfully shared!');
            }
        }
    }

    public static void changeRecordAccess(Map<Id, Account> oldAccounts, List<Account> newAccounts){

        List<Account> changedTeamAccounts = new List<account>();

        for(Account newAccount: newAccounts){
            Account oldAccount = oldAccounts.get(newAccount.Id);

            if((newAccount.TeamName__c != oldAccount.TeamName__c) || (newAccount.OwnerId != oldAccount.OwnerId)){
                changedTeamAccounts.add(newAccount);
            }
        }

        if(!changedTeamAccounts.isEmpty()){
            giveRecordAccess(changedTeamAccounts);
        }
    }

    public static List<Id> getAccountIds(List<Account> accounts){
        List<Id> accountIds = new List<Id>();
        for(Account account: accounts){
            accountIds.add(account.Id);
        }

        return accountIds;
    }

    public static List<AccountShare> getAccountShares(List<Id> accountIds){

        List<Group> necessaryGroups = getPublicGroups();
        List<Id> groupIds = new List<Id>();
        for(Group gr: necessaryGroups){
            groupIds.add(gr.Id);
        }

        return [SELECT  Id, AccountId, AccountAccessLevel, UserOrGroupId,
                        OpportunityAccessLevel, CaseAccessLevel
                        FROM AccountShare 
                        WHERE AccountId IN :accountIds AND UserOrGroupId IN :groupIds];
    }

    public static List<String> getPickList(){
        List<String> optionList = new List<String>();
        
        Schema.DescribeFieldResult fieldRes = Account.TeamName__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldRes.getPicklistValues();
        
        for(Schema.PicklistEntry en: entries){
            optionList.add(en.getLabel());
        }
		        
        return optionList;  
    }

    public static List<Group> getPublicGroups(){
        List<String> necessaryGroups = getPickList();
        return [SELECT Id, Name FROM Group WHERE Name IN :necessaryGroups];
    }
}
