#!/usr/bin/env bash
# Deploys the Setup-built parts in a safe order. Stops at the first failure.
# Usage: ./deploy-setup.sh [org-alias]     (default alias: insuranceOrg)
set -e
ORG="${1:-insuranceOrg}"
export SF_USE_GENERIC_UNIX_KEYCHAIN=true
step() { echo; echo "=== $1 ==="; }

step "0/7 Data model, LWC and existing Apex (safe to re-run)"
sf project deploy start --source-dir force-app/main/default/objects --source-dir force-app/main/default/tabs -o "$ORG"

step "1/7 Queues and public groups"
sf project deploy start -m Queue -m Group -o "$ORG"

step "2/7 Apex classes (includes ClaimApprovalAction)"
sf project deploy start -m ApexClass -o "$ORG"

step "3/7 Approval field updates and approval process"
sf project deploy start -m Workflow -m ApprovalProcess -o "$ORG"

step "4/7 Flows"
sf project deploy start -m Flow -o "$ORG"

step "5/7 Sharing rules"
sf project deploy start -m SharingRules -o "$ORG"

step "6/7 Quick action (add it to the Claim layout by hand: Object Manager > Claim > Page Layouts)"
sf project deploy start -m QuickAction -o "$ORG"

step "7/7 Permission sets"
sf project deploy start -m PermissionSet -o "$ORG"

echo; echo "All steps finished."
