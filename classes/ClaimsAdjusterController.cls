public with sharing class ClaimsAdjusterController {

    public class ClaimWrapper {
        @AuraEnabled public Id claimId;
        @AuraEnabled public String claimNumber;
        @AuraEnabled public Decimal claimAmount;
        @AuraEnabled public String status;
        @AuraEnabled public String policyType;
        @AuraEnabled public String policyHolderName;
        @AuraEnabled public Integer daysOpen;

        public ClaimWrapper(Claim__c c) {
            this.claimId = c.Id;
            this.claimNumber = c.Name;
            this.claimAmount = c.Claim_Amount__c;
            this.status = c.Approval_Status__c;

            Policy__c p = c.Policy__r;
            this.policyType = (p != null && p.RecordType != null) ? p.RecordType.Name : 'Unknown';
            this.policyHolderName = (p != null && p.Customer__r != null) ? p.Customer__r.Name : '';

            this.daysOpen = (c.Date_of_Loss__c != null)
                ? c.Date_of_Loss__c.date().daysBetween(Date.today())
                : 0;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ClaimWrapper> getAssignedClaims() {
        List<ClaimWrapper> results = new List<ClaimWrapper>();
        List<Claim__c> claims = [
            SELECT Id, Name, Claim_Amount__c, Approval_Status__c, Date_of_Loss__c,
                   Policy__r.Name,
                   Policy__r.RecordType.Name,
                   Policy__r.Customer__r.Name
            FROM Claim__c
            WHERE OwnerId = :UserInfo.getUserId()
            ORDER BY Date_of_Loss__c DESC NULLS LAST
            LIMIT 200
        ];
        for (Claim__c claim : claims) {
            results.add(new ClaimWrapper(claim));
        }
        return results;
    }
}