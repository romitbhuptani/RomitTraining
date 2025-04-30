import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/LazyLoadingController.getAccounts';
import getTotalAccounts from '@salesforce/apex/LazyLoadingController.getAccountCount';
import getNameAccounts from '@salesforce/apex/LazyLoadingController.getNameAccounts';
const columns = [
    { label: 'Id', fieldName: 'Id', type: 'text' },
    { label: 'Name', fieldName: 'Name', type: 'text',sortable: true },
  
];

export default class LazyLoading extends LightningElement {
    accounts=[];
    error;
    columns = columns;
    rowLimit =25;
    rowOffSet=0;
    totalAccounts = 0;
    fetchTotalAccounts = getTotalAccounts().then(result => {this.totalAccounts = result});
    sortBy = 'Name';
    sortDirection = 'asc';
    isSort = false;
    numberOfSearch = 0;
    numberOfSearchAccounts = getNameAccounts().then(result => {this.numberOfSearch = result});
    @track searchKey = '';

    connectedCallback() {
        this.loadData();
    }
    doSorting(event) {
        
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.isSort = true;
        this.loadData();
    }
    loadData(){
        
        
        return getAccounts({ limitSize: this.rowLimit , offset : this.rowOffSet , sortBy : this.sortBy, sortOrder : this.sortDirection , nameLike : this.searchKey})
        .then(result => {
            if(this.isSort){
            this.accounts = result;
            this.isSort = false;
            return;
        }
        else{
            
            if(this.searchKey!=''){
                var updatedRecords = [...result]
                if(this.rowOffSet > 0){
                    updatedRecords = [...this.accounts,...result];
                }
                
            }
            else{
                var updatedRecords = [...this.accounts, ...result];
                if(updatedRecords.length > this.totalAccounts){
                    this.accounts = [];
                    var updatedRecords = [...this.accounts, ...result];
                }
            }
            console.log(this.rowOffSet);
            
            this.accounts = updatedRecords;
            
        }
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.accounts = undefined;
        });
        
    }
    handleSearchKeyChange(event) {   
        this.searchKey = event.detail.value;
        this.rowOffSet = 0;
        getNameAccounts({nameLike : this.searchKey}).then(result => {this.numberOfSearch = result});
        const baseTableEle = this.template.querySelector('lightning-datatable')
            if (baseTableEle) {
                baseTableEle.enableInfiniteLoading = true
            }
        this.loadData();

    }

    loadMoreData(event) {
        const currentRecord = this.accounts ;
        const { target } = event;
        if(target.isLoading){
            return;
        }
        this.rowOffSet = this.rowOffSet + this.rowLimit;
        if(this.searchKey != '' && currentRecord.length == this.numberOfSearch ){
            
            this.rowOffSet = 0;
            this.rowLimit = currentRecord.length;
            const baseTableEle = this.template.querySelector('lightning-datatable')
            if (baseTableEle) {
                baseTableEle.enableInfiniteLoading = false
            }
            return;
        }
        if(currentRecord.length  == this.totalAccounts){
            this.rowOffSet = 0;
            this.rowLimit = currentRecord.length;
            const baseTableEle = this.template.querySelector('lightning-datatable')
            if (baseTableEle) {
                baseTableEle.enableInfiniteLoading = false
            }
            return;
        }   
        if(this.rowOffSet > currentRecord.length){
            this.rowOffSet = 0;
            this.rowLimit = currentRecord.length;
        }
        target.isLoading = true;
        this.loadData()
        .then(()=> {
                target.isLoading = false;
            });   
    }


}