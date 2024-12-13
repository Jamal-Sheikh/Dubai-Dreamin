import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import retrievePrice from '@salesforce/apex/PaymentController.retrievePrice';
import registerAttendee from '@salesforce/apex/DubaiRSVPController.registerAttendees';
import createPaymentPage from '@salesforce/apex/DubaiRSVPController.createPaymentPage';
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import ATTENDEE_OBJECT from "@salesforce/schema/Attendee__c";
import COUNTRY_FIELD from "@salesforce/schema/Attendee__c.Country__c";
import CITY_FIELD from "@salesforce/schema/Attendee__c.City__c";
import COMPANYSIZE_FIELD from "@salesforce/schema/Attendee__c.Company_Size__c";
import FOOD_FIELD from "@salesforce/schema/Attendee__c.Food_Preference__c";
import TSHIRT_FIELD from "@salesforce/schema/Attendee__c.Tshirt_Size__c";
import SESSION_FIELD from "@salesforce/schema/Attendee__c.Session_Interest__c";
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
import EVENT_ID_LMS from '@salesforce/messageChannel/EventIDMessageChannel__c';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import fetchCouponId from '@salesforce/apex/DubaiRSVPController.fetchCouponId';

export default class Dd_RSVP_Section extends LightningElement {
  speakersLink = '/s/speakers';
  thankYouLink = window.location.href + 'thankyou';

  selectedEventId;
  quantity = 0;
  ticketId;
  ticketsWithQuantity = [];
  ticketInfo = {}
  tickets;
  selectedTicket;
  totalTicketPrice;

  // --- section flags---
  isOpen = false;
  showTickets = false;
  showAttendeeForm = true;
  showOrderSummary = false;
  showCheckout = false;
  isTicketActive = true;
  isPlaceOrderVisible = false;
  isNextButtonVisible = true;
  isPreviousButtonVisible = true;


  // ----attendee info----
  nextButtonClickCount = 0;
  allAttendeesData = [];
  couponId;
  attendeeId
  nextAttendeeId = 1;
  firstName = '';
  lastName = '';
  email = '';
  taxReceipt;
  attendeeAddress;
  attendeeCountry;
  registrationType;
  townCity;
  postalCode;
  phoneNumber = '';
  sessionInterest;
  companyName = '';
  foodPreference;
  tShirtSize;
  designation = '';
  companySize;
  paymentPageLink;
  trailblazerId = '';
  linkedinId = '';
  message = '';
  agreement = false;


  attendeeRecordTypeId;
  countryPickList;
  cityPickList;
  sessionPickList;
  foodPreferencePickList;
  tShirtSizePickList;
  companySizePickList;

  currentFormIndex = 1;

  @wire(MessageContext)
  messageContext

  subscribeToScrollMsg() {

    let scrollSubs = subscribe(this.messageContext, SCROLL_MESSAGE, (sectionMessage) => {

      console.log('sectionMessage', sectionMessage);
      this.handleMessage(sectionMessage)
    })
    // console.log(this.sectionMessage)
  }

  handleMessage(sectionMessage) {
    let section = sectionMessage.section;
    console.log('handleMessage', section);

    if (section == 'goto_register') {
      console.log(this.template.querySelector('.goto_register'));
      this.template.querySelector('.goto_register').scrollIntoView({ behavior: 'smooth' });

    }
  }


  @wire(getDubaiDreaminEventId)
  wiredEventId({ error, data }) {
    if (data) {

      this.selectedEventId = data;
    } else if (error) {
      console.error('getDubaiDreaminEventId Error:', error);
    }
  }


  loadTickets() {
    console.log('loadTickets : ');
    retrievePrice()
      .then(result => {
        this.tickets = result;
        console.log(' this.tickets : ', JSON.stringify(this.tickets));

        this.showTickets = true;

      })
      .catch(error => {
        console.error('Error fetching ticket data:', error);
      });
  }


  handleTicketSelection() {
    this.dispatchEvent(
      new ShowToastEvent({
        title: 'Only Early Bird Ticket Available!',
        message: 'Please note that only the Early Bird ticket is available for selection. ',
        variant: 'warning'
      })
    );
  }

