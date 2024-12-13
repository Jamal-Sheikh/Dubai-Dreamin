/**
* @author: Muhammad Raza
* @description: Test class for testing the SessionController class.
*               This class tests the functionality related to retrieving sessions for an event.
* @since: 01/02/24
* @Last Modified by: Muhammad Raza
*/
@isTest
public with sharing class SessionControllerTest {
    /**
* @author: Muhammad Raza
* @description:  Test method to verify the functionality of the getSessions method.
*               It creates test data for event, session, speaker, and session speaker,
*               then verifies that the correct number of sessions is retrieved for the given event.
*/
    @isTest
    static void testingGetSessions(){
        // Create test event, session, and speaker
        Event__c testEvent = EventTestDataFactory.createEvent();
        Session__c testSession = EventTestDataFactory.createSession(testEvent);
        Speaker__c testSpeaker = EventTestDataFactory.createSpeaker(testEvent);
        Session_Speaker__c testSessionSpeaker = EventTestDataFactory.createSessionSpeaker(testSession,testSpeaker);
        
        new SessionSpeakerSelector().getSpeakersBySessionId(testSession.Id);
        
        Test.startTest();
        List<DenormalizedSession> result = SessionController.getSessions(testEvent.Id);
        Test.StopTest();
        Assert.areEqual(1, result.size(), 'Expected event list' );
    }
// }
// @isTest
// private class SessionControllerTest {
    @isTest
    static void testGetSessions() {
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
        
        // String testUserId = [SELECT Id FROM User WHERE Email = 'testuser@gmail.com' LIMIT 1].Id;
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
        insert testEvent;

        Session__c testSession = new Session__c(
            // Name = 'Test Session',
            Session_Title__c = 'Test Session Title',
            Session_Description__c = 'Test Session Description',
            Session_Start_Date__c = Date.newInstance(2024, 11, 14),
            Session_End_Date__c = Date.newInstance(2024, 11, 14),
            // Session_Duration__c = 60,
            Event__c = testEvent.Id
        );
        insert testSession;

         Speaker__c testSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Approval_Status__c = 'Pending'
        );
        insert testSpeaker;

        Session_Speaker__c testSessionSpeaker = new Session_Speaker__c(
            Session__c = testSession.Id,
            Speaker__c = testSpeaker.Id
        );
        insert testSessionSpeaker;

        // Call the method to test
        Test.startTest();
        List<DenormalizedSession> sessions = SessionController.getSessions(testEvent.Id);
        Test.stopTest();

        // Verify the results
        System.assertEquals(1, sessions.size());
        DenormalizedSession denormalizedSession = sessions[0];
        System.assertEquals('Test Session Title', denormalizedSession.sessionTitle);
        System.assertEquals('Test Session Description', denormalizedSession.sessionDescription);
        // Add more assertions as needed for other fields
        System.assertEquals('Test Speaker', denormalizedSession.lstOfSpeakers[0].speakerName);
       // System.assertEquals('Test Image URL', denormalizedSession.lstOfSpeakers[0].speakerImage);
    }
}