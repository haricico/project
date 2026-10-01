@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        
        // Extract the Account ID from the URI. 
        // The URL will look like: /services/apexrest/Accounts/<Account_ID>/contacts
        String accountId = request.requestURI.substringBetween('Accounts/', '/contacts');
        
        // Query the Account and its associated Contacts
        Account result = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) 
                          FROM Account 
                          WHERE Id = :accountId 
                          LIMIT 1];
        
        return result;
    }
}