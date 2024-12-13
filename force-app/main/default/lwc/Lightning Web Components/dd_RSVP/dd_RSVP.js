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
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import fetchCouponId from '@salesforce/apex/DubaiRSVPController.fetchCouponId';

export default class Dd_RSVP extends LightningElement {

    // ----event id ---
    selectedEventId;
    paymentPageLink;


    // -----pages links----
    speakersLink = '/s/speakers';
    thankYouLink = window.location.href + 'thank-you-attendee';


    // --- flags---
    isLoading = false;
    showTickets = false;
    showOrderSummary = false;
    isTicketActive = true;
    showAgreementCheckbox = false
    showWarning = false;
    noteMessage = false
    showInActivePromoMessage = false;
    showInValidPromoMessage = false;
    showAppliedPromoMessage = false;
    disableApplyAction = false;
    isPrimaryForm = false;
    isAdditionalForm = false;
    showNextButton = true;
    showPlaceOrderButton = false;
    showPreviousButton = false;



    // ---counter variable-----
    currentIndex = 0;
    additionalAttendeeId = 0;
    quantity = 0;


    // ----ticket info---.
    ticketId;
    tickets;
    selectedTicket;
    totalTicketPrice;

    // ----- Lists/arrays/collections ----
    additionalAttendees = [];
    currentAdditionalAttendees = [];



    // ----attendee info----
    primaryFirstName = '';
    primaryLastName = '';
    primaryEmail = '';
    trailblazerId = '';
    linkedinId = '';
    phoneNumber = '';
    sessionInterest;
    companyName = '';
    foodPreference;
    tShirtSize;
    designation = '';
    companySize;
    country


    // -----promo details----
    couponId;
    promoActivationDate;
    promoExpiryDate;
    promoCode = ''


    // ------Picklist values-----
    attendeeRecordTypeId;
    countryPickList;
    cityPickList;
    sessionPickList;
    foodPreferencePickList;
    tShirtSizePickList;
    companySizePickList;



    @wire(MessageContext)
    messageContext
    /**
     * Subscribes to the scroll message channel to handle section navigation.
     */
    subscribeToScrollMsg() {

        let scrollSubs = subscribe(this.messageContext, SCROLL_MESSAGE, (sectionMessage) => {

            console.log('sectionMessage', sectionMessage);
            this.handleMessage(sectionMessage)
        })

    }

    /**
     * Handles the received section message and scrolls to the respective section.
     * @param {Object} sectionMessage - The message containing the section to scroll to.
     */
    handleMessage(sectionMessage) {
        let section = sectionMessage.section;

        if (section == 'goto_register') {
            this.template.querySelector('.goto_register').scrollIntoView({ behavior: 'smooth' });
        }
    }

