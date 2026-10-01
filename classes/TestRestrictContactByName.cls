@IsTest
private class TestRestrictContactByName {
    
    @IsTest
    static void testInsertInvalidContact() {
        // Test data setup for insert with invalid last name
        Contact c = new Contact(FirstName='John', LastName='INVALIDNAME');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(c, false);
        Test.stopTest();
        
        // Verify that the insert was blocked with the correct error
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML', result.getErrors()[0].getMessage());
    }
    
    @IsTest
    static void testUpdateInvalidContact() {
        // Test data setup with a valid contact first
        Contact c = new Contact(FirstName='Jane', LastName='Doe');
        insert c;
        
        // Update the contact's last name to trigger the error condition
        c.LastName = 'INVALIDNAME';
        
        Test.startTest();
        Database.SaveResult result = Database.update(c, false);
        Test.stopTest();
        
        // Verify that the update was blocked
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML', result.getErrors()[0].getMessage());
    }
    
    @IsTest
    static void testInsertValidContact() {
        // Test data setup for a normal, valid contact
        Contact c = new Contact(FirstName='Valid', LastName='User');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(c, false);
        Test.stopTest();
        
        // Verify that the insert succeeds successfully
        System.assert(result.isSuccess());
    }
}