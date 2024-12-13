/**
 *@author: Fatima
* @description: For retrieving Stripe Event record
* @since: 07/05/24
 */

public without sharing class StripeEventSelector {
   
/**
 * @description Soql for Stripe event record
 * @param whereClause 
 * @return  `List<stripeGC__Stripe_Event__c>`
 */
    private static List<stripeGC__Stripe_Event__c> getStripeEvent(String whereClause) {
        String clause = whereClause != null ? ' WHERE ' + whereClause : '';
        String query = 'SELECT stripeGC__Request_Body__c FROM stripeGC__Stripe_Event__c ' + clause;
        return Database.query(query);
    }

    /**
     * @description Retrieving stripe event record based on transaction id of a ticket
     * @param Id 
     * @return  `stripeGC__Stripe_Event__c`
     */
    public stripeGC__Stripe_Event__c getStripeEventById(String Id) {

        String clause =  ' Id = \'' + Id + '\'';
        List<stripeGC__Stripe_Event__c> stripeEvent = getStripeEvent(clause);
        if (stripeEvent.size() > 0) {
             return stripeEvent.get(0);
        }
        return null;
    
      
    }
}