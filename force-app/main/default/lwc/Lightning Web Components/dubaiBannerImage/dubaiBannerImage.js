import { LightningElement, wire } from 'lwc';
import getEventHightlight from '@salesforce/apex/EventController.getEvent';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import DUBAI_ASSET from '@salesforce/resourceUrl/DUBAI_ASSET';
import dubaibanner from '@salesforce/resourceUrl/dubaibanner';
import DESIGN_IMAGES from '@salesforce/resourceUrl/DESIGN_IMAGES';
import BannerLogo from '@salesforce/resourceUrl/BannerLogo';
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
// import { subscribe,  MessageContext } from 'lightning/messageService';
import EVENT_ID_LMS from '@salesforce/messageChannel/EventIDMessageChannel__c';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
export default class DubaiBannerImage extends LightningElement {
   // selectedEventId = 'a021m00001cTgUnAAK';
   selectedEventId;
    buttonLabel = 'RSVP'
    backgroundImageUrl;
    dubaiBuildingsIcon;
    eventTitle;
    eventDescription;
    eventStreet;
    eventCity;
    eventCountry;
    eventDate;
    eventTime;
    eventStartDateTime;
    eventEndDateTime;


    main_banner;
    bannerLogo;


    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) {
    if (data) {
        
     
        this.selectedEventId=data;
    } else if (error) {
        console.error('getDubaiDreaminEventId Error:', error);
    }
}

    @wire(MessageContext)
    messageContext
   
    // subscribeToScrollMsg(){
    //   let scrollSubs = subscribe(this.messageContext, SCROLL_MESSAGE, (sectionMessage)=> this.handleMessage(sectionMessage))
    // // console.log(this.sectionMessage)
    // }

//   handleMessage(sectionMessage){
//     let section = sectionMessage.section;
    
//     if(section === 'goto_register'){
//         console.log('handleMessage');
//             this.template.querySelector('#goto_register').scrollIntoView({ behavior: 'smooth' });
      
//     }
//   }
  registerScroll(event){
 
    console.log('registerid : ',event.target.dataset.registerid);
     let section = event.target.dataset.registerid;

    console.log('section : ',section);
     const payload = { section: section };

    console.log('payload : ',JSON.stringify(payload));
    publish(this.messageContext, SCROLL_MESSAGE, payload);
    console.log('publish : ',publish(this.messageContext, SCROLL_MESSAGE, payload));
  }
    @wire(getEventHightlight, { eventId: '$selectedEventId' })
    wiredEventHightlight({ error, data }) {
        if (data) {
            this.eventTitle = data.eventTitle;
            this.eventDescription = data.eventDescription;
            this.eventStreet = data.eventStreet;
            this.eventCity = data.eventCity;
            this.eventCountry = data.eventCountry;
            this.eventStartDateTime = data.eventStartDateTime;
            this.eventEndDateTime = data.eventEndDateTime;
            this.bannerImageWarning = data.bannerImageWarning;
            this.titleWarning = data.titleWarning;
            this.dateTimeWarning = data.dateTimeWarning;
            this.descriptionWarning = data.descriptionWarning
            this.locationWarning = data.locationWarning;
        } else if (error) {
            console.error(' getEventHightlight Error:', error);
        }
    }

    handleSubmit(event) {
        // Handle submit logic here
        // You can access input field values using this.template.querySelector
        // For example:
        // const pickupLocation = this.template.querySelector('lightning-input[data-id="pickup-location"]').value;
        // const dateTime = this.template.querySelector('lightning-input[data-id="date-time"]').value;
        // Then you can perform further actions based on the values
    }


    connectedCallback() {
        // this.subscribeToScrollMsg();
        
        // this.backgroundImageUrl = DUBAI_ASSET + '/bannersection.png';
        // this.backgroundImageUrl = DUBAI_ASSET + '/bannerBg.png';
        this.backgroundImageUrl = dubaibanner + '/dubaibanner.png';
        this.dubaiBuildingsIcon = DUBAI_ASSET + '/dubai.png';


        this.main_banner = DESIGN_IMAGES + '/designImages/main_banner.png';
        this.bannerLogo = BannerLogo;
       
        console.log(' this.main_banner : ', this.main_banner);

    }
    

    get backgroundImageStyle() {
        return `background-image: url(${this.backgroundImageUrl});`;
    }

}