public class ContactSearch {
    public static List<Contact> searchForContacts(String lastName, String postalCode) {
        // Query to find contacts matching the provided last name and mailing postal code
        List<Contact> matchingContacts = [SELECT Id, Name 
                                          FROM Contact 
                                          WHERE LastName = :lastName 
                                          AND MailingPostalCode = :postalCode];
        
        // Return the list of contacts
        return matchingContacts;
    }
}