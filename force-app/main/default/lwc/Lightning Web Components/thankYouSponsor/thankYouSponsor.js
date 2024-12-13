import { LightningElement, wire, api } from 'lwc';


export default class ThankYouSponsor extends LightningElement {

    @api thankyouType;

    isSpeaker;
    isSponsor;
    isAttendee;
    isAttendeeAlreadyRegistered;
    showContactSoon;

    renderedCallback() {
        this.isSponsor = this.thankyouType == 'Sponsor';
        this.isSpeaker = this.thankyouType == 'Speaker';
        this.isAttendee = this.thankyouType == 'Attendee';
        this.isAttendeeAlreadyRegistered = this.thankyouType == 'Ticket Confirmed';
        this.showContactSoon = this.isSpeaker || this.isSponsor;
    }
}