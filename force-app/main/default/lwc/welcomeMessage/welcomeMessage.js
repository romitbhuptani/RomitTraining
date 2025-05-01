import { LightningElement, track } from 'lwc';

export default class WelcomeMessage extends LightningElement {
    @track showModal = false;
    @track email = '';
    @track role = '';

    connectedCallback() {
        // Listen for welcome event from communityHeader
        document.addEventListener('welcome', this.handleWelcomeEvent.bind(this));
    }

    handleWelcomeEvent(event) {
        // Check if welcome message has already been shown in this session
        if (sessionStorage.getItem('hasSeenWelcome') === 'true') {
            return;
        }

            this.email = sessionStorage.getItem('loggedInEmail');
            this.role = sessionStorage.getItem('userRole');

            if (this.role === 'Teacher' || this.role === 'Student') {
                this.showModal = true;
                sessionStorage.setItem('hasSeenWelcome', 'true');

            }
    }

    closeModal() {
        this.showModal = false;
    }
}