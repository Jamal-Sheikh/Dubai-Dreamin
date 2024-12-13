import { LightningElement, wire, track, api } from 'lwc';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getEmailsByLeadEmail from '@salesforce/apex/SponsorController.getEmailsByLeadEmail';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
// import COMPANYTYPE_FIELD from '@salesforce/schema/Lead.Company_Type__c';
// import INDUSTRY_FIELD from '@salesforce/schema/Lead.Industry';
// // import SPONSORSHIPLEVEL_FIELD from '@salesforce/schema/Lead.Sponsorship_Level__c';
// import getEmail  from '@salesforce/apex/EmailUniquenessClass.getEmail';
// import isEmailUnique  from '@salesforce/apex/EmailUniquenessClass.isEmailUnique';
import getCompanyInfo from '@salesforce/apex/CompanyInformationController.getCompanyInfo';
import getDocumentIdBYContentVersion from '@salesforce/apex/SponsorController.getDocumentIdBYContentVersion';
import DubaiApprovedSponsors from 'c/dubaiApprovedSponsors';
export default class SponsorForm extends LightningElement {
    organizationId;
    fileName;
    // @track submittedThankyou = false;
    enteredEmails = [];
    selectedEventId;
    @track documentId;
    pageUrl = window.location.href.replace('sponsors', 'thankyou');
    @api recordId;

    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) {
        if (data) {
            this.selectedEventId = data;
        } else if (error) {
            console.error('getDubaiDreaminEventId Error:', error);
        }
    }
    
    handleEmailBlur(event) {
        const emailInput = this.template.querySelector('.email-input');
        const email = event.target.value;
        getEmailsByLeadEmail({ inputEmail: email })
            .then(result => {
                console.log('Emails', result);
                if (result && result.length > 0) {
                    // Email already exists
                    const toastEvent = new ShowToastEvent({
                        title: 'Duplicate Email',
                        message: 'A sponsor with this email already exists.',
                        variant: 'error',
                    });
                    this.dispatchEvent(toastEvent);
                    emailInput.value = ''; // Clear the input field
                }
            })
            .catch(error => {
                console.error(error);
            });
    }
   

    // @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    // objectInfo;

    // @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: COMPANYTYPE_FIELD })
    // wiredCompanyTypePicklistValues({ error, data }) {
    //     if (data) {
    //         this.companyTypePicklistValues = data.values.map(item => ({
    //             label: item.label,
    //             value: item.value
    //         }));
    //     } else if (error) {
    //         console.error('Error retrieving Company Type picklist values: ', error);
    //     }
    // }

    // @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: INDUSTRY_FIELD })
    // wiredIndustryPicklistValues({ error, data }) {
    //     if (data) {
    //         this.industryPicklistValues = data.values.map(item => ({
    //             label: item.label,
    //             value: item.value
    //         }));
    //     } else if (error) {
    //         console.error('Error retrieving Industry picklist values: ', error);
    //     }
    // }

    // @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: SPONSORSHIPLEVEL_FIELD })
    // wiredSponsorshipLevelPicklistValues({ error, data }) {
    //     if (data) {
    //         this.sponsorshipLevelPicklistValues = data.values.map(item => ({
    //             label: item.label,
    //             value: item.value
    //         }));
    //     } else if (error) {
    //         console.error('Error retrieving Sponsorship Level picklist values: ', error);
    //     }
    // }

    get acceptedFormats() {
        return ['.jpg','.jpeg','.png'];
    }
//    showThankYouPage(event){
//     event.preventDefault();
//     this.submittedThankyou = true;
//    }
 
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        let cvId;
        if (uploadedFiles && uploadedFiles.length > 0) {
            let uploadedFileNames = '';
            for (let i = 0; i < uploadedFiles.length; i++) {
                uploadedFileNames += uploadedFiles[i].name + ', ';
                if (uploadedFiles[i].contentVersionId) {
                    this.documentId = uploadedFiles[i].contentVersionId;
                } else {
                    cvId = uploadedFiles[i].contentVersionId;
                }
            }
            console.log('CV ID: ', this.documentId);
            if (!this.documentId) {
                getDocumentIdBYContentVersion({contentVersionId: cvId})
                .then(docId => {
                    console.log('Doc ID: ', docId);

                    this.documentId = docId;
                });
            }
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: uploadedFiles.length + ' Files uploaded Successfully: ' + uploadedFileNames,
                    variant: 'success',
                }),
            );
            this.fileName=uploadedFileNames;

        } else {
            console.error('No files uploaded');
        }
    }
    // handleEmailChange(event) {
    //     const newEmail = event.target.value;
    //     isEmailUnique({ email: newEmail, recordId: this.recordId })
    //         .then(result => {
    //             if (!result) {
    //                 const toastEvent = new ShowToastEvent({
    //                     title: 'Duplicate Email',
    //                     message: 'The email value entered already exists. Please enter a unique email.',
    //                     variant: 'error',
    //                 });
    //                 this.dispatchEvent(toastEvent);
    //                 event.preventDefault(); // Prevent form submission
    //             }
    //         })
    //         .catch(error => {
    //             console.error(error);
    //         });
    // }
    @wire(getCompanyInfo)
    getAllCompanyInfo({ data, error }) {
        if (data) {
         
            this.organizationId = data.orgId;
            this.orgURL = data.orgUrl;

        } else if (error) {
            console.error('Error fetching company info:', error);
        }
    }
    get actionURL() {
        return 'https://test.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8&orgId=' + this.organizationId;
    }
    
}