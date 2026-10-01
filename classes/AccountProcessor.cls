public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds) {
        // Query the accounts and their related contacts
        List<Account> accountsToUpdate = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds];
        
        // Loop through the accounts and update the custom field
        for (Account acc : accountsToUpdate) {
            acc.Number_Of_Contacts__c = acc.Contacts.size();
        }
        
        // Update the accounts in the database
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}