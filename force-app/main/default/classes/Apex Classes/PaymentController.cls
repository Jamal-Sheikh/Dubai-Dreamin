public class PaymentController {
//  private static final string END_POINT = 'callout:Stripe_Named_Credential/prices?product=prod_PxAqJp1tlD3T3u&active=true';
 private static final string END_POINT = 'callout:Stripe_Named_Credential/prices?product=prod_PpDICfjTRUlPCP&active=true';

@AuraEnabled(cacheable=true)
public static List<Price> retrievePrice() {
    List<Price> pricesList;
    List<Price> ticketsWithDates = new List<Price>();
   

    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();

  
    req.setEndPoint(END_POINT);
    req.setMethod('GET');
  
    res = http.send(req);

    if (res.getStatusCode() == 200) {
        pricesList = PriceParser.parsePrices(res.getBody());
        
        System.debug(pricesList);
        List<Ticket_Configuration__mdt> ticketConfigs = [ SELECT Ticket_Name__c,Description__c, Expiry_Date__c, 	Activation_Date__c, active__c FROM Ticket_Configuration__mdt ];
       
        
        Map<String, Ticket_Configuration__mdt> ticketConfigMap = new Map<String, Ticket_Configuration__mdt>();
        for (Ticket_Configuration__mdt config : ticketConfigs) {
            ticketConfigMap.put(config.Ticket_Name__c, config);
        }
     

        for (Price ticket : pricesList) {
            if (ticket.unitAmount != null) {
          
                Ticket_Configuration__mdt config = ticketConfigMap.get(ticket.nickname);
               
                Date currentDate = Date.TODAY();

                if (config != null) {
                    ticket.expiryDate = config.Expiry_Date__c;
                    ticket.activationDate = config.Activation_Date__c;
                    ticket.active = config.Activation_Date__c < currentDate && config.Expiry_Date__c > currentDate;
                    ticket.description = config.Description__c;
                    ticketsWithDates.add(ticket);
                }
            }
        }
      
    }
    System.debug('Tickets: ' + ticketsWithDates);
    return ticketsWithDates;
}


 
  
}