import { LightningElement } from 'lwc';
import ComingSpeakers from "@salesforce/resourceUrl/ComingSoonSpeakers";
export default class ComingSoonSpeaker extends LightningElement {
    comingSoonSpeakersUrl = ComingSpeakers;
    connectedCallback() {
        console.log('Resource URL:', this.comingSoonSpeakersUrl);
    }
}