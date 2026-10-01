@isTest
private class AddPrimaryContactTest {
    
    @isTest
    static void testQueueable() {
        // 1. Insert 50 Account records for BillingState NY and 50 for CA
        List<Account> testAccounts = new List<Account>();
        
        for (Integer i = 0; i < 50; i++) {
            testAccounts.add(new Account(Name = 'Test Account NY ' + i, BillingState = 'NY'));
        }
        
        for (Integer i = 0; i < 50; i++) {
            testAccounts.add(new Account(Name = 'Test Account CA ' + i, BillingState = 'CA'));
        }
        
        insert testAccounts;
        
        // 2. Create the Contact to be cloned
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        
        // 3. Create an instance of the AddPrimaryContact class
        AddPrimaryContact updater = new AddPrimaryContact(testContact, 'CA');
        
        // 4. Enqueue the job inside startTest/stopTest block
        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest(); // Forces the asynchronous process to run synchronously
        
        // 5. Assert that 50 contacts were inserted for CA accounts
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE Account.BillingState = 'CA'];
        System.assertEquals(50, contactCount, 'There should be exactly 50 Contacts related to CA Accounts');
    }
}