  handleFieldChange(event) {
    // const fieldName = event.target.value;
    // const fieldName = event.target.label;
    const fieldName = event.target.dataset.fieldname;
    const value = event.target.value;
    switch (fieldName) {
      case 'First Name':
        this.firstName = value;
        break;
      case 'Last Name':
        this.lastName = value;
        break;
      case 'Email':
        this.email = value;
        break;
      case 'TAX RECEIPT':
        this.taxReceipt = value;
        break;
      case 'ADDRESS':
        this.attendeeAddress = value;
        break;
      case 'Country':
        this.attendeeCountry = value;
        break;
      case 'REGISTRATION TYPE':
        this.registrationType = value;
        break;
      case 'TOWN/CITY':
        this.townCity = value;
        break;
      case 'POSTAL CODE':
        this.postalCode = value;
        break;
      case 'Phone Number':
        this.phoneNumber = value;
        break;
      case 'Session interest information':
        this.sessionInterest = value;
        break;
      case 'Food Preference':
        this.foodPreference = value;
        break;
      case 'T-Shirt Size':
        this.tShirtSize = value;
        break;
      case 'Company Name':
        this.designation = value;
        break;
      case 'Company Size':
        this.companySize = value;
        break;
      case 'Message':
        this.message = value;
        break;
      case 'Trailblazer Id':
        this.trailblazerId = value;
        break;
      case 'Linkedin':
        this.linkedinId = value;
        break;
      case 'Terms & Conditions':
        // this.agreement = value;
        this.agreement = (value !== undefined) ? true : false;
        break;
      default:
        break;
    }
  }
  showWarning = false;
  noteMessage = false
  handleQuantityChange(event) {
    this.noteMessage = true

    const ticketId = event.target.dataset.ticketid;
    const enteredQuantity = parseInt(event.target.value);

    if (isNaN(enteredQuantity) || enteredQuantity < 1 || enteredQuantity > 99) {
      // If the entered value is not a number or it's less than 1 or greater than 99
      event.target.value = ''; // Reset input field
      this.showWarning = true; // 
      return; // Exit the method
    }
    else {
      this.showWarning = false; // 

    }

    this.quantity = enteredQuantity;

    this.ticketsWithQuantity = [];


    const selectedTicket = this.tickets.find(ticket => ticket.id === ticketId);
    // let maxQuantity =Math.max(this.quantity, 1);
    let maxQuantity = Math.min(Math.max(this.quantity, 1), 99); // Limit quantity between 1 and 99

    let vatTax = 0.05;
    let subTotalPrice = maxQuantity * selectedTicket.unitAmount;

    // Calculate VAT amount
    let vatAmount = subTotalPrice * vatTax;

    // Calculate total price including VAT
    let totalPrice = subTotalPrice + vatAmount;
    if (selectedTicket && this.quantity !== 0) {
      const ticketInfo = {
        id: ticketId,
        quantity: maxQuantity,
        ticketTitle: selectedTicket.nickname,
        ticketPrice: selectedTicket.unitAmount,
        vatTax: vatAmount,
        totalPrice: totalPrice,
        subTotalPrice: subTotalPrice
      };


      this.ticketsWithQuantity.push(ticketInfo);
      console.log('this.ticketsWithQuantity:', this.ticketsWithQuantity);
    }
    this.showOrderSummary = true;


  }




