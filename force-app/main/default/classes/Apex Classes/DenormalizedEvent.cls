/**
* @author: Aneela Oad
* @description: Manages the denormalization of Event data for improved performance.
* @since: 20/12/23
* @Last Modified by: Aneela Oad
*/
public with sharing  class DenormalizedEvent {
  @AuraEnabled public String eventDescription;
  @AuraEnabled public String aboutUsDescription;
   @AuraEnabled public String bannerImage;
   @AuraEnabled public String company;
   @AuraEnabled public String companyLogo;
   @AuraEnabled public String eventTitle;
   @AuraEnabled public String eventCity;
   @AuraEnabled public String eventCountry;
   @AuraEnabled public String eventStreet;
   @AuraEnabled public DateTime eventStartDateTime;
   @AuraEnabled public DateTime eventEndDateTime;
   @AuraEnabled public String dubaiDreamineventId;
 
  @AuraEnabled public String titleWarning;
  @AuraEnabled public String descriptionWarning;
  @AuraEnabled public String dateTimeWarning;
  @AuraEnabled public String locationWarning;
  @AuraEnabled public String bannerImageWarning;

  public DenormalizedEvent(){
    titleWarning = 'Title is missing';
    descriptionWarning = 'Description is missing';
    dateTimeWarning = 'N/A.';
    bannerImageWarning= 'Banner image is missing.';
  }

}