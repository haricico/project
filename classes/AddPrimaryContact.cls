public class AddPrimaryContact implements Queueable {
    
    private Contact contact;
    private String stateAbbreviation;
    
    // Constructor
    public AddPrimaryContact(Contact contact, String stateAbbreviation) {
        this.contact = contact;
        this.stateAbbreviation = stateAbbreviation;
    }
    
    // Execute method
    public void execute(QueueableContext context) {
        // Query a maximum of 200 Accounts with the matching BillingState
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :stateAbbreviation LIMIT 200];
        
        List<Contact> contactsToInsert = new List<Contact>();
        
        // Clone the contact for each account and link it
        for (Account acc : accounts) {
            // clone(preserveId, isDeepClone, preserveReadonlyTimestamps, preserveAutonumber)
            Contact clonedContact = contact.clone(false, false, false, false);
            clonedContact.AccountId = acc.Id;
            contactsToInsert.add(clonedContact);
        }
        
        // Insert the cloned contacts
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}