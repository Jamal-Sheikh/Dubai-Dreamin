@isTest
public with sharing class EventTestDataFactory {
    // public EventTestDataFactory() {

    // }
    public static Event__c createEvent(String eventName, String eventTitle) {
        Event__c newEvent = new Event__c();
        newEvent.Name = eventName;
        newEvent.Event_Title__c = eventTitle;
        // Set other required fields for your event object
        return newEvent;
    }

    // creating Event No Parametrized Method
    public static Event__c createEvent() {
        Account organizerCompany = new Account();
        organizerCompany.Name = 'Cloud-1';
        organizerCompany.Logo__c = 'https://play-lh.googleusercontent.com/8LfdOiQHWMsE1WXP_18yj61asw00uAHucGH2mOpDSesc_C5xEU9KJ_n1R0tLuhPZRW88=w240-h480-rw';
        organizerCompany.About_Us_Description__c = 'Test Description';
        insert organizerCompany;
        Datetime startDate = Datetime.newInstance(2024, 12, 14, 9, 0, 0);
        Datetime endDate = Datetime.newInstance(2024, 12, 14, 10, 30, 0);
         Event__c testEvent = new Event__c(
            Event_Title__c = 'Grand plot fair',
            Event_Organizer_Company__c = organizerCompany.Id,
            Event_Description__c = 'Test Event Description',
            Banner_Image__c = 'Test Image',
            Event_Address__City__s = 'Test City',
            Event_Address__CountryCode__s = 'US',
            Event_Address__Street__s = 'Test Street',
   			Event_Start_Date_and_Time__c = startDate,
 	 		Event_End_Date_and_Time__c = endDate

        );
        insert testEvent;
        
        return testEvent;
    }
    // creating Sessions
    public static Session__c createSession(Event__c eventTest) {
         // Add Session for the new event
           Session__c newSession = new Session__c(
             Event__c = eventTest.Id,
             Session_Description__c = 'This is Session Description',
             Session_Start_Date__c = eventTest.Event_Start_Date_and_Time__c.date(), // Corrected date initialization
             Session_End_Date__c = eventTest.Event_End_Date_and_Time__c.date(), // Corrected date initialization
             Session_Start_Time__c = Time.newInstance(10, 0, 0, 0), // Example time initialization
             Session_End_Time__c = Time.newInstance(11, 0, 0, 0), // Example time initialization
               Session_Title__c = 'Test Session',
               Session_Approval_Status__c='Approved'
           );
           
           insert newSession;
           
           return newSession;
       }
   
       // creating Speakers
       public static Speaker__c createSpeaker(Event__c eventTest) {
         
           Speaker__c newSpeaker = new Speaker__c(
              
               Company_Name__c = eventTest.Event_Organizer_Company__c, 
               Email__c = 'speaker@example.com',
               Phone_Number__c = '123-456-7890',
               Speaker_Information__c = 'Experienced speaker with expertise in real estate trends and home discovery.',
               Speaker_Name__c = 'Jane Doe',
               Speaker_Profile_Image__c='https://ca.slack-edge.com/T03QSUT4URF-U03R42TGMS4-8a678d7a263e-72',
               Speaker_Title__c='Test Speaker',
               Approval_Status__c='Approved',
               Voucher_Code__c='KSJ492H40J'
           );
           
           insert newSpeaker;
           
           return newSpeaker;
       }
       // Creating sessionSpeaker
       public static Session_Speaker__c createSessionSpeaker(Session__c session,Speaker__c speaker){
           
           Session_Speaker__c sessionSpeaker=new Session_Speaker__c();
           sessionSpeaker.Session__c=session.Id;
           sessionSpeaker.Speaker__c=speaker.Id;
           insert sessionSpeaker;
           return sessionSpeaker;
       }

       // creating Event Speaker
       public static Event_Speaker__c createEventSpeaker(Event__c event,Speaker__c speaker ){
        Event_Speaker__c eventSpeaker=new Event_Speaker__c();
        eventSpeaker.Event__c=event.id;
        eventSpeaker.Speaker__c=speaker.id;
        insert eventSpeaker;
        return eventSpeaker;
       }

       // creating Event Sponsor
       public static Sponsor__c createEventSponsor(Event__c event ){
        Sponsor__c eventSponsor=new Sponsor__c();
        eventSponsor.Event__c=event.id;
        eventSponsor.Sponsor__c=event.Event_Organizer_Company__c;
        insert eventSponsor;
        return eventSponsor;
       }



}