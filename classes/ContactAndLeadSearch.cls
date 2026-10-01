public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads(String searchWord) {
        
        // Execute the SOSL query to search across both Contact and Lead objects
        List<List<sObject>> searchList = [FIND :searchWord IN ALL FIELDS 
                                          RETURNING Contact(FirstName, LastName), 
                                          Lead(FirstName, LastName)];
        
        return searchList;
    }
}