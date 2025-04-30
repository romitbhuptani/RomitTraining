import { LightningElement, track } from 'lwc';
import searchRecords from '@salesforce/apex/SearchController.searchRecords';

export default class task6 extends LightningElement {
    @track searchTerm = '';
    @track selectedObjects = [];
    @track objectOptions = [
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Lead', value: 'Lead' },
    ];
    @track results;

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
    }

    handleObjectSelectionChange(event) {
        this.selectedObjects = event.detail.value;
    }

    handleSearchClick() {
        if (!this.searchTerm || this.selectedObjects.length === 0) {
            alert('Please enter a search term and select at least one object.');
            return;
        }

        searchRecords({ searchTerm: this.searchTerm, objectNames: this.selectedObjects })
            .then((data) => {
                this.results = Object.entries(data).map(([objectName, records]) => ({
                    objectName,
                    records,
                }));
            })
            .catch((error) => {
                console.error('Error during search:', error);
                this.results = null;
            });
    }
}