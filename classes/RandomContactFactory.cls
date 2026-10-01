public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numContacts, String commonLastName) {
        List<Contact> contacts = new List<Contact>();
        
        for (Integer i = 0; i < numContacts; i++) {
            Contact c = new Contact(
                FirstName = 'Test ' + i,
                LastName = commonLastName
            );
            contacts.add(c);
        }
        
        return contacts;
    }
}