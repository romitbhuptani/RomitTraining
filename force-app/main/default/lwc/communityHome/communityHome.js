import { LightningElement, track } from 'lwc';
import getUserRole from '@salesforce/apex/CommunityPortalController.getUserRole';

export default class CommunityHome extends LightningElement {
    @track isTeacher = false;
    @track isStudent = false;
    @track isLoading = true;
    @track error = '';
    @track email = '';

    connectedCallback() {
        this.email = sessionStorage.getItem('loggedInEmail');
        const role = sessionStorage.getItem('userRole');
        if (role) {
            this.setRole(role);
            this.isLoading = false;
        } else if (this.email) {
            this.fetchUserRole();
        } else {
            this.error = 'Please log in to access this page.';
            this.isLoading = false;
        }
    }

    async fetchUserRole() {
        try {
            const role = await getUserRole({ email: this.email });
            sessionStorage.setItem('userRole', role);
            this.setRole(role);
        } catch (error) {
            this.error = error.body.message || 'Error fetching user role.';
        } finally {
            this.isLoading = false;
        }
    }

    setRole(role) {
        this.isTeacher = role === 'Teacher';
        this.isStudent = role === 'Student';
    }

    handleStudentSelect(event) {
        const studentId = event.detail;
        // Dynamically load student detail component
        const detailContainer = this.template.querySelector('c-teacher-students');
        if (detailContainer) {
            detailContainer.showStudentDetail(studentId);
        }
    }
}