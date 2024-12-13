/**
* @author: Muhammad Raza
* @description:  This class representing denormalized information about a sponsor
* @since: 31/01/24
* @Last Modified by: Muhammad Raza
*/
public with sharing class DenormalizedSponsor {
    
    // @AuraEnabled  public String sponsorName;
    // @AuraEnabled  public String companyName;
    // @AuraEnabled  public String companyIndustry;
    // @AuraEnabled  public String sponsorTitle;
    // @AuraEnabled public String companyType;
    
    // @AuraEnabled public String companyWebsite;
    @AuraEnabled public String sponsorEmail;
    @AuraEnabled public String sponsorImage;
    @AuraEnabled public String sponsorshipLevel;
     @AuraEnabled public String companyPhone;
    // @AuraEnabled public String sponsorImageBlob;
   // @AuraEnabled public String sponsorInformation;
    // @AuraEnabled public String companyAddress;
   
    
    // @AuraEnabled public String companyDescription;
    // @AuraEnabled  public String eventId;
    
    
    public DenormalizedSponsor(){}
    
}