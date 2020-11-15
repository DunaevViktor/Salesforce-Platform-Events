@IsTest
public with sharing class TriggerHelperTest {
    
    private static String ACCOUNT_NAME = 'Test Name';
    private static String INVALID_RULES_AMOUNT = 'The number received does not match the expected number.';
    private static String INVALID_GROUP = 'The resulting name does not match what was expected.';

    @IsTest
    public static void insertTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        account.TeamName__c = 'Team 1';

        Test.startTest();
        insert account;
        Test.stopTest();

        List<AccountShare> rules = [SELECT Id, UserOrGroupId, AccountId 
                                    FROM AccountShare 
                                    WHERE AccountId = :account.Id AND RowCause = 'Manual'];
        System.assertEquals(1, rules.size(), INVALID_RULES_AMOUNT);

        Group userGroup = [SELECT Id, Name FROM Group WHERE Id = :rules[0].UserOrGroupId];
        System.assertEquals(account.TeamName__c, userGroup.Name, INVALID_RULES_AMOUNT);
    }  
    
    @IsTest
    public static void updateTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        account.TeamName__c = 'Team 1';

        Test.startTest();
        insert account;
        account.TeamName__c = 'Team 2';
        update account;
        Test.stopTest();

        List<AccountShare> rules = [SELECT Id, UserOrGroupId, AccountId 
                                    FROM AccountShare 
                                    WHERE AccountId = :account.Id AND RowCause = 'Manual'];
        System.assertEquals(1, rules.size(), INVALID_RULES_AMOUNT);

        Group userGroup = [SELECT Id, Name FROM Group WHERE Id = :rules[0].UserOrGroupId];
        System.assertEquals(account.TeamName__c, userGroup.Name, INVALID_RULES_AMOUNT);
    }
}
