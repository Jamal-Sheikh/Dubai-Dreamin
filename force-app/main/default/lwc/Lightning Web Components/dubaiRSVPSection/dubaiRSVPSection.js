import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
import retrievePrice from '@salesforce/apex/PaymentController.retrievePrice';
import registerAttendee from '@salesforce/apex/DubaiRSVPController.registerAttendee';
import createPaymentPage from '@salesforce/apex/DubaiRSVPController.createPaymentPage';
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import ATTENDEE_OBJECT from "@salesforce/schema/Attendee__c";
import COUNTRY_FIELD from "@salesforce/schema/Attendee__c.Country__c";
import CITY_FIELD from "@salesforce/schema/Attendee__c.City__c";
import COMPANYSIZE_FIELD from "@salesforce/schema/Attendee__c.Company_Size__c";
import FOOD_FIELD from "@salesforce/schema/Attendee__c.Food_Preference__c";
import TSHIRT_FIELD from "@salesforce/schema/Attendee__c.Tshirt_Size__c";
import SESSION_FIELD from "@salesforce/schema/Attendee__c.Session_Interest__c";
import fetchCouponId from '@salesforce/apex/DubaiRSVPController.getPromoOrVoucherCodeDetails';
import SCROLL_MESSAGE from '@salesforce/messageChannel/ScrollMessageChannel__c';
import EVENT_ID_LMS from '@salesforce/messageChannel/EventIDMessageChannel__c';
import { publish, subscribe, MessageContext } from 'lightning/messageService';

export default class DubaiRSVPSection extends LightningElement {
  speakersLink = '/s/speakers';
  thankYouLink = window.location.href + 'thank-you-attendee';

  selectedEventId;
  quantity = 1;
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
  showWarning = false;
  noteMessage = false
  showInActivePromoMessage = false;
  showInValidPromoMessage = false;
  showAppliedPromoMessage=false;
  disableApplyAction = false;
  isLoading= false
  showUsedVoucherErrorMessage=false

  // ----attendee info----
  attendeeId
  firstName = '';
  lastName = '';
  email = '';
  taxReceipt = '';
  attendeeAddress = '';
  attendeeCountry = 'United Arab Emirates';
  registrationType = '';
  townCity = '';
  postalCode = '';
  phoneNumber = '';
  selectedCountryCode = '';


  sessionInterest = 'Sales Cloud';
  companyName = '';
  foodPreference = 'Non-Veg';
  tShirtSize = 'Medium';
  designation = '';
  companySize = '1 - 50';
  paymentPageLink;
  trailblazerId = '';
  linkedinId = '';
  message;
  agreement;


  attendeeRecordTypeId;
  countryPickList;
  cityPickList;
  sessionPickList;
  foodPreferencePickList;
  tShirtSizePickList;
  companySizePickList;


  // ------promo/voucher/coupon details----------
  promoCode = '';
  couponId;
  couponDiscount;
  speakerAttendeeId;
  promoActivationDate;
  promoExpiryDate;
  usedVoucherErrorMessage=''




  countryCodes = [
    { code: '+1', name: 'USA' },
    { code: '+44', name: 'UK' },
    // Add more country codes as needed
  ];

  handleCountryCodeChange(event) {
    this.selectedCountryCode = event.target.value;
  }

  handlePhoneNumberChange(event) {
    this.phoneNumber = event.target.value;
  }

  @wire(MessageContext)
  messageContext

  subscribeToScrollMsg() {

    let scrollSubs = subscribe(this.messageContext, SCROLL_MESSAGE, (sectionMessage) => {
      this.handleMessage(sectionMessage)
    })
  }

