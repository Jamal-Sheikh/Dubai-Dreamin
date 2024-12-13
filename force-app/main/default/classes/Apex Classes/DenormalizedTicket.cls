public with sharing class DenormalizedTicket {
    
    @AuraEnabled public String id;
    @AuraEnabled public String ticketTitle;
    @AuraEnabled public String ticketPrice;
   @AuraEnabled public String ticketVatTex;
   @AuraEnabled public String ticketDescription;
   @AuraEnabled public String quantity;

}