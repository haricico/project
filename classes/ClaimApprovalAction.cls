public with sharing class ClaimApprovalAction {

    public class Request {
        @InvocableVariable(required=true label='Claim Id')
        public Id recordId;
        @InvocableVariable(required=true label='Decision (Approve or Reject)')
        public String decision;
        @InvocableVariable(label='Comments')
        public String comments;
    }

    @InvocableMethod(
        label='Process Claim Approval'
        description='Approves or rejects the pending approval request for a claim and returns a message.'
    )
    public static List<String> processApproval(List<Request> requests) {
        List<String> results = new List<String>();
        Set<Id> recordIds = new Set<Id>();
        for (Request r : requests) {
            if (r.recordId != null) {
                recordIds.add(r.recordId);
            }
        }

        Map<Id, ProcessInstanceWorkitem> workitemByRecord = new Map<Id, ProcessInstanceWorkitem>();
        for (ProcessInstanceWorkitem w : [
            SELECT Id, ProcessInstance.TargetObjectId
            FROM ProcessInstanceWorkitem
            WHERE ProcessInstance.TargetObjectId IN :recordIds
            AND ProcessInstance.Status = 'Pending'
        ]) {
            workitemByRecord.put(w.ProcessInstance.TargetObjectId, w);
        }

        for (Request r : requests) {
            ProcessInstanceWorkitem w = workitemByRecord.get(r.recordId);
            if (w == null) {
                results.add('No pending approval request was found for this claim.');
                continue;
            }
            Boolean approve = (r.decision == 'Approve');
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(w.Id);
            req.setAction(approve ? 'Approve' : 'Reject');
            req.setComments(r.comments);
            try {
                Approval.process(req);
                results.add(approve ? 'The claim step was approved.' : 'The claim was rejected.');
            } catch (Exception e) {
                results.add('Could not process the approval: ' + e.getMessage());
            }
        }
        return results;
    }
}