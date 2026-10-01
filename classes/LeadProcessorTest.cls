@IsTest
private class LeadProcessorTest {
    
    @IsTest
    static void testBatchClass() {
        // 1. Insert 200 Lead records
        List<Lead> leadsToInsert = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leadsToInsert.add(new Lead(
                FirstName = 'TestFirst', 
                LastName = 'TestLast ' + i, 
                Company = 'Test Company ' + i
            ));
        }
        insert leadsToInsert;
        
        // 2. Execute the LeadProcessor Batch class
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest(); // Forces asynchronous batch jobs to run synchronously
        
        // 3. Test that all 200 Lead records were updated correctly
        Integer updatedLeadsCount = [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeadsCount, 'All 200 leads should have LeadSource set to Dreamforce');
    }
}