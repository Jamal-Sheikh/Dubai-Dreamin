/**
* @author: Aneela Oad
* @description: Test class for EventController
* @since: 01/02/24
* @Last Modified by: Aneela Oad
*/
@isTest
public class EventControllerTest {
 
   /**
   * @author: Aneela Oad
   * @description: The method test the getEvent()  
   * @param  none
    * @return: void
   */
    @isTest
    static void getEventTest() {
        
        Account organizerCompany = new Account();
        organizerCompany.Name='Cloud-1';
        organizerCompany.Logo__c = 'https://play-lh.googleusercontent.com/8LfdOiQHWMsE1WXP_18yj61asw00uAHucGH2mOpDSesc_C5xEU9KJ_n1R0tLuhPZRW88=w240-h480-rw';
        organizerCompany.About_Us_Description__c = 'Test Description';
        insert organizerCompany;
        
        Datetime startDate = Datetime.newInstance(2024, 12, 14, 9, 0, 0);
        Datetime endDate = Datetime.newInstance(2024, 12, 14, 10, 30, 0);


        Speaker__c testSpeakerTWO = new Speaker__c(
            Speaker_Name__c = 'Test Speaker tWO',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test1221@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
           Approval_Status__c = 'Pending'
        );
        insert testSpeakerTWO;

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
        
        Event__c testEventdubai = new Event__c(
            Name = 'Dubai Dreamin',
            Banner_Image__c = 'https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            Event_Title__c = 'Dubai Dreamin 24',
            // Event_Organizer__c = testUserId,
            Event_Organizer_Company__c = organizerCompany.Id,
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
        insert testEventdubai;
        insert testEvent;

        Event_Speaker__c newEventSpeakertWO = new Event_Speaker__c(
            Event__c = testEvent.Id,
            Speaker__c = testSpeakerTWO.Id
        );
        
        DenormalizedEvent result = EventController.getEvent(testEvent.Id);
        String resultdubai = EventController.getDubaiDreaminEventId();
        List<Speaker__c> resultES = EventSpeakerSelector.getSpeakerByEventId(testEvent.Id);
     EventSpeakerSelector.getApprovedSpeakersByEventId(testEvent.Id);
        Assert.areEqual('Grand plot fair', result.eventTitle,'Expected Event Title ');
        Assert.areEqual('Test Description', result.aboutUsDescription, 'Expected Company About Us');
        Assert.areEqual('Test Event Description', result.eventDescription, 'Expected Event Description');
        Assert.areEqual('Test Image', result.bannerImage, 'Expected Event Image');
        Assert.areEqual('Test City', result.eventCity,'Expected Event City');
        Assert.areEqual('US', result.eventCountry, 'Expected Event Country');
        Assert.areEqual('Test Street', result.eventStreet, 'Expected Event Street');
        Assert.areEqual(testEvent.Event_Start_Date_and_Time__c, result.eventStartDateTime, 'Expected Event Start date');
        Assert.areEqual(testEvent.Event_End_Date_and_Time__c, result.eventEndDateTime, 'Expected Event end date');
    }
    
     
}