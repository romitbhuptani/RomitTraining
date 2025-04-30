import { api, LightningElement } from 'lwc';
import addRandomFile from '@salesforce/apex/FutureCallout.addRandomFile';
export default class FutureTask extends LightningElement {
    @api recordId;
    handleClick(){
        addRandomFile({oppId : this.recordId});
    }
}