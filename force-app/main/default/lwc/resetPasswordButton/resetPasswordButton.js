import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ResetPasswordButton extends NavigationMixin(LightningElement) {
    handleResetPassword() {
        // Redirect to the ResetPassword page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/resetpassword' // Custom reset password page URL
            }
        });
    }
}