    /**
        * Loads the Dubai Dreamin event by calling the Apex method `getDubaiDreaminEventId`.
        */
    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) {
        if (data) {

            this.selectedEventId = data;
        } else if (error) {
            console.error('getDubaiDreaminEventId Error:', error);
        }
    }

    /**
     * Loads the ticket data by calling the Apex method `retrievePrice`.
     */
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

    /**
     * Displays a warning toast message for ticket selection.
     */
    handleTicketSelection() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Only Early Bird Ticket Available!',
                message: 'Please note that only the Early Bird ticket is available for selection. ',
                variant: 'warning'
            })
        );
    }

    /**
     * Handles the change in ticket quantity.
     * @param {Event} event - The event object containing the ticket quantity.
     */
    handleQuantityChange(event) {
        this.noteMessage = true

        const ticketId = event.target.dataset.ticketid;
        const enteredQuantity = parseInt(event.target.value);

        if (isNaN(enteredQuantity) || enteredQuantity < 1 || enteredQuantity > 99) {

            event.target.value = '';
            this.showWarning = true;
            return;
        }
        else {
            this.showWarning = false; // 

        }

        this.quantity = enteredQuantity;

        this.ticketsWithSummary = [];


        const selectedTicket = this.tickets.find(ticket => ticket.id === ticketId);

        let maxQuantity = Math.min(Math.max(this.quantity, 1), 99); // Limit quantity between 1 and 99

        let vatTax = 0.05;
        let subTotalPrice = maxQuantity * selectedTicket.unitAmount;
        let discountAmount = parseInt(selectedTicket.unitAmount) * 0.1;

        let totalPrice = subTotalPrice;
        if (selectedTicket && this.quantity !== 0) {
            const ticketInfo = {
                id: ticketId,
                quantity: maxQuantity,
                ticketTitle: selectedTicket.nickname,
                ticketPrice: selectedTicket.unitAmount,
                vatTax: '',
                totalPrice: totalPrice,
                subTotalPrice: subTotalPrice
            };


            this.ticketsWithSummary.push(ticketInfo);
            console.log('discountAmount: ', discountAmount);
        }
        this.showOrderSummary = true;


    }

    /**
     * Handles the checkout process by displaying the attendee form.
     */
    handleCheckout() {
        this.updateButtonState(this.quantity);
    
        if (this.quantity > 0) {
            let attendeeForm = this.template.querySelector('.attendee-form');
            let ticketForm = this.template.querySelector('.ticket_table_flShow');
            ticketForm.style.display = 'none'
            attendeeForm.style.display = 'block'
    
            this.isPrimaryForm = true;
            this.isAdditionalForm = false;
            this.currentIndex = 1; // Start with the primary attendee
            this.showPreviousButton = false;
    
            // Update the button state specifically for checkout
            if (this.quantity === 1 && this.isPrimaryForm) {
                this.showNextButton = false;
                this.showPlaceOrderButton = true;
            }
        }
    }
    
    // handleCheckout() {
    //     this.updateButtonState(this.quantity);
    //     // if(this.quantity ==1){
    //     //     this.showNextButton = false;
    //     //     this.showPlaceOrderButton = true;
    //     // }
    //     if (this.quantity > 0) {
    //         let attendeeForm = this.template.querySelector('.attendee-form');
    //         let ticketForm = this.template.querySelector('.ticket_table_flShow');
    //         ticketForm.style.display = 'none'
    //         attendeeForm.style.display = 'block'

    //         this.isPrimaryForm = true;
    //         this.isAdditionalForm = false;
    //         this.currentIndex = 1; // Start with the primary attendee
    //         this.showPreviousButton = false;
    //     }
    // }

    /**
     * Reverses the toggle between the ticket form and the attendee form.
     */
    reverseToggle() {
        let attendeeForm = this.template.querySelector('.attendee-form');
        let ticketForm = this.template.querySelector('.ticket_table_flShow');

        ticketForm.style.display = 'block'
        attendeeForm.style.display = 'none'


    }
    /**
    * Handles the change in primary attendee information.
    * @param {Event} event - The event object containing the primary attendee information.
    */
    handlePrimaryChange(event) {
        const field = event.target.dataset.id;
        const value = event.target.value;
        console.log('field: ',field);
        console.log('value: ',value);
        switch (field) {
            case 'firstName':
                this.primaryFirstName = value;
                break;
            case 'lastName':
                this.primaryLastName = value;
                break;
            case 'email':
                this.primaryEmail = value;
                break;
            case 'trailblazerId':
                this.trailblazerId = value;
                break;
            case 'linkedinId':
                this.linkedinId = value;
                break;
            case 'country':
                this.country = value;
                break;
            case 'phoneNumber':
                this.phoneNumber = value;
                break;
            case 'sessionInterest':
                this.sessionInterest = value;
                break;
            case 'foodPreference':
                this.foodPreference = value;
                break;
            case 'tShirtSize':
                this.tShirtSize = value;
                break;
            case 'companyName':
                this.companyName = value;
                break;
            case 'companySize':
                this.companySize = value;
                break;
            case 'message':
                this.message = value;
                break;
            case 'agreement':
                this.agreement = event.target.checked;
                break;
            default:
                break;
        }

        this.updatePrimaryAttendeeInList();
    }
    /**
    * Updates the primary attendee information in the list.
    */
    updatePrimaryAttendeeInList() {
        const primaryAttendee = this.additionalAttendees.find(attendee => attendee.primary);
        if (primaryAttendee) {

            primaryAttendee.firstName = this.primaryFirstName;
            primaryAttendee.lastName = this.primaryLastName;
            primaryAttendee.email = this.primaryEmail;
            primaryAttendee.trailblazerId = this.trailblazerId;
            primaryAttendee.linkedinId = this.linkedinId;
            primaryAttendee.country = this.country;
            primaryAttendee.phone = this.phoneNumber;
            primaryAttendee.sessionInterest = this.sessionInterest;
            primaryAttendee.foodPreference = this.foodPreference;
            primaryAttendee.tShirtSize = this.tShirtSize;
            primaryAttendee.designation = this.companyName;
            primaryAttendee.companySize = this.companySize;
            primaryAttendee.message = this.message;
            primaryAttendee.agreement = this.agreement;
        } else {
            this.additionalAttendees.push({
                id: ++this.additionalAttendeeId,
                firstName: this.primaryFirstName,
                lastName: this.primaryLastName,
                email: this.primaryEmail,
                trailblazerId: this.trailblazerId,
                linkedinId: this.linkedinId,
                country: this.country,
                phoneNumber: this.phoneNumber,
                sessionInterest: this.sessionInterest,
                foodPreference: this.foodPreference,
                tShirtSize: this.tShirtSize,
                companyName: this.companyName,
                companySize: this.companySize,
                message: this.message,
                agreement: this.agreement,
                primary: true,
                eventId: this.selectedEventId,

            });
        }
    }
