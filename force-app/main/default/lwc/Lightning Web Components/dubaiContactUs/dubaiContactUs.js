import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DUBAI_ASSET from '@salesforce/resourceUrl/DUBAI_ASSET';
import getCompanyInfo from '@salesforce/apex/CompanyInformationController.getCompanyInfo';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import { subscribe, MessageContext } from "lightning/messageService";
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
import EVENT_MESSAGE from '@salesforce/messageChannel/EventIDMessageChannel__c';

export default class DubaiContactUs extends LightningElement {

    foooterBackgroundImage;
    formBackgroundImage
    organizationId
    orgURL
    pageUrl = '/s';
    selectedEventId;

    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) { 
    if (data) {
        
        console.log('Dubai Dreamin Event ID:', data);
        this.selectedEventId=data;
    } else if (error) {
        console.error('getDubaiDreaminEventId Error:', error);
    }
}

@wire(MessageContext) messageContext;
    
    subscribeToMessageChannel() {
        this.scrlMsg = subscribe(this.messageContext, SCROLL_MESSAGE, (message) => this.handleScroll(message));
        this.subscription = subscribe(this.messageContext, EVENT_MESSAGE, (eventMessage) => this.handleMessage(eventMessage));
    }

  handleScroll(message) {
        const scrollSection = message.section;

        if (scrollSection === 'Contact Us') {
            this.template.querySelector('.contact-us-section').scrollIntoView({ behavior: 'smooth' });

        }

 if (scrollSection === 'Sponsors') {
            this.template.querySelector('.sponsor-section').scrollIntoView({ behavior: 'smooth' });

        }
    }
    @wire(getCompanyInfo)
    getAllCompanyInfo({ data, error }) {
        if (data) {


            this.organizationId = data.orgId;
            this.orgURL = data.orgUrl;

        } else if (error) {
            console.error('Error fetching company info:', error);
        }
    }
    handleSubmit(event) {
  
        const actionUrl = `${this.orgURL}/servlet/servlet.WebToCase?encoding=UTF-8&orgId=${this.organizationId}`;

        event.target.action = actionUrl;
        this.showToast();


    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Case Submitted.',
            message: 'Your Case has been Submitted Successfully!',
            variant: 'success',
        });
        this.dispatchEvent(event);
    }






    connectedCallback() {
        this.subscribeToMessageChannel();
        this.foooterBackgroundImage = DUBAI_ASSET + '/footerform.png';
        this.formBackgroundImage = DUBAI_ASSET + '/formBg.png';


    }

    get backgroundImageStyle() {
        return `background-image: url(${this.foooterBackgroundImage});`;
    }

    get formBackgroundStyle() {
        return `background-image: url(${this.formBackgroundImage})`
    }
}