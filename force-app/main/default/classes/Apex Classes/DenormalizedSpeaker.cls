/**
* @author: Muhammad Raza
* @description: This class representing denormalized information about a speaker
* @created: 31/01/24
* @Last Modified by:  Muhammad Raza
*/
public with sharing class DenormalizedSpeaker {
    
   @AuraEnabled public Boolean hasCoSpeaker;
   @AuraEnabled public String speakerName;
   @AuraEnabled public String speakerPhone;
   @AuraEnabled public String speakerTitle;
   @AuraEnabled public String speakerImage;
   @AuraEnabled public String speakerImageBlob;
   @AuraEnabled public String speakerInformation;
   @AuraEnabled public String companyName;
   @AuraEnabled public String speakerSocialMedia;
   @AuraEnabled public String speakerRole;
   @AuraEnabled public String speakerTarget;
   @AuraEnabled public String coSpeakerName;
   @AuraEnabled public String coSpeakerCompanyName;
   @AuraEnabled public String coSpeakerPhone;
   @AuraEnabled public String coSpeakerEmail;
   @AuraEnabled public String coSpeakerTitle;
   @AuraEnabled public String coSpeakerRole;
   @AuraEnabled public String coSpeakerImage;
   @AuraEnabled public String coSpeakerImageBlob;
   @AuraEnabled public String speakerEmail;
   @AuraEnabled public String speakerContactNumber;
   @AuraEnabled public String speakerAge;
   @AuraEnabled public String speakerGender;
   @AuraEnabled public String speakerFileName;

   @AuraEnabled public String eventId;

   @AuraEnabled public DenormalizedSession sessionInfo;
  
    public DenormalizedSpeaker(){}


    public void setSpeakerName(String speakerName){

        this.speakerName = speakerName;
    }
    public void setSpeakerPhone(String speakerPhone){

        this.speakerPhone = speakerPhone;
    }
}