import { LightningElement, wire, api, track } from "lwc";
import registerSpeaker from "@salesforce/apex/SpeakerController.registerSpeaker";
// import getEvents from '@salesforce/apex/EventController.getEvents';
import EVENT_MESSAGE from "@salesforce/messageChannel/EventIDMessageChannel__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { subscribe, MessageContext } from "lightning/messageService";
import SpeakerAnnouncement from "@salesforce/resourceUrl/SpeakerAnnouncement";
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import SPEAKER_OBJECT from "@salesforce/schema/Speaker__c";
import ROLE_FIELD from "@salesforce/schema/Speaker__c.Speaker_Target__c";
import SESSION_OBJECT from "@salesforce/schema/Session__c";
import SESSION_TRACK_FIELD from "@salesforce/schema/Session__c.Session_Track__c";
import LEVEL_FIELD from "@salesforce/schema/Session__c.Level__c";

import getDubaiDreaminEventId from "@salesforce/apex/EventController.getDubaiDreaminEventId";


export default class SpeakerRegistrationForm extends LightningElement {
  submittedThankyou = false;
  thankyouSpeakerUrl = "/s/thank-you-speaker";
  isOpen = false;
  speakerRecordTypeId;
  speakerRoleOption;
  sessionAudienceLevel;

  sessionRecordTypeId;
  sessionTrackOption;

  showFirstPage = true;
  showRoleDropDown = false;
  showLevelDropDown = false;
  speakerAnnouncementImage = SpeakerAnnouncement + '/SpeakerPageAnnouncment.png';

  selectedSpeakerRoles = [];
  selectedSessionLevel = [];
  

  

  @wire(getObjectInfo, { objectApiName: SPEAKER_OBJECT })
  speakerRoleResults({ error, data }) {
    if (data) {
      this.speakerRecordTypeId = data.defaultRecordTypeId;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.speakerRecordTypeId = undefined;
    }
  }

  @wire(getPicklistValues, {
    recordTypeId: "$speakerRecordTypeId",
    fieldApiName: ROLE_FIELD
  })
  rolPicklistResults({ error, data }) {
    if (data) {
      this.speakerRoleOption = data.values;
      this.speakerRoleOption = this.speakerRoleOption.map(item => {
        return { ...item, selected: false };
    });
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.speakerRoleOption = undefined;
    }
  }

  @wire(getObjectInfo, { objectApiName: SESSION_OBJECT })
  sessionResults({ error, data }) {
    if (data) {
      this.sessionRecordTypeId = data.defaultRecordTypeId;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.sessionRecordTypeId = undefined;
    }
  }

  @wire(getPicklistValues, {
    recordTypeId: "$sessionRecordTypeId",
    fieldApiName: SESSION_TRACK_FIELD
  })
  trackPicklistResults({ error, data }) {
    if (data) {
      this.sessionTrackOption = data.values;
      this.sessionTrackOption = this.sessionTrackOption.map(item => {
        return { ...item, selected: false };
    });
      // console.log(this.sessionTrackOption[0].value);
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.sessionTrackOption = undefined;
    }
  }

//   @wire(getPicklistValues, {
//     recordTypeId: "$sessionRecordTypeId",
//     fieldApiName: LEVEL_FIELD
//   })
//   levelPicklistResults({ error, data }) {
//     if (data) {
//       console.log('LEVEL', data.values)
//       this.sessionAudienceLevel = data.values;
//       this.error = undefined;
//     } else if (error) {
//       this.error = error;
//       this.sessionAudienceLevel = undefined;
//       console.error('Error retrieving picklist values:', error.body);
//     }
//     console.log('audience level', this.sessionAudienceLevel);
//   }


