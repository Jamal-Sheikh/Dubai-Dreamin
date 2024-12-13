import { LightningElement, wire, api } from "lwc";
import getSponsor from "@salesforce/apex/SponsorController.getSponsor";
import { subscribe, MessageContext } from "lightning/messageService";
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
import EVENT_MESSAGE from '@salesforce/messageChannel/EventIDMessageChannel__c';


export default class SponsorSection extends LightningElement {
    selectedEventId = 'a021m00001cTgUnAAK';
//    @api selectedEventId;

    subscription;
    scrlMsg;
    sponsorInformation;


    @wire(MessageContext) messageContext;


    subscribeToMessageChannel() {
        this.scrlMsg = subscribe(this.messageContext, SCROLL_MESSAGE, (message) => this.handleScroll(message));
    }
    subscribeToEventIdMessageChannel(){
        
        this.subscription = subscribe(this.messageContext, EVENT_MESSAGE, (eventMessage) => this.handleEventIdMessage(eventMessage))
    
    }
    handleEventIdMessage(eventMessage) {
        console.log('this.eventMessage : ', eventMessage);

    this.selectedEventId = eventMessage.eventId;
        console.log('this.selectedEventId : ', this.selectedEventId);


  }


    @wire(getSponsor, { eventId: '$selectedEventId' })
    wiredData({ error, data }) {
        if (data) {
            this.sponsorInformation = data
        } else if (error) {
            console.error('Sponsor Error:', error);
        }
    }
    handleScroll(message) {
        const scrollSection = message.section;

        if (scrollSection === 'Sponsors') {

            this.template.querySelector('.sectionSponser_outer').scrollIntoView({ behavior: 'smooth' });

        }
    }
    connectedCallback() {
        this.subscribeToMessageChannel();
        this.subscribeToEventIdMessageChannel();
    }
}