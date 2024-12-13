import { LightningElement, wire } from 'lwc';
import getFooterItems from '@salesforce/apex/FooterController.getFooterItems';
// import SOCIAL_ICONS from '@salesforce/resourceUrl/SOCIAL_ICONS';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import SOCIAL_ICONS from '@salesforce/resourceUrl/SO_ICONS';
import getNavigationItems from '@salesforce/apex/NavigationbarController.getNavigationItems';
import EVENT_CHANNEL from '@salesforce/messageChannel/EventIDMessageChannel__c';
import { publish, MessageContext } from 'lightning/messageService';
export default class DubaiFooter extends LightningElement {
    socialIcons = SOCIAL_ICONS;
    linksLoaded = false;
    socialLinks = [];
    selectedEventId
    companyLogo
    speakersLink = '/s/speakers';
    ourSpeakersLink = '/s/our-speakers';
    sponsorsLink = '/s/sponsors';
    aboutUsLink = '/s/aboutus';

  @wire(MessageContext)
  messageContext;


    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) {
        if (data) {

            this.selectedEventId = data;
        } else if (error) {
            console.error('getDubaiDreaminEventId Error:', error);
        }
    }

    @wire(getFooterItems, { eventId: '$selectedEventId' })

    wiredData({ error, data }) {
        if (data) {
            this.linksLoaded = true
            data.forEach(link => {
                const iconName = link.socialMediaIcon;
                let socialLink = Object.assign({}, link, { socialMediaIcon: this.socialIcons + '/' + iconName });
                this.socialLinks.push(socialLink);


            });
        } else if (error) {
            console.error('Error:', error);
        }
    }

    @wire(getNavigationItems, { eventId: '$selectedEventId' })
    wiredData1({ error, data }) {
        if (data) {
            this.linksLoaded = true
            if (data && data.length > 0) {

                this.companyLogo = data[0].companyLogo;
                this.navigationItems = data;
            }


        } else if (error) {
            console.error('Error:', error);
        }
    }

    // publishEventId() {


    //     const payload = { eventId: this.selectedEventId };
    //     publish(createMessageContext(), EVENT_CHANNEL, payload);

    // }
    // connectedCallback() {
    //     this.publishEventId();
    // }

}