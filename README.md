# Multi-Line Insurance Policy & Claims Management System

A Salesforce DX project for managing auto, property and life insurance policies and claims. It covers guided policy quoting, automatic premium calculation, claim routing, a high-value approval workflow and an adjuster dashboard.

Built for the Naan Mudhalvan / SkillWallet program.

## Key features
- **Guided quoting:** `AutoQuotingFlow` (screen flow) collects policy holder, state and vehicle details, creates a draft Auto policy and calculates the premium.
- **Automatic premium calculation:** the invocable Apex class `PremiumCalculator` prices a policy from its details and is called from the flow.
- **Claim routing:** `Claim Routing Flow` assigns each new claim to the Auto, Property or Life queue based on the policy's record type.
- **High-value approvals:** claims over 50,000 are submitted automatically to a two-step approval process (Senior Adjuster, then Manager). An approver screen flow and quick action let approvers approve or reject from the claim page, backed by the `ClaimApprovalAction` Apex class.
- **State-based sharing:** the policy state is copied onto each claim, and sharing rules share CA and TX claims with matching public groups.
- **Adjuster dashboard:** Lightning Web Components (`claimsDashboardLwc`, `claimTileLwc`) show the claims assigned to the logged-in user.

## Architecture
| Layer | Components |
|---|---|
| Data model | `Policy__c` and `Claim__c`, record types (Auto, Property, Life / Accident, Property, Life), field sets, VIN validation rule |
| Apex | `PremiumCalculator`, `ClaimsAdjusterController`, `ClaimApprovalAction` and their test classes |
| UI | LWCs `claimsDashboardLwc`, `claimTileLwc`; quick action `Approve/Reject Claim` |
| Automation | 5 flows, `High Value Claim Approval` process, 3 approval field updates |
| Security | Permission sets (Insurance Agent, Claims Adjuster, Claims Manager), queues, public groups, sharing rules |

**Flows**
1. `AutoQuotingFlow` - screen flow, creates the policy and premium
2. `Claim Routing Flow` - record-triggered on Claim create, sets the queue owner
3. `Submission Automation Flow` - submits claims over 50,000 for approval
4. `Claim Approver Screen Flow` - approve or reject from a claim
5. `Claim Policy Holder State Update` - before-save flow that copies the policy state

## Project structure
```
insurance-claims-system/
  force-app/main/default/
    approvalProcesses/  classes/  flows/  groups/  lwc/  objects/
    permissionsets/  queues/  quickActions/  sharingRules/  tabs/  workflows/
  docs/                 project documentation (PDF)
  deploy-setup.sh       ordered deploy script
  sfdx-project.json
  README.md
```

## Deployment
Requirements: [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli) and a Developer Edition org.

```bash
git clone <repo-url>
cd insurance-claims-system
sf org login web --alias insuranceOrg --set-default
```

1. Open `force-app/main/default/approvalProcesses/Claim__c.High_Value_Claim_Approval.approvalProcess-meta.xml` and replace the approver usernames with users in your org.
2. Deploy everything in the right order:
   ```bash
   ./deploy-setup.sh insuranceOrg
   ```
   (Or deploy in one go with `sf project deploy start --source-dir force-app -o insuranceOrg`.)

## Manual setup after deploy
- Assign the three permission sets to your user.
- Turn on **Manage Approvals** on the Claims Manager Access permission set.
- Add yourself as a member of the Auto, Property and Life claims queues.
- Add the **Approve/Reject Claim** action to the Claim page layout (Mobile & Lightning Actions).
- Add adjusters to the CA Adjusters and TX Adjusters public groups.

## Testing
```bash
sf apex run test --class-names ClaimsAdjusterControllerTest --class-names PremiumCalculatorTest --class-names ClaimApprovalActionTest --result-format human --code-coverage --wait 10 -o insuranceOrg
```
Manual end-to-end check:
1. Create a Contact, then run `AutoQuotingFlow` and confirm the policy has a premium.
2. Create a claim under 50,000: the owner should be a queue and the state should be copied.
3. Create a claim over 50,000: status becomes Submitted for Approval, then approve it with the quick action.

## Documentation
The project documentation PDF is in the `docs/` folder.

## Team
Vinoth Kumar (lead), Harish G, J Jegan, Ajai Karthi, M Stony
