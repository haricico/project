@isTest
private class DailyLeadProcessorTest {
    
    // Dummy CRON expression for testing: midnight on March 15, 2042.
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';
    
    @isTest
    static void testScheduledJob() {
        // 1. Insert 200 Lead records with a blank LeadSource
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'TestFirst', 
                LastName = 'TestLast ' + i, 
                Company = 'Test Company ' + i
                // LeadSource is left blank by default
            ));
        }
        insert testLeads;
        
        // 2. Schedule the job inside startTest/stopTest block
        Test.startTest();
        String jobId = System.schedule('Daily Lead Processor Test', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest(); // Forces the asynchronous scheduled job to execute synchronously
        
        // 3. Test that all 200 Lead records were updated correctly
        Integer updatedLeadsCount = [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeadsCount, 'All 200 leads should have LeadSource set to Dreamforce');
    }
}