import { LightningElement, wire } from 'lwc';
import getFAQsList from '@salesforce/apex/FAQsController.getFAQsList';
import DUBAI_ASSET from '@salesforce/resourceUrl/DUBAI_ASSET';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import { subscribe, MessageContext } from "lightning/messageService";
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';

export default class DubaiFAQs extends LightningElement {
  
  selectedEventId;
  faqList;
  mailBackgroundImg;

  isPopupOpen = false;
  selectedEmail = '';
  sendersEmail = '';
  emailSubject = '';
  emailBody = '';


  @wire(getDubaiDreaminEventId)
  wiredEventId({ error, data }) {
    if (data) {

      this.selectedEventId = data;
    } else if (error) {
      console.error('getDubaiDreaminEventId Error:', error);
    }
  }

  @wire(getFAQsList, { eventId: '$selectedEventId' })
  wiredData({ error, data }) {
    if (data) {
      this.faqList = data
    } else if (error) {
      console.error('Error:', error);
    }
  }


  @wire(MessageContext) messageContext;

  subscribeToMessageChannel() {
    this.scrlMsg = subscribe(this.messageContext, SCROLL_MESSAGE, (message) => this.handleScroll(message));
  }

  handleScroll(message) {
    const scrollSection = message.section;

    if (scrollSection === 'FAQs') {
      this.template.querySelector('.faq-section-container').scrollIntoView({ behavior: 'smooth' });

    }

  }







  openPopup() {
    this.isPopupOpen = true;
  }

  closePopup() {
    this.isPopupOpen = false;
  }

  handleSenderEmailChange(event) {
    this.senderEmail = event.target.value;
  }

  handleSubjectChange(event) {
    this.subject = event.target.value;
  }

  handleBodyChange(event) {
    this.body = event.target.value;
  }

  



  connectedCallback() {
    this.subscribeToMessageChannel()
    // this.mailBackgroundImg = DUBAI_ASSET + '/directmail1.png';
    this.mailBackgroundImg = DUBAI_ASSET + '/vector1.png';
  }
  get mailBackgroundImage() {
    return `background: url(${this.mailBackgroundImg})`
  }
}