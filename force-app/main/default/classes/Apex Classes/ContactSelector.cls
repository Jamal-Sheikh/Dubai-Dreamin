/**
* @author: Muhammad Raza    
* @description: Selector class for contacts
* @since: Feb-2024  
* @Last Modified by: Muhammad Raza 
*/
public with sharing class ContactSelector {

    /**
    * @author: Muhammad Raza    
    * @description: Queries the contact using Email
    * @param  String Email
    * @return: List<Contact>
    */
    public static List<Contact> getContacts(String whereClause){
        String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;

        String query = 'SELECT Id, Name FROM Contact ' + clause;
        
        List<Contact> result = Database.query(String.valueOf(query));
        return result;
    }

    /**
 * Queries the contact based on the provided email.
 * @param email The email to query contacts.
 * @return List of contacts matching the provided email.
 */
public static List<Contact> getContactsByEmail(String email){
    String clause = 'Email = \''+email+'\' ';
    		System.debug(clause);

       List<Contact>  contacts = getContacts(clause);
		System.debug(contacts);
        return contacts;
}

 

}