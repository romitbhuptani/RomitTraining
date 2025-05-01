import { LightningElement, api, track } from 'lwc';
import getStudentDetails from '@salesforce/apex/CommunityPortalController.getStudentDetails';
import submitFeedback from '@salesforce/apex/CommunityPortalController.submitFeedback';

export default class StudentDetail extends LightningElement {
    @api studentId;
    @api email;
    @track student = {};
    @track isLoading = true;
    @track error = '';
    @track showFeedback = false;
    @track feedback = { emoji: '', comment: '' };
    @track success = '';

    emojiOptions = [
        { label: '😊 Positive', value: '😊' },
        { label: '😐 Neutral', value: '😐' },
        { label: '😞 Needs Improvement', value: '😞' }
    ];

    connectedCallback() {
        this.fetchStudentDetails();
    }

    async fetchStudentDetails() {
        try {
            this.student = await getStudentDetails({ studentId: this.studentId });
            this.isLoading = false;
        } catch (error) {
            this.error = error.body.message || 'Error fetching student details.';
            this.isLoading = false;
        }
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('back'));
    }

    handleFeedback() {
        this.showFeedback = true;
        this.error = '';
        this.success = '';
    }

    handleEmojiChange(event) {
        this.feedback.emoji = event.detail.value;
    }

    handleCommentChange(event) {
        this.feedback.comment = event.detail.value;
    }

    async handleSubmitFeedback() {
        if (!this.feedback.emoji) {
            this.error = 'Please select an emoji.';
            return;
        }

        try {
            const result = JSON.parse(await submitFeedback({
                studentId: this.studentId,
                teacherEmail: this.email,
                emoji: this.feedback.emoji,
                comment: this.feedback.comment
            }));

            if (result.success) {
                this.success = result.message;
                this.feedback = { emoji: '', comment: '' };
                this.showFeedback = false;
            } else {
                this.error = result.message;
            }
        } catch (error) {
            this.error = error.body.message || 'Error submitting feedback.';
        }
    }

    handleCancelFeedback() {
        this.showFeedback = false;
        this.feedback = { emoji: '', comment: '' };
        this.error = '';
        this.success = '';
    }
}