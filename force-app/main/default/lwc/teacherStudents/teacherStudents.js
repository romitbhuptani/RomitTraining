import { LightningElement, api, track } from 'lwc';
import getStudentsForTeacher from '@salesforce/apex/CommunityPortalController.getStudentsForTeacher';

export default class TeacherStudents extends LightningElement {
    @api email;
    @track students = [];
    @track isLoading = true;
    @track error = '';
    @track showDetail = false;
    @track selectedStudentId = '';
    @track hasStudents = false;

    columns = [
        { label: 'First Name', fieldName: 'First_Name__c' },
        { label: 'Last Name', fieldName: 'Last_Name__c' },
        { label: 'Email', fieldName: 'Email__c', type: 'email' },
        { label: 'Grade Level', fieldName: 'Grade_Level__c' },
        { type: 'action', typeAttributes: { rowActions: [{ label: 'View Details', name: 'view' }] } }
    ];

    connectedCallback() {
        this.fetchStudents();
    }

    async fetchStudents() {
        try {
            this.students = await getStudentsForTeacher({ teacherEmail: this.email });
            this.hasStudents = this.students.length > 0;
            this.isLoading = false;
        } catch (error) {
            this.error = error.body.message || 'Error fetching students.';
            this.isLoading = false;
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view') {
            this.selectedStudentId = row.Id;
            this.showDetail = true;
            this.dispatchEvent(new CustomEvent('studentselect', { detail: row.Id }));
        }
    }

    handleBack() {
        this.showDetail = false;
        this.selectedStudentId = '';
    }

    @api
    showStudentDetail(studentId) {
        this.selectedStudentId = studentId;
        this.showDetail = true;
    }
}