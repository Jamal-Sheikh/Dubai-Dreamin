import { LightningElement } from 'lwc';
import SpeakerAnnouncement from "@salesforce/resourceUrl/SpeakerAnnouncement";


export default class DubaiHomeSpeakerSection extends LightningElement {

    speakersLink = '/s/speakers';
    speakerAnnouncementImage = SpeakerAnnouncement + '/HomePageAnnouncment.png';
}