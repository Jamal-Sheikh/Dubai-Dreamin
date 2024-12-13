import { LightningElement, wire } from 'lwc';
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
import EVENT_CHANNEL from '@salesforce/messageChannel/EventIDMessageChannel__c';
import { publish, subscribe, MessageContext, createMessageContext } from 'lightning/messageService';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import DUBAILOGO from "@salesforce/resourceUrl/DubaiDreaminLogo";


export default class DubaiNavbar extends LightningElement {
  
  homeLink = '/s/';
  speakersLink = '/s/speakers';
  ourSpeakersLink = '/s/our-speakers';
  sponsorsLink = '/s/sponsors';
  aboutUsLink = '/s/aboutus';

  selectedEventId;
  buttonLabel = 'Contact Us';
  companyLogo = DUBAILOGO;
  navigationItems = [];
  menuOpen = false;

  @wire(getDubaiDreaminEventId)
  wiredEventId({ error, data }) {
  if (data) {
  this.selectedEventId=data;
  } else if (error) {
      console.error('getDubaiDreaminEventId Error:', error);
  }
  }


  @wire(MessageContext)
  messageContext;


  toggleMenu() {
    this.menuOpen = !this.menuOpen;
  }
  get menuClass() {
    return this.menuOpen ? 'menu-open' : '';
  }

  

  publishEventId() {
    const payload = { eventId: this.selectedEventId };
    publish(createMessageContext(), EVENT_CHANNEL, payload);

  }
  handleNavItemClick(event) {
    const section = event.target.dataset.section;
    const payload = { section: section };
    publish(this.messageContext, SCROLL_MESSAGE, payload);
  this.menuOpen = false;

  }

  renderedCallback() {
    try {
      window.onscroll = () => {
        let stickysection = this.template.querySelector('.myStickyHeader');
        let sticky2 = stickysection.offsetTop;

        if (window.pageYOffset > sticky2) {
          stickysection.classList.add("slds-is-fixed");
          this.stickyMargin = 'margin-top:90px';
          this.contentPadding = 'padding-top:105px'
        } else {
          stickysection.classList.remove("slds-is-fixed");
          this.stickyMargin = '';
          this.contentPadding = 'padding-top:10px'
        }
      }
    } catch (error) {
      console.error('error =>', error);
    }
  }

  connectedCallback() {
    this.publishEventId();
    window.scrollTo(0,0);

  }
}