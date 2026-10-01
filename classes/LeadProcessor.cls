public class LeadProcessor implements Database.Batchable<sObject> {
    
    // Collect all Lead records in the org
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }
    
    // Update the LeadSource of all records in the batch
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext bc) {
        // Execute any post-processing operations (not required for this challenge)
    }
}