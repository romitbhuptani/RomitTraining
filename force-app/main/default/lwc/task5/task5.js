import { LightningElement, track, wire } from 'lwc';
import getRecords from '@salesforce/apex/WizardController.getRecords';
import sendEmail from '@salesforce/apex/WizardController.sendEmail';

export default class task5 extends LightningElement {
    @track isSection1Visible = true;
    @track isSection2Visible = false;
    @track isSection3Visible = false;

    @track selectedObject;
    @track records = [];
    @track selectedRecordIds = [];
    @track emailContent = '';

    objectOptions = [
        { label: 'Lead', value: 'Lead' },
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' },
    ];

    handleObjectChange(event) {
        this.selectedObject = event.detail.value;
        this.fetchRecords();
    }

    fetchRecords() {
        getRecords({ objectName: this.selectedObject })
            .then((result) => {
                this.records = result.map(record => ({ Id: record.Id, Name: record.Name }));
            })
            .catch((error) => {
                console.error('Error fetching records:', error);
            });
    }

    handleRecordSelection(event) {
        const recordId = event.target.value;
        if (event.target.checked) {
            this.selectedRecordIds.push(recordId);
        } else {
            this.selectedRecordIds = this.selectedRecordIds.filter(id => id !== recordId);
        }
    }

    handleEmailChange(event) {
        this.emailContent = event.target.value;
    }

    goToNextSection() {
        if (this.isSection1Visible) {
            this.isSection1Visible = false;
            this.isSection2Visible = true;
        } else if (this.isSection2Visible) {
            this.isSection2Visible = false;
            this.isSection3Visible = true;
        }
    }

    goToPreviousSection() {
        if (this.isSection3Visible) {
            this.isSection3Visible = false;
            this.isSection2Visible = true;
        } else if (this.isSection2Visible) {
            this.isSection2Visible = false;
            this.isSection1Visible = true;
        }
    }

    sendEmail() {

        sendEmail({ emailContent: this.emailContent, Ids: this.selectedRecordIds })
            .then((result) => {
                alert(result);
            })
            .catch((error) => {
                console.error('Error sending email:', error);
            });
    }
}