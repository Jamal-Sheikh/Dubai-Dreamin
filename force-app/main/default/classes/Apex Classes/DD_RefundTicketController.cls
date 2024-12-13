/**
 * @author Fatima
 * @description Controller to process ticket amount refund
 * @since 07/05/24
 */
public class DD_RefundTicketController {

    public class FlowInput {
        @InvocableVariable
        public Id recordId;
    }

    public class RefundResult {
        @InvocableVariable
        public Integer statusCode;
        @InvocableVariable
        public String message;
        @InvocableVariable
        public String responseBody;
        // @InvocableVariable
        // public String refundTransactionId;
    }

    @InvocableMethod(label='Process Refund' description='Process refund for the ticket')
    public static List<RefundResult> processRefund(List<FlowInput> flowInputs) {
        List<RefundResult> results = new List<RefundResult>();

        for (FlowInput flowInput : flowInputs) {
            SpeakerSelector speakerSelector = new SpeakerSelector();
            Speaker__c speaker = speakerSelector.getSpeakerById(flowInput.recordId);
            if (speaker != null && speaker.Attendee__c != null) {
                TicketSelector ticketSelector = new TicketSelector();
                Ticket__c ticket = ticketSelector.getTicketByAttendeeId(speaker.Attendee__c);
                if (ticket != null && ticket.TransactionId__c != null) {
                    StripeEventSelector stripeEventSelector = new StripeEventSelector();
                    stripeGC__Stripe_Event__c stripeEvent = stripeEventSelector.getStripeEventById(ticket.TransactionId__c);
                    if (stripeEvent != null && stripeEvent.stripeGC__Request_Body__c != null) {
                        Map<String, Object> requestBodyMap = (Map<String, Object>) JSON.deserializeUntyped(stripeEvent.stripeGC__Request_Body__c);
                        System.debug('Response Body  '+requestBodyMap);

                        String paymentIntent = (String) ((Map<String, Object>) ((Map<String, Object>) requestBodyMap.get('data')).get('object')).get('payment_intent');
                       
                        // Integer ticketAmount = (speaker.Ticket_Amount__c * 100).intValue();
                        Integer ticketAmount = (speaker.Amount_To_Be_Refund__c * 100).intValue();
                        System.debug('ticketAmount: '+ticketAmount);
                        System.debug('paymentIntent: '+paymentIntent);

                       
                        RefundResult result = callRefundAPI(paymentIntent, ticketAmount);
                        if (result.statusCode == 200) {
                            
                            System.debug('Response Body  '+result.responseBody);
                            Map<String, Object> requestResponseMap = (Map<String, Object>) JSON.deserializeUntyped(result.responseBody);
                            System.debug('Response Body  '+requestResponseMap);
                           
                            String transactionId = (String) requestResponseMap.get('balance_transaction');
                            
                             speaker.Refund_Transaction_Id__c=transactionId;
                            speaker.Amount_To_Be_Refund__c -= (ticketAmount / 100.00);
                            speaker.Payment_Status__c='Refunded';
                            update speaker;
                        }
                        results.add(result);
                    } else {
                        System.debug('Stripe Event record not found or RequestBody__c is null');
                    }
                } else {
                    System.debug('Ticket record not found or TransactionId__c is null');
                }
            } else {
                System.debug('Speaker record not found or Attendee__c is null');
            }
        }
        return results;
    }

    /**
     * @description hitting stripe refund api for specific payment intent and amount
     * @param paymentIntent 
     * @param ticketAmount 
     * @return RefundResult
     */
    private static RefundResult callRefundAPI(String paymentIntent, Decimal ticketAmount) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        RefundResult result = new RefundResult();
    
        req.setEndPoint('callout:Stripe_Named_Credential/refunds');
        req.setMethod('POST');

         // req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    
        String body = 'payment_intent=' + EncodingUtil.urlEncode(paymentIntent, 'UTF-8') + '&amount=' + ticketAmount;
        req.setBody(body);
    //req.setHeader('Authorization', 'Bearer ' + API_KEY);
    // req.setHeader('Authorization', 'Bearer ' + '{!$Credential.Stripe_External_Credential.key}');
        res = http.send(req);
    
        result.statusCode = res.getStatusCode();
        result.responseBody=res.getBody();
        
        Map<String, Object> responseBodyMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        if (responseBodyMap.containsKey('error')) {
            Map<String, Object> errorMap = (Map<String, Object>) responseBodyMap.get('error');
            if (errorMap.containsKey('message')) {
                result.message = (String) errorMap.get('message');
            }
        } else {

            // String transacId = (String) ((Map<String, Object>) ((Map<String, Object>) responseBodyMap.get('data'))).get('balance_transaction');
            // result.refundTransactionId=transacId;

           result.message = 'Refund successful';
           
        }
    
        return result;
    }
    
}