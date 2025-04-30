import { LightningElement, track } from 'lwc';
import sendOtp from '@salesforce/apex/CommunityForgotPasswordController.sendOtp';
import updatePassword from '@salesforce/apex/CommunityForgotPasswordController.updatePassword';
import { NavigationMixin } from 'lightning/navigation';

export default class CommunityForgotPassword extends NavigationMixin(LightningElement) {
    @track email = '';
    @track otp = '';
    @track newPassword = '';
    @track confirmPassword = '';
    @track errorMessage = '';
    @track successMessage = '';
    @track showOtpForm = false;
    @track generatedOtp = ''; // Holds the OTP from Apex

    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'email') {
            this.email = event.target.value;
        } else if (field === 'otp') {
            this.otp = event.target.value;
        } else if (field === 'newPassword') {
            this.newPassword = event.target.value;
        } else if (field === 'confirmPassword') {
            this.confirmPassword = event.target.value;
        }
        this.errorMessage = '';
        this.successMessage = '';
    }

    async handleSendOtp(event) {
        event.preventDefault();
        this.errorMessage = '';
        this.successMessage = '';

        try {
            const result = await sendOtp({ email: this.email });
            const otpResult = JSON.parse(result);

            if (otpResult.success) {
                this.successMessage = otpResult.message;
                this.generatedOtp = otpResult.otp;
                this.showOtpForm = true;
            } else {
                this.errorMessage = otpResult.message;
            }
        } catch (error) {
            this.errorMessage = 'An error occurred. Please try again.';
            console.error('Send OTP error:', error);
        }
    }

    async handleResetPassword(event) {
        event.preventDefault();
        this.errorMessage = '';
        this.successMessage = '';

        try {
            const result = await updatePassword({
                email: this.email,
                otp: this.generatedOtp,
                providedOtp: this.otp,
                newPassword: this.newPassword,
                confirmPassword: this.confirmPassword
            });
            const passwordResult = JSON.parse(result);

            if (passwordResult.success) {
                this.successMessage = passwordResult.message + ' Redirecting to login...';
                // Reset form
                this.email = '';
                this.otp = '';
                this.newPassword = '';
                this.confirmPassword = '';
                this.showOtpForm = false;
                this.generatedOtp = '';

                // Redirect to login page after a brief delay
                setTimeout(() => {
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: '/login' // Standard login page URL
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

    handleLoginRedirect() {
        // Redirect to the login page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/login' // Standard login page URL
            }
        });
    }
}