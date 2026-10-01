@isTest
private class AnimalLocatorTest {
    @isTest 
    static void testGetAnimalNameById() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        // Call the method to test
        String actualName = AnimalLocator.getAnimalNameById(1);
        String expectedName = 'chicken';
        
        // Verify that the response received contains fake values
        Assert.areEqual(expectedName, actualName, 'The animal name did not match the expected mock output.');
    }
}