@isTest
private class ClaimApprovalActionTest {

    private static ClaimApprovalAction.Request makeRequest(Id claimId, String decision) {
        ClaimApprovalAction.Request r = new ClaimApprovalAction.Request();
        r.recordId = claimId;
        r.decision = decision;
        r.comments = 'Test comment';
        return r;
    }

    @isTest
    static void testNoPendingRequest() {
        Claim__c c = new Claim__c(Claim_Amount__c = 1000, Date_of_Loss__c = Datetime.now());
        insert c;
        Test.startTest();
        List<String> out = ClaimApprovalAction.processApproval(
            new List<ClaimApprovalAction.Request>{ makeRequest(c.Id, 'Approve') }
        );
        Test.stopTest();
        System.assertEquals(1, out.size());
        System.assert(out[0].contains('No pending approval'));
    }

    @isTest
    static void testHighValueClaimApproveAndReject() {
        // Over 50,000: the submission flow sends these to the approval process
        Claim__c a = new Claim__c(Claim_Amount__c = 75000, Date_of_Loss__c = Datetime.now());
        Claim__c b = new Claim__c(Claim_Amount__c = 80000, Date_of_Loss__c = Datetime.now());
        insert new List<Claim__c>{ a, b };
        Test.startTest();
        List<String> out = ClaimApprovalAction.processApproval(
            new List<ClaimApprovalAction.Request>{
                makeRequest(a.Id, 'Approve'),
                makeRequest(b.Id, 'Reject')
            }
        );
        Test.stopTest();
        System.assertEquals(2, out.size());
        System.assertNotEquals(null, out[0]);
        System.assertNotEquals(null, out[1]);
    }
}