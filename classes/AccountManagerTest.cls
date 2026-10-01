@IsTest
private class AccountManagerTest {
    
    @isTest
    static void testGetAccount() {
        // 1. Create mock data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testAccount.Id);
        insert testContact;
        
        // 2. Set up the test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://yourInstance.my.salesforce.com/services/apexrest/Accounts/' + testAccount.Id + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // 3. Call the REST method
        Account returnedAccount = AccountManager.getAccount();
        
        // 4. Verify the results
        System.assertNotEquals(null, returnedAccount, 'The returned account should not be null.');
        System.assertEquals('Test Account', returnedAccount.Name, 'The account name should match.');
        System.assertEquals(1, returnedAccount.Contacts.size(), 'The account should have exactly 1 contact.');
    }
}