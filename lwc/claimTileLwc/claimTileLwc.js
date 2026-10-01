import { LightningElement, api } from 'lwc';

export default class ClaimTileLwc extends LightningElement {
    @api claimData;

    get policyIcon() {
        if (this.claimData && this.claimData.policyType) {
            const type = this.claimData.policyType.toLowerCase();
            if (type === 'auto') return 'utility:truck';
            if (type === 'property') return 'utility:home';
            if (type === 'life') return 'utility:favorite';
        }
        return 'utility:help';
    }
}