import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import LOGO from '@salesforce/resourceUrl/CommunityFavicon';

export default class CommunityHeader extends NavigationMixin(LightningElement) {
    @track logo = LOGO;
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

    handleLogout(event) {
        event.preventDefault();
        // Clear sessionStorage
        sessionStorage.removeItem('loggedInEmail');
        sessionStorage.removeItem('userRole');

        // Force full page reload to /login
        window.location.href = '/portal/login';
    }
}