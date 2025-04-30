import { getRecord } from 'lightning/uiRecordApi';
import { LightningElement , api, wire , track} from 'lwc';
import LastName from '@salesforce/schema/Contact.LastName';
import Email from '@salesforce/schema/Contact.Email';
import Phone from '@salesforce/schema/Contact.Phone';
export default class CustomComp extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track showMessage = false;
    @track showText = false;
    fields = [LastName, Email, Phone];
    constructor(){
        super();
        this.showMessage = true;
        this.message = 'Loading content...';
    }
    connectedCallback(){
        setTimeout(() => {
                this.showMessage = false;
                this.showText = true;
            }, 2000);
    }
    renderedCallback(){
        console.log('Rendered..');
    }
    disconnectedCallback(){
        console.log('Disconnected..');
    }
}