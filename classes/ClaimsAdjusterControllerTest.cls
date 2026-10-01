@isTest
private class ClaimsAdjusterControllerTest {

    @testSetup
    static void setupTestData() {
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String uname = 'claimsadj' + UserInfo.getOrganizationId() + '@example.com.test';
        User u = new User(
            FirstName = 'Test', LastName = 'Adjuster', Alias = 'tadj',
            Username = uname, Email = 'claimsadj@example.com',
            TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
            ProfileId = prof.Id
        );
        // Avoids MIXED_DML_OPERATION between User and custom objects
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert u;
            // Read access on Claim is needed so claims can be handed back to this user
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Claims_Adjuster_Access' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
        }

        Id autoPolicyRT = Schema.SObjectType.Policy__c.getRecordTypeInfosByDeveloperName().get('Auto').getRecordTypeId();
        Id propPolicyRT = Schema.SObjectType.Policy__c.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
        Id claimRT = Schema.SObjectType.Claim__c.getRecordTypeInfosByDeveloperName().get('Accident').getRecordTypeId();

        Contact con = new Contact(FirstName = 'John', LastName = 'Doe', OwnerId = u.Id);
        insert con;

        Policy__c autoPolicy = new Policy__c(
            Customer__c = con.Id, RecordTypeId = autoPolicyRT,
            VIN__c = '1A903284375893532', OwnerId = u.Id
        );
        Policy__c propPolicy = new Policy__c(
            Customer__c = con.Id, RecordTypeId = propPolicyRT,
            Square_Footage__c = 1800, OwnerId = u.Id
        );
        insert new List<Policy__c>{ autoPolicy, propPolicy };

        List<Claim__c> claims = new List<Claim__c>{
            new Claim__c(Policy__c = autoPolicy.Id, RecordTypeId = claimRT,
                Claim_Amount__c = 5000, Date_of_Loss__c = Datetime.now().addDays(-10), OwnerId = u.Id),
            new Claim__c(Policy__c = propPolicy.Id, RecordTypeId = claimRT,
                Claim_Amount__c = 12000, Date_of_Loss__c = Datetime.now().addDays(-2), OwnerId = u.Id)
        };
        insert claims;
        // The claim routing flow moves new claims into a queue on create.
        // Hand them back to the test adjuster so the dashboard query has data.
        for (Claim__c c : claims) {
            c.OwnerId = u.Id;
        }
        update claims;
    }

    @isTest
    static void testGetAssignedClaims() {
        User u = [SELECT Id FROM User WHERE Alias = 'tadj' LIMIT 1];
        List<ClaimsAdjusterController.ClaimWrapper> results;
        System.runAs(u) {
            Test.startTest();
            results = ClaimsAdjusterController.getAssignedClaims();
            Test.stopTest();
        }
        System.assertEquals(2, results.size());
        // Ordered by Date of Loss, newest first -> property claim first
        System.assertEquals('Property', results[0].policyType);
        System.assertEquals('Auto', results[1].policyType);
        System.assertEquals(5000, results[1].claimAmount);
        System.assertEquals('New', results[1].status);
        System.assert(results[1].policyHolderName.contains('John'));
        System.assert(results[1].daysOpen >= 9 && results[1].daysOpen <= 11);
        System.assertNotEquals(null, results[1].claimId);
        System.assertNotEquals(null, results[1].claimNumber);
    }

    @isTest
    static void testClientSideFilterSourceData() {
        User u = [SELECT Id FROM User WHERE Alias = 'tadj' LIMIT 1];
        Integer autoCount = 0;
        System.runAs(u) {
            for (ClaimsAdjusterController.ClaimWrapper c : ClaimsAdjusterController.getAssignedClaims()) {
                if (c.policyType == 'Auto') { autoCount++; }
            }
        }
        System.assertEquals(1, autoCount);
    }

    @isTest
    static void testNoClaimsForOtherUser() {
        // Running as the admin who owns none of the claims
        List<ClaimsAdjusterController.ClaimWrapper> results = ClaimsAdjusterController.getAssignedClaims();
        System.assertEquals(0, results.size());
    }
}