/**
 * Validates all required fields for the current form.
 * @returns {boolean} - Returns true if all required fields are valid, otherwise false.
 */
validateFields() {
    let isValid = true;

    // Validate primary attendee form fields if it's the primary form
    if (this.isPrimaryForm) {
        const primaryFormFields = this.template.querySelectorAll('.primary-attendee input[required], .primary-attendee select[required], .primary-attendee textarea[required]');
        console.log('primaryFormFields: ', primaryFormFields);
        
        primaryFormFields.forEach(field => {
        console.log('feild: ', field);
        console.log('Id: ', field.dataset.id);

            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('slds-has-error');
                const errorElement = field.parentElement.querySelector('.error-msg');
                if (errorElement) {
                    // errorElement.textContent = `${field.name} is required.`;
                    errorElement.textContent = ` required.`;
                    errorElement.style.display = 'block';
                }
            } else {
                field.classList.remove('slds-has-error');
                const errorElement = field.parentElement.querySelector('.error-msg');
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
            }
        });
    }

    // Validate additional attendees form fields if it's the additional form
    if (this.isAdditionalForm) {
        const additionalFormFields = this.template.querySelectorAll('.additional-attendee input[required], .additional-attendee select[required], .additional-attendee textarea[required]');
        additionalFormFields.forEach(field => {
            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('slds-has-error');
                const errorElement = field.parentElement.querySelector('.error-msg');
                if (errorElement) {
                    errorElement.textContent = ` required.`;
                    // errorElement.textContent = `${field.name} is required.`;
                    errorElement.style.display = 'block';
                }
            } else {
                field.classList.remove('slds-has-error');
                const errorElement = field.parentElement.querySelector('.error-msg');
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
            }
        });
    }

    return isValid;
}

    /**
     * Handles the 'Next' button click event to navigate through the attendee forms.
     * It manages the transition from primary attendee form to additional attendees form
     * and processes the information accordingly.
     */
    handleNext() {
        if (!this.validateFields()) {
            return;
        }
        if (this.isPrimaryForm) {
            this.updatePrimaryAttendeeInList();
            this.isPrimaryForm = false;
            this.isAdditionalForm = true;
            this.currentIndex = 2;
            this.showPreviousButton = true;
            this.addNextAdditionalAttendees();
        } else if (this.isAdditionalForm) {
            this.saveCurrentAdditionalAttendees();
            if (this.currentIndex <= this.quantity) {
                this.addNextAdditionalAttendees();
            } else {
                this.updateButtonState();
            }
        }

    }


    /**
     * Handles the 'Previous' button click event to navigate through the attendee forms.
     * It manages the transition back from additional attendees form to primary attendee form
     * and processes the information accordingly.
     */
    handlePrevious() {
        if (this.currentIndex > 1) {
            this.saveCurrentAdditionalAttendees();
            this.currentIndex -= this.currentAdditionalAttendees.length;
            if (this.currentIndex <= 2) {
                // if (this.currentIndex <= 1) {
                this.currentIndex = 1;
                this.isPrimaryForm = true;
                this.isAdditionalForm = false;
                this.showPreviousButton = false;
            } else {
                this.showPreviousButton = true;
                this.isPrimaryForm = false;
                this.isAdditionalForm = true;
                this.loadPreviousAdditionalAttendees();
            }
            this.updateButtonState();
        }
    }

    /**
     * Adds the next set of additional attendees to the current form view.
     * This method is called when navigating to the next attendees in the form.
     */
    addNextAdditionalAttendees() {
        this.currentAdditionalAttendees = [];
        const remainingQuantity = this.quantity - 1;
        console.log('additionalAttendeeId: ', this.additionalAttendeeId);

        for (let i = 0; i < 3 && this.currentIndex <= this.quantity; i++) {
            const existingAttendee = this.additionalAttendees[this.currentIndex - 1];
            this.currentAdditionalAttendees.push(existingAttendee ? existingAttendee : {
                id: ++this.additionalAttendeeId,
                firstName: '',
                lastName: '',
                email: '',
                eventId: this.selectedEventId,
                primary: false
            });
            this.currentIndex++;
        }
        this.updateButtonState(remainingQuantity);
    }

    /**
     * Loads the previous set of additional attendees to the current form view.
     * This method is called when navigating back to the previous attendees in the form.
     */
    loadPreviousAdditionalAttendees() {
        this.currentAdditionalAttendees = [];
        const startIndex = this.currentIndex - 3;
        for (let i = startIndex; i < this.currentIndex; i++) {
            const attendee = this.additionalAttendees.find(att => att.id == i);

            this.currentAdditionalAttendees.push(attendee);
        }
        this.currentIndex = startIndex + this.currentAdditionalAttendees.length;

       

    }
    /**
     * Updates the state of the navigation buttons (Next, Previous, Place Order).
     * @param {number} remainingQuantity - The number of remaining attendees to be added.
     */
    updateButtonState(remainingQuantity) {
        const isPrimaryAttendee = this.currentIndex === 1; // Assuming primary attendee is at index 1
    
        if (remainingQuantity < 3 && isPrimaryAttendee) {
            this.showNextButton = false;
            this.showPlaceOrderButton = true;
        } else if (remainingQuantity >= 3 && isPrimaryAttendee) {
            this.showNextButton = true;
            this.showPlaceOrderButton = false;
        } else if (this.currentIndex > this.quantity) {
            this.showNextButton = false;
            this.showPlaceOrderButton = true;
        } else {
            this.showNextButton = true;
            this.showPlaceOrderButton = false;
        }
    }
    
    
    
    // updateButtonState(remainingQuantity) {

    //     // if (remainingQuantity <= 3 || this.currentIndex > this.quantity) {
    //         if (remainingQuantity == 1 ||remainingQuantity==2 || this.currentIndex > this.quantity) {
    //         this.showNextButton = false;
    //         this.showPlaceOrderButton = true;
    //     } else {
    //         this.showNextButton = true;
    //         this.showPlaceOrderButton = false;
    //     }
    // }
    /**
     * Saves the current additional attendees' information to the main list.
     * This method is called before navigating between attendee forms to ensure data persistence.
     */
    saveCurrentAdditionalAttendees() {
        console.log('saveCurrentAdditionalAttendees: ', JSON.stringify(this.additionalAttendees));

        this.currentAdditionalAttendees.forEach(attendee => {
            const existingAttendeeIndex = this.additionalAttendees.findIndex(a => a.id === attendee.id);
            if (existingAttendeeIndex !== -1) {
                this.additionalAttendees[existingAttendeeIndex] = attendee;
            } else {
                this.additionalAttendees.push(attendee);
            }
        });
    }

    /**
     * Handles the change event for additional attendee input fields.
     * It updates the respective attendee information in the current form view.
     * @param {Event} event - The event object containing the updated attendee information.
     */
    handleAdditionalChange(event) {
        const index = event.target.dataset.index;
        const field = event.target.dataset.id;
        console.log('field:', field);

        this.currentAdditionalAttendees = this.currentAdditionalAttendees.map(attendee => {
            if (attendee.id === parseInt(index, 10)) {
                return {
                    ...attendee,
                    [field]: event.target.value
                };
            }
            return attendee;
        });
    }



    // ----------apply promo code------------
    
    /**
     * Handles the change event for the promo code input field.
     * @param {Event} event - The event object containing the updated promo code value.
     */
    handlePromoCodeChange(event) {
        this.promoCode = event.target.value;
    }

    /**
     * Applies the entered promo code by validating it and updating ticket prices if valid.
     * Displays appropriate messages based on the promo code status.
     */
    handleApplyPromo() {

        this.showInActivePromoMessage = false;
        this.showInValidPromoMessage = false;
        this.showAppliedPromoMessage = false;
        this.disableApplyAction = true;

        fetchCouponId({
            promoCode: this.promoCode
        })
            .then(result => {
                if (result) {
                    if (result.isActive) {
                        this.showAppliedPromoMessage = true

                        this.couponId = result.couponId;


                        this.ticketsWithSummary.forEach(ticket => {
                            //  let discountAmount = ticket.ticketPrice * 0.1;
                            let discountAmount = parseInt(ticket.ticketPrice) * (Number(result.discountPercentage) / 100);

                            let totalDiscountAmount = discountAmount * ticket.quantity;

                            ticket.discountAmount = parseFloat(totalDiscountAmount.toFixed(3));
                            ticket.totalDiscountedPrice = parseFloat(((ticket.ticketPrice - discountAmount) * ticket.quantity).toFixed(3));
                        });
                        this.ticketsWithSummary = [...this.ticketsWithSummary];


                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: result.promoCode + ' applied',
                                message: 'Promo code successfully  applied! ',
                                variant: 'info'
                            })
                        );
                    }

                    else {
                        this.showInActivePromoMessage = true
                        this.showInValidPromoMessage = false
                        this.showAppliedPromoMessage = false
                    }

                }
                this.disableApplyAction = false;
            })
            .catch(error => {

                this.showInValidPromoMessage = true
                this.showInActivePromoMessage = false
                this.showAppliedPromoMessage = false
                this.disableApplyAction = false;

            });

    }

    /**
     * Handles the 'Pay Now' button click event to process the payment.
     * Saves the current attendees, registers them, and redirects to the payment page.
     */
    handlePayNow() {
        if (!this.validateFields()) {
            return;
        }
        this.isLoading = true
        this.saveCurrentAdditionalAttendees();

        const allAttendees = [...this.additionalAttendees];
        console.log('All Attendees:', JSON.stringify(allAttendees));

        let q;
        let i;

        this.ticketsWithSummary.forEach(ticket => {
            q = ticket.quantity;
            i = ticket.id;

        });



        registerAttendee({ attendeesInfo: JSON.stringify(allAttendees) })
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
                createPaymentPage({ attendeeId: this.attendeeId, quantity: q, priceId: i, redirectUrl: this.thankYouLink, couponId: this.couponId })
                    .then((paymentId => {

                        this.paymentPageLink = paymentId;
                        window.location.href = this.paymentPageLink;

                        console.log('paymentId : ', paymentId);
                    }))
                    .catch((err) => {

                    })

            })
        this.resetForm();
    }





    // ------ fetch picklist values for attendee form-----

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
        // this.ticketsWithSummary = []; // Reset ticketsList
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