import { LightningElement, api, track } from 'lwc';
import getUserProfile from '@salesforce/apex/CommunityPortalController.getUserProfile';
import updateUserProfile from '@salesforce/apex/CommunityPortalController.updateUserProfile';

export default class StudentProfile extends LightningElement {
    @api email;
    @track profile = {};
    @track form = {};
    @track isLoading = true;
    @track isEditing = false;
    @track error = '';
    @track success = '';

    connectedCallback() {
        this.fetchProfile();
    }

    async fetchProfile() {
        try {
            this.profile = await getUserProfile({ email: this.email });
            this.form = { ...this.profile };
            this.isLoading = false;
        } catch (error) {
            this.error = error.body.message || 'Error fetching profile.';
            this.isLoading = false;
        }
    }

    handleEdit() {
        this.isEditing = true;
        this.error = '';
        this.success = '';
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this.form[field] = event.target.value;
    }

    async handleSave(event) {
        event.preventDefault();
        this.error = '';
        this.success = '';

        const { First_Name__c, Last_Name__c, Email__c, Grade_Level__c } = this.form;
        if (!First_Name__c || !Last_Name__c || !Email__c || !Grade_Level__c) {
            this.error = 'All fields are required.';
            return;
        }

        try {
            const result = JSON.parse(await updateUserProfile({
                email: this.email,
                firstName: First_Name__c,
                lastName: Last_Name__c,
                department: null,
                gradeLevel: Grade_Level__c
            }));

            if (result.success) {
                this.success = result.message;
                this.profile = { ...this.form };
                this.isEditing = false;
                this.fetchProfile();
            } else {
                this.error = result.message;
            }
        } catch (error) {
            this.error = error.body.message || 'Error saving profile.';
        }
    }

    handleCancel() {
        this.isEditing = false;
        this.form = { ...this.profile };
        this.error = '';
        this.success = '';
    }
}