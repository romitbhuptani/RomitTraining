import { LightningElement, track } from 'lwc';

export default class WelcomeMessage extends LightningElement {
    @track showModal = false;
    @track email = '';
    @track role = '';

    connectedCallback() {
        // Listen for welcome event from communityHeader
        this.template.addEventListener('welcome', this.handleWelcomeEvent.bind(this));
    }

    handleWelcomeEvent(event) {
        // Check if welcome message has already been shown in this session
        if (sessionStorage.getItem('hasSeenWelcome') === 'true') {
            return;
        }

        // Set email and role from event
        this.email = event.detail.email;
        this.role = event.detail.role;

        // Show modal if valid role
        if (this.role === 'Teacher' || this.role === 'Student') {
            this.showModal = true;
            sessionStorage.setItem('hasSeenWelcome', 'true');

            // Auto-close after 5 seconds
            setTimeout(() => {
                this.closeModal();
            }, 5000);
        }
    }

    closeModal() {
        this.showModal = false;
    }
}