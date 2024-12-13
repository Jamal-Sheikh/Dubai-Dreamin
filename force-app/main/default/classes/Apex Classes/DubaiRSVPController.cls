/**
* @author: Aneela Oad
* @description: Manages the logic and functionality related to attendee registration.
* @since: 22/02/24
* @Last Modified by: Aneela Oad
*/
public without sharing class DubaiRSVPController {
    

 private static final string END_POINT = 'callout:Stripe_Named_Credential/checkout/sessions';

    /**
    * @author: Aneela Oad
    * @description: Handles registration of attendee along with his/her payment
    * @param  String attendeeInfo
    * @return: void
    */
    @AuraEnabled
    public static Attendee__c registerAttendee(String attendeeInfo) {
     System.debug('attendeeInfo ---> '+ attendeeInfo);
 
     DenormalizedAttendee denormalizedAttendeeInfo = (DenormalizedAttendee) JSON.deserialize(attendeeInfo, DenormalizedAttendee.class);
     System.debug('denormalizedAttendeeInfo ---> '+ denormalizedAttendeeInfo);

   

    // System.debug('ticketsList ---> '+ ticketsList);
 
  
     // if (attendeeExistsForEvent(denormalizedAttendeeInfo.email, denormalizedAttendeeInfo.eventId)) {
     //  throw new CustomException('An attendee with the same email already exists.');
 
     // }
     
         List<Contact> existingContacts = ContactSelector.getContactsByEmail(denormalizedAttendeeInfo.email);
     Contact existingContact;
     Id contactId;
 
     if (existingContacts.size() == 0) {
         Contact contact = new Contact();
         contact.FirstName = denormalizedAttendeeInfo.firstName;
         contact.LastName = denormalizedAttendeeInfo.lastName;
         contact.Email = denormalizedAttendeeInfo.email; // Corrected the field name to "Email"
         // if (Schema.sObjectType.Contact.isCreateable()) {
             insert contact;
        // }
         contactId = contact.Id;  
     } else {
         existingContact = existingContacts.get(0);
         contactId = existingContact.Id;
     }
      Attendee__c attendee = new Attendee__c(
         Event__c = denormalizedAttendeeInfo.eventId,
         Attendee__c = contactId,
         // Company_Name__c	= denormalizedAttendeeInfo.companyName,
         Company_Size__c= denormalizedAttendeeInfo.companySize,
         Food_Preference__c= denormalizedAttendeeInfo.foodPreference,
         Message__c= denormalizedAttendeeInfo.message,
         Phone__c= denormalizedAttendeeInfo.phone,
         Session_Interest__c= denormalizedAttendeeInfo.sessionInterest,
         Tshirt_Size__c= denormalizedAttendeeInfo.tShirtSize,
         Company_Name__c= denormalizedAttendeeInfo.designation,
         Trailblazer_Id__c = denormalizedAttendeeInfo.trailblazerId,
         Linkedin_Id__c = denormalizedAttendeeInfo.linkedinId,
         Email__c = denormalizedAttendeeInfo.email,
         Country__c = denormalizedAttendeeInfo.country,
                  Promo_Voucher__c = denormalizedAttendeeInfo.code

         // Agreed_to_Terms_Conditions__c = denormalizedAttendeeInfo.agreement
      
     );
     
   
     if (Schema.sObjectType.Attendee__c.isCreateable()) {
         insert attendee;
         
     } 

     // Check if speakerAttendeeId exists and link the speaker to the attendee
        if (denormalizedAttendeeInfo.speakerAttendeeId != null) {
            // List<Speaker__c> speakers = [SELECT Id FROM Speaker__c WHERE Id = :denormalizedAttendeeInfo.speakerAttendeeId LIMIT 1];
            Speaker__c speaker = [SELECT Id FROM Speaker__c WHERE Id = :denormalizedAttendeeInfo.speakerAttendeeId LIMIT 1];
            system.debug('speaker attendee: '+speaker);

               // Check if the voucher has already been used
                if (speaker.is_Attendee__c) {
                    throw new AuraHandledException('Voucher code has already been used.');
                }

            if (speaker !=null) {
                speaker.attendee__c = attendee.Id;
            }
            update speaker;
        }
       
     return attendee;
 
     
 }


public static Boolean attendeeExistsForEvent( String email, Id eventId) {
    Integer count = [SELECT COUNT() FROM Attendee__c WHERE Attendee__r.Email = :email AND Event__c = :eventId];
    return count > 0;
}

@AuraEnabled
  public static string createPaymentPage(String attendeeId, Integer quantity, String priceId, String redirectUrl, String couponId){
    String paymentLinkId;
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();

    req.setEndPoint(END_POINT);
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    String body = '&line_items[0][quantity]='+quantity + '&line_items[0][price]='+priceId+'&success_url='+redirectUrl+'&client_reference_id='+attendeeId+'&mode=payment';
    if (couponId != null) {
        body += '&discounts[0][coupon]=' + couponId;
    }
    // req.setHeader('Authorization', 'Bearer ' + API_KEY);
    req.setBody(body);

     res =  http.send(req);
     System.debug('res.getBody(): ' +res.getBody());

      if (res.getStatusCode() == 200) {
              paymentLinkId =   getPaymentLinkId(res.getBody());
             System.debug('paymentLinkId: ' +paymentLinkId);
      }
 
        return paymentLinkId;
      
  }


 private static String getPaymentLinkId(String responseBody) {
     
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        String pageURL =  (String)responseMap.get('url');
        return pageURL;
    }


    @AuraEnabled(cacheable=true)
    public static DenormalizedPromotionCode fetchCouponId(String promoCode) {
        // Query the DD_Promotion_Code custom metadata object
        List<DD_Promotion_Codes__mdt> promoCodes = [SELECT Id, Coupon_Id__c, Promo_Code__c, Off__c, Activation_Date__c, Expiry_Date__c FROM DD_Promotion_Codes__mdt WHERE Promo_Code__c = :promoCode LIMIT 1];
         Date currentDate = Date.TODAY();
       
        if (!promoCodes.isEmpty()) {
            // return promoCodes[0];
            DD_Promotion_Codes__mdt promoCodeRecord = promoCodes[0];
            DenormalizedPromotionCode denormalizedRecord = new DenormalizedPromotionCode();

            // Instantiate the DenormalizedPromotionCode class and assign the attributes
    
            denormalizedRecord.couponId = promoCodeRecord.Coupon_Id__c;
            denormalizedRecord.promoCode = promoCodeRecord.Promo_Code__c;
            denormalizedRecord.activationDate = promoCodeRecord.Activation_Date__c;
            denormalizedRecord.expiryDate = promoCodeRecord.Expiry_Date__c;
            denormalizedRecord.discountPercentage = Integer.valueOf(promoCodeRecord.Off__c);
            denormalizedRecord.isActive = promoCodeRecord.Activation_Date__c <= currentDate && promoCodeRecord.Expiry_Date__c >= currentDate;

            System.debug(denormalizedRecord);
            System.debug(promoCodeRecord.Activation_Date__c == currentDate && promoCodeRecord.Expiry_Date__c > currentDate);
            return denormalizedRecord;    
        } else {
            // Throw an exception if promo code doesn't match any records
            throw new AuraHandledException('Promo code not found or invalid');
        }

        
    }
    @AuraEnabled(cacheable=true)
    public static DenormalizedPromotionCode getPromoOrVoucherCodeDetails(String code) {
        DenormalizedPromotionCode denormalizedRecord = new DenormalizedPromotionCode();
        Date currentDate = Date.today();
        
        try {

            System.debug('PROMO: ' + code);
            // to find the promo code directly in the metadata
            List<DD_Promotion_Codes__mdt> promoCodes = [SELECT Id, Coupon_Id__c, Promo_Code__c, Off__c, Activation_Date__c, Expiry_Date__c 
                                                        FROM DD_Promotion_Codes__mdt 
                                                        WHERE Promo_Code__c = :code LIMIT 1];
            if (!promoCodes.isEmpty()) {
                DD_Promotion_Codes__mdt promoCodeRecord = promoCodes[0];
                denormalizedRecord.couponId = promoCodeRecord.Coupon_Id__c;
                denormalizedRecord.promoCode = promoCodeRecord.Promo_Code__c;
                denormalizedRecord.activationDate = promoCodeRecord.Activation_Date__c;
                denormalizedRecord.expiryDate = promoCodeRecord.Expiry_Date__c;
                denormalizedRecord.discountPercentage = Integer.valueOf(promoCodeRecord.Off__c);
                denormalizedRecord.isActive = promoCodeRecord.Activation_Date__c <= currentDate && promoCodeRecord.Expiry_Date__c >= currentDate;
                // System.debug(denormalizedRecord);
              
                // return denormalizedRecord;
                
            }
                       
            // Check if the code is a voucher code for an approved or rejected speaker
            List<Speaker__c> speakers = [SELECT Id, Name, is_Attendee__c, Approval_Status__c, Voucher_Code__c 
            FROM Speaker__c WHERE Voucher_Code__c = :code AND (Approval_Status__c = 'Approved' OR Approval_Status__c = 'Rejected') LIMIT 1];

            if (!speakers.isEmpty()) {
                Speaker__c speaker = speakers[0];
                denormalizedRecord.speaker = speaker;
                denormalizedRecord.approvalStatus = speaker.Approval_Status__c;
                 
                if(speaker.is_Attendee__c){
                    System.debug('Voucher is used!');
                    denormalizedRecord.errorMessage = 'This voucher code has already been redeemed and cannot be applied again.';
                }
                if (speaker.Approval_Status__c == 'Approved'){
                    List<DD_Promotion_Codes__mdt> approvedPromoCodes = [SELECT Id, Coupon_Id__c, Promo_Code__c, Off__c, Activation_Date__c, Expiry_Date__c 
                    FROM DD_Promotion_Codes__mdt 
                    WHERE Off__c = 100 LIMIT 1];

                    if (!approvedPromoCodes.isEmpty()){
                        DD_Promotion_Codes__mdt promoCodeRecord = approvedPromoCodes[0];
                        denormalizedRecord.couponId = promoCodeRecord.Coupon_Id__c;
                        denormalizedRecord.promoCode = code;
                        denormalizedRecord.activationDate = promoCodeRecord.Activation_Date__c;
                        denormalizedRecord.expiryDate = promoCodeRecord.Expiry_Date__c;
                        denormalizedRecord.discountPercentage = Integer.valueOf(promoCodeRecord.Off__c);
                        denormalizedRecord.isActive = promoCodeRecord.Activation_Date__c <= currentDate && promoCodeRecord.Expiry_Date__c >= currentDate;
              
                    }
                }
                else if (speaker.Approval_Status__c == 'Rejected'){
                    List<DD_Promotion_Codes__mdt> rejectedPromoCodes = [SELECT Id, Coupon_Id__c, Promo_Code__c, Off__c, Activation_Date__c, Expiry_Date__c 
                    FROM DD_Promotion_Codes__mdt 
                    WHERE Off__c = 20 LIMIT 1];

                    if (!rejectedPromoCodes.isEmpty()) {
                        DD_Promotion_Codes__mdt promoCodeRecord = rejectedPromoCodes[0];
                        denormalizedRecord.couponId = promoCodeRecord.Coupon_Id__c;
                        denormalizedRecord.promoCode = code;
                        denormalizedRecord.activationDate = promoCodeRecord.Activation_Date__c;
                        denormalizedRecord.expiryDate = promoCodeRecord.Expiry_Date__c;
                        denormalizedRecord.discountPercentage = Integer.valueOf(promoCodeRecord.Off__c);
                        denormalizedRecord.isActive = promoCodeRecord.Activation_Date__c <= currentDate && promoCodeRecord.Expiry_Date__c >= currentDate;

                    }
                }
                
            }

           
            System.debug(denormalizedRecord);

            return denormalizedRecord;

        } catch (Exception e) {
            return null;
        }}

public class CustomException extends Exception {}

}