  speakerName = "";
  speakerTitle = "";
  speakerEmail = "";
  speakerPhone = "";
  speakerAge = "";
  speakerFileName="";
  speakerGender = "";
  speakerProfileImage = "";
  speakerInformation = "";
  companyName = "";
  speakerImage = "";
  speakerImageBlob = "";
  speakerSocialMedia = "";
  sessionTitle = "";
  sessionDescription = "";
  sessionSelectionDetails = '';
  sessionStartTime;
  sessionEndTime;
  sessionIntro = '';
  speakerRole = "Admins";
  speakerTarget = "Admins";
  sessionTrack = "Sales Cloud";
  coSpeakerName = "";
  coSpeakerTitle = "";
  coSpeakerPhone = "";
  coSpeakerCompanyName = "";
  coSpeakerRole = "Admins";
  coSpeakerImage = "";
  coSpeakerImageBlob = "";
  coSpeakerEmail = "";
  sessionIntroLink = '';
  sessionPresentedLink = '';
  sessionAlreadyPresented = false;
 
  sessionExpertiseOnSubject = '';
  audienceLevel;

  terms = false;
  termsError = false;

  formReset = false;

  @track speakerDocumentId = "";
  @track coSpeakerDocumentId = "";
  speakerFileName;
  coSpeakerFileName;

  @api selectedEventId;
  showSessionFields = false;
  showModal = false;

  showCoSpeakerFields = false;
  showEmailExistsValidation = false;
  showSpeakerEmailValidation = false;
  showSpeakerNameValidation = false;
  showSpeakerCompanyValidation = false;
  showSessionTitleValidation = false;
  showSpeakerImageValidation = false;


  get genderOptions() {
    return [
      {label: "Male", value: "Male", isSelected: false},
      {label: "Female", value: "Female", isSelected: false},
      {label: "Non-Binary", value: "Non-Binary", isSelected: false},
      {label: "Preferred not to say", value: "Preferred not to say", isSelected: false},
    ];
}

  @wire(getDubaiDreaminEventId)
  wiredEventId({ error, data }) {
    if (data) {
      this.selectedEventId = data;
    } else if (error) {
      console.error("getDubaiDreaminEventId Error:", error);
    }
  }
  handleSpeakerNameChange(event) {
    this.speakerName = event.target.value;
    this.showSpeakerNameValidation = false;
  }
  handleSpeakerRoleChange(event) {
    this.speakerRole = event.target.value;
  }
  handleSpeakerPhoneChange(event) {
    this.speakerPhone = event.target.value;
  }

  handleSpeakerAgeChange(event) {
    this.speakerAge = event.target.value;
  }

  handleSpeakerGenderChange(event) {
    this.speakerGender = event.target.value;
    this.genderOptions.forEach(gender => {
      gender.isSelected = gender.label === this.speakerGender;
    });
    
  }
  handleSpeakerEmailChange(event) {
    this.speakerEmail = event.target.value;
    this.showEmailExistsValidation = false;
    this.showSpeakerEmailValidation = false;
  }

  handleSpeakerTitleChange(event) {
    this.speakerTitle = event.target.value;
    this.showSpeakerTitleValidation = false;
  }
  // handleProfileImageChange(event) {
  //     // this.speakerProfileImage = event.target.files[0];
  //     this.speakerProfileImage = event.target.value;;
  // }

  handleSpeakerInformationChange(event) {
    this.speakerInformation = event.target.value;
  }

  handleCoSpeakerFormVisibility(event) {
    this.showCoSpeakerFields = event.target.checked;
  }
  toggleCoSpeakerFormVisibility(event) {
    this.showCoSpeakerFields = !this.showCoSpeakerFields;
    console.log(this.coSpeakerRole);
    console.log(this.speakerRole);
  }

  handleAddSession() {
    this.showSessionFields = true;
  }

  handleSessionTitleChange(event) {
    this.sessionTitle = event.target.value;
    this.showSessionTitleValidation = false;
  }

  handleSessionStartDateChange(event) {
    this.sessionStartDate = event.target.value;
  }

  handleSessionEndDateChange(event) {
    this.sessionEndDate = event.target.value;
  }

  handleSessionStartTimeChange(event) {
    this.sessionStartTime = event.target.value;
  }

