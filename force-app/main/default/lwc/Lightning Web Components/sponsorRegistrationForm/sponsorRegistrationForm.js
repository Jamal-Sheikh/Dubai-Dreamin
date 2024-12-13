import { LightningElement, wire, track, api } from 'lwc';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import COMPANYTYPE_FIELD from '@salesforce/schema/Lead.Company_Type__c';
import INDUSTRY_FIELD from '@salesforce/schema/Lead.Industry';
import SPONSORSHIPLEVEL_FIELD from '@salesforce/schema/Lead.Sponsorship_Level__c';

export default class SponsorRegistrationForm extends LightningElement {
    sponsorsLink = '/s/sponsors';
    isOpen = false;
    sponsorProfileImage = '';
    sponsorProfileImageBlob='';
    selectedEventId;
    @track documentId;
    pageUrl = '/s/';
    @api recordId;

    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) {
        if (data) {
            this.selectedEventId = data;
        } else if (error) {
            console.error('getDubaiDreaminEventId Error:', error);
        }
    }

    openModal(event) {
        this.isOpen = true;
        document.body.style.overflow = 'hidden';
    }

    closeModal() {
        this.isOpen = false;
        document.body.style.overflow = 'auto';
    }

    @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: COMPANYTYPE_FIELD })
    wiredCompanyTypePicklistValues({ error, data }) {
        if (data) {
            this.companyTypePicklistValues = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        } else if (error) {
            console.error('Error retrieving Company Type picklist values: ', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: INDUSTRY_FIELD })
    wiredIndustryPicklistValues({ error, data }) {
        if (data) {
            this.industryPicklistValues = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        } else if (error) {
            console.error('Error retrieving Industry picklist values: ', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: SPONSORSHIPLEVEL_FIELD })
    wiredSponsorshipLevelPicklistValues({ error, data }) {
        if (data) {
            this.sponsorshipLevelPicklistValues = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        } else if (error) {
            console.error('Error retrieving Sponsorship Level picklist values: ', error);
        }
    }

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        
        if (uploadedFiles && uploadedFiles.length > 0) {
            let uploadedFileNames = '';
            for (let i = 0; i < uploadedFiles.length; i++) {
                uploadedFileNames += uploadedFiles[i].name + ', ';
                if (uploadedFiles[i].documentId) {
                    this.documentId = uploadedFiles[i].documentId;
                } else {
                    console.error('contentDocumentId is undefined for file: ' + uploadedFiles[i].name);
                }
            }
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: uploadedFiles.length + ' Files uploaded Successfully: ' + uploadedFileNames,
                    variant: 'success',
                }),
            );
        } else {
            console.error('No files uploaded');
        }
    }
}