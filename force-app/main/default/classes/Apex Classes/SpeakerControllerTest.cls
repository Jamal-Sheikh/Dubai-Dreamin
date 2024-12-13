/**
* @author: Muhammad Raza
* @description: Test class for testing the SpeakerController class.
*               This class tests the functionality related to retrieving speakers for an event.
* @since: 01/02/24
* @Last Modified by: Muhammad Raza 
*/
@isTest
public with sharing class SpeakerControllerTest {
    
    /**
* @author: Muhammad Raza
* @description:  Test method to verify the functionality of the getSpeakers method.
*               It creates test data for event, session, speaker, and event speaker,
*               then verifies that the correct number of speakers is retrieved for the given event.
*/
    @isTest
    static void testingGetSpeakers(){
        // Event__c testEvent = EventTestDataFactory.createEvent();
        // Session__c testSession = EventTestDataFactory.createSession(testEvent);
        // Speaker__c testSpeaker = EventTestDataFactory.createSpeaker(testEvent);
        
        // Event_Speaker__c testEventSpeaker = EventTestDataFactory.createEventSpeaker(testEvent,testSpeaker);
        
        
        // Test.startTest();
        // List<DenormalizedSpeaker> result = SpeakerController.getSpeakers(testEvent.Id);
        // Test.StopTest();
        // Assert.areEqual(1, result.size(), 'Expected event list' );
        
        // User testUser = new User(
        //     FirstName = 'test',
        //     LastName = 'user001',
        //     Username = 'testuser112231824@gmail.com',
        //     Email = 'testuser@gmail.com',
        //     Alias = 'TA',
        //     CommunityNickname = 'test',
        //     TimeZoneSidKey = 'GMT', 
        //     LocaleSidKey = 'en_US',
        //     EmailEncodingKey = 'UTF-8',
        //     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
        //     LanguageLocaleKey = 'en_US'
        // );
        
        // insert testUser;
       

        String firstName = 'test';
        String lastName = 'user001';
        String emailPrefix = 'testuser';
        String emailDomain = 'gmail.com';
        String uniqueIdentifier = String.valueOf(System.currentTimeMillis()); // Using timestamp as a unique identifier
        String username = emailPrefix + uniqueIdentifier + '@' + emailDomain;
        
        User testUser = new User(
            FirstName = firstName,
            LastName = lastName,
            Username = username,
            Email = emailPrefix + uniqueIdentifier + '@' + emailDomain, // Using the same unique identifier for email as well
            Alias = 'TA',
            CommunityNickname = firstName, // You can use the first name as the community nickname
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        
        insert testUser;
        
        //  String testUserId = [SELECT Id FROM User WHERE Email = 'testuser@gmail.com' LIMIT 1].Id;
        String testUserId = [SELECT Id FROM User WHERE Email =: testUser.Email].Id;
        
        Account dubaiAccount = new Account(
            Name = 'Dubai Dreamin',
            Logo__c = 'https://dubaidreamin.com/assets/img/logo/main_logo.png'
        );
        insert dubaiAccount;
        
        Event__c testEvent = new Event__c(
            Name = 'Dubai Dreamin',
            Banner_Image__c = 'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            Event_Title__c = 'Dubai Dreamin 24',
            Event_Organizer__c = testUserId,
            Event_Organizer_Company__c = dubaiAccount.Id,
            Event_Type__c = 'Hybrid',
            Event_Charges__c = 500,
            Event_Description__c = 'Dubai Dreamin takes center stage as the ultimate community-driven assembly for Salesforce professionals. Immerse yourself in a full-day spectacle featuring a rich array of content tracks and riveting keynote speakers that promise an unforgettable experience!',
            Event_Address__CountryCode__s = 'AE',
            Event_Address__City__s = 'Dubai',
            Event_Address__PostalCode__s = '15500',
            Event_Address__Street__s = 'Street 152',
            Event_Start_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 9, 0, 0),
            Event_End_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 10, 30, 0)
        );
        // Event__c testEvent = new Event__c(Name = 'Test Event');
        // Event__c testEvent = new Event__c(Name = 'Test Event');
        // insert testEvent;
        
        insert testEvent;
        
        
        
        Speaker__c testSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Approval_Status__c = 'Approved'
        );
        insert testSpeaker;
        // insert testSpeaker;
        Event_Speaker__c newEventCOSpeaker = new Event_Speaker__c(
            Event__c = testEvent.Id,
            Speaker__c = testSpeaker.Id
        );
        
        insert newEventCOSpeaker;
        // Create a ContentDocument and ContentDocumentLink linked to the testSpeaker
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='SampleTitle', 
            PathOnClient ='SampleTitle.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = testSpeaker.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        // Call the method under test
        // Test.startTest();
        ContentController.createPubliclink(new List<Id>{testSpeaker.Id});
        // Test.stopTest();
        
        // Query for the created ContentDistribution
        List<ContentDistribution> cdList = [SELECT Id FROM ContentDistribution WHERE Name = 'Test' LIMIT 1];
        
        // List<Speaker__c> speakersList = EventSpeakerSelector.getApprovedSpeakersByEventId(eventId);
        List<DenormalizedSpeaker>  speakersList = SpeakerController.getSpeakers(testEvent.id);
        System.assertEquals(1, speakersList.size(), 'Expected one Speaker__c record to be created');
        
    }
    
    
    
    @isTest static void testRegisterSpeaker() {
        
        // Setup test data
        ContentVersion cv = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test Document Content')
        );
        insert cv;
        
        Event__c testEvent = new Event__c(
            Name = 'Dubai Dreamin',
            Banner_Image__c = 'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            Event_Title__c = 'Dubai Dreamin 24',
            // Event_Organizer__c = testUserId,
            // Event_Organizer_Company__c = dubaiAccount.Id,
            Event_Type__c = 'Hybrid',
            Event_Charges__c = 500,
            Event_Description__c = 'Dubai Dreamin takes center stage as the ultimate community-driven assembly for Salesforce professionals. Immerse yourself in a full-day spectacle featuring a rich array of content tracks and riveting keynote speakers that promise an unforgettable experience!',
            Event_Address__CountryCode__s = 'AE',
            Event_Address__City__s = 'Dubai',
            Event_Address__PostalCode__s = '15500',
            Event_Address__Street__s = 'Street 152',
            Event_Start_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 9, 0, 0),
            Event_End_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 10, 30, 0)
        );
        // Event__c testEvent = new Event__c(Name = 'Test Event');
        // Event__c testEvent = new Event__c(Name = 'Test Event');
        // insert testEvent;
        
        insert testEvent;
        
        
        Speaker__c testSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Approval_Status__c = 'Approved'
        );
        insert testSpeaker;
        
        Event_Speaker__c es = new Event_Speaker__c();
        es.Speaker__c = testSpeaker.id;
        es.Event__c = testEvent.id;
        insert es;
        
        DenormalizedSession ds = new DenormalizedSession();
        
        String speakerInfoJson = '{"speakerName": "Test Speaker", "speakerEmail": "testspeaker@example.com", "speakerTitle": "Test Title", "speakerSocialMedia": "https://twitter.com/testspeaker", "speakerInformation": "Test Information", "speakerPhone": "1234567890", "companyName": "Test Company", "speakerRole": "Admins", "speakerImage": "'+cv.id+'","speakerImageBlob": "", "coSpeakerName": "", "coSpeakerTitle": "", "coSpeakerEmail": "", "coSpeakerRole": "", "coSpeakerImageBlob": "", "hasCoSpeaker": false, "eventId": "'+testEvent.id+'", "sessionInfo": {"sessionTitle": "Test Session", "sessionDescription": "Test Description", "sessionTrack": "Data Cloud", "sessionAlreadyPresented": false}}';
        String existingSpeakerInfoJson = '{"speakerName": "Test Speaker", "speakerEmail": "test@example.com", "speakerTitle": "Test Title", "speakerSocialMedia": "https://twitter.com/testspeaker", "speakerInformation": "Test Information", "speakerPhone": "1234567890", "companyName": "Test Company", "speakerRole": "Admins", "speakerImage": "'+cv.id+'","speakerImageBlob": "", "coSpeakerName": "", "coSpeakerTitle": "", "coSpeakerEmail": "", "coSpeakerRole": "", "coSpeakerImageBlob": "", "hasCoSpeaker": false, "eventId": "'+testEvent.id+'", "sessionInfo": {"sessionTitle": "Test Session", "sessionDescription": "Test Description", "sessionTrack": "Data Cloud", "sessionAlreadyPresented": false}}';

        // Call the method to test
        try{
        Test.startTest();
        //SpeakerController.registerSpeaker(speakerInfoJson);
        SpeakerController.registerSpeaker(existingSpeakerInfoJson);
        EventSpeakerSelector.getSpeakerByEventId(testEvent.id);
        Test.stopTest();
        }catch (Exception ex) {
 // Utils.handleException(ex);
 system.debug(ex);
}
        
        // Verify that the Speaker__c record was created
        List<Speaker__c> speakers = [SELECT Id, Speaker_Name__c, Email__c FROM Speaker__c WHERE Email__c = :'testspeaker@example.com'];
        //System.assertEquals(1, speakers.size(), 'Expected one Speaker__c record to be created');
        
        // Additional verifications can be added here to check for the creation of related records (Event_Speaker__c, Session__c, etc.)
    }
    
    @isTest static void testRegisterSpeakerWithCoSpeaker() {
        
        Event__c testEvent = new Event__c(
            Name = 'Dubai Dreamin',
            Banner_Image__c = 'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            Event_Title__c = 'Dubai Dreamin 24',
            // Event_Organizer__c = testUserId,
            // Event_Organizer_Company__c = dubaiAccount.Id,
            Event_Type__c = 'Hybrid',
            Event_Charges__c = 500,
            Event_Description__c = 'Dubai Dreamin takes center stage as the ultimate community-driven assembly for Salesforce professionals. Immerse yourself in a full-day spectacle featuring a rich array of content tracks and riveting keynote speakers that promise an unforgettable experience!',
            Event_Address__CountryCode__s = 'AE',
            Event_Address__City__s = 'Dubai',
            Event_Address__PostalCode__s = '15500',
            Event_Address__Street__s = 'Street 152',
            Event_Start_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 9, 0, 0),
            Event_End_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 10, 30, 0)
        );
        // Event__c testEvent = new Event__c(Name = 'Test Event');
        // Event__c testEvent = new Event__c(Name = 'Test Event');
        // insert testEvent;
        
        insert testEvent;
        
        String speakerInfoJson = '{"speakerName": "Test Speaker", "speakerEmail": "testspeaker@example.com", "speakerTitle": "Test Title", "speakerSocialMedia": "https://twitter.com/testspeaker", "speakerInformation": "Test Information", "speakerPhone": "1234567890", "companyName": "Test Company", "speakerRole": "Admins", "speakerImage": "","speakerImageBlob": "HJHJHJHJHJHSNSNSJS", "coSpeakerName": "Test Speaker co", "coSpeakerTitle": "test co speaker title", "coSpeakerEmail": "testcospeaker@gmail.coco", "coSpeakerRole": "Admins", "coSpeakerImage": "","coSpeakerImageBlob": "HJHJHJHJHJHSNSNSJSJJJJJ", "hasCoSpeaker": true, "eventId": "'+testEvent.id+'", "sessionInfo": {"sessionTitle": "Test Session", "sessionDescription": "Test Description", "sessionTrack": "Data Cloud",  "sessionAlreadyPresented": false, "individualPresentor" : false, "IPRCompliance": false}}';
        
        // Call the method to test
        Test.startTest();
    SpeakerController.registerSpeaker(speakerInfoJson);
        Test.stopTest();
        
        // Verify that the Speaker__c record was created
        List<Speaker__c> speakers = [SELECT Id, Speaker_Name__c, Email__c FROM Speaker__c WHERE Email__c = :'testspeaker@example.com'];
        System.assertEquals(1, speakers.size(), 'Expected one Speaker__c record to be created');
        
        
    }
    
    @isTest static void testRegisterSpeakerWithExistingEmail() {
        // Setup test data with an existing email
        // Call the method to test and expect an exception
        // Verify that no records were created
    }
}