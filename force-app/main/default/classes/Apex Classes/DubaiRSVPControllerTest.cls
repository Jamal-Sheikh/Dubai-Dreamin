@isTest
global class DubaiRSVPControllerTest {

 
    @isTest
    static void createPaymentPageTest() {
     
        String attendeeId = 'a0VXXXXXXXXXXXXXXX';
        Integer quantity = 2;
        String priceId = 'price_XXXXXXXXXXXXXXX';
        String couponId = 'co_XXXXXXXXXXXXXXX';
        String redirectUrl = 'https://example.com/redirect';

     
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
     
        Test.startTest();
        String result = DubaiRSVPController.createPaymentPage(attendeeId, quantity, priceId, redirectUrl, couponId);
        Test.stopTest();
        

    }
    
    global class MockHttpResponseGenerator implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            // Create mock HTTP response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"url":"https://mockpaymentlink.com"}');
            return res;
        }
    }
    
    
     
    @isTest
    static void testRegisterAttendee() {
        Event__c event = new Event__c();
        event.Name='test event';
        event.Event_Title__c = 'event title';
        insert event;
        
       // String attendeeInfoJson = '{"firstName":"John","lastName":"Doe","email":"john.doe@example.com","eventId":"a0EXXXXXXXXXXXXXXX","companyName":"XYZ Corp","companySize":"Large","foodPreference":"Vegetarian","message":"Test message","phone":"1234567890","sessionInterest":"Developer","tShirtSize":"L","designation":"Developer","trailblazerId":"123","linkedinId":"john-doe"}';
        
        String attendeeInfoJson = '{"firstName":"John","lastName":"Doe","email":"john.doe@example.com","eventId":"' + event.Id + '","companyName":"XYZ Corp","companySize":"1 - 50","foodPreference":"Veg","message":"Test message","phone":"1234567890","sessionInterest":"Sales Cloud","tShirtSize":"Large","designation":"Developer","trailblazerId":"123","linkedinId":"john-doe"}';

        Contact existingContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com');
        insert existingContact;
        
        
        Test.startTest();
        //Test.setStub(ContactSelector.getContacts, new ContactSelectorStub());
        
      
        Attendee__c attendee = DubaiRSVPController.registerAttendee(attendeeInfoJson);
        Test.stopTest();
        
        
        System.assertEquals(event.Id, attendee.Event__c);
        System.assertEquals(existingContact.Id, attendee.Attendee__c);
       
    }
    static void testAttendeeExistsForEvent() {
        // Create test data: Event and Attendee
        Event__c testEvent = new Event__c(Name = 'Test Event');
        insert testEvent;
        
        Contact testAttendee = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'test@example.com');
        insert testAttendee;
        
        Attendee__c testAttendeeRecord = new Attendee__c(Attendee__c = testAttendee.Id, Event__c = testEvent.Id);
        insert testAttendeeRecord;
        
        // Test when attendee exists for the event
        Boolean attendeeExists = DubaiRSVPController.attendeeExistsForEvent('test@example.com', testEvent.Id);
        System.assertEquals(true, attendeeExists, 'Attendee should exist for the event');
        
        // Test when attendee does not exist for the event
        Boolean attendeeDoesNotExist = DubaiRSVPController.attendeeExistsForEvent('nonexistent@example.com', testEvent.Id);
        System.assertEquals(false, attendeeDoesNotExist, 'Attendee should not exist for the event');
    }
    
    @isTest
    static void fetchCouponIdTest() {
       

        
        DenormalizedPromotionCode result = DubaiRSVPController.fetchCouponId('DWT2410');

        // Verify the result
      
        System.assertEquals('DWT2410', result.promoCode);
     
    }
    
     @isTest
    static void attendeeExistsForEventTest() {
     
        Event__c testEvent = new Event__c(Name = 'Test Event', Event_Title__c = 'Test Event');
        insert testEvent;
        
        String testEmail = 'test@example.com';
        Attendee__c testAttendee = new Attendee__c(Email__c = testEmail, Event__c = testEvent.Id);
        insert testAttendee;
        
      
       // System.assertEquals(true, DubaiRSVPController.attendeeExistsForEvent(testEmail, testEvent.Id));
        
       
        System.assertEquals(false, DubaiRSVPController.attendeeExistsForEvent('another@example.com', testEvent.Id));
    }
}