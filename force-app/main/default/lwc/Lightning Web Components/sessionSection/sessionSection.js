import { LightningElement, wire, track } from "lwc";
import getSession from "@salesforce/apex/SessionController.getSessions";
import { subscribe, MessageContext } from "lightning/messageService";
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
import EVENT_ID_LMS from '@salesforce/messageChannel/EventIDMessageChannel__c';
import SessionsLabel from '@salesforce/label/c.Session_Label';
import AllSessionsLabel from '@salesforce/label/c.All_Sessions_Label';
import ButtonLabel from '@salesforce/label/c.Button_View_Label';
export default class SessionSection extends LightningElement {
   
    sessionLabel = SessionsLabel;
    allSessionsLabel = AllSessionsLabel;
    buttonLabel = ButtonLabel;
    subscription = null;
    scrlMsg;

    @wire(MessageContext) messageContext;
     sessionInformation = [];
    
    @track allsessionInformation ;
    @track threesessionInformation;

    selectedEventId;
    selectedSessionId;
   
    showAllSession = false;
    showModal = false;
    isExpanded = false;

    // --individual session's details---
    sessionDetails;
    sessionTitle;
    sessionDescription;
    sessionStartDate;
    sessionEndDate;
    sessionSartTime;
    sessionEndTime;
    sessionDuration;
    speakerNames;


    // --All sessions' details---
    allSessionDetails;
    allSessionTitle;
    allSessionDescription;
    allSessionStartDate;
    allSessionEndDate;
    allSessionSartTime;
    allSessionEndTime;
    allSessionDuration;
    allSpeakerNames;



    wholeClass = 'card_info'
 
    get contentClass() {
        return this.isExpanded ? 'content expanded' : 'content';
    }
    toggleExpansion(event) {


        let sessId = event.target.dataset.sessionid;
        let session = this.allsessionInformation.find(sess => sess.sessionTitle == sessId);
        session.contentClass = session.contentClass == 'content' ? 'content expanded' : 'content';

        // if( session.contentClass == 'content expanded'){
        //     this.wholeClass = 'testClass'
            
        // }
        // if (sessId === this.allSessionTitle) {
        //     this.isExpanded = !this.isExpanded;
        //     // this.isExpanded = false;
        // } else {
        //     this.isExpanded = true;
        //     this.allSessionDetails = this.allsessionInformation.find(session => session.sessionTitle === sessId);
           

        //     this.allSessionTitle = this.allSessionDetails.sessionTitle;
        //     this.allSessionDescription = this.allSessionDetails.sessionDescription;
        //     this.allSessionStartDate = this.allSessionDetails.sessionStartDate;
        //     this.allSessionEndDate = this.allSessionDetails.sessionEndDate;
        //     this.allSessionEndTime = this.allSessionDetails.sessionEndTime;
        //     this.allSessionDuration = this.allSessionDetails.sessionDuration;
        //     this.allSpeakerNames = this.allSessionDetails.lstOfSpeakers;
         
        // }
    }

    openModal(event) {
        this.showModal = true;
      
        this.selectedSessionId = event.target.dataset.sessionid;

        this.sessionDetails = this.threesessionInformation.find(session => session.sessionTitle === this.selectedSessionId
        );

        this.sessionTitle = this.sessionDetails.sessionTitle;
        this.sessionDescription = this.sessionDetails.sessionDescription;
        this.sessionStartDate = this.sessionDetails.sessionStartDate;
        this.sessionEndDate = this.sessionDetails.sessionEndDate;
        this.sessionEndTime = this.sessionDetails.sessionEndTime;
        this.sessionDuration = this.sessionDetails.sessionDuration;

        //this.speakerNames = this.sessionDetails.lstOfSpeakers.map(speaker => speaker.speakerName).join(', ');
        this.speakerNames = this.sessionDetails.lstOfSpeakers;
        document.body.style.overflow = 'hidden';

    }

    closeModal() {
        this.showModal = false;
        document.body.style.overflow = 'auto';

    }



    @wire(MessageContext) messageContext;

    subscribeToMessageChannel() {
        this.subscription = subscribe(this.messageContext, EVENT_ID_LMS, (eventMessage) => this.handleMessage(eventMessage));
        this.scrlMsg = subscribe(this.messageContext, SCROLL_MESSAGE, (message) => this.handleScroll(message));
    }

    handleMessage(eventMessage) {
        //this.selectedEventId = eventMessage.eventId;
        this.selectedEventId = 'a0nH2000001UMtGIAW';


      
        getSession({ eventId: this.selectedEventId })
            .then(data => {
                this.sessionInformation = data;
                this.threesessionInformation = this.sessionInformation.slice(0, 3);
               

            });
    }
    handleScroll(message) {
        const scrollSection = message.section;
  
        if (scrollSection === 'Sessions') {
            this.template.querySelector('.Sessions').scrollIntoView({ behavior: 'smooth' });

        }
    }
    handleViewAllClick() {
        this.showAllSession = true;
        this.allsessionInformation = [];
        this.sessionInformation.forEach(session => {
            let sessionItem = Object.assign({}, session, {contentClass: 'content'});
            this.allsessionInformation.push(sessionItem);
        });
        // this.allsessionInformation = this.sessionInformation;
        document.body.style.overflow = 'hidden';
    }
    handleCloseModal() {
        this.showAllSession = false;
        this.isExpanded = false;
        document.body.style.overflow = 'auto';
    }
    connectedCallback() {
        this.subscribeToMessageChannel();
    }



}