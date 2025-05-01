import { LightningElement, track } from 'lwc';
import loginUser from '@salesforce/apex/CommunityLoginController.loginUser';
import { NavigationMixin } from 'lightning/navigation';

export default class CommunityLogin extends NavigationMixin(LightningElement) {
    @track email = '';
    @track password = '';
    @track errorMessage = '';

    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'email') {
            this.email = event.target.value;
        } else if (field === 'password') {
            this.password = event.target.value;
        }
    }

    async handleLogin(event) {
        event.preventDefault();
        this.errorMessage = '';

        try {
            const result = await loginUser({ email: this.email, password: this.password });
            const loginResult = JSON.parse(result);

            if (loginResult.success) {
                // Store email and role in sessionStorage for home page
                sessionStorage.setItem('loggedInEmail', this.email);
                sessionStorage.setItem('userRole', loginResult.role); // Store role
                sessionStorage.setItem('hasSeenWelcome', 'false'); // Reset welcome message flag

                // Redirect to the Community Portal home page
                window.location.href = '/portal';
            } else {
                this.errorMessage = loginResult.message;
            }
        } catch (error) {
            this.errorMessage = 'An error occurred. Please try again.';
            console.error('Login error:', error);
        }
    }

    handleSignUp() {
        // Redirect to the SelfRegister page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/SelfRegister' // Standard registration page URL
            }
        });
    }

    handleForgotPassword() {
        // Redirect to the ForgotPassword page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/ForgotPassword' // Standard forgot password page URL
            }
        });
    }
}