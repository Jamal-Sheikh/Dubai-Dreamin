/**
 * 
 * @author MUhammad Faraz
 * @since May 2 2024
 */
global class EmailController {

    global class FlowInputs{
    
        // @InvocableVariable
        // public Account accountSobj;
        
        @InvocableVariable(label='Speaker IDs' required = true)
        global List<id> ids;


        @InvocableVariable(label='Flow Type' required = true)
    global String flowType; 
    }
    /**
     * @description sends email to approved speaker based on flow input
     * @param request contains parameter from flows that were recevied in the invocable variables of inner class
     */
    @InvocableMethod(label='Send Submission Emails to Speakers' )
    public static void sendSubmissionEmails(List<FlowInputs> request){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
     //   SessionSpeakerSelector selectorObj = new SessionSpeakerSelector();
    //  List<Session_Speaker__c> sessionSpeakers = selectorObj.getSessionSpeakerBySpeakerIds(ids[0]);

    List<Speaker__c> speakers = [Select id,Email__c,Speaker_Name__c from Speaker__c where id IN: request[0].ids ];
    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
   


    if(request[0].flowType=='Opening'){
    List<Dubai_Dreamin_Timeline__mdt> deadline  = [Select id, Branding_Material_Delivery_Date__c, Speaker_Material_Submission_Date__c from Dubai_Dreamin_Timeline__mdt];
    String formattedDate = deadline[0].Speaker_Material_Submission_Date__c.day() + ' ' + getMonthName(deadline[0].Speaker_Material_Submission_Date__c.month()) + ', ' + String.valueOf(deadline[0].Speaker_Material_Submission_Date__c.year());
  //  EmailTemplate template =   [SELECT Id, Subject, Body, DeveloperName FROM EmailTemplate WHERE DeveloperName = 'Send_Email_To_Approved_Attendee_1713770888415' ];
  // ContentVersion contentVersions = [Select id from contentversion limit 1];
  StaticResource sr = [Select  Name, Id, Body From StaticResource where Name = 'dubaiSpeakerBrandingMaterial'];

  Blob tempBlob = sr.Body;
    for(Speaker__c speaker:speakers) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        Messaging.EmailFileAttachment emailFileAttachment= new Messaging.EmailFileAttachment();
       // emailFileAttachment.setFileName('Dubai Dreamin \'24 Submission Template');
       	// myEmail.setTemplateId(template.Id);
       email.setSubject('Important: Dubai Dreamin’24 Presentation Materials');
    //    email.setHtmlBody('<div class="wrapper"> <!-- Main table --> <table border="0" align="center" cellspacing="0" cellpadding="0" bgcolor="#EAF3FE" width="650" style="margin: auto; border-radius:20px; padding:50px 25px 40px"> <tr> <td> <!-- Child table --> <table border="0" cellspacing="0" cellpadding="0" style="color:#0f3462; font-family: sans-serif;"> <tr> <td> <img src="https://i.imgur.com/aK4EdrM.png" height="50px" width="280" style="display:block; margin:auto;padding-bottom: 50px;height:auto;  "> </td> </tr> <tr> <td style=""> <p style=" padding-bottom: 5px ; font-size: 14px;">Dear <b>'+speaker.Speaker_Name__c+'</b> </p> <p style=" font-size: 14px; padding:0px"> I hope this email finds you well. As a confirmed speaker for Dubai Dreamin \'24 we greatly appreciate your participation and contribution to our upcoming event. We are eagerly looking forward to your presentation, which we know will be invaluable to our attendees. </p> <p style=" font-size: 14px; padding:0px"> We kindly remind you that the deadline for submitting your presentation is fast approaching. Your session materials should be submitted no later than [Submission last date]. This deadline is crucial for ensuring that we can properly organize and prepare all sessions for the event.</p> <p style=" font-size: 14px; padding:0px"> If you have already submitted your presentation, we sincerely thank you for your promptness and cooperation. However, if you have not yet done so, we kindly request that you take a moment to finalize and upload your materials to our system as soon as possible.</p>  <p style=" font-size: 14px; padding:0px"> Should you encounter any difficulties or require any assistance with the submission process, please do not hesitate to reach out to us. We are here to support you in any way we can to ensure a smooth and successful experience for both you and our attendees.</p> <p style=" font-size: 14px; padding:0px">   Thank you once again for your participation in Dubai Dreamin \'24. We truly appreciate your expertise and dedication to making this event a success. </p>  <p style=" font-size: 14px; padding:0px"> </td> </tr> <tr> <td> <!-- <p style="font-size: 14px;">Thank you once again for considering sponsorship with us. We look forward to the possibility of collaborating with you creating a mutually beneficial partnership.</p> --> </td> </tr> <tr> <td> <p style="font-size: 14px; padding:0px"><b>Best,</b></p> <p style="font-size: 14px; padding:0px">Team Dubai Dreamin</p> </td> </tr> </table> <!-- /Child table --> </td> </tr> </table> <!-- / Main table --> </div>');
       email.setHtmlBody('<div class="wrapper"> <table align="center" bgcolor="#EAF3FE" border="0" cellpadding="0" cellspacing="0" style="margin: auto; border-radius:20px; padding:50px 25px 40px" width="650"> <tbody> <tr> <td> <table border="0" cellpadding="0" cellspacing="0" style="color:#0f3462; font-family: sans-serif;"> <tbody> <tr> <td><img height="50px" src="https://i.imgur.com/aK4EdrM.png" style="display:block; margin:auto;padding-bottom: 50px;height:auto;" width="280" /></td> </tr> <tr> <td style=""> <p style="padding-bottom: 5px ; font-size: 14px;">Dear '+speaker.Speaker_Name__c+',</p> <p style="font-size: 14px; padding:0px">We hope this message finds you well.</p> <p style="font-size: 14px; padding:0px">As a confirmed speaker for Dubai Dreamin &#39;24, we&#39;re excited to have you join us for the event. To ensure a smooth and efficient process for all speakers, we kindly request that you use the following PowerPoint (PPT) template attached to this email.</p> <!-- <p style="font-size: 14px; padding:0px"><a href="[Insert link to the PowerPoint template here]">[Insert link to the PowerPoint template here] </a></p> --> <p style="font-size: 14px; padding:0px">Please duplicate the provided presentation to tailor your session.</p> <p style="font-size: 14px; padding:0px"><b>The deadline for session submission is '+formattedDate+'. </b></p> <p style="font-size: 14px; padding:0px">Furthermore, please utilize the attached PowerPoint to advertise your session effectively on social media.</p> <p style="font-size: 14px; padding:0px">If you have any questions or need further assistance, please don&#39;t hesitate to reach out to us.</p> <p style="font-size: 14px; padding:0px">Thank you for your cooperation, and we look forward to your presentation at Dubai Dreamin &#39;24.</p><!-- <p style="font-size: 14px; padding:0px">&nbsp;</p> --> </td> </tr><!-- <tr> <td>&nbsp;</td> </tr>--> <tr> <td> <p style="font-size: 14px; padding:0px">Best,</p> <p style="font-size: 14px; padding:0px">Team Dubai Dreamin.</p> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </div>');
        email.setToAddresses(new String[] { (String) speaker.Email__c });
        email.setOrgWideEmailAddressId(owa.id); 

        emailFileAttachment.setBody(tempBlob);

        emailFileAttachment.setFileName('DubaiDreaminSpeakerTemplate.pptx');

        email.setFileAttachments(new Messaging.EmailFileAttachment[] {emailFileAttachment});
        // email.setEntityAttachments(new List<Id>{contentVersions.Id});
       
       
       
       
       
        // myEmail.setTargetObjectId(ticket.Attendee__r.Attendee__c);
        // myEmail.setWhatId(ticket.Attendee__c);
        // myEmail.setTemplateId(template.Id);

        emails.add(email);
        

      }

    }
    else if(request[0].flowType=='Reminder'){
    List<Timeline__c> deadline  = [Select id, date__c, Name from Timeline__c where name='Speaker Submission Deadline'];
    String formattedDate = deadline[0].Date__c.day() + ' ' + getMonthName(deadline[0].Date__c.month()) + ', ' + String.valueOf(deadline[0].Date__c.year());
  //  EmailTemplate template =   [SELECT Id, Subject, Body, DeveloperName FROM EmailTemplate WHERE DeveloperName = 'Send_Email_To_Approved_Attendee_1713770888415' ];
  // ContentVersion contentVersions = [Select id from contentversion limit 1];
    for(Speaker__c speaker:speakers) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

    //    Messaging.EmailFileAttachment emailFileAttachment= new Messaging.EmailFileAttachment();
     //   emailFileAttachment.setFileName('Dubai Dreamin \'24 Submission Template');
       email.setSubject('Reminder: Submission Deadline for Your Presentation');
    //    email.setHtmlBody('<div class="wrapper"> <!-- Main table --> <table border="0" align="center" cellspacing="0" cellpadding="0" bgcolor="#EAF3FE" width="650" style="margin: auto; border-radius:20px; padding:50px 25px 40px"> <tr> <td> <!-- Child table --> <table border="0" cellspacing="0" cellpadding="0" style="color:#0f3462; font-family: sans-serif;"> <tr> <td> <img src="https://i.imgur.com/aK4EdrM.png" height="50px" width="280" style="display:block; margin:auto;padding-bottom: 50px;height:auto;  "> </td> </tr> <tr> <td style=""> <p style=" padding-bottom: 5px ; font-size: 14px;">Dear <b>'+speaker.Speaker_Name__c+'</b> </p> <p style=" font-size: 14px; padding:0px"> I hope this email finds you well. As a confirmed speaker for Dubai Dreamin \'24 we greatly appreciate your participation and contribution to our upcoming event. We are eagerly looking forward to your presentation, which we know will be invaluable to our attendees. </p> <p style=" font-size: 14px; padding:0px"> We kindly remind you that the deadline for submitting your presentation is fast approaching. Your session materials should be submitted no later than [Submission last date]. This deadline is crucial for ensuring that we can properly organize and prepare all sessions for the event.</p> <p style=" font-size: 14px; padding:0px"> If you have already submitted your presentation, we sincerely thank you for your promptness and cooperation. However, if you have not yet done so, we kindly request that you take a moment to finalize and upload your materials to our system as soon as possible.</p>  <p style=" font-size: 14px; padding:0px"> Should you encounter any difficulties or require any assistance with the submission process, please do not hesitate to reach out to us. We are here to support you in any way we can to ensure a smooth and successful experience for both you and our attendees.</p> <p style=" font-size: 14px; padding:0px">   Thank you once again for your participation in Dubai Dreamin \'24. We truly appreciate your expertise and dedication to making this event a success. </p>  <p style=" font-size: 14px; padding:0px"> </td> </tr> <tr> <td> <!-- <p style="font-size: 14px;">Thank you once again for considering sponsorship with us. We look forward to the possibility of collaborating with you creating a mutually beneficial partnership.</p> --> </td> </tr> <tr> <td> <p style="font-size: 14px; padding:0px"><b>Best,</b></p> <p style="font-size: 14px; padding:0px">Team Dubai Dreamin</p> </td> </tr> </table> <!-- /Child table --> </td> </tr> </table> <!-- / Main table --> </div>');
       email.setHtmlBody('<div class="wrapper"> <table align="center" bgcolor="#EAF3FE" border="0" cellpadding="0" cellspacing="0" style="margin: auto; border-radius:20px; padding:50px 25px 40px" width="650"> <tbody> <tr> <td> <table border="0" cellpadding="0" cellspacing="0" style="color:#0f3462; font-family: sans-serif;"> <tbody> <tr> <td><img height="50px" src="https://i.imgur.com/aK4EdrM.png" style="display:block; margin:auto;padding-bottom: 50px;height:auto;" width="280" /></td> </tr> <tr> <td style=""> <p style="padding-bottom: 5px ; font-size: 14px;">Dear &#39;+speaker.Speaker_Name__c+&#39;,</p> <p style="font-size: 14px; padding:0px">We hope this message finds you well.</p> <p style="font-size: 14px; padding:0px">As a confirmed speaker for Dubai Dreamin &#39;24 we greatly appreciate your participation and contribution to our upcoming event. We are eagerly looking forward to your presentation, which we know will be invaluable to our attendees.</p> <!-- <p style="font-size: 14px; padding:0px"><a href="[Insert link to the PowerPoint template here]">[Insert link to the PowerPoint template here] </a></p> --> <p style="font-size: 14px; padding:0px">We kindly remind you that the deadline for submitting your presentation is fast approaching. Your session materials should be submitted no later than '+formattedDate+'. This deadline is crucial for ensuring that we can properly organize and prepare all sessions for the event.</p> <p style="font-size: 14px; padding:0px">If you have already submitted your presentation, we sincerely thank you for your promptness and cooperation. However, if you have not yet done so, we kindly request that you take a moment to finalize and upload your materials to our system as soon as possible.</p> <p style="font-size: 14px; padding:0px">Should you encounter any difficulties or require any assistance with the submission process, please do not hesitate to reach out to us. We are here to support you in any way we can to ensure a smooth and successful experience for both you and our attendees.</p> <p style="font-size: 14px; padding:0px">Thank you once again for your participation in Dubai Dreamin &#39;24. We truly appreciate your expertise and dedication to making this event a success.</p> <!--<p style="font-size: 14px; padding:0px">Thank you for your cooperation, and we look forward to your presentation at Dubai Dreamin &#39;24.</p>--><!-- <p style="font-size: 14px; padding:0px">&nbsp;</p> --></td> </tr> <!-- <tr> <td>&nbsp;</td> </tr> <tr> --> <tr> <td> <p style="font-size: 14px; padding:0px">Best,</p> <p style="font-size: 14px; padding:0px">Team Dubai Dreamin.</p> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </div>');
        email.setToAddresses(new String[] { (String) speaker.Email__c });
        email.setOrgWideEmailAddressId(owa.id); 
     //   email.setEntityAttachments(new List<Id>{contentVersions.Id});
        
        emails.add(email);
        

      }

    }
    else if(request[0].flowType=='PostDeadline'){
    List<Timeline__c> deadline  = [Select id, date__c, Name from Timeline__c where name='Speaker Submission Deadline'];
    String formattedDate = deadline[0].Date__c.day() + ' ' + getMonthName(deadline[0].Date__c.month()) + ', ' + String.valueOf(deadline[0].Date__c.year());
  //  EmailTemplate template =   [SELECT Id, Subject, Body, DeveloperName FROM EmailTemplate WHERE DeveloperName = 'Send_Email_To_Approved_Attendee_1713770888415' ];
  // ContentVersion contentVersions = [Select id from contentversion limit 1];
    for(Speaker__c speaker:speakers) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

     //   Messaging.EmailFileAttachment emailFileAttachment= new Messaging.EmailFileAttachment();
     //   emailFileAttachment.setFileName('Dubai Dreamin \'24 Submission Template');
       email.setSubject('Reminder: Submission Deadline for Your Presentation');
    //    email.setHtmlBody('<div class="wrapper"> <!-- Main table --> <table border="0" align="center" cellspacing="0" cellpadding="0" bgcolor="#EAF3FE" width="650" style="margin: auto; border-radius:20px; padding:50px 25px 40px"> <tr> <td> <!-- Child table --> <table border="0" cellspacing="0" cellpadding="0" style="color:#0f3462; font-family: sans-serif;"> <tr> <td> <img src="https://i.imgur.com/aK4EdrM.png" height="50px" width="280" style="display:block; margin:auto;padding-bottom: 50px;height:auto;  "> </td> </tr> <tr> <td style=""> <p style=" padding-bottom: 5px ; font-size: 14px;">Dear <b>'+speaker.Speaker_Name__c+'</b> </p> <p style=" font-size: 14px; padding:0px"> I hope this email finds you well. As a confirmed speaker for Dubai Dreamin \'24 we greatly appreciate your participation and contribution to our upcoming event. We are eagerly looking forward to your presentation, which we know will be invaluable to our attendees. </p> <p style=" font-size: 14px; padding:0px"> We kindly remind you that the deadline for submitting your presentation is fast approaching. Your session materials should be submitted no later than [Submission last date]. This deadline is crucial for ensuring that we can properly organize and prepare all sessions for the event.</p> <p style=" font-size: 14px; padding:0px"> If you have already submitted your presentation, we sincerely thank you for your promptness and cooperation. However, if you have not yet done so, we kindly request that you take a moment to finalize and upload your materials to our system as soon as possible.</p>  <p style=" font-size: 14px; padding:0px"> Should you encounter any difficulties or require any assistance with the submission process, please do not hesitate to reach out to us. We are here to support you in any way we can to ensure a smooth and successful experience for both you and our attendees.</p> <p style=" font-size: 14px; padding:0px">   Thank you once again for your participation in Dubai Dreamin \'24. We truly appreciate your expertise and dedication to making this event a success. </p>  <p style=" font-size: 14px; padding:0px"> </td> </tr> <tr> <td> <!-- <p style="font-size: 14px;">Thank you once again for considering sponsorship with us. We look forward to the possibility of collaborating with you creating a mutually beneficial partnership.</p> --> </td> </tr> <tr> <td> <p style="font-size: 14px; padding:0px"><b>Best,</b></p> <p style="font-size: 14px; padding:0px">Team Dubai Dreamin</p> </td> </tr> </table> <!-- /Child table --> </td> </tr> </table> <!-- / Main table --> </div>');
       email.setHtmlBody('<div class="wrapper"> <table align="center" bgcolor="#EAF3FE" border="0" cellpadding="0" cellspacing="0" style="margin: auto; border-radius:20px; padding:50px 25px 40px" width="650"> <tbody> <tr> <td> <table border="0" cellpadding="0" cellspacing="0" style="color:#0f3462; font-family: sans-serif;"> <tbody> <tr> <td><img height="50px" src="https://i.imgur.com/aK4EdrM.png" style="display:block; margin:auto;padding-bottom: 50px;height:auto;" width="280" /></td> </tr> <tr> <td style=""> <p style="padding-bottom: 5px ; font-size: 14px;">Dear &#39;+speaker.Speaker_Name__c+&#39;,</p> <p style="font-size: 14px; padding:0px">We hope this email finds you well. As a confirmed speaker for Dubai Dreamin &#39;24, we would like to kindly remind you of the upcoming submission deadline for your presentation.</p> <p style="font-size: 14px; padding:0px">The deadline for submitting your presentation is '+formattedDate+'. It&#39;s crucial that we receive your presentation at the earliest to ensure smooth coordination and preparation for the event.</p> <!-- <p style="font-size: 14px; padding:0px"><a href="[Insert link to the PowerPoint template here]">[Insert link to the PowerPoint template here] </a></p> --> <p style="font-size: 14px; padding:0px">Should you encounter any challenges or require assistance with your presentation submission, please don&#39;t hesitate to reach out to us. We&#39;re here to support you every step of the way.</p> <p style="font-size: 14px; padding:0px">Thank you for your attention to this matter, and we look forward to your valuable contribution to Dubai Dreamin &#39;24.</p> <!--<p style="font-size: 14px; padding:0px">Thank you for your cooperation, and we look forward to your presentation at Dubai Dreamin &#39;24.</p>--><!-- <p style="font-size: 14px; padding:0px">&nbsp;</p> --></td> </tr> <!-- <tr> <td>&nbsp;</td> </tr> <tr> --> <tr> <td> <p style="font-size: 14px; padding:0px">Best,</p> <p style="font-size: 14px; padding:0px">Team Dubai Dreamin.</p> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </div>');
        email.setToAddresses(new String[] { (String) speaker.Email__c });
        email.setOrgWideEmailAddressId(owa.id); 
     //   email.setEntityAttachments(new List<Id>{contentVersions.Id});
        
        emails.add(email);
        

      }

    }

      Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);

      for (Messaging.SendEmailResult result : results) {
          if (result.isSuccess()) {
              // Email sent successfully
              System.debug('Email sent successfully');
          } else {
              // Handle any errors or exceptions
              System.debug('Error sending email: ' + result.getErrors()[0].getMessage());
          }
      }

    }

    

    public static String getMonthName(Integer monthNumber) {
        // Define month names in the desired format
        String[] monthNames = new String[]{'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};
        // Return the month name corresponding to the month number
        return monthNames[monthNumber - 1];
    }
}