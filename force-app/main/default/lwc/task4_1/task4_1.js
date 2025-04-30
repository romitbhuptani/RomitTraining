import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import { publish, MessageContext } from 'lightning/messageService';
import AccountChannelMessage from '@salesforce/messageChannel/AccountMessageChannel__c';
export default class Task4_1 extends LightningElement {
    @wire(getAccounts) accounts;
    @wire(MessageContext) messageContext;

    handleAccountChange(event) {
        const accountId = event.target.value;

        publish(this.messageContext, AccountChannelMessage,{ accId: accountId });
    }
}