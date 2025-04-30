import { LightningElement, track } from 'lwc';
export default class FileUploadExample extends LightningElement {
    @track imageData;

    handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = () => {
                this.imageData = reader.result;
            };
            
            reader.readAsDataURL(file);
        }
    }
}