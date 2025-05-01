import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import ASTRONAUT_IMAGE from '@salesforce/resourceUrl/LostAstronaut';

export default class CustomPageNotFound extends NavigationMixin(LightningElement) {
    astronautImage = ASTRONAUT_IMAGE;

    navigateToHome() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/' // Standard home page URL
            }
        });
    }

    navigateToLogin() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/login' // Standard login page URL
            }
        });
    }

    navigateToSignUp() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/SelfRegister' // Standard sign-up page URL
            }
        });
    }
}