import { LightningElement, track } from 'lwc';
import updatePassword from '@salesforce/apex/CommunityResetPasswordController.updatePassword';
import { NavigationMixin } from 'lightning/navigation';

export default class ResetPassword extends NavigationMixin(LightningElement) {
    @track newPassword = '';
    @track confirmPassword = '';
    @track errorMessage = '';
    @track successMessage = '';
    @track email = '';

    connectedCallback() {
        // Retrieve email from sessionStorage
        const loggedInEmail = sessionStorage.getItem('loggedInEmail');
        if (loggedInEmail) {
            this.email = loggedInEmail;
        } else {
            this.errorMessage = 'No user logged in. Please log in to reset your password.';
        }
    }

    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'newPassword') {
            this.newPassword = event.target.value;
        } else if (field === 'confirmPassword') {
            this.confirmPassword = event.target.value;
        }
        this.errorMessage = '';
        this.successMessage = '';
    }

    async handleResetPassword(event) {
        event.preventDefault();
        this.errorMessage = '';
        this.successMessage = '';

        if (!this.email) {
            this.errorMessage = 'No user logged in. Please log in to reset your password.';
            return;
        }

        try {
            const result = await updatePassword({
                email: this.email,
                newPassword: this.newPassword,
                confirmPassword: this.confirmPassword
            });
            const passwordResult = JSON.parse(result);

            if (passwordResult.success) {
                this.successMessage = passwordResult.message;
                // Reset form
                this.newPassword = '';
                this.confirmPassword = '';

                // Clear sessionStorage to ensure re-login
                sessionStorage.removeItem('loggedInEmail');

                // Redirect to home page after a brief delay
                setTimeout(() => {
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: '/login' // Standard home page URL
                        }
                    });
                }, 2000); // 2-second delay to show success message
            } else {
                this.errorMessage = passwordResult.message;
            }
        } catch (error) {
            this.errorMessage = 'An error occurred. Please try again.';
            console.error('Reset password error:', error);
        }
    }

    handleCancel() {
        // Redirect to the home page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/' // Standard home page URL
            }
        });
    }
}