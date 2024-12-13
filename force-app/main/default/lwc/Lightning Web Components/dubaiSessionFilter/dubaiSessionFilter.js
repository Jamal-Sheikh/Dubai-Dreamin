import { LightningElement, track,wire,api } from 'lwc';
import getSearchedSessions  from '@salesforce/apex/SessionSelector.searchSessions';
import searchTrackedSessions from '@salesforce/apex/SessionSelector.searchTrackedSessions';
import searchSessionsByKeyword from '@salesforce/apex/SessionSelector.searchSessionsByKeyword';
import searchSessionsByLevel from '@salesforce/apex/SessionSelector.searchSessionsByLevel';
import searchSessionsByRole from '@salesforce/apex/SessionSpeakerSelector.searchSessionsByRole';
import filteredSessions from '@salesforce/apex/SessionSelector.filteredSessions';


const columns=[
    { label :'Session Name',fieldName :'Session_Title__c'},
    { label :'Speaker Name',fieldName :'Speaker_Name__c'}
]
export default class DubaiSessionFilter extends LightningElement {

columns=columns;
 sessions = [];
 error;
//  filteredSessions = [];
 searchKey = '';
 selectedTrack = '';
 selectedKeyword = '';
 selectedProduct = '';
 selectedLevel = '';
filterBy;

handleChange(event){
this.searchKey=event.target.value;
console.log('Handle Change Function Called',this.searchKey);
}
handleButtonClick(event){
    getSearchedSessions({searchKey : this.searchKey})
    .then(result =>{
        this.sessions=result;
        console.log('Sessions Data ', this.sessions);
    })
    .catch(error =>{
        this.error=error;
    })
}

tracks = [
    { label: 'Admin', value: 'Admin' },
    { label: 'Developer', value: 'Developer' },
    { label: 'Architect', value: 'Architect' },
    { label: 'Business Analyst', value: 'Business Analyst' },
    { label: 'Consultant', value: 'Consultant' },
    { label: 'Partner', value: 'Partner' },

];

keywords = [
    { label: 'Apex', value: 'Apex' },
    { label: 'Lightning Web Components / LWC', value: 'LWC' },
    { label: 'Development', value: 'Development' },
    { label: 'Architect', value: 'Architect' },
    { label: 'Consultant', value: 'Consultant' },
    { label: 'Admin/Administrato', value: 'Admin' },
    { label: 'Clouds', value: 'Clouds' },
    { label: 'Platform', value: 'Platform' },

];

levels = [
    { label: 'Beginner', value: 'Beginner' },
    { label: 'Intermediate', value: 'Intermediate' },
    { label: 'Advanced', value: 'Advanced' },

];

products = [
    { label: 'Sales Cloud', value: 'Sales Cloud' },
    { label: 'Data Cloud', value: 'Data Cloud' },
    { label: 'Service Cloud', value: 'Service Cloud' },
    { label: 'Experience Cloud', value: 'Experience Cloud' },
    { label: 'Marketing Cloud', value: 'Marketing Cloud' },
    { label: 'Commerce Cloud', value: 'Commerce Cloud' },
    { label: 'Analytics Cloud', value: 'Analytics Cloud' },
    { label: 'Integration Cloud', value: 'Integration Cloud' },
    { label: 'Manufacturing Cloud', value: 'Manufacturing Cloud' },
    { label: 'Financial Services Cloud', value: 'Financial Services Cloud' },
    { label: 'Education Services Cloud', value: 'Education Services Cloud' },
    { label: 'Nonprofit Cloud', value: 'Nonprofit Cloud' },
    { label: 'Health Cloud', value: 'Health Cloud' },
    { label: 'Vaccine Cloud', value: 'Vaccine Cloud' },
    { label: 'Other', value: 'Other' }

];

handleTrackChange(event) {
     this.selectedTrack = event.target.value;
    searchSessionsByRole({searchKey :this.selectedTrack})
    .then(result =>{
        this.sessions=result;
        console.log('Handle Track Methos Change Called');
        console.log('Tracked Sessions Data ', this.sessions);
    })
    .catch(error =>{
        this.error=error;
    })  
    // Filter sessions based on selected track
    
}

handleKeywordChange(event) {
    this. selectedKeyword = event.target.value;
    searchSessionsByKeyword({searchKey :this.selectedKeyword})
    .then(result =>{
        this.sessions=result;
        console.assert.og('Handle Keyword Change Method Called');
        console.log('Sessions Data ', this.sessions);
    })
    .catch(error =>{
        this.error=error;
    })
   
   
}
// handleProductChange(event) {
//     const selectedOptions = Array.from(event.target.selectedOptions).map(option => option.value);
//     console.log('List Of Products'+selectedOptions);
//     // Now `selectedOptions` contains an array of selected product values
//     // Perform your logic with the selected options, e.g., call Apex method
//     searchTrackedSessions({ searchKey: selectedOptions })
//         .then(result => {
//             this.sessions = result;
//             console.log('Tracked Sessions Data ', this.sessions);
//         })
//         .catch(error => {
//             this.error = error;
//         });
// }

handleProductChange(event) {
    this. selectedProduct = event.target.value;
    searchTrackedSessions({searchKey :this.selectedProduct})
    .then(result =>{
        this.sessions=result;
        console.log('Handle Product Change Method Called');
        console.log('Tracked Sessions Data ', this.sessions);
    })
    .catch(error =>{
        this.error=error;
    })
    
}
handleLevelChange(event) {
    this.selectedLevel = event.target.value;
    searchSessionsByLevel({searchKey :this.selectedLevel})
    .then(result =>{
        this.sessions=result;
        console.log('handle level change Method called');
        console.log('Sessions Data ', this.sessions);
    })
    .catch(error =>{
        this.error=error;
    })
   
} 
handleAllSearchFilter(){
    console.log('Level',this.selectedLevel);
    console.log('Keyword',this.selectedKeyword);
    console.log('Product',this.selectedProduct);
    console.log('SpeakerRole',this.selectedTrack);
    filteredSessions({level: this.selectedLevel,
    keyword: this.selectedKeyword,
    trackedProduct: this.selectedProduct,speakerRole:this.selectedTrack})
    .then(result =>{
        this.sessions=result;
        console.log('handle All Search Filter Method Called');
        console.log('All Filtered Sessions Data ', this.sessions);
    })
    .catch(error =>{
        this.error=error;
    })
}
}