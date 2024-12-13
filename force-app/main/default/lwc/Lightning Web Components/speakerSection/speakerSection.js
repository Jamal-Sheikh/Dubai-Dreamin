import { LightningElement,api,  wire, track } from "lwc";
import getSpeakers from "@salesforce/apex/SpeakerController.getSpeakers";
import { subscribe, MessageContext } from "lightning/messageService";
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
import EVENT_ID_LMS from '@salesforce/messageChannel/EventIDMessageChannel__c';
import IMAGES from '@salesforce/resourceUrl/IMAGES'
import SpeakerLabel from '@salesforce/label/c.Speaker_Label';
import AllSpeakersLabel from '@salesforce/label/c.All_Speakers_Label';
import ButtonLabel from '@salesforce/label/c.Button_View_Label';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import getSessionsBySearch from '@salesforce/apex/SessionController.getSessionsBySearch';
import getAllSessions from '@salesforce/apex/SessionController.getAllSessions';
import fetchOnlyFilteredSessions from '@salesforce/apex/SessionController.fetchOnlyFilteredSessions';
const columns=[
  { label :'Session Name',fieldName :'sessionTitle'},
  { label :'Speaker Name',fieldName :'speakerName'}
]

export default class speakerSection extends LightningElement {
  subscription = null;
  scrlMsg;
  @track speakerInformation;
  showAllSpeakers = false;
  @track allspeakerInformation = [];
  @track threespeakerInformation;
  selectedEventId;
  showModal = false;
  speakerLabel = SpeakerLabel;
  allSpeakersLabel = AllSpeakersLabel;
  buttonLabel = ButtonLabel;
  speakerId;
  profilePlaceholder;
  speakerModalDetails;
  speakerName;
  speakerDescription;
  speakerTitle;
  speakerEmail;
  speakerPhone;
  speakerImage;
  speakerSocialMedia;
  showlevelOptions=false;
  showProductOptions=false;
  showSessionTrackOptions=false;
  showKeywordOptions=false;
  showFilterOptions=false;
  columns=columns;
 sessions = [];
 allSessions=[];
 allFilterSessions=[];
 error;
 searchKey = [];
 selectedTrack = [];
 selectedKeyword = [];
 selectedProduct = [];
 selectedLevel=[];
filterBy;
errorDisplay=false;