  handleSessionEndTimeChange(event) {
    this.sessionEndTime = event.target.value;
  }
  handleCompanyNameChange(event) {
    this.companyName = event.target.value;
    this.showSpeakerCompanyValidation = false;
  }
  handleCoSpeakerCompanyNameChange(event) {
    this.coSpeakerCompanyName = event.target.value;
    // this.showSpeakerCompanyValidation = false;
  }
  @track selectedSpeakerRoles = [];
  @track value;
  // @track allValues = [];
  handleSpeakerTargetChange(event) {
    const selectedValue = event.target.value;
    const isChecked = event.target.checked;

    if (isChecked && !this.selectedSpeakerRoles.includes(selectedValue)) {
        this.selectedSpeakerRoles.push(selectedValue);
    } else if (!isChecked && this.selectedSpeakerRoles.includes(selectedValue)) {
        const index = this.selectedSpeakerRoles.indexOf(selectedValue);
        if (index !== -1) {
            this.selectedSpeakerRoles.splice(index, 1);
        }
    }
    
    this.speakerRoleOption = this.speakerRoleOption.map(item => {
        if (item.label === selectedValue) {
            return { ...item, checked: isChecked };
        }
        return item;
    });

    this.speakerTarget = this.selectedSpeakerRoles.join(";");
}


  

  handleRemove(event) {
    const valueRemoved = event.target.name;
    this.selectedSpeakerRoles.splice(
      this.selectedSpeakerRoles.indexOf(valueRemoved),
      1
    );
    this.speakerTarget = this.selectedSpeakerRoles.join(";");
    this.speakerRoleOption = this.speakerRoleOption.map(item => {
        if (item.label === valueRemoved) {
            return { ...item, checked: false };
        }
        return item;
    });
    console.log(this.selectedSpeakerRoles[0]);
    console.log(this.speakerTarget);
  }

  @track levelOptions = [
    { value: 'beginner', label: 'Beginner', checked: false },
    { value: 'intermediate', label: 'Intermediate', checked: false },
    { value: 'advanced', label: 'Advanced', checked: false }
];
@track selectedSessionLevel = [];
  @track value;
  // @track allValues = [];
  handleSessionLevelChange(event) {
    const selectedValue = event.target.value;
    const isChecked = event.target.checked;

    if (isChecked && !this.selectedSessionLevel.includes(selectedValue)) {
        this.selectedSessionLevel.push(selectedValue);
    } else if (!isChecked && this.selectedSessionLevel.includes(selectedValue)) {
        const index = this.selectedSessionLevel.indexOf(selectedValue);
        if (index !== -1) {
            this.selectedSessionLevel.splice(index, 1);
        }
    }

    this.levelOptions = this.levelOptions.map(item => {
        if (item.label === selectedValue) {
            return { ...item, checked: isChecked };
        }
        return item;
    });

    this.sessionLevel = this.selectedSessionLevel.join(";");
}


handleRemoveSessionLevel(event) {
    const valueRemoved = event.detail.name;

    this.selectedSessionLevel.splice(
        this.selectedSessionLevel.indexOf(valueRemoved),
        1
    );

    this.sessionLevel = this.selectedSessionLevel.join(";");

    this.levelOptions = this.levelOptions.map(item => {
        if (item.label === valueRemoved) {
            return { ...item, checked: false };
        }
        return item;
    });
}


  handleProfileImageChange(event) {
    this.speakerImage = event.target.value;
  }
  handleSpeakerSocialMediaChange(event) {
    this.speakerSocialMedia = event.target.value;
  }
  handleSessionDescriptionChange(event) {
    this.sessionDescription = event.target.value;
  }
  handleSessionTrackChange(event) {
    this.sessionTrack = event.target.value;
    this.sessionTrackOption.forEach(track => {
      track.isSelected = track.label === this.sessionTrack;
    });
  }
  handleCoSpeakerNameChange(event) {
    this.coSpeakerName = event.target.value;
    this.termsError = false;
  }
  handleCoSpeakerPhoneChange(event) {
    this.coSpeakerPhone = event.target.value;
    // this.termsError = false;
  }
  handleCoSpeakerTitleChange(event) {
    this.coSpeakerTitle = event.target.value;
  }
  handleCoSpeakerRoleChange(event) {
    this.coSpeakerRole = event.target.value;
    this.speakerRoleOption.forEach(role => {
      role.isSelected = role.label === this.coSpeakerRole;
    });
  }
  handleCoSpeakerProfileImageChange(event) {
    this.coSpeakerImage = event.target.value;
  }