  handleMessage(sectionMessage) {
    let section = sectionMessage.section;
    if (section == 'goto_register') {
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
    retrievePrice()
      .then(result => {
        this.tickets = result;

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
      case 'COUNTRY':
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
        this.agreement = event.target.checked;
         break;
      default:
        break;
    }
  }



  ticketInfo;
  handleQuantityChange(ticketId) {
    this.noteMessage = true
    debugger;
    // const ticketId = ticketId;
    const enteredQuantity = 1;

    // if (isNaN(enteredQuantity) || enteredQuantity < 1 || enteredQuantity > 99) {
    //   // If the entered value is not a number or it's less than 1 or greater than 99
    //   event.target.value = ''; // Reset input field
    //   this.showWarning = true; // 
    //   return; // Exit the method
    // }
    // else{
    //   this.showWarning = false; // 

    // }
    this.quantity = enteredQuantity;

    this.ticketsWithQuantity = [];


    const selectedTicket = this.tickets.find(ticket => ticket.id === ticketId);
    // let maxQuantity =Math.max(this.quantity, 1);
    let maxQuantity = Math.min(Math.max(this.quantity, 1), 99); // Limit quantity between 1 and 99

    let vatTax = 0.05;
    let subTotalPrice = maxQuantity * selectedTicket.unitAmount;
    let discountAmount = parseInt(selectedTicket.unitAmount) * 0.1;
    // Calculate VAT amount
    // let vatAmount = subTotalPrice * vatTax;

    // Calculate total price including VAT
    let totalPrice = subTotalPrice;
    if (selectedTicket && this.quantity !== 0) {
      this.ticketInfo = {
        id: ticketId,
        quantity: maxQuantity,
        ticketTitle: selectedTicket.nickname,
        ticketPrice: selectedTicket.unitAmount,
        vatTax: '',
        totalPrice: totalPrice,
        subTotalPrice: subTotalPrice
      };


      this.ticketsWithQuantity.push(this.ticketInfo);
      // console.log('this.ticketsWithQuantity:', this.ticketsWithQuantity);
      console.log('discountAmount: ', discountAmount);
    }
    this.showOrderSummary = true;


  }




  toggleCheckOut(event) {
    this.handleQuantityChange(event.currentTarget.dataset.ticketid);
    if (Object.keys(this.ticketsWithQuantity).length > 0) {
      let attendeeForm = this.template.querySelector('.attendee-form');
      let ticketForm = this.template.querySelector('.ticket_table_flShow');

      ticketForm.style.display = 'none'
      attendeeForm.style.display = 'block'
    }
    else {
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

    if (ticketForm.style.display = 'block') {
      this.showOrderSummary = false
    }

    this.resetForm();
  }


  handleValidation() {


    const inputFields = this.template.querySelectorAll('input[required], select[required], textarea[required]');
    const checkboxField = this.template.querySelector('input[type="checkbox"][required]');
    const emailField = this.template.querySelector('input[type="email"]');
    emailField.reportValidity();
    let isValid = true;
    // this.handleEmailValidation();

    inputFields.forEach(field => {
      if (!field.value.trim()) {
        isValid = false;
        const fieldName = field.getAttribute('data-fieldname');

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

    return isValid;
  }

  // ---------promo apply -----

  // ----------apply promo code------------
  handlePromoCodeChange(event) {
    this.promoCode = event.target.value;
  }

 
  
  handleApplyPromo() {

    this.showInActivePromoMessage = false;
    this.showInValidPromoMessage = false;
    this.showAppliedPromoMessage = false;
    this.disableApplyAction = true;

   
    fetchCouponId({ code: this.promoCode })
      .then(result => {
        if (result) {

          if (result.isActive) {
          
            if(result.errorMessage){
                this.usedVoucherErrorMessage = result.errorMessage;
               this.showUsedVoucherErrorMessage =true

            }
            else{
                this.usedVoucherErrorMessage =''
                this.showAppliedPromoMessage = true
                console.log('result: ',JSON.stringify(result));
                
                this.couponId = result.couponId;
                this.couponDiscount = result.discountPercentage;
                
                
                this.promoActivationDate = result.activationDate
                this.promoExpiryDate = result.expiryDate
    
                this.ticketsWithQuantity.forEach(ticket => {
                  let discountAmount = parseInt(ticket.ticketPrice) * (Number(result.discountPercentage) / 100);
                  let totalDiscountAmount = discountAmount * ticket.quantity;
    
              
                  ticket.discountAmount = parseFloat(totalDiscountAmount.toFixed(3));
                  ticket.totalDiscountedPrice = parseFloat(((ticket.ticketPrice - discountAmount) * ticket.quantity).toFixed(3));
                });
                this.ticketsWithQuantity = [...this.ticketsWithQuantity];
            }
        //   this.showAppliedPromoMessage = true
        //     console.log('result: ',JSON.stringify(result));
            
        //     this.couponId = result.couponId;
        //     this.couponDiscount = result.discountPercentage;
            
            
        //     this.promoActivationDate = result.activationDate
        //     this.promoExpiryDate = result.expiryDate

        //     this.ticketsWithQuantity.forEach(ticket => {
        //       let discountAmount = parseInt(ticket.ticketPrice) * (Number(result.discountPercentage) / 100);
        //       let totalDiscountAmount = discountAmount * ticket.quantity;

          
        //       ticket.discountAmount = parseFloat(totalDiscountAmount.toFixed(3));
        //       ticket.totalDiscountedPrice = parseFloat(((ticket.ticketPrice - discountAmount) * ticket.quantity).toFixed(3));
        //     });
        //     this.ticketsWithQuantity = [...this.ticketsWithQuantity];

          }

          else {

            this.showInActivePromoMessage = false
            this.showInValidPromoMessage = true
            this.showAppliedPromoMessage = false
            this.showUsedVoucherErrorMessage =false

          }

        }
        this.disableApplyAction = false;

      })
      .catch(error => {

        this.showInValidPromoMessage = false
        this.showInActivePromoMessage = true
        this.showAppliedPromoMessage = false
        this.disableApplyAction = false;
        this.showUsedVoucherErrorMessage =false



        // window.alert('Promo code is not matched or invalid');

      });

  }





  handlePayNow() {

    let isValid = this.handleValidation();
    // If any required field is empty, stop further processing
    if (!isValid) {
      return;
    }
    if(this.agreement== true){
     this.isLoading = true
     let attendeeListObj = {
      eventId: this.selectedEventId,
      code:this.promoCode ,
      speakerAttendeeId:this.speakerAttendeeId,
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
    }
    let q;
    let i;

    this.ticketsWithQuantity.forEach(ticket => {
      q = ticket.quantity;
      i = ticket.id;

    });
    // i = 'price_1P6tv1BG9mkkVMIkCiIAz00Y'

    registerAttendee({ attendeeInfo: JSON.stringify(attendeeListObj) })
      .then((attendeeObj) => {
        this.attendeeId = attendeeObj.Id


        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Success',
            message: 'Successfully registered for event! ',
            variant: 'success'
          })
        );
        createPaymentPage({ attendeeId: this.attendeeId, quantity: q, priceId: i, redirectUrl: this.thankYouLink, couponId: this.couponId })
          .then((paymentId => {

            this.paymentPageLink = paymentId;
            window.location.href = this.paymentPageLink;
          }))
          .catch((err) => {

          })

      })

    }
    else{
        this.template.querySelector('.error-msg').style.display = 'block';

    }

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
    // Reset all form field values to their initial state
    this.attendeeId = '';
    this.firstName = '';
    this.lastName = '';
    this.email = '';
    this.taxReceipt = '';
    this.attendeeAddress = '';
    this.attendeeCountry = 'United Arab Emirates';
    this.registrationType = '';
    this.townCity = '';
    this.postalCode = '';
    this.phoneNumber = '';
    this.sessionInterest = 'Sales Cloud';
    this.companyName = '';
    this.foodPreference = 'Non-Veg';
    this.tShirtSize = 'Medium';
    this.designation = '';
    this.companySize = '1 - 50';
    this.paymentPageLink = '';
    this.trailblazerId = '';
    this.linkedinId = '';
    this.message = '';
    this.agreement = false;
  }

  connectedCallback() {
    this.loadTickets();
    this.subscribeToScrollMsg();
  }
}