  tracks = [
    { label: 'Admin', value: 'Admin', checked: false },
    { label: 'Developer', value: 'Developer', checked: false },
    { label: 'Architect', value: 'Architect', checked: false },
    { label: 'Business Analyst', value: 'Business Analyst', checked: false },
    { label: 'Consultant', value: 'Consultant', checked: false },
    { label: 'Partner', value: 'Partner', checked: false },

];

keywords = [
    { label: 'Apex', value: 'Apex', checked: false },
    { label: 'Lightning Web Components / LWC', value: 'LWC', checked: false },
    { label: 'Development', value: 'Development', checked: false },
    { label: 'Architect', value: 'Architect', checked: false },
    { label: 'Consultant', value: 'Consultant', checked: false },
    { label: 'Admin/Administrator', value: 'Admin', checked: false },
    { label: 'Clouds', value: 'Clouds', checked: false },
    { label: 'Platform', value: 'Platform', checked: false },

];

levels = [
    { label: 'Beginner', value: 'Beginner' , checked: false},
    { label: 'Intermediate', value: 'Intermediate', checked: false },
    { label: 'Advanced', value: 'Advanced', checked: false },

];

products = [
    { label: 'Sales Cloud', value: 'Sales Cloud', checked: false  },
    { label: 'Data Cloud', value: 'Data Cloud', checked: false  },
    { label: 'Service Cloud', value: 'Service Cloud', checked: false  },
    { label: 'Experience Cloud', value: 'Experience Cloud', checked: false  },
    { label: 'Marketing Cloud', value: 'Marketing Cloud', checked: false  },
    { label: 'Commerce Cloud', value: 'Commerce Cloud', checked: false  },
    { label: 'Analytics Cloud', value: 'Analytics Cloud' , checked: false },
    { label: 'Integration Cloud', value: 'Integration Cloud', checked: false  },
    { label: 'Manufacturing Cloud', value: 'Manufacturing Cloud' , checked: false },
    { label: 'Financial Services Cloud', value: 'Financial Services Cloud', checked: false  },
    { label: 'Education Services Cloud', value: 'Education Services Cloud', checked: false  },
    { label: 'Nonprofit Cloud', value: 'Nonprofit Cloud', checked: false  },
    { label: 'Health Cloud', value: 'Health Cloud', checked: false  },
    { label: 'Vaccine Cloud', value: 'Vaccine Cloud', checked: false  },
    { label: 'Other', value: 'Other' , checked: false }

];


    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) {
      console.log('speaker data'+data);
    if (data) {

        this.selectedEventId=data;       
    } else if (error) {
        console.error('getDubaiDreaminEventId Error:', error);
    }
    }
  openModal(event) {
    this.showModal = true;
    this.speakerId = event.target.dataset.speakerid
   
    this.speakerModalDetails = this.speakerInformation.find(speaker => speaker.speakerName === this.speakerId)

    this.speakerName = this.speakerModalDetails.speakerName;
    this.speakerDescription = this.speakerModalDetails.speakerInformation;
    this.speakerTitle = this.speakerModalDetails.speakerTitle;
    this.speakerEmail = this.speakerModalDetails.speakerEmail;
    this.speakerPhone = this.speakerModalDetails.speakerContactNumber;
    this.speakerImage = this.speakerModalDetails.speakerImage;
    this.speakerSocialMedia = this.speakerModalDetails.speakerSocialMedia;
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

@wire(getSpeakers, { eventId: '$selectedEventId' })
wiredData({ error, data }) {
  if (data) {
 this.speakerInformation = data;
   this.threespeakerInformation = this.speakerInformation;console.log('datalist:', data);  } else if (error) {
     console.error('Error:', error);
  }
}
  handleMessage(eventMessage) {
    this.selectedEventId = eventMessage.eventId;
   
    getSpeakers({ eventId: this.selectedEventId })
      .then(data => {
        this.speakerInformation = data;
        this.threespeakerInformation = this.speakerInformation;

      });
  }

  handleScroll(message) {
    const scrollSection = message.section;

    if (scrollSection === 'Speakers') {
   
      this.template.querySelector('.sectionSpeaker').scrollIntoView({ behavior: 'smooth' });

    }
  }
  handleViewAllClick() {
    this.showAllSpeakers = true;
    this.allspeakerInformation = this.speakerInformation;
    document.body.style.overflow = 'hidden';

  }
  handleCloseModal() {
    this.showAllSpeakers = false;
    document.body.style.overflow = 'auto';

  }
  connectedCallback() {
    this.subscribeToMessageChannel();
    // this.profilePlaceholder = IMAGES + '/profile' + '.png';
    this.profilePlaceholder = IMAGES + '/email_logo.png';
    // this.profilePlaceholder = 'https://i.imgur.com/aK4EdrM.png';
    console.log('This.All Session'+ JSON.stringify(this.allSessions));
    this.fetchAllSessions();
  }

  fetchAllSessions() {
    getAllSessions()
      .then(result => {
        this.allSessions = result;
        this.sessions = result;
        console.log('All Sessions:', JSON.stringify(this.allSessions));
      })
      .catch(error => {
        this.error = error;
        console.error('Error fetching all sessions:', error);
      });
  }
  handleShowLevel() {
    console.log('handleShowLevel Called');
    this.showlevelOptions=!this.showlevelOptions;
    this.showProductOptions=false;
  this.showSessionTrackOptions=false;
  this.showKeywordOptions=false;

  }
  handleShowProductOptions() {
    console.log('handleShowProductOptions Called');
    this.showProductOptions=!this.showProductOptions;

    this.showlevelOptions=false;
  this.showSessionTrackOptions=false;
  this.showKeywordOptions=false;
  }
  handleShowSessionTrackOptions() {
    console.log(' handleShowSessionTrackOptions Called');
    this.showSessionTrackOptions=!this.showSessionTrackOptions;

    this.showlevelOptions=false;
    this.showProductOptions=false;
  this.showKeywordOptions=false;
  }
  handleShowKeywordOption() {
    console.log(' handleShowKeywordOption Called');
    this.showKeywordOptions=!this.showKeywordOptions;

    this.showlevelOptions=false;
    this.showProductOptions=false;
  this.showSessionTrackOptions=false;
  }
  handleShowFilterIcon(){
    console.log('handleShowFilterIcon called');
    this.showFilterOptions=!this.showFilterOptions;
  }
  
  handleChange(event) {
    this.searchKey = event.target.value;
    console.log('Handle Change Function Called', this.searchKey);

    if (!this.searchKey) {
      this.sessions = this.allSessions;
      this.errorDisplay = false;
      console.log('Search key is empty. Displaying all sessions.');
    } else if (this.searchKey.length > 2) {
      getSessionsBySearch({ searchKey: this.searchKey })
        .then(result => {
          if (result.length > 0) {
            this.sessions = result;
            this.errorDisplay = false;
          } else {
            this.sessions = [];
            this.errorDisplay = true;
          }
          console.log('Sessions Data:', this.sessions);
        })
        .catch(error => {
          console.error('Error fetching sessions:', error);
          // this.sessions = [];
          this.errorDisplay = true;
        });
    }
  }
  
    handleButtonClick(event) {
      console.log('handle button click Function Called');
      getSessionsBySearch({ searchKey: this.searchKey })
          .then(result => {
              if (result.length > 0) {
                  this.sessions = result;
              } else {
                this.errorDisplay=true;
                  // this.sessions = this.allSessions;
              }
              console.log('Sessions Data:', this.sessions);
          })
          .catch(error => {
              this.error = error;
              console.error('Error fetching sessions by search key:', error);
          });
  }
  handleLevelChange(event) {
    this.errorDisplay = false;
    this.allFilterSessions = [];
    const value = event.target.value;
    const isChecked = event.target.checked;
    console.log('Level Selected:', value);

    if (isChecked && !this.selectedLevel.includes(value)) {
        this.selectedLevel.push(value);
    } else if (!isChecked && this.selectedLevel.includes(value)) {
        this.selectedLevel = this.selectedLevel.filter(level => level !== value);
    }

    this.levels = this.levels.map(level => {
        if (level.value === value) {
            return { ...level, checked: isChecked };
        }
        return level;
    });
}

    handleFilterHide(event){
      this.showFilterOptions=false;
    }


handleTrackChange(event) {
  this.allFilterSessions = [];
  this.errorDisplay = false;
  const value = event.target.value;
  const isChecked = event.target.checked;
  console.log('Track Selected:', value);

  if (isChecked && !this.selectedTrack.includes(value)) {
      this.selectedTrack.push(value);
  } else if (!isChecked && this.selectedTrack.includes(value)) {
      this.selectedTrack = this.selectedTrack.filter(track => track !== value);
  }

  this.tracks = this.tracks.map(track => {
      if (track.value === value) {
          return { ...track, checked: isChecked };
      }
      return track;
  });
}


handleProductChange(event) {
  this.allFilterSessions = [];
  this.errorDisplay = false;
  const value = event.target.value;
  const isChecked = event.target.checked;
  console.log('Product Selected:', value);

  if (isChecked && !this.selectedProduct.includes(value)) {
      this.selectedProduct.push(value);
  } else if (!isChecked && this.selectedProduct.includes(value)) {
      this.selectedProduct = this.selectedProduct.filter(product => product !== value);
  }

  this.products = this.products.map(product => {
      if (product.value === value) {
          return { ...product, checked: isChecked };
      }
      return product;
  });
}


handleKeywordChange(event) {
  this.allFilterSessions = [];
  this.errorDisplay = false;
  const value = event.target.value;
  const isChecked = event.target.checked;
  console.log('Keyword Selected:', value);

  if (isChecked && !this.selectedKeyword.includes(value)) {
      this.selectedKeyword.push(value);
  } else if (!isChecked && this.selectedKeyword.includes(value)) {
      this.selectedKeyword = this.selectedKeyword.filter(keyword => keyword !== value);
  }

  this.keywords = this.keywords.map(keyword => {
      if (keyword.value === value) {
          return { ...keyword, checked: isChecked };
      }
      return keyword;
  });
}
handleAllSearchFilter(){
    console.log('Level',JSON.stringify(this.selectedLevel));
    console.log('Keyword',JSON.stringify(this.selectedKeyword));
    console.log('Product',JSON.stringify(this.selectedProduct));
    console.log('SpeakerRole',JSON.stringify(this.selectedTrack));
    console.log('All Filter Sessions'+JSON.stringify(this.allFilterSessions));
    this.sessions=this.allFilterSessions;
    console.log('Filter Session Console'+this.sessions);
}


handleOnlyFilteredSession(){
  this.showFilterOptions=false;
  console.log('Level',JSON.stringify(this.selectedLevel));
  console.log('Keyword',JSON.stringify(this.selectedKeyword));
  console.log('Product',JSON.stringify(this.selectedProduct));
  console.log('SpeakerRole',JSON.stringify(this.selectedTrack));
 fetchOnlyFilteredSessions({levels: this.selectedLevel,
    keywords: this.selectedKeyword,trackedProducts:this.selectedProduct,speakerRole: this.selectedTrack,})
    .then(result =>{
        this.sessions=result;
        console.log('handle only  Filter Method Called');
        console.log('@@@ All Filtered Sessions Data ', JSON.stringify(this.sessions));
        this.sessions=result;
    })
    .catch(error =>{
        this.error=error;
    })
}
get hasSessions() {
  return this.sessions.length > 0;
}
}