import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CommunityFooter extends NavigationMixin(LightningElement) {
    @track isExcludedPage = false;

    connectedCallback() {
        // Get current page URL
        const currentUrl = window.location.pathname.toLowerCase();
        
        // Exclude /login and /SelfRegister
        this.isExcludedPage = currentUrl === '/portal/login' || currentUrl === '/portal/selfregister';
    }

    navigateToHome(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/'
            }
        });
    }

    navigateToResetPassword(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/resetpassword'
            }
        });
    }

    navigateToForgotPassword(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/ForgotPassword'
            }
        });
    }
}