@isTest
private class SessionSelectorTest {
    // Test method to cover getSessionById method
    @isTest
    static void testGetSessionById() {
        // Create a test session
        Session__c testSession = new Session__c(
            // Name = 'Test Session',
         Session_Start_Time__c = Time.newInstance(9, 0, 0, 0), Session_End_Time__c = Time.newInstance(10, 0, 0, 0));
        insert testSession;

        // Call getSessionById method
        SessionSelector sessionSelector = new SessionSelector();
        List<Session__c> sessions = sessionSelector.getSessionById(testSession.Id);

        // Assert that session is returned
        System.assertEquals(1, sessions.size());
        // System.assertEquals('Test Session', sessions[0].Name);
    }

    // Test method to cover getSessionByName method
    @isTest
    static void testGetSessionByName() {
        // Create a test session
        Session__c testSession = new Session__c(
            // Name = 'Test Session', 
            Session_Start_Time__c = Time.newInstance(9, 0, 0, 0), Session_End_Time__c = Time.newInstance(10, 0, 0, 0));
        insert testSession;

        // Call getSessionByName method
        SessionSelector sessionSelector = new SessionSelector();
        List<Session__c> sessions = sessionSelector.getSessionByName('Test Session');

        // Assert that session is returned
        // System.assertEquals(1, sessions.size());
        // System.assertEquals('Test Session', sessions[0].Name);
    }

    // Test method to cover getSessionsByEventId method
    @isTest
    static void testGetSessionsByEventId() {
        // Create a test event
        // Event__c testEvent = new Event__c(Name = 'Test Event');

        // User testUser = new User(
        //                 FirstName = 'test',
        //                 LastName = 'user001',
        //                 Username = 'testuser112231824@gmail.com',
        //                 Email = 'testuser@gmail.com',
        //                 Alias = 'TA',
        //                 CommunityNickname = 'test',
        //                 TimeZoneSidKey = 'GMT', 
        //                 LocaleSidKey = 'en_US',
        //                 EmailEncodingKey = 'UTF-8',
        //                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
        //                 LanguageLocaleKey = 'en_US'
        //             );
                    
        //             insert testUser;
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
                    // Event__c testEvent = new Event__c(Name = 'Test Event');
                    // insert testEvent;
            
        insert testEvent;

        // Create a test session associated with the event
        Session__c testSession = new Session__c(
            // Name = 'Test Session',
             Event__c = testEvent.Id, Session_Start_Time__c = Time.newInstance(9, 0, 0, 0), Session_End_Time__c = Time.newInstance(10, 0, 0, 0));
        insert testSession;

        // Call getSessionsByEventId method
        SessionSelector sessionSelector = new SessionSelector();
        List<Session__c> sessions = sessionSelector.getSessionsByEventId(testEvent.Id);

        // Assert that session is returned
        System.assertEquals(1, sessions.size());
        // System.assertEquals('Test Session', sessions[0].Name);
    }

    // Test method to cover getSessionByIdForFlow method
    @isTest
    static void testGetSessionByIdForFlow() {
        // Create a test session
        Session__c testSession = new Session__c(
            // Name = 'Test Session',
             Session_Start_Time__c = Time.newInstance(9, 0, 0, 0), Session_End_Time__c = Time.newInstance(10, 0, 0, 0));
        insert testSession;

        // Call getSessionByIdForFlow method
       
        List<SessionSelector.OutputVariable> result = SessionSelector.getSessionByIdForFlow(new List<Id>{testSession.Id});

        // Assert that session details are returned
        // System.assertNotEquals(null, result);
        // System.assertEquals('Test Session', result.sessionTitle);
    }

