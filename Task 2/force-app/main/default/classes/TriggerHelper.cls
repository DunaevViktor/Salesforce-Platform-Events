public with sharing class TriggerHelper {

    private static final String READ_ACCESS = 'Read';

    public static void giveRecordAccess(List<Account> accounts){

        List<AccountShare> shares = new List<AccountShare>();
        List<Group> groups = getPublicGroups();
    
        for(Account account: accounts){
            for(Group publicGroup: groups){
                if(account.TeamName__c == publicGroup.Name){
                    AccountShare share  = new AccountShare(AccountId = account.Id,
                                                            UserOrGroupId = publicGroup.Id,
                                                            AccountAccessLevel = READ_ACCESS, 
                                                            OpportunityAccessLevel = READ_ACCESS,
                                                            CaseAccessLevel = READ_ACCESS );
                    shares.add(share);
                }
            }            
        }
    
        List<Database.SaveResult> saveResults = Database.insert(shares, false);
    
        for (Database.SaveResult sr : saveResults) {
            if (sr.isSuccess()) {
                System.debug('Records successfully shared!');
            }
        }
    }

    public static List<Group> getPublicGroups(){
        return [SELECT Id, Name FROM Group];
    }

    public static void changeRecordAccess(Map<Id, Account> oldAccounts, List<Account> newAccounts){

        List<Account> changedTeamAccounts = new List<account>();

        for(Account newAccount: newAccounts){
            Account oldAccount = oldAccounts.get(newAccount.Id);

            if(newAccount.TeamName__c != oldAccount.TeamName__c){
                changedTeamAccounts.add(newAccount);
            }
        }

        if(!changedTeamAccounts.isEmpty()){
            giveRecordAccess(changedTeamAccounts);
        }
    }
}
