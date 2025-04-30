import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    selectedAccountId;

    handleAccountSelected(event) {
        
        this.selectedAccountId = event.detail.accId;
        console.log(this.selectedAccountId);
    }
}