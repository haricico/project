import { LightningElement, wire } from 'lwc';
import getAssignedClaims from '@salesforce/apex/ClaimsAdjusterController.getAssignedClaims';

export default class ClaimsDashboardLwc extends LightningElement {
    allClaims = [];
    visibleClaims = [];
    selectedType = 'All';
    error;

    @wire(getAssignedClaims)
    wiredClaims({ error, data }) {
        if (data) {
            this.allClaims = data;
            this.applyFilter();
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.allClaims = [];
            this.visibleClaims = [];
            console.error('Error retrieving claims:', JSON.stringify(error));
        }
    }

    handleFilterChange(event) {
        this.selectedType = event.detail.value;
        this.applyFilter();
    }

    applyFilter() {
        this.visibleClaims = this.selectedType === 'All'
            ? this.allClaims
            : this.allClaims.filter(c => c.policyType === this.selectedType);
    }

    get hasClaims() {
        return this.visibleClaims && this.visibleClaims.length > 0;
    }

    get policyTypeOptions() {
        return [
            { label: 'All Policy Types', value: 'All' },
            { label: 'Auto', value: 'Auto' },
            { label: 'Property', value: 'Property' },
            { label: 'Life', value: 'Life' }
        ];
    }
}