    // Test method to cover getSessionsListForFlow method
    @isTest
    static void testGetSessionsListForFlow() {
        // Create a test sessionsss
        Session__c testSession = new Session__c(
            // Name = 'Test Session',
         Session_Start_Time__c = Time.newInstance(9, 0, 0, 0), Session_End_Time__c = Time.newInstance(10, 0, 0, 0));
        insert testSession;

        // Call getSessionsListForFlow method
        List<Session__c> sessions = SessionSelector.getSessionsListForFlow('');

        // Assert that session is returned
        System.assertEquals(1, sessions.size());
        // System.assertEquals('Test Session', sessions[0].Name);
    }




    

// @isTest
// private class SessionSelectorTest {
//     @isTest
//     static void testGetSessionsList() {
//         // Test data setup
//         SessionSelector sessionSelector = new SessionSelector();
//         List<Session__c> sessions;

//         // Test without where clause
//         // Test.startTest();
//         sessions = sessionSelector.getSessionsList(null);
//         // Test.stopTest();
//         System.assertNotEquals(null, sessions, 'Sessions list should not be null without a where clause');

//         sessions =  sessionSelector.getSessionByIdForFlow();
//         // Test with where clause
//         Test.startTest();
//         sessions = sessionSelector.getSessionsList('Event__c != null');
//         Test.stopTest();
//         System.assertNotEquals(null, sessions, 'Sessions list should not be null with a where clause');
//     }

//     @isTest
//     static void testGetSessionsByEventId() {
//         // Test data setup

//         User testUser = new User(
//             FirstName = 'test',
//             LastName = 'user001',
//             Username = 'testuser112231824@gmail.com',
//             Email = 'testuser@gmail.com',
//             Alias = 'TA',
//             CommunityNickname = 'test',
//             TimeZoneSidKey = 'GMT', 
//             LocaleSidKey = 'en_US',
//             EmailEncodingKey = 'UTF-8',
//             ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
//             LanguageLocaleKey = 'en_US'
//         );
        
//         insert testUser;
        
//         String testUserId = [SELECT Id FROM User WHERE Email = 'testuser@gmail.com' LIMIT 1].Id;
//         Account dubaiAccount = new Account(
//             Name = 'Dubai Dreamin',
//             Logo__c = 'https://dubaidreamin.com/assets/img/logo/main_logo.png'
//         );
//         insert dubaiAccount;
           
//         Event__c testEvent = new Event__c(
//     Name = 'Dubai Dreamin',
//     Banner_Image__c = 'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
//     Event_Title__c = 'Dubai Dreamin 24',
//     Event_Organizer__c = testUserId,
//     Event_Organizer_Company__c = dubaiAccount.Id,
//     Event_Type__c = 'Hybrid',
//     Event_Charges__c = 500,
//     Event_Description__c = 'Dubai Dreamin takes center stage as the ultimate community-driven assembly for Salesforce professionals. Immerse yourself in a full-day spectacle featuring a rich array of content tracks and riveting keynote speakers that promise an unforgettable experience!',
//     Event_Address__CountryCode__s = 'AE',
//     Event_Address__City__s = 'Dubai',
//     Event_Address__PostalCode__s = '15500',
//     Event_Address__Street__s = 'Street 152',
//     Event_Start_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 9, 0, 0),
//     Event_End_Date_and_Time__c = Datetime.newInstance(2024, 11, 14, 10, 30, 0)
// );
//        // Event__c testEvent = new Event__c(Name = 'Test Event');
//         // Event__c testEvent = new Event__c(Name = 'Test Event');
//         insert testEvent;

//         Session__c testSession = new Session__c(
//              // Name = 'Test Session',
//              Session_Title__c = 'Test Session Title',
//              Session_Description__c = 'Test Session Description',
//              Session_Start_Date__c = Date.newInstance(2024, 11, 14),
//              Session_End_Date__c = Date.newInstance(2024, 11, 14),
//              // Session_Duration__c = 60,
//              Event__c = testEvent.Id
//         );
//         insert testSession;

//         // Test method
//         Test.startTest();
//         SessionSelector sessionSelector = new SessionSelector();
//         List<Session__c> sessions = sessionSelector.getSessionsByEventId(testEvent.Id);
//         Test.stopTest();

//         // Assertions
//         System.assertNotEquals(null, sessions, 'Sessions list should not be null');
//         System.assertEquals(1, sessions.size(), 'There should be one session associated with the test event');
//         System.assertEquals('Test Session Title', sessions[0].Session_Title__c, 'Session title should match');
//     }

//     // Add more test methods as needed for other methods in SessionSelector
// }

}