  handleCoSpeakerEmailChange(event) {
    this.coSpeakerEmail = event.target.value;
  }

  handleCoSessionIntroLink(event) {
    this.sessionIntroLink = event.target.value;
  }

  handleSessionSelectionDetails(event) {
    this.sessionSelectionDetails = event.target.value;
  }

  handleSessionAlreadyPresented(event) {
    this.sessionAlreadyPresented = event.target.checked;
  }

  handleIPRCompliance(event) {
    this.iPRCompliance = event.target.checked;
  }

  handleIndividualPresentor(event) {
    this.individualPresentor = event.target.checked;
  }

  handleSessionExpertiseOnSubject(event) {
    this.sessionExpertiseOnSubject = event.target.value;
  }

  handleSessionPresentedLink(event) {
    this.sessionPresentedLink = event.target.value;
  }

  // handleTermsChange(event) {
  //     this.terms = event.target.checked;
  //     this.termsError = false;
  // }

  // speakerName = '';
  // speakerTitle = '';
  // speakerProfileImage;
  // speakerInformation = '';
  // companyName='';
  // speakerImage='';
  // speakerSocialMedia='';
  // sessionTitle='';
  // sessionDescription;
  // sessionStartTime;
  // sessionEndTime;
  // speakerRole;
  // sessionTrack;
  // coSpeakerName='';
  // coSpeakerTitle='';
  // coSpeakerRole;
  // coSpeakerImage='';

