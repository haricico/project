public class AccountHandler {
    public static Account insertNewAccount(String accountName) {
        try {
            // Create the new account using the incoming parameter
            Account newAcct = new Account(Name = accountName);
            
            // Insert the account into the system
            insert newAcct;
            
            // Return the successfully inserted record
            return newAcct;
            
        } catch (DmlException e) {
            // Catch the failed DML if, for example, the string is empty
            System.debug('A DML exception has occurred: ' + e.getMessage());
            return null;
        }
    }
}