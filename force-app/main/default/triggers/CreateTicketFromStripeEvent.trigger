trigger CreateTicketFromStripeEvent on stripeGC__Stripe_Event__c (after insert) {
    List<ticket__c> ticketsToInsert = new List<ticket__c>();
    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

    for (stripeGC__Stripe_Event__c eventRecord : Trigger.new) {
      if (eventRecord.stripeGC__Request_Body__c != null  && eventRecord.stripeGC__Event_Name__c=='checkout.session.completed') {
        if (eventRecord.stripeGC__Request_Body__c != null) {
            Map<String, Object> eventData = (Map<String, Object>) JSON.deserializeUntyped(eventRecord.stripeGC__Request_Body__c);
            
            if (eventData.containsKey('data')) {
                Map<String, Object> dataMap = (Map<String, Object>) eventData.get('data');
                
                if (dataMap.containsKey('object')) {
                    Map<String, Object> objectMap = (Map<String, Object>) dataMap.get('object');
                    
                    if (objectMap.containsKey('client_reference_id')) {
                        String clientReferenceId = (String) objectMap.get('client_reference_id');
                    //    Integer amountTotal = (Integer) objectMap.get('amount_total');
						
                        Decimal amountTotal = (Decimal) objectMap.get('amount_total');
						Decimal decimalAmountTotal = amountTotal.divide(100, 2);
                        
                        // Create ticket record
                        ticket__c newTicket = new ticket__c();
                        newTicket.Attendee__c = clientReferenceId;
                        newTicket.TransactionID__c = eventRecord.Id;
                        newTicket.Total_Amount__c = decimalAmountTotal;
                        ticketsToInsert.add(newTicket);

                    }
                }
            }
        }
        if (!ticketsToInsert.isEmpty()) {
            insert ticketsToInsert;
        }
    }
    
   
    }
    AttendeeTicketPDFController.getAttendeeInfo(ticketsToInsert.get(0).Id);

}