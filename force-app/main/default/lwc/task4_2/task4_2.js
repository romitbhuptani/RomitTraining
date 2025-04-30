import { LightningElement, api, wire } from 'lwc';
import getOpportunities from '@salesforce/apex/OppAndConController.getOpportunities';
import getContacts from '@salesforce/apex/OppAndConController.getContacts';
import { subscribe, MessageContext } from 'lightning/messageService';
import AccountChannelMessage from '@salesforce/messageChannel/AccountMessageChannel__c';

export default class Task4_2 extends LightningElement {
    @api recordId;

    @wire(getOpportunities, { accId: '$recordId' }) opportunities;
    @wire(getContacts, { accId: '$recordId' }) contacts;

    @wire(MessageContext) messageContext;

    connectedCallback() {
         subscribe(
            this.messageContext,AccountChannelMessage,
            (message) => this.handleAccountMessage(message)
        );
    }

    handleAccountMessage(message) {
        this.recordId = message.accId;
    }
}