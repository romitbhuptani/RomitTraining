import { LightningElement, track } from 'lwc';
export default class Task4_parent extends LightningElement {
    @track recordId;
    handleAccountSelect(event) {
        this.recordIdNotNull = true;
        this.recordId = event.detail;
    }
}