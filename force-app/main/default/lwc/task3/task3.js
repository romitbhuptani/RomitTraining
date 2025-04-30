import { LightningElement, api, track } from 'lwc';
import getFiles from '@salesforce/apex/FileUploadController.getFiles';

const PAGE_SIZE = 5;

export default class FileUploaderLWC extends LightningElement {
    @api recordId;
    @track files = [];
    @track paginatedFiles = [];
    @track currentPage = 1;
    @track totalPages = 1;
    @track ifFirstPage = true;
    @track ifLastPage = false;
    renderedCallback() {
        this.ifFirstPage = this.currentPage === 1;
        this.ifLastPage =  this.currentPage === this.totalPages;
    }

    connectedCallback() {
        this.loadFiles();
    }

    async loadFiles() {
        try {
            const result = await getFiles({ recordId: this.recordId });
            this.files = result.map(file => ({
                Id: file.Id,
                Title: file.ContentDocument.Title,
                ContentDocumentLink: `/sfc/servlet.shepherd/document/download/${file.ContentDocumentId}`
            }));
            this.totalPages = Math.ceil(this.files.length / PAGE_SIZE);
            this.updatePaginatedFiles();
        } catch (error) {
            console.error('Error fetching files:', error);
        }
    }
    

    handleUploadFinished() {
        this.loadFiles();
    }

    updatePaginatedFiles() {
        const start = (this.currentPage - 1) * PAGE_SIZE;
        const end = start + PAGE_SIZE;
        this.paginatedFiles = this.files.slice(start, end);
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedFiles();
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedFiles();
        }
    }
    
}