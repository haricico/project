@IsTest
private class AccountProcessorTest {
    @IsTest
    static void testCountContacts() {
        // 1. Create test data
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
        
        Contact testCon1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testAcc.Id);
        Contact testCon2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = testAcc.Id);
        insert new List<Contact>{testCon1, testCon2};
        
        List<Id> accountIds = new List<Id>{testAcc.Id};
        
        // 2. Execute the future method
        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest(); // Forces the asynchronous code to run synchronously for testing
        
        // 3. Query the updated account and assert the result
        Account updatedAcc = [SELECT Id, Number_Of_Contacts__c FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals(2, updatedAcc.Number_Of_Contacts__c, 'The number of contacts should be exactly 2.');
    }
}