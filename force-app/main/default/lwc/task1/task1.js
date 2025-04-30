import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

export default class task1 extends LightningElement {
    
    @api objectApiName;
    
    fields = [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD];
    

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Contact created successfully',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}