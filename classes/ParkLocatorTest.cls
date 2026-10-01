@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {
        // Set the mock callout class
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        
        // Call the method that invokes the callout
        String country = 'Germany';
        List<String> result = ParkLocator.country(country);
        
        // Create an expected list of parks to verify against the mock response
        List<String> expectedParks = new List<String>{'Hamburg Wadden Sea National Park', 'Hainich National Park', 'Bavarian Forest National Park'};
        
        // Verify that the fake result is returned properly
        Assert.areEqual(expectedParks, result);
    }
}