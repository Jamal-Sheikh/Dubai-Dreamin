/**
 *@author: Fatima
* @description: For retrieving ticket records
* @since: 07/05/24
 */

public without sharing class TicketSelector {

    /**
     * @description Executes a query to retrieve tickets based on the provided WHERE clause
     * @param whereClause 
     * @return  `List<Ticket__c>`
     */
    private static List<Ticket__c> getTickets(String whereClause,Set<Id> attendeeIds) {
        String clause = whereClause != null ? ' WHERE ' + whereClause : '';
        String query = 'SELECT Attendee__c, Total_Amount__c,TransactionId__c FROM Ticket__c ' + clause;
        return Database.query(query);
    }

    private static List<Ticket__c> getTicket(String whereClause) {
        String clause = whereClause != null ? ' WHERE ' + whereClause : '';
        String query = 'SELECT Attendee__c, Total_Amount__c,TransactionId__c FROM Ticket__c ' + clause;
        return Database.query(query);
    }


    public static Map<Id, Decimal> getTicketAmounts(Set<Id> attendeeIds) {
        Map<Id, Decimal> ticketAmountMap = new Map<Id, Decimal>();
        String whereClause = 'Attendee__c IN :attendeeIds';
        
        for (Ticket__c ticket : getTickets(whereClause,attendeeIds)) {
            ticketAmountMap.put(ticket.Attendee__c, ticket.Total_Amount__c);
        }
        
        return ticketAmountMap;
    }
    

/**
 * @description Retrieving TransacionId from ticket based on attendee Id
 * @param attendeeId 
 * @return  `Ticket__c`
 */
   
    public Ticket__c getTicketByAttendeeId(Id attendeeId) {

        String clause =  ' Attendee__c = \'' + attendeeId + '\'';
        List<Ticket__c> ticket = getTicket(clause);
        if (ticket.size() > 0) {
             return ticket.get(0);
        }
        return null;
    
      
    }
}