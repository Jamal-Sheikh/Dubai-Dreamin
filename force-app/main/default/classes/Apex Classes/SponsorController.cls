/**
 * @author: Muhammad Raza
 * @description: A controller class for retrieving denormalized sponsor information.
 * @since: 31/01/24
 * @Last Modified by: Muhammad Faraz
 */
public without sharing class SponsorController {

    /**
     * 
     * @param eventId The ID of the event to filter sponsor records.
     * @return List<DenormalizedSponsor> A list of denormalized sponsor objects containing sponsor image URLs.
     * @description: Retrieves a list of denormalized sponsor information based on the specified event ID.
     */
    @AuraEnabled(cacheable=true)
    public static List<DenormalizedSponsor> getSponsor(String eventId) {
        List<Sponsor__c> sponsorList = new SponsorSelector().getSponsorsByEventId(eventId);
        List<DenormalizedSponsor> denormalizedSponsorList = new List<DenormalizedSponsor>();
        
        for (Sponsor__c sponsor : sponsorList) {
            DenormalizedSponsor denormalizedSponsor = new DenormalizedSponsor();
            denormalizedSponsor.sponsorImage = sponsor.Sponsor__r.Logo__c;
            denormalizedSponsor.sponsorshipLevel=sponsor.Sponsorship_Level__c;
            denormalizedSponsorList.add(denormalizedSponsor);
        }

        return denormalizedSponsorList;
    }

    /**
     * @description Registers sponsor for events
     * @param sponsorInfo Serialized JSON string containing sponsor information.
     */
    /*@AuraEnabled
    public static void registerSponsor(String sponsorInfo) {
      DenormalizedSponsor denormalizedsponsorInfo = (DenormalizedSponsor) JSON.deserialize(sponsorInfo, DenormalizedSponsor.class);
      System.debug('sponsorInfo ---> '+ sponsorInfo);
      System.debug('denormalizedsponsorInfo ---> '+ denormalizedsponsorInfo);
    
    //  DenormalizedSession denormalizedSession =  denormalizedsponsorInfo.sessionInfo;

    
        Sponsor__c newSponsor = new Sponsor__c(
            Name = denormalizedSponsorInfo.sponsorName,
            Company_Name__c = denormalizedSponsorInfo.companyName,
            Industry__c = denormalizedSponsorInfo.companyIndustry,
            Sponsor_Title__c = denormalizedSponsorInfo.sponsorTitle,
            Company_Type__c = denormalizedSponsorInfo.companyType,
            Email__c = denormalizedSponsorInfo.sponsorEmail,
            Company_Website__c = denormalizedSponsorInfo.companyWebsite,
            // Sponsor_Image__c = denormalizedSponsorInfo.sponsorImage,
            Company_HQ__c = denormalizedSponsorInfo.companyAddress,
            Sponsorship_Level__c = denormalizedSponsorInfo.sponsorshipLevel,
            Sponsor_Phone__c = denormalizedSponsorInfo.companyPhone,
            Company_Description__c = denormalizedSponsorInfo.companyDescription,
            Event__c = denormalizedSponsorInfo.eventId
        );
        system.debug(newSponsor);
         insert newSponsor;
        

         if( denormalizedSponsorInfo.sponsorImage!=''){
            ContentVersion cvSponsor = createContentVersion(denormalizedSponsorInfo.sponsorImageBlob, denormalizedSponsorInfo.sponsorImage);
            ContentDocumentLink cdlSponsor = createContentLink(cvSponsor.Id, newSponsor.Id);
           }
        // // Create Event Speaker record
        // Event_Speaker__c newEventSpeaker = new Event_Speaker__c(
        //     Event__c = denormalizedspeakerInfo.eventId,
        //     Speaker__c = newSpeaker.Id
        // );
        // insert newEventSpeaker;

        // Session__c newSession = new Session__c(
        //     Event__c = denormalizedspeakerInfo.eventId,
        //     Session_Title__c = denormalizedSession.sessionTitle,
        //     Session_Description__c = denormalizedSession.sessionDescription,
        //     Session_Start_Date__c = denormalizedSession.sessionStartDate,
        //     Session_End_Date__c = denormalizedSession.sessionEndDate,
        //     Session_Start_Time__c = Time.newInstance(Integer.valueOf(denormalizedSession.sessionStartTime.split(':')[0]), Integer.valueOf(denormalizedSession.sessionStartTime.split(':')[1]), 0 ,0),
        //     Session_End_Time__c = Time.newInstance(Integer.valueOf(denormalizedSession.sessionEndTime.split(':')[0]), Integer.valueOf(denormalizedSession.sessionEndTime.split(':')[1]), 0 ,0)
        // );
        // insert newSession;
}*/
// private static ContentVersion createContentVersion(String base64, String filename) {
//     ContentVersion cv = new ContentVersion();
//     cv.VersionData = EncodingUtil.base64Decode(base64);
//     cv.Title = filename;
//     cv.PathOnClient = filename;
//     try {
//       insert cv;
//       return cv;
//     } catch(DMLException e) {
//       System.debug(e);
//       return null;
//     }
//   }

  
  // private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
  //             if (contentVersionId == null || recordId == null) { return null; }
  //               ContentDocumentLink cdl = new ContentDocumentLink();
  //               cdl.ContentDocumentId = [  SELECT ContentDocumentId  FROM ContentVersion  WHERE Id =: contentVersionId ].ContentDocumentId;
  //               cdl.LinkedEntityId = recordId;
  //               // ShareType is either 'V', 'C', or 'I'
  //               // V = Viewer, C = Collaborator, I = Inferred
  //               cdl.ShareType = 'V';
  //               try {
  //                 insert cdl;
  //                 return cdl;
  //               } catch(DMLException e) {
  //                 System.debug(e);
  //                 return null;
  //               }
  //             }
  @AuraEnabled(cacheable=true)
  public static List<String> getEmailsByLeadEmail(String inputEmail) {
    List<String> emailAddresses = new List<String>();
    
    if (!String.isBlank(inputEmail)) {
         List<Lead> leads = [SELECT Id,Email FROM Lead WHERE Email = :inputEmail];
        //  List<Lead> leads = [SELECT Id,Email FROM Lead];

        for (Lead lead : leads) {
            emailAddresses.add(lead.Email);
        }
    }
    
    return emailAddresses;
}


    @AuraEnabled
    public static string getDocumentIdBYContentVersion(String contentVersionId){
        try {
            List<ContentVersion> contentVersions = new ContentVersionSelector().getContentVersion(' Id = \'' + contentVersionId + '\'' );
            System.debug('contentVersions'+contentVersions);
            System.debug('Content Document Id'+contentVersions.get(0).ContentDocumentId);
            return contentVersions.size() > 0 ? contentVersions.get(0).ContentDocumentId : null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}