  toggleCheckOut() {

    if (Object.keys(this.ticketsWithQuantity).length > 0) {
      let attendeeForm = this.template.querySelector('.attendee-form');
      let ticketForm = this.template.querySelector('.ticket_table_flShow');
      ticketForm.style.display = 'none'
      attendeeForm.style.display = 'block'

      this.handleButtonVisibility();


    }
    else {
      console.log('PLEASE ATLEAST CHOOSE 1 PURCHASE!')
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'BUY 1 TICKET ATLEAST',
          message: 'Please select 1 ticket minimum to checkout! ',
          variant: 'error'
        })
      );
    }

  }
  reverseToggle() {
    let attendeeForm = this.template.querySelector('.attendee-form');
    let ticketForm = this.template.querySelector('.ticket_table_flShow');

    ticketForm.style.display = 'block'
    attendeeForm.style.display = 'none'


  }


  handleButtonVisibility() {
    if (this.quantity === 1) {
      this.isNextButtonVisible = false;
      this.isPlaceOrderVisible = true;
    } else {
      this.isNextButtonVisible = this.nextButtonClickCount < this.quantity - 1;
      this.isPlaceOrderVisible = !this.isNextButtonVisible;
    }

    this.isPreviousButtonVisible = this.isNextButtonVisible;

  }
  handleNextButton() {

    if (this.nextButtonClickCount < this.quantity) {

      this.pushFormData();
      this.nextButtonClickCount++;

      this.handleButtonVisibility();
      this.resetForm();

      this.fillAttendeeForm();

    }

    else {
      window.alert('You have reached the maximum quantity of purchase.');

    }

  }


  handlePrevousButton() {

    if (this.nextButtonClickCount > 0) {
      console.log('this.nextButtonClickCount: ', this.nextButtonClickCount);

      this.nextButtonClickCount--;
      this.fillAttendeeForm();
      

      this.handleButtonVisibility();
    } else {
      window.alert('You are already at the first attendee form.');
    }
  }
  pushFormData() {
    let attendeeData = {
      id: this.nextAttendeeId,
      eventId: this.selectedEventId,
      ticketsList: this.ticketsWithQuantity,
      firstName: this.firstName,
      lastName: this.lastName,
      email: this.email,
      taxReceipt: this.taxReceipt,
      address: this.attendeeAddress,
      country: this.attendeeCountry,
      townCity: this.townCity,
      postalCode: this.postalCode,
      phone: this.phoneNumber,
      sessionInterest: this.sessionInterest,
      companyName: this.companyName,
      foodPreference: this.foodPreference,
      tShirtSize: this.tShirtSize,
      designation: this.designation,
      companySize: this.companySize,
      message: this.message,
      agreement: this.agreement,
      trailblazerId: this.trailblazerId,
      linkedinId: this.linkedinId
    };
    this.nextAttendeeId++;
    // this.allAttendeesData.push(attendeeData);
    if (this.nextButtonClickCount === 0) {
      attendeeData.primary = true;
    } else {
      attendeeData.primary = false;
    }
    this.allAttendeesData[this.nextButtonClickCount] = attendeeData;


  }
  fillAttendeeForm() {
    let previousAttendeeData = this.allAttendeesData[this.nextButtonClickCount];
    this.selectedEventId = previousAttendeeData.eventId;
    this.ticketsWithQuantity = previousAttendeeData.ticketsList;
    this.firstName = previousAttendeeData.firstName;
    this.lastName = previousAttendeeData.lastName;
    this.email = previousAttendeeData.email;
    this.taxReceipt = previousAttendeeData.taxReceipt;
    this.attendeeAddress = previousAttendeeData.address;
    this.attendeeCountry = previousAttendeeData.country;
    this.townCity = previousAttendeeData.townCity;
    this.postalCode = previousAttendeeData.postalCode;
    this.phoneNumber = previousAttendeeData.phone;
    this.sessionInterest = previousAttendeeData.sessionInterest;
    this.companyName = previousAttendeeData.companyName;
    this.foodPreference = previousAttendeeData.foodPreference;
    this.tShirtSize = previousAttendeeData.tShirtSize;
    this.designation = previousAttendeeData.designation;
    this.companySize = previousAttendeeData.companySize;
    this.message = previousAttendeeData.message;
    this.agreement = previousAttendeeData.agreement;
    this.trailblazerId = previousAttendeeData.trailblazerId;
    this.linkedinId = previousAttendeeData.linkedinId;
  }

  // ----------apply promo code------------
  handlePromoCodeChange(event) {
    this.promoCode = event.target.value;
}


  handleApplyPromo(){
    fetchCouponId({ promoCode: this.promoCode })
    .then(result => {
        // Handle the result here
        console.log('Coupon ID:', result);
        this.couponId = result;
        // You can further process the result as needed
    })
    .catch(error => {
        // Handle any errors here
        console.error('Error fetching coupon ID:', error);
    });
  }
  handlePayNow() {
    const inputFields = this.template.querySelectorAll('input[required], select[required], textarea[required]');
    const checkboxField = this.template.querySelector('input[type="checkbox"][required]');

    let isValid = true;

    inputFields.forEach(field => {
      if (!field.value.trim()) {
        isValid = false;
        const fieldName = field.getAttribute('data-fieldname');
        console.log('fieldName : ', fieldName);
        const errorMessage = `${fieldName} is required.`;
        const errorElement = field.parentElement.querySelector('.error-msg');
        if (errorElement) {
          errorElement.textContent = errorMessage;
          errorElement.style.display = 'block';
        }
      }
    });
    // Check if the checkbox is checked
    if (!checkboxField.checked) {
      isValid = false;
      const fieldName = checkboxField.getAttribute('data-fieldname');
      const errorMessage = `Please agree to ${fieldName}.`;
      const errorElement = checkboxField.parentElement.querySelector('.error-msg');
      if (errorElement) {
        errorElement.textContent = errorMessage;
        errorElement.style.display = 'block';
      }
    }
    // If any required field is empty, stop further processing
    if (!isValid) {
      return;
    }
    if (this.nextButtonClickCount === this.quantity - 1) {
      this.pushFormData();

      let q;
      let i;
  
      this.ticketsWithQuantity.forEach(ticket => {
        q = ticket.quantity;
        i = ticket.id;
  
      });

      registerAttendee({ attendeesInfo: JSON.stringify(this.allAttendeesData) })
      .then((attendeeObj) => {
        this.attendeeId = attendeeObj

        console.log(' this.attendeeId', this.attendeeId);

        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Success',
            message: 'Successfully registered for event! ',
            variant: 'success'
          })
        );
        createPaymentPage({ attendeeId: this.attendeeId, quantity: q, priceId: i, redirectUrl: this.thankYouLink , couponId: this.couponId})
          .then((paymentId => {

            this.paymentPageLink = paymentId;
            window.location.href = this.paymentPageLink;

            console.log('paymentId : ', paymentId);
          }))
          .catch((err) => {

          })

      })
      this.resetForm();
    } else {

      window.alert('Please complete all attendees before proceeding to payment.');
    }



    // registerAttendee({ attendeesInfo: JSON.stringify(this.allAttendeesData) })
    //   .then((attendeeObj) => {
    //     console.log('OUTPUT OF REGISTER ATTENDEE : ', JSON.stringify(attendeeObj));
    //     this.attendeeId = attendeeObj

    //     console.log(' this.attendeeId', this.attendeeId);

    //     this.dispatchEvent(
    //       new ShowToastEvent({
    //         title: 'Success',
    //         message: 'Successfully registered for event! ',
    //         variant: 'success'
    //       })
    //     );
    //     createPaymentPage({ attendeeId: this.attendeeId, quantity: q, priceId: i, redirectUrl: this.thankYouLink })
    //       .then((paymentId => {

    //         this.paymentPageLink = paymentId;
    //         window.location.href = this.paymentPageLink;

    //         console.log('paymentId : ', paymentId);
    //       }))
    //       .catch((err) => {

    //       })

    //   })



  }


  @wire(getObjectInfo, { objectApiName: ATTENDEE_OBJECT })
  results({ error, data }) {
    if (data) {
      this.attendeeRecordTypeId = data.defaultRecordTypeId;


      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.attendeeRecordTypeId = undefined;
    }
  }

  @wire(getPicklistValues, { recordTypeId: "$attendeeRecordTypeId", fieldApiName: COUNTRY_FIELD })
  getCountryValues({ error, data }) {
    if (data) {
      this.countryPickList = data.values;

      this.error = undefined;
    } else if (error) {
      this.error = error;
    }
  }
  @wire(getPicklistValues, { recordTypeId: "$attendeeRecordTypeId", fieldApiName: CITY_FIELD })
  getCityValues({ error, data }) {
    if (data) {
      this.cityPickList = data.values;

      this.error = undefined;
    } else if (error) {
      this.error = error;
    }
  }
  @wire(getPicklistValues, { recordTypeId: "$attendeeRecordTypeId", fieldApiName: FOOD_FIELD })
  getFoodValues({ error, data }) {
    if (data) {
      this.foodPreferencePickList = data.values;

      this.error = undefined;
    } else if (error) {
      this.error = error;
    }
  }
  @wire(getPicklistValues, { recordTypeId: "$attendeeRecordTypeId", fieldApiName: TSHIRT_FIELD })
  getShirtValues({ error, data }) {
    if (data) {
      this.tShirtSizePickList = data.values;

      this.error = undefined;
    } else if (error) {
      this.error = error;

    }
  }
  @wire(getPicklistValues, { recordTypeId: "$attendeeRecordTypeId", fieldApiName: COMPANYSIZE_FIELD })
  getCompanySizeValues({ error, data }) {
    if (data) {
      this.companySizePickList = data.values;

      this.error = undefined;
    } else if (error) {
      this.error = error;

    }
  }
  @wire(getPicklistValues, { recordTypeId: "$attendeeRecordTypeId", fieldApiName: SESSION_FIELD })
  getSessionValues({ error, data }) {
    if (data) {
      this.sessionIntrestPickList = data.values;

      this.error = undefined;
    } else if (error) {
      this.error = error;

    }
  }
  resetForm() {
    // this.selectedEventId = ''; // Reset eventId
    // this.ticketsWithQuantity = []; // Reset ticketsList
    this.firstName = ''; // Reset firstName
    this.lastName = ''; // Reset lastName
    this.email = ''; // Reset email
    this.taxReceipt = false; // Reset taxReceipt
    this.attendeeAddress = ''; // Reset address
    this.attendeeCountry = ''; // Reset country
    this.townCity = ''; // Reset townCity
    this.postalCode = ''; // Reset postalCode
    this.phoneNumber = ''; // Reset phone
    this.sessionInterest = ''; // Reset sessionInterest
    this.companyName = ''; // Reset companyName
    this.foodPreference = ''; // Reset foodPreference
    this.tShirtSize = ''; // Reset tShirtSize
    this.designation = ''; // Reset designation
    this.companySize = ''; // Reset companySize
    this.message = ''; // Reset message
    this.agreement = false; // Reset agreement
    this.trailblazerId = ''; // Reset trailblazerId
    this.linkedinId = ''; // Reset linkedinId
  }


  connectedCallback() {
    this.loadTickets();
    this.subscribeToScrollMsg();
  }
}