  @track showSpinner = false;
  handleSpeakerRegistration(event) {
    console.log("thisevent" + this.selectedEventId);
    // this.showSpinner = true;
    //     setTimeout(()=>{
    //         this.showSpinner = false;
    //     },3000)
    event.preventDefault();
    // this.resetValidationFlags();
    console.log("Current value of the input: " + this.terms);
    const allValid = [...this.template.querySelectorAll("input")].reduce(
      (validSoFar, inputElem) => {
        if (inputElem.reportValidity) {
          inputElem.reportValidity();
          return validSoFar && inputElem.checkValidity();
        } else {
          // Fallback for browsers that don't support reportValidity()
          if (!inputElem.validity.valid) {
            inputElem.classList.add("slds-has-error"); // Example of adding error class for SLDS styling
            return false;
          }
          return validSoFar;
        }
      },
      true
    );
    // if (allValid) {
    //     alert('All form entries look valid. Ready to submit!');
    // } else {
    //     alert('Please update the invalid form entries and try again.');
    // }

    //     if(!showCoSpeakerFields){
    //         console.log('coSpeakerRole', this.coSpeakerRole);

    //     }

    //     if(this.isEmpty(this.speakerName)){
    //         // alert('name is null')
    //         missingMsg = `${this.speakerName} is missing`
    //         this.showSpeakerNameValidation = true;
    //     }
    //   if(this.isEmpty(this.companyName)){
    //         // alert('name is null')
    //         this.showSpeakerCompanyValidation = true;
    //     }
    //   if(this.speakerTitle==''){
    //         // alert('name is null')
    //         this.showSpeakerTitleValidation = true;
    //     }
    //   if(this.sessionTitle==''){
    //         // alert('name is null')
    //         this.showSessionTitleValidation = true;
    //     }
    //   if(this.speakerImage==''){
    //         // alert('name is null')
    //         this.showSpeakerImageValidation = true;
    //     }
    //   if(this.speakerEmail==''){
    //         // alert('name is null')
    //         this.showSpeakerEmailValidation = true;
    //     }
    //     if (this.hasValidationErrors()) {
    //         return;
    //     }
    // else{
    let speakerInfo = {
      hasCoSpeaker: this.showCoSpeakerFields,
      speakerName: this.speakerName,
      speakerEmail: this.speakerEmail,
      speakerPhone: this.speakerPhone,
      speakerTitle: this.speakerTitle,
      speakerAge: this.speakerAge,
      speakerGender: this.speakerGender,
      speakerFileName: this.speakerFileName,
      speakerImage: this.speakerDocumentId,
      speakerImageBlob: this.speakerImageBlob,
      speakerInformation: this.speakerInformation,
      companyName: this.companyName,
      speakerSocialMedia: this.speakerSocialMedia,
      speakerRole: this.speakerRole,
      speakerTarget: this.speakerTarget,
      coSpeakerName: this.coSpeakerName,
      coSpeakerPhone: this.coSpeakerPhone,
      coSpeakerCompanyName: this.coSpeakerCompanyName,
      coSpeakerTitle: this.coSpeakerTitle,
      coSpeakerRole: this.coSpeakerRole,
      coSpeakerImage: this.coSpeakerDocumentId,
      coSpeakerImageBlob: this.coSpeakerImageBlob,
      coSpeakerEmail: this.coSpeakerEmail,
      sessionInfo: {
        sessionTitle: this.sessionTitle,
        sessionDescription: this.sessionDescription,
        sessionStartDate: this.sessionStartDate,
        sessionEndDate: this.sessionEndDate,
        sessionStartTime: this.sessionStartTime,
        sessionEndTime: this.sessionEndTime,
        sessionTrack: this.sessionTrack,
        sessionSelectionDetails: this.sessionSelectionDetails,
        sessionExpertiseOnSubject: this.sessionExpertiseOnSubject,
        sessionIntroLink: this.sessionIntroLink,
        sessionAlreadyPresented: this.sessionAlreadyPresented,
        individualPresentor: this.individualPresentor,
        iPRCompliance: this.iPRCompliance,
        sessionPresentedLink:  this.sessionPresentedLink,
        sessionLevel: this.sessionLevel
      },
      eventId: this.selectedEventId
    };

    // registerSpeaker({ speakerName: this.speakerName, speakerTitle: this.speakerTitle, selectedEventId: this.selectedEventId, speakerImage: this.speakerProfileImage, speakerInformation:this.speakerInformation })
    registerSpeaker({ speakerInfo: JSON.stringify(speakerInfo) })
      .then((data) => {
        // this.closeModal();
        // this.resetForm();
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Speaker Application Submitted! ",
            variant: "success"
          })
        );
        //  location.replace(this.thankyouSpeakerUrl)
        this.submittedThankyou = true;
        window.scrollTo(0, 0);
      })
      .catch((error) => {
        if (
          error.body &&
          error.body.message &&
          error.body.message.includes(
            "A Session Request with the same Speaker/Co-Speaker email already exists."
          )
        ) {
          console.log("error.body.message : ", error.body.message);
          this.showEmailExistsValidation = true;
          this.errorMessage =
            "A Session Request with the same Speaker/Co-Speaker email already exists.";
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error",
              message: this.errorMessage,
              variant: "error"
            })
          );
        } else {
          console.error("Error registering speaker: ", error);
          console.error("Error registering speaker: ", error.body);

          this.errorMessage = "An error occurred while registering speaker.";
        }
      });
  }
  // this.closeModal();

  // }
  //reset form

  // resetValidationFlags() {
  //     this.showSpeakerNameValidation = false;
  //     this.showSpeakerCompanyValidation = false;
  //     // Reset other validation flags here
  // }

  resetForm() {
    this.speakerName = "";
    this.speakerTitle = "";
    this.speakerEmail = "";
    this.speakerPhone = "";
    this.speakerAge = "";
    this.speakerGender = "";
    this.speakerProfileImage = "";
    this.speakerInformation = "";
    this.companyName = "";
    this.speakerImage = "";
    this.speakerImageBlob = "";
    this.speakerSocialMedia = "";
    this.sessionTitle = "";
    this.sessionDescription = "";
    this.sessionStartTime = "";
    this.sessionEndTime = "";
    this.speakerRole = "Designer";
    this.sessionTrack = "Data Cloud";
    this.coSpeakerName = "";
    this.coSpeakerTitle = "";
    this.coSpeakerRole = "Designer";
    this.coSpeakerImage = "";
    this.coSpeakerImageBlob = "";
    this.coSpeakerEmail = "";
    this.terms = false;
    
    this.formReset = true;
  }

  //    isEmpty(value) {
  //     return value === '';
  // }

  // hasValidationErrors() {
  //     return (
  //         this.showSpeakerNameValidation ||
  //         this.showSpeakerCompanyValidation
  //         // Add other validation flags here
  //     );
  // }

  connectedCallback() {
    // this.subscribeToMessageChannel();
  }

  // speakerProfilePicBlob;
  // speakerProfilePicName;
  // @api recordId;
  speakerfileData = false;
  openfileUploadSpeaker(event) {
    const file = event.target.files[0];
    const fileSize = event.target.files[0].size;
    // if(fileSize>15000000){
    //     alert('file size too big');
    //     event.target.value = ''
    //     console.log('nulled');
    // }
    // else{
    var reader = new FileReader();
    reader.onload = () => {
      var base64 = reader.result.split(",")[1];
      this.speakerImageBlob = base64;
      this.speakerImage = file.name;
      this.showSpeakerImageValidation = false;
      // this.speakerfileData=true;
      // this.fileData = {
      //     'filename': file.name,
      //     'base64': base64,
      //     'recordId': this.recordId
      // }
      // console.log(this.fileData.filename)
      // console.log(this.speakerProfilePicBlob)
      // console.log(this.fileData.recordId)
    };
    reader.readAsDataURL(file);

    // }
  }
  openfileUploadCoSpeaker(event) {
    const file = event.target.files[0];
    var reader = new FileReader();
    reader.onload = () => {
      var base64 = reader.result.split(",")[1];
      this.coSpeakerImageBlob = base64;
      this.coSpeakerImage = file.name;
      // this.fileData = {
      //     'filename': file.name,
      //     'base64': base64,
      //     'recordId': this.recordId
      // }
      // console.log(this.fileData.filename)
      // console.log(this.speakerProfilePicBlob)
      // console.log(this.fileData.recordId)
    };
    reader.readAsDataURL(file);
  }

  get acceptedFormats() {
    return [".jpg", ".jpeg", ".png"];
  }
  handleUploadSpeakerImageFinished(event) {
    const uploadedFiles = event.detail.files;
    let cvId;
    if (uploadedFiles && uploadedFiles.length > 0) {
      let uploadedFileNames = "";
      for (let i = 0; i < uploadedFiles.length; i++) {
        uploadedFileNames += uploadedFiles[i].name + ", ";
        if (uploadedFiles[i].contentVersionId) {
          this.speakerDocumentId = uploadedFiles[i].contentVersionId;
        } else {
          cvId = uploadedFiles[i].contentVersionId;
        }
      }
      console.log("CV ID: ", this.speakerDocumentId);
      if (!this.speakerDocumentId) {
        getDocumentIdBYContentVersion({ contentVersionId: cvId }).then(
          (docId) => {
            console.log("Doc ID: ", docId);

            this.speakerDocumentId = docId;
          }
        );
      }

      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success",
          message:
            uploadedFiles.length +
            " Files uploaded Successfully: " +
            uploadedFileNames,
          variant: "success"
        })
      );
      this.speakerFileName = uploadedFileNames;
    } else {
      console.error("No files uploaded");
    }
  }

  handleUploadCoSpeakerImageFinished(event) {
    const uploadedFiles = event.detail.files;
    let cvId;
    if (uploadedFiles && uploadedFiles.length > 0) {
      let uploadedFileNames = "";
      for (let i = 0; i < uploadedFiles.length; i++) {
        uploadedFileNames += uploadedFiles[i].name + ", ";
        if (uploadedFiles[i].contentVersionId) {
          this.coSpeakerDocumentId = uploadedFiles[i].contentVersionId;
        } else {
          cvId = uploadedFiles[i].contentVersionId;
        }
      }
      console.log("CV ID: ", this.coSpeakerDocumentId);
      if (!this.coSpeakerDocumentId) {
        getDocumentIdBYContentVersion({ contentVersionId: cvId }).then(
          (docId) => {
            console.log("Doc ID: ", docId);

            this.coSpeakerDocumentId = docId;
          }
        );
      }

      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success",
          message:
            uploadedFiles.length +
            " Files uploaded Successfully: " +
            uploadedFileNames,
          variant: "success"
        })
      );
      this.coSpeakerFileName = uploadedFileNames;
    } else {
      console.error("No files uploaded");
    }
  }

  @api recordId;
  @track currentStep;

  goBackToStepOne() {
    this.currentStep = "1";

    this.template.querySelector("div.stepTwo").classList.add("slds-hide");
    this.template.querySelector("div.stepOne").classList.remove("slds-hide");
  }

  goToStepTwo() {
    this.currentStep = "2";

    this.template.querySelector("div.stepOne").classList.add("slds-hide");
    this.template.querySelector("div.stepTwo").classList.remove("slds-hide");
  }
  goBackToStepTwo() {
    this.currentStep = "2";

    this.template.querySelector("div.stepThree").classList.add("slds-hide");
    this.template.querySelector("div.stepTwo").classList.remove("slds-hide");
  }
  goToStepThree() {
    this.currentStep = "3";

    this.template.querySelector("div.stepTwo").classList.add("slds-hide");
    this.template.querySelector("div.stepThree").classList.remove("slds-hide");
  }

  moveToNextPage() {
    this.showFirstPage = false;
  }

  moveToPreviousPage() {
    this.showFirstPage = true;
  }

  handleDropdownClick(event) {
    event.stopPropagation();
}

connectedCallback() {
    this.clickEventListener = this.handleGlobalClick.bind(this);
    document.body.addEventListener('click', this.clickEventListener);
}

disconnectedCallback() {
    document.body.removeEventListener('click', this.clickEventListener);
}

handleGlobalClick(event) {
    
    if (!event.target.closest('.slds-combobox')) {
       
        this.showRoleDropDown = false;
        this.showLevelDropDown = false;
    }
}


handleRoleDropdown() {
  this.showRoleDropDown = !this.showRoleDropDown;
}

  handleLevelDropdown() {
    this.showLevelDropDown = !this.showLevelDropDown;
  }

  setCheckboxRole(event) {
    console.log(event.target.value);
    let inputVal = event.target.value;
    return inputVal && this.speakerTarget && this.speakerTarget.includes(inputVal);
  }

//   get selectedlevel() {
//     return this.audienceLevel.join(',');
// }

//   levelChange(e) {
//       this.audienceLevel = e.detail.value;
//       // this.audienceLevel.join(';');
//   }

//   get levelOptions() {
//     return [
//         { label: 'Beginner', value: 'Beginner' },
//         { label: 'Intermediate', value: 'Intermediate' },
//         { label: 'Advanced', value: 'Advanced' }
//     ];
// }

validateFirstPage() {
  const inputs = this.template.querySelectorAll('.mainContainer input[required]');
  let isValid = true;
  const errorMessages = [];

  inputs.forEach(input => {
      if (!input.reportValidity()) {
          isValid = false;
          const errorMessage = input.validationMessage;
          errorMessages.push({ field: input.name, message: errorMessage });
      }
  });

  if (isValid) {
      this.moveToNextPage();
  } else {
      errorMessages.forEach(error => {
          const fieldName = error.field;
          const errorMessage = error.message;
          console.log(`Error in field '${fieldName}': ${errorMessage}`);
        
      });
  }
}


 isExpertiseRequired() {
  return !this.sessionAlreadyPresented;
 }


}