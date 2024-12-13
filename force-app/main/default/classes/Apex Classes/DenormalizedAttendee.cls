/**
* @author: Aneela Oad
* @description: Handles the denormalization process for attendee data.
* @since: 11/12/23
* @Last Modified by: Aneela Oad
*/
public class DenormalizedAttendee{
@AuraEnabled public String eventId;
@AuraEnabled public String id;
@AuraEnabled public String firstName;
@AuraEnabled public String lastName;
@AuraEnabled public String email;
@AuraEnabled public String transactionID;
@AuraEnabled public Decimal amount;
@AuraEnabled public String companyName;
@AuraEnabled public String companySize;
@AuraEnabled public String foodPreference;
@AuraEnabled public String message;
@AuraEnabled public String phone;
@AuraEnabled public String sessionInterest;
@AuraEnabled public String tShirtSize;
@AuraEnabled public String designation;
@AuraEnabled public String trailblazerId;
@AuraEnabled public String linkedinId;
@AuraEnabled public String country;
@AuraEnabled public String code;
@AuraEnabled public Boolean primary;
@AuraEnabled public Id speakerAttendeeId;
// @AuraEnabled public boolean agreement;

@AuraEnabled public List<DenormalizedResponse> responsesList;
@AuraEnabled public List<DenormalizedQuestion> questionsList;
@AuraEnabled public List<DenormalizedTicket> ticketsList;


public DenormalizedAttendee(){
    
}

}