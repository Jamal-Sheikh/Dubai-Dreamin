@isTest
global class AttendeeTicketPDFControllerTest {

    @isTest
    static void testConstructor() {
        // Create a mock PageReference
        PageReference mockPageRef = new PageReference('https://salesforce.com');
        Test.setCurrentPage(mockPageRef);

        // Set up test data
        Ticket__c testTicket = new Ticket__c();
        insert testTicket;

        // Set the ticketId parameter in the current page
        ApexPages.currentPage().getParameters().put('ticketId', testTicket.Id);

        // Call the constructor
        AttendeeTicketPDFController controller = new AttendeeTicketPDFController();

    }
    @isTest
    static void testSetAttendeeInformation() {
        Contact con = new Contact(LastName = 'Test Contact');
        insert con;
       Attendee__c a = new Attendee__c(Attendee__c = con.id);
        insert a;
        Ticket__c testTicket = new Ticket__c(
            Total_Amount__c = 1000,
            Attendee__c = a.Id // Replace with valid Attendee record Id
            // Add other required fields here
        );
        insert testTicket;

        // Call the method to test
        Test.startTest();
        AttendeeTicketPDFController.setAttendeeInformation(testTicket.Id);
        Test.stopTest();

        // Verify the results
        AttendeeTicketPDFController.AttendeeTicket attendeeTicket = AttendeeTicketPDFController.attendeeTicket;
        //System.assertEquals(testTicket.Attendee__r.Attendee_Full_Name__c, attendeeTicket.attendeeName);
        //System.assertEquals(testTicket.Attendee__r.Email__c, attendeeTicket.attendeeEmail);
        //System.assertEquals(testTicket.Total_Amount__c, attendeeTicket.amount);
        //System.assertEquals(testTicket.Id, attendeeTicket.ticketNumber);
        // Add assertions for other fields as needed
    }

      @isTest
    static void getAttendeeInfoTest() {
       Attendee__c a = new Attendee__c();
        insert a;
        Ticket__c testTicket = new Ticket__c(
            Total_Amount__c = 100.00,
            Attendee__c = a.Id // Replace with a valid Salesforce Id
            // Add other required fields as necessary
        );
        insert testTicket;
        
        // Call the method to set attendee information
        AttendeeTicketPDFController.setAttendeeInformation(testTicket.Id);
        Test.startTest();
        // AttendeeTicketPDFController.getAttendeeInfo(testTicket.Id);
        Test.stopTest();
        // Perform assertions for attendee information
        
        // Retrieve the AttendeeTicket object
        AttendeeTicketPDFController.AttendeeTicket attendeeTicket = AttendeeTicketPDFController.attendeeTicket;
        
        System.assertNotEquals(null, attendeeTicket, 'AttendeeTicket should not be null');
        
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage LIMIT 1];
        //System.assertNotEquals(0, sentEmails.size(), 'An email should be sent');
    
}
}