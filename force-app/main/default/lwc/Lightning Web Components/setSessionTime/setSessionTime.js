import { LightningElement, api, wire } from 'lwc';
import getSessionTime from '@salesforce/apex/ApprovalProcessController.getSessionTime';
import setSessionTime from '@salesforce/apex/ApprovalProcessController.setSessionTime';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


// import { getRecord } from 'lightning/uiRecordApi';

// const FIELDS = ["Speaker.Name"];
export default class SetSessionTime extends LightningElement {
  sessionName;
  sessionTitle
  sessionStartTime;
  sessionEndTime;
  sessionSelectionDetails;
  sessionExpertiseOnSubject;
  sessionIntroLink;
  sessionLevel;
  sessionPresentedLink;
  sessionAlreadyPresented;
  IPRCompliance;
  individualPresentor;
  speakerName;
  speakerPhone;
  speakerSocialMedia;
  speakerAge;
  speakerGender;
  coSpeakerName;
  coSpeakerCompanyName;
  coSpeakerPhone;
  coSpeakerEmail;
  coSpeakerTitle;
  coSpeakerRole;
    @api recordId;

    @wire(getSessionTime, { recordId: "$recordId"})
    getSessionResults({ error, data }) {
      if (data) {
        console.log('data', data[0].sessionName);
        console.log('data', data[0].sessionTitle);
        console.log('data', data[0].sessionStartTime);
        console.log('gender', data[0].speakerGender);
        this.sessionName = data[0].sessionName;
        this.sessionTitle = data[0].sessionTitle;
        this.sessionStartTime = data[0].sessionStartTime;
        this.sessionEndTime = data[0].sessionEndTime;
        this.sessionDescription = data[0].sessionDescription;
        this.sessionTrack = data[0].sessionTrack;
        this.sessionSelectionDetails = data[0].sessionSelectionDetails;
        this.sessionExpertiseOnSubject = data[0].sessionExpertiseOnSubject;
        this.sessionIntroLink = data[0].sessionIntroLink;
        this.sessionLevel = data[0].sessionLevel;
        this.sessionPresentedLink = data[0].sessionPresentedLink;
        this.sessionAlreadyPresented = data[0].sessionAlreadyPresented;
        this.IPRCompliance = data[0].IPRCompliance;
        this.individualPresentor = data[0].individualPresentor;
        this.speakerName = data[0].speakerName;
        this.speakerPhone = data[0].speakerPhone;
        this.speakerRole = data[0].speakerRole;
        this.speakerTarget = data[0].speakerTarget;
        this.speakerEmail = data[0].speakerEmail;
        this.companyName = data[0].companyName;
        this.speakerInformation = data[0].speakerInformation;
        this.speakerSocialMedia = data[0].speakerSocialMedia;
        this.speakerAge = data[0].speakerAge;
        this.speakerGender = data[0].speakerGender;
        this.coSpeakerName = data[0].coSpeakerName;
        this.coSpeakerCompanyName = data[0].coSpeakerCompanyName;
        this.coSpeakerPhone = data[0].coSpeakerPhone;
        this.coSpeakerEmail = data[0].coSpeakerEmail;
        this.coSpeakerTitle = data[0].coSpeakerTitle;
        this.coSpeakerRole = data[0].coSpeakerRole;
        // this.sessionStartTime = data;
        // console.log(this.sessionStartTime);
      } else if (error) {
        this.error = error;
        console.error('error fetching sesson'+ error);
        // this.sessionTrackOption = undefined;
      }
    }


    handleStartTimeChange(event){
        this.sessionStartTime = event.target.value;

    }
    handleEndTimeChange(event){
        this.sessionEndTime = event.target.value;

    }
    // @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    // contact;
  
    // get myname() {
    //   return this.contact.data.fields.Name.value;
    // }

    handleSubmission(){
      setSessionTime({ sessionName: this.sessionName, sessionStartTime: this.sessionStartTime, sessionEndTime: this.sessionEndTime })
        .then((data => {
         
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Session Updated Successfully!',
                    variant: 'success'
                })
            );
            this.closeModal();
        }))
        .catch((error) => {
            if (error.errorType=="fetchResponse" ) {
                console.log('error.body.message : ',error.body.message);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                         message:  'Time Difference Must be 30-60 minutes',
                        variant: 'error'
                    })
                );
            } else {

                console.error('Error registering speaker: ', error);

                this.errorMessage = 'An error occurred while registering speaker.';
            }

        })


        // console.log(this.recordId)
        // console.log(this.myname)
    }
}