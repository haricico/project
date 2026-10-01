@isTest
private class PremiumCalculatorTest {

    private static Policy__c makePolicy(String state, String modelYear) {
        Id rtId = Schema.SObjectType.Policy__c.getRecordTypeInfosByDeveloperName().get('Auto').getRecordTypeId();
        Policy__c p = new Policy__c(
            RecordTypeId = rtId,
            VIN__c = '1A903284375893532',
            Model_Year__c = modelYear,
            Policy_State__c = state
        );
        insert p;
        return p;
    }

    @isTest
    static void testCaliforniaOlderVehicle() {
        Policy__c p = makePolicy('CA', '2015');
        PremiumCalculator.PremiumInputWrapper w = new PremiumCalculator.PremiumInputWrapper();
        w.policyId = p.Id;
        Test.startTest();
        List<Decimal> out = PremiumCalculator.calculatePremium(new List<PremiumCalculator.PremiumInputWrapper>{ w });
        Test.stopTest();
        System.assertEquals(1, out.size());
        System.assertEquals(1250.00, out[0]);
    }

    @isTest
    static void testTexasNewerVehicle() {
        Policy__c p = makePolicy('TX', '2022');
        PremiumCalculator.PremiumInputWrapper w = new PremiumCalculator.PremiumInputWrapper();
        w.policyId = p.Id;
        List<Decimal> out = PremiumCalculator.calculatePremium(new List<PremiumCalculator.PremiumInputWrapper>{ w });
        System.assertEquals(1050.00, out[0]);
    }

    @isTest
    static void testMissingPolicyReturnsBase() {
        PremiumCalculator.PremiumInputWrapper w = new PremiumCalculator.PremiumInputWrapper();
        List<Decimal> out = PremiumCalculator.calculatePremium(new List<PremiumCalculator.PremiumInputWrapper>{ w });
        System.assertEquals(1000.00, out[0]);
    }
}