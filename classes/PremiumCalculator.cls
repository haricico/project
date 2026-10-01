public with sharing class PremiumCalculator {

    public class PremiumInputWrapper {
        @InvocableVariable(required=true)
        public Id policyId;
    }

    @InvocableMethod(label='Calculate Policy Premium' description='Calculates premium based on policy fields (VIN, Model Year, State).')
    public static List<Decimal> calculatePremium(List<PremiumInputWrapper> inputs) {
        Set<Id> policyIds = new Set<Id>();
        for (PremiumInputWrapper input : inputs) {
            if (input.policyId != null) {
                policyIds.add(input.policyId);
            }
        }

        Map<Id, Policy__c> policies = new Map<Id, Policy__c>([
            SELECT Id, VIN__c, Model_Year__c, Policy_State__c
            FROM Policy__c
            WHERE Id IN :policyIds
        ]);

        // One result per input, in input order (required by invocable methods)
        List<Decimal> premiumResults = new List<Decimal>();
        for (PremiumInputWrapper input : inputs) {
            Decimal basePremium = 1000.00;
            Policy__c policy = policies.get(input.policyId);
            if (policy != null) {
                if (policy.Policy_State__c == 'CA') {
                    basePremium *= 1.15;
                } else if (policy.Policy_State__c == 'TX') {
                    basePremium *= 1.05;
                }
                if (String.isNotBlank(policy.Model_Year__c)
                        && policy.Model_Year__c.isNumeric()
                        && Integer.valueOf(policy.Model_Year__c) < 2018) {
                    basePremium += 100;
                }
            }
            premiumResults.add(basePremium.setScale(2));
        }
        return premiumResults;
    }
}