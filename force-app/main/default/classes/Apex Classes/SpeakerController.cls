/**
* @author: Muhammad Raza
* @description: Controller Class for handling speaker information.
* @created: 31/01/24
* @Last Modified by: Muhammad Raza
*/
@RestResource(urlMapping='/api/Speaker')
global without sharing class SpeakerController {   
    

    public static Id commonSessionId;
    public static Id primarySpeaker;
    @AuraEnabled(cacheable=true)
public static List<DenormalizedSpeaker> getSpeakers(String eventId) {
    
    List<Speaker__c> speakersList = EventSpeakerSelector.getApprovedSpeakersByEventId(eventId);
  List<String> speakerIdsList = new List<String>();
    for(Speaker__c speaker: speakersList){

      speakerIdsList.add(speaker.id);
    }
    List<DenormalizedSpeaker> denormalizedSpeakerList = new List<DenormalizedSpeaker>();
    
    // Query ContentDocumentLinks for all related documents
  //  List<ContentDocumentLink> contentLinks = [SELECT ContentDocumentId ,LinkedEntityId
  //                                            FROM ContentDocumentLink 
  //                                            WHERE LinkedEntityId IN :speakerIdsList];
    
    // Create a map to store ContentDocumentId with Speaker__c Id

  //  System.debug(contentLinks);
   // Map<Id, Id> speakerContentMap = new Map<Id, Id>();
  //  for (ContentDocumentLink link : contentLinks) {
  //      speakerContentMap.put(link.LinkedEntityId, link.ContentDocumentId);
   // }
    
    for (Speaker__c speaker : speakersList) {
        DenormalizedSpeaker denormalizedSpeaker = new DenormalizedSpeaker();
        denormalizedSpeaker.speakerName = speaker.Speaker_Name__c;
        denormalizedSpeaker.speakerInformation = speaker.Speaker_Information__c;
        denormalizedSpeaker.speakerContactNumber = speaker.Phone_Number__c;
        denormalizedSpeaker.speakerEmail = speaker.Email__c;
        denormalizedSpeaker.speakerTitle = speaker.Speaker_title__c;
        denormalizedSpeaker.speakerSocialMedia = speaker.Speaker_Social_Media__c;
        denormalizedSpeaker.speakerFileName = speaker.Speaker_Profile_Image__c;
        denormalizedSpeaker.speakerAge = speaker.Speaker_Age__c;
        denormalizedSpeaker.speakerGender = speaker.Speaker_Gender__c;
        
        // Retrieve image URL from ContentVersion if ContentDocument exists
        // Id contentDocumentId = speakerContentMap.get(speaker.Id);
        // if (contentDocumentId != null) {
            // ContentVersion contentVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId ORDER BY CreatedDate DESC LIMIT 1];
            // ContentDistribution    cdlink = [SELECT Id, ContentDownloadUrl, DistributionPublicUrl, ContentVersionId, Name FROM ContentDistribution where ContentVersionId=:contentVersion.id ];

            // ContentDistribution cdl = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :contentVersion.Id LIMIT 1];
            // System.debug('public url bro'+cdl);
            // denormalizedSpeaker.speakerImage =  URL.getSalesforceBaseUrl().toExternalForm() +'/sfc/servlet.shepherd/version/download/' + contentVersion.Id;
          
          //  denormalizedSpeaker.speakerImage = '/sfc/servlet.shepherd/version/download/' + contentVersion.Id;
       //   denormalizedSpeaker.speakerImage =  cdlink.ContentDownloadUrl;
            // denormalizedSpeaker.speakerImage = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + contentVersion.Id;
        // }
        
        denormalizedSpeakerList.add(denormalizedSpeaker);
    }
    
    return denormalizedSpeakerList;
}


    // speaker registration 
    @AuraEnabled
   @HttpPost
    // global static void registerSpeaker(String speakerName, String speakerEmail, String speakerTitle, String speakerSocialMedia, String speakerInformation, String speakerPhone, String companyName, String speakerImageBlob) {
    global static void registerSpeaker(String speakerInfo) {
      System.debug(speakerInfo);
      DenormalizedSpeaker denormalizedspeakerInfo = (DenormalizedSpeaker) JSON.deserialize(speakerInfo, DenormalizedSpeaker.class);
     System.debug('speakerInfo ---> '+ speakerInfo);
     System.debug('denormalizedspeakerInfo ---> '+ denormalizedspeakerInfo.speakerRole);
      DenormalizedSession denormalizedSession =  denormalizedspeakerInfo.sessionInfo;
      List<Speaker__c> existingSpeaker = speakerExistsForEvent(denormalizedspeakerInfo.speakerEmail, denormalizedspeakerInfo.eventId);
      List<Speaker__c> existingCoSpeakerCheck =speakerExistsForEvent(denormalizedspeakerInfo.coSpeakerEmail, denormalizedspeakerInfo.eventId);
      if (existingSpeaker.size()>0 ) {
      if(sessionExistsForSpeaker(existingSpeaker,denormalizedSession.sessionTrack)){
       throw new CustomException('A Session Request with the same Speaker/Co-Speaker email already exists.');

      }
    }
    if (existingCoSpeakerCheck.size()>0 ) {
      if(sessionExistsForSpeaker(existingCoSpeakerCheck,denormalizedSession.sessionTrack)){
       throw new CustomException('A Session Request with the same Speaker/Co-Speaker email already exists.');

      }
      
      }
      if (existingSpeaker.size()>0) {
      //  throw new CustomException('A Speaker/Co-Speaker with the same email already exists.');
      EventSelector selectedEvent = new EventSelector();
      // List<Event__c> currentEvent =selectedEvent.getEvents(denormalizedspeakerInfo.eventId);
      system.debug('eventid'+denormalizedspeakerInfo.eventId);
      String currentEventid =EventSelector.getDubaiDreaminEvent();
      Event__c currentEvent =selectedEvent.getEventById(denormalizedspeakerInfo.eventId);
      system.debug('current event'+currentEvent);
      Time sessionStartDummyTime = Time.newInstance(12, 0, 0, 0);



      
      Session__c newSession = new Session__c(
        Event__c = denormalizedspeakerInfo.eventId,
        Session_Title__c = denormalizedSession.sessionTitle,
        Session_Description__c = denormalizedSession.sessionDescription,
        Level__c =denormalizedSession.sessionLevel,
        Session_Start_Date__c =currentEvent.Event_Start_Date_and_Time__c.date() ,
        Session_End_Date__c = currentEvent.Event_End_Date_and_Time__c.date(),

        // Session_Start_Date__c = denormalizedSession.sessionStartDate,
        // Session_End_Date__c = denormalizedSession.sessionEndDate,
        Session_Start_Time__c = sessionStartDummyTime ,
        Session_End_Time__c =sessionStartDummyTime.addMinutes(45),
        // Session_Start_Time__c = Time.newInstance(Integer.valueOf(denormalizedSession.sessionStartTime.split(':')[0]), Integer.valueOf(denormalizedSession.sessionStartTime.split(':')[1]), 0 ,0),
        // Session_End_Time__c = Time.newInstance(Integer.valueOf(denormalizedSession.sessionEndTime.split(':')[0]), Integer.valueOf(denormalizedSession.sessionEndTime.split(':')[1]), 0 ,0),
        Session_Track__c = denormalizedSession.sessionTrack,
        Session_Approval_Status__c = 'Pending'
    );
    insert newSession;
    submitForApproval(newSession.id);
    commonSessionId = newSession.Id;

    Session_Speaker__c newSessionSpeaker = new Session_Speaker__c(
        Session__c = commonSessionId,
        Speaker__c = existingSpeaker[0].Id
    );
    insert newSessionSpeaker;

    }

    else{

      

      Speaker__c newSpeaker = new Speaker__c(
            Speaker_Name__c = denormalizedspeakerInfo.speakerName,
            Email__c = denormalizedspeakerInfo.speakerEmail,
            Speaker_Title__c = denormalizedspeakerInfo.speakerTitle,
            Speaker_Profile_Image__c = denormalizedspeakerInfo.speakerFileName,
            Speaker_Social_Media__c = denormalizedspeakerInfo.speakerSocialMedia,
            Speaker_Information__c = denormalizedspeakerInfo.speakerInformation,
            Company_Name__c = denormalizedspeakerInfo.companyName,
            Speaker_Target__c = denormalizedspeakerInfo.speakerTarget,
            Speaker_Role__c = denormalizedspeakerInfo.speakerRole,
            Speaker_Type__c = 'Primary Speaker',
            Phone_Number__c = denormalizedspeakerInfo.speakerPhone,
            Speaker_Age__c = denormalizedSpeakerInfo.speakerAge,
            Speaker_Gender__c = denormalizedSpeakerInfo.speakerGender,
           Approval_Status__c = 'Pending',
           
            Primary__c = true
        );

      // String  speakerImage='imagename.png';
        
        system.debug('speaker record'+newSpeaker);
        insert newSpeaker;
        primarySpeaker = newSpeaker.id;
       
       
      //  submitForApproval(newSpeaker.id);



      //  system.debug(denormalizedspeakerInfo.speakerImageBlob);

        if( denormalizedspeakerInfo.speakerImage!=''){
       // ContentVersion cvSpeaker = createContentVersion(denormalizedspeakerInfo.speakerImageBlob,denormalizedspeakerInfo.speakerImage);
        // System.debug('cvSpeaker'+cvSpeaker);
        System.debug('newSpeaker'+newSpeaker);
        ContentDocumentLink cdlSpeaker = createContentLink(denormalizedspeakerInfo.speakerImage, newSpeaker.Id);
        // ContentDistribution cdbSpeaker =  createContentDistribution(cvSpeaker.Id);

       }


        
        
        // Create Event Speaker record
        Event_Speaker__c newEventSpeaker = new Event_Speaker__c(
            Event__c = denormalizedspeakerInfo.eventId,
            Speaker__c = newSpeaker.Id
        );
        insert newEventSpeaker;


        EventSelector selectedEvent = new EventSelector();
        // List<Event__c> currentEvent =selectedEvent.getEvents(denormalizedspeakerInfo.eventId);
        system.debug('eventid'+denormalizedspeakerInfo.eventId);
        String currentEventid =EventSelector.getDubaiDreaminEvent();
        Event__c currentEvent =selectedEvent.getEventById(denormalizedspeakerInfo.eventId);
        system.debug('current event'+currentEvent);
        Time sessionStartDummyTime = Time.newInstance(12, 0, 0, 0);


        
        Session__c newSession = new Session__c(
            Event__c = denormalizedspeakerInfo.eventId,
            Session_Title__c = denormalizedSession.sessionTitle,
            Session_Description__c = denormalizedSession.sessionDescription,
            Session_Start_Date__c =currentEvent.Event_Start_Date_and_Time__c.date() ,
            Session_End_Date__c = currentEvent.Event_End_Date_and_Time__c.date(),
            Why_Session_is_Chosen__c = denormalizedSession.sessionSelectionDetails,
            Does_session_already_presented__c = denormalizedSession.sessionAlreadyPresented,
            Intellectual_Property_Rights_Compliance__c= denormalizedSession.IPRCompliance,
            Individual_Presenter_Confirmation__c= denormalizedSession.individualPresentor,
            Intro_Video_Link__c = denormalizedSession.sessionIntroLink,
            Already_Presented_Link__c = denormalizedSession.sessionPresentedLink,
            Session_Expertise_Details__c = denormalizedSession.sessionExpertiseOnSubject,
            Level__c = denormalizedSession.sessionLevel,
          
            // Session_Start_Time__c = sessionStartDummyTime ,
            // Session_End_Time__c =sessionStartDummyTime.addMinutes(45),
            // Session_Start_Time__c = Time.newInstance(Integer.valueOf(denormalizedSession.sessionStartTime.split(':')[0]), Integer.valueOf(denormalizedSession.sessionStartTime.split(':')[1]), 0 ,0),
            // Session_End_Time__c = Time.newInstance(Integer.valueOf(denormalizedSession.sessionEndTime.split(':')[0]), Integer.valueOf(denormalizedSession.sessionEndTime.split(':')[1]), 0 ,0),
            Session_Track__c = denormalizedSession.sessionTrack,
            Session_Approval_Status__c = 'Pending'
            
        );
        insert newSession;
        submitForApproval(newSession.id);
        commonSessionId = newSession.Id;

        Session_Speaker__c newSessionSpeaker = new Session_Speaker__c(
            Session__c = newSession.Id,
            Speaker__c = newSpeaker.Id
        );
        insert newSessionSpeaker;


    }
    
    
      

        if(denormalizedspeakerInfo.hasCoSpeaker){

          List<Speaker__c> existingCoSpeaker =speakerExistsForEvent(denormalizedspeakerInfo.coSpeakerEmail, denormalizedspeakerInfo.eventId);
    if (existingCoSpeaker.size()>0) {
       // throw new CustomException('A Speaker/Co-Speaker with the same email already exists.');
     
     
     
    //    Event_Speaker__c newEventCOSpeaker = new Event_Speaker__c(
    //     Event__c = denormalizedspeakerInfo.eventId,
    //     Speaker__c = existingCoSpeaker[0].Id
    // );
    // insert newEventCOSpeaker;

    Session_Speaker__c newSessionCoSpeaker = new Session_Speaker__c(
          Session__c = commonSessionId,
          Speaker__c = existingCoSpeaker[0].Id
      );
      insert newSessionCoSpeaker;
       }

       else{

        Speaker__c newCoSpeaker = new Speaker__c(
          Speaker_Name__c = denormalizedspeakerInfo.coSpeakerName,
          Speaker_Title__c =denormalizedspeakerInfo.coSpeakerTitle,
          // Speaker_Profile_Image__c = denormalizedspeakerInfo.coSpeakerImage,
          Speaker_Role__c = denormalizedspeakerInfo.coSpeakerRole,
          Email__c = denormalizedspeakerInfo.coSpeakerEmail,
          Company_Name__c = denormalizedspeakerInfo.coSpeakerCompanyName,
          Phone_Number__c = denormalizedspeakerInfo.coSpeakerPhone,
          
          Speaker_Type__c = 'Co-Speaker',
         Approval_Status__c = 'Pending',
          Primary__c=false,
          Parent_Speaker__c=primarySpeaker
          );
          system.debug(newCoSpeaker);
         insert newCoSpeaker;
        // submitForApproval(newCoSpeaker.id);
        if( denormalizedspeakerInfo.coSpeakerImage!=''){
      //    ContentVersion cvCoSpeaker = createContentVersion(denormalizedspeakerInfo.coSpeakerImageBlob, denormalizedspeakerInfo.coSpeakerImage);
         ContentDocumentLink cdlCoSpeaker = createContentLink(denormalizedspeakerInfo.coSpeakerImage, newCoSpeaker.Id);
        }
        Event_Speaker__c newEventCOSpeaker = new Event_Speaker__c(
          Event__c = denormalizedspeakerInfo.eventId,
          Speaker__c = newCoSpeaker.Id
      );
      insert newEventCOSpeaker;

      Session_Speaker__c newSessionCoSpeaker = new Session_Speaker__c(
            Session__c = commonSessionId,
            Speaker__c = newCoSpeaker.Id
        );
        insert newSessionCoSpeaker;
         
      }




       }











      





    }
    

    private static void submitForApproval(Id sessionId){

            // Insert an account
            // Account a = new Account(Name='Test',annualRevenue=100.0);
            // insert a;
               String profileid = [Select id from Profile where Name =  'System Administrator'].id;
            List<User> user1 = [SELECT Id FROM User WHERE Profileid=:profileid];
                
        
              //    for(User user1:users){
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = 
                new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for Dubai Dreamin Session approval.');
            req1.setObjectId(sessionId);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(user1[0].Id); 
            
            // Submit the record to the existing process named PTO_Reqwuest_Process
            req1.setProcessDefinitionNameOrId('Approve_Session');
            
            // Skip the criteria evaluation for the specified process
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
        //    }
            // Verify the result
            // System.assert(result.isSuccess());
            
            // System.assertEquals(
            //     'Pending', result.getInstanceStatus(), 
            //     'Instance Status'+result.getInstanceStatus());
    }

    // Helper method to check if an attendee with the same email already exists for the event
private static List<Speaker__c> speakerExistsForEvent(String email, Id eventId) {
    // Query Speaker__c records for the given email and event
   // Integer count = [SELECT COUNT()  FROM Speaker__c WHERE Email__c = :email ];

   //Integer juncCount  = [SELECT COUNT() FROM Event_Speaker__c WHERE Event__r.id=:eventid AND Speaker__r.Email__c=:email];
   // return count > 0 && juncCount >0;


   List<Speaker__c> existingSpeaker = [SELECT id  FROM Speaker__c WHERE Email__c = :email ];
return existingSpeaker;
    
}
private static boolean sessionExistsForSpeaker(List<Speaker__c> speaker, String sessionTrack){
boolean error =false;
//  List<Session_Speaker__c> sessionSpeaker = [Select id, Session__r.Session_Track__c from Session_Speaker__c where Speaker__c=:speaker[0].id];

// if(sessionSpeaker.size()>0){

//   for(Session_Speaker__c sessSpeaker: sessionSpeaker){

//     if(sessSpeaker.Session__r.Session_Track__c==sessionTrack){
//       error = true;
//       break;
    
//     }
    
//      }
// }

 return error;
}
// private static ContentVersion createContentVersion(String base64, String filename) {
//     ContentVersion cv = new ContentVersion();
//     cv.VersionData = EncodingUtil.base64Decode(base64);
//     cv.Title = filename;
//     cv.PathOnClient = filename;
//     cv.Origin = 'C';
//     try {
//       insert cv;
//       return cv;
//     } catch(DMLException e) {
//       System.debug(e);
//       return null;
//     }
//   }

  
  private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
              if (contentVersionId == null || recordId == null) { return null; }
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [  SELECT ContentDocumentId  FROM ContentVersion  WHERE Id =: contentVersionId ].ContentDocumentId;
                cdl.LinkedEntityId = recordId;
                cdl.Visibility = 'AllUsers';
                // ShareType is either 'V', 'C', or 'I'
                // V = Viewer, C = Collaborator, I = Inferred
                cdl.ShareType = 'V';
                try {
                  insert cdl;
                  return cdl;
                } catch(DMLException e) {
                  System.debug(e);
                  return null;
                }
              }



//               public static ContentDistribution createContentDistribution(Id contentVersionId) {
//                 ContentDistribution cd = new ContentDistribution();
//                 cd.ContentVersionId = contentVersionId;
//                 cd.PreferencesAllowViewInBrowser = true;
//                 cd.PreferencesExpires = true;
//                 cd.Name = 'PublicShare'; // Ensure this line is present and correctly sets the Name
//                 cd.ExpiryDate = Datetime.now().addDays(1000);
//                 // cd.PreferencesExpirationDate = System.now().addDays(7); // Set an expiration date
//                 insert cd;
//                 System.debug(cd);

//                 ContentDistribution    cdl = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :cd.Id LIMIT 1];
// // return 
// SYStem.debug('faraz'+cdl.DistributionPublicUrl);
//                 return cd;


//             }



            

    public class CustomException extends Exception {}
}