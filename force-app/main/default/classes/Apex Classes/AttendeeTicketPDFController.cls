public class AttendeeTicketPDFController {
    public static AttendeeTicket attendeeTicket { get; set; } // Change to static
    
    public class AttendeeTicket  {
        public String ticketNumber { get; set; }
        public Decimal amount { get; set; }
        public String attendeeName { get; set; }
        public String attendeeEmail { get; set; } 
        public String eventName { get; set; } 
        public String createdDate { get; set; } 
        public String createdTime { get; set; } 
        public String qrCode {get;set; }
        
    }
    
    public AttendeeTicketPDFController() {
        String ticketId = ApexPages.currentPage().getParameters().get('ticketId');
        setAttendeeInformation(ticketId);
    }
    
    public static void setAttendeeInformation(Id recordId) {
        System.debug('@@setAttendeeInformation'+recordId);
           attendeeTicket = new AttendeeTicket();
      
    //   String DateStr = String.valueOf(nowTime.date());
    //   String timeStr = String.valueOf(nowTime.time());
    
      Ticket__c ticketInfo = [SELECT Id,Name, Total_Amount__c, CreatedDate, Attendee__c, Attendee__r.Dubai_Dreamin_QR_Code__c, Attendee__r.Attendee_Full_Name__c,Attendee__r.Email__c, Attendee__r.Event__r.Name FROM Ticket__c WHERE Id =: recordId];
             
        attendeeTicket.attendeeName = ticketInfo.Attendee__r.Attendee_Full_Name__c; 
        attendeeTicket.attendeeEmail = ticketInfo.Attendee__r.Email__c;
        attendeeTicket.amount = ticketInfo.Total_Amount__c;
        attendeeTicket.ticketNumber = ticketInfo.Name;
		attendeeTicket.eventName =  ticketInfo.Attendee__r.Event__r.Name;
		DateTime dateTimeIn  =  ticketInfo.CreatedDate;
       attendeeTicket.createdDate = String.valueOf(dateTimeIn.date());
       attendeeTicket.createdTime = String.valueOf(dateTimeIn.time());
        attendeeTicket.qrCode = ticketInfo.Attendee__r.Dubai_Dreamin_QR_Code__c;
    }
    
   // @InvocableMethod(label='Get Attendee Info')

  @future(callout = true)
    // public static void getAttendeeInfo(List<String> recordIds) {
    public static void getAttendeeInfo(String recordId) {
        System.debug(recordId);
        PageReference pg = new Pagereference('/apex/TicketPage?ticketId=' + recordId);
        pg.setRedirect(false);
        Blob pageContent;
        if(Test.isRunningTest()){
           pageContent = blob.valueOf('Unit.Test');
        } else {
           pageContent = pg.getContent();
        }
        
        ContentVersion conVer = new ContentDocumentUtils().constructContentVersion(pageContent,'Attendee_Ticket.pdf');
        insert conVer;
        
        List<ContentVersion> contentVersions = new ContentVersionSelector().getContentVersion('Id = \'' + conVer.Id + '\'');
        
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = recordId;
        conDocLink.ContentDocumentId = contentVersions.get(0).ContentDocumentId;
        conDocLink.shareType = 'V';
        conDocLink.Visibility='AllUsers';
        insert conDocLink;        
        
         setAttendeeInformation(recordId);
        
      

        Ticket__c ticket = [Select Id, Attendee__c, Attendee__r.Attendee__c from Ticket__c where Id =: recordId];
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
        EmailTemplate template =   [SELECT Id, Subject, Body, DeveloperName FROM EmailTemplate WHERE DeveloperName = 'Send_Email_To_Approved_Attendee_1713770888415' ];

        Messaging.SingleEmailMessage myEmail=new  Messaging.SingleEmailMessage();
        // Sending Email Attachment
        Messaging.EmailFileAttachment emailFileAttachment= new Messaging.EmailFileAttachment();
        emailFileAttachment.setFileName('Attendee');
        // myEmail.setSubject('Attendee Registration Successfull');        
       	myEmail.setTemplateId(template.Id);
        myEmail.setWhatId(ticket.Attendee__c);
        // myEmail.setHTMLBody(template.body);
       myEmail.setTargetObjectId(ticket.Attendee__r.Attendee__c);
        myEmail.setToAddresses(new String[]{attendeeTicket.attendeeEmail}); 
        // myEmail.setToAddresses(new String[]{'mrehman@cloud-1.co', 'aneela@cloud-1.co'}); 
        myEmail.setEntityAttachments(new List<Id>{contentVersions.get(0).Id});
         myEmail.setOrgWideEmailAddressId(owa.id); 
        
        if (!Test.isRunningTest()) {
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{myEmail});            
        }
    }
}