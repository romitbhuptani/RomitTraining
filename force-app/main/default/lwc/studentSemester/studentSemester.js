import { LightningElement, track } from 'lwc';
import getCurrentSemesterSubjects from '@salesforce/apex/CommunityPortalController.getCurrentSemesterSubjects';

export default class StudentSemester extends LightningElement {
    @track subjects = [];
    @track isLoading = true;
    @track error = '';

    columns = [
        { label: 'Subject', fieldName: 'Name' },
        { label: 'Semester', fieldName: 'Semester__c' },
        { label: 'Teacher', fieldName: 'TeacherName', type: 'text' }
    ];

    connectedCallback() {
        this.fetchSubjects();
    }

    async fetchSubjects() {
        try {
            const subjects = await getCurrentSemesterSubjects();
            this.subjects = subjects.map(subject => ({
                ...subject,
                TeacherName: `${subject.Teacher__r.First_Name__c} ${subject.Teacher__r.Last_Name__c}`
            }));
            this.isLoading = false;
        } catch (error) {
            this.error = error.body.message || 'Error fetching subjects.';
            this.isLoading = false;
        }
    }
}