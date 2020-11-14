@IsTest
public with sharing class TriggerHelperTest {
    
    private static String ACCOUNT_NAME = 'Test Name';
    private static String NO_EXPECTED_RESULT = 'The result was not what was expected.';

    @TestSetup
    static void makeData(){
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;
    }

    @IsTest
    static void findUpdatedFieldsTest(){
        Account account = [SELECT Id, Name FROM Account];

        try{
            account.Name = 'New Test Name';
            update account;
        }
        catch(Exception e) {
            System.assert(false, NO_EXPECTED_RESULT);
        }

        System.assert(true);
    }
}
