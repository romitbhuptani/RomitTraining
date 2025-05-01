import { LightningElement, track } from 'lwc';
import registerUser from '@salesforce/apex/CommunityRegistrationController.registerUser';
import { NavigationMixin } from 'lightning/navigation';

export default class RegistrationForm extends NavigationMixin(LightningElement) {
    @track selectedRole = '';
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track password = '';
    @track confirmPassword = '';
    @track department = '';
    @track gradeLevel = '';
    @track error = '';
    @track success = '';
    @track isTeacher = false;
    @track isStudent = false;

    roleOptions = [
        { label: 'Teacher', value: 'Teacher' },
        { label: 'Student', value: 'Student' }
    ];

    handleRoleChange(event) {
        this.selectedRole = event.detail.value;
        this.isTeacher = this.selectedRole === 'Teacher';
        this.isStudent = this.selectedRole === 'Student';
        this.error = '';
        this.success = '';
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
        this.error = '';
        this.success = '';
    }

    async handleRegister(event) {
        event.preventDefault();
        this.error = '';
        this.success = '';

        // Trim all input values
        const trimmedFirstName = this.firstName.trim();
        const trimmedLastName = this.lastName.trim();
        const trimmedEmail = this.email.trim();
        const trimmedPassword = this.password.trim();
        const trimmedConfirmPassword = this.confirmPassword.trim();
        const trimmedDepartment = this.department.trim();
        const trimmedGradeLevel = this.gradeLevel.trim();

        // Validate trimmed values are not empty
        if (!trimmedFirstName) {
            this.error = 'First Name cannot be empty or only spaces.';
            return;
        }
        if (!trimmedLastName) {
            this.error = 'Last Name cannot be empty or only spaces.';
            return;
        }
        if (!trimmedEmail) {
            this.error = 'Email cannot be empty or only spaces.';
            return;
        }
        if (!trimmedPassword) {
            this.error = 'Password cannot be empty or only spaces.';
            return;
        }
        if (!trimmedConfirmPassword) {
            this.error = 'Confirm Password cannot be empty or only spaces.';
            return;
        }
        if (this.isTeacher && !trimmedDepartment) {
            this.error = 'Department cannot be empty or only spaces.';
            return;
        }
        if (this.isStudent && !trimmedGradeLevel) {
            this.error = 'Grade Level cannot be empty or only spaces.';
            return;
        }
        if (!this.selectedRole) {
            this.error = 'Please select a role.';
            return;
        }

        // Validate Email Format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(trimmedEmail)) {
            this.error = 'Please enter a valid email address.';
            return;
        }

        // Validate Password
        const passwordRegex = /^(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
        if (!passwordRegex.test(trimmedPassword)) {
            this.error = 'Password must be at least 8 characters long, contain at least one digit, and one special character.';
            return;
        }

        // Validate Password Match
        if (trimmedPassword !== trimmedConfirmPassword) {
            this.error = 'Passwords do not match.';
            return;
        }

        // Prepare Data
        const userData = {
            firstName: trimmedFirstName,
            lastName: trimmedLastName,
            email: trimmedEmail,
            password: trimmedPassword,
            role: this.selectedRole,
            department: trimmedDepartment,
            gradeLevel: trimmedGradeLevel
        };

        try {
            const result = await registerUser({ userData: JSON.stringify(userData) });
            this.success = 'Registration successful! Redirecting to login page...';
            this.resetForm();

            // Redirect to home page after a brief delay to show success message
            setTimeout(() => {
                this.handleLoginRedirect();
            }, 2000); // 2-second delay for user to see success message
        } catch (error) {
            this.error = error.body.message || 'An error occurred during registration.';
        }
    }

    handleLoginRedirect() {
        // Redirect to the Login page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/login' // Adjust to your Login page URL
            }
        });
    }

    resetForm() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.password = '';
        this.confirmPassword = '';
        this.department = '';
        this.gradeLevel = '';
        this.selectedRole = '';
        this.isTeacher = false;
        this.isStudent = false;
        this.error = '';
    }
}