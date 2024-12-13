/**
* @author: Muhammad Raza
* @description: Apex class for retrieving session information.
* @since: 01/01/24
* @Last Modified by:  Muhammad Raza
*/

public with sharing class SessionSelector {
    
    /**
   * @author: Muhammad Raza
   * @param whereClause - An optional WHERE clause to filter sessions.
   * @return List<Session__c> - A list of sessions that meet the specified criteria.
   * @description: This method constructs a dynamic SOQL query to fetch sessions with specified fields.
   *                WHERE clause is optional and can be used for additional filtering.
   */
       
       public  List<Session__c> getSessionsList(String whereClause){
           String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;
           String queryOnEventSpeaker = 'SELECT Id, Name, Session_Title__c, Session_Start_Time__c, Session_End_Time__c, Session_Start_Date__c, Session_End_Date__c, Session_Duration__c, Session_Description__c, Session_Track__c, Why_Session_is_Chosen__c, Does_session_already_presented__c, Intellectual_Property_Rights_Compliance__c, Individual_Presenter_Confirmation__c, Intro_Video_Link__c, Already_Presented_Link__c, Session_Expertise_Details__c, Level__c, Session_Approval_Status__c,  Event__r.Id '
               +' FROM Session__c '
               + clause  ;
           List<Session__c> lstofSessions = Database.query(queryOnEventSpeaker);
           return   lstofSessions;
       }
       
    /**
   * @author: Muhammad Raza
   * @param   eventId - The ID of the event to filter sessions.
   * @return: List<Session__c> - A list of sessions associated with the specified event.
   * @description: Retrieves a list of sessions associated with a specific event ID.
   *               This method calls the getSessionsList method with a WHERE clause based 
   *                on the event ID.
   */
       
       public  List<Session__c> getSessionsByEventId(String eventId){
           String clause = 'Event__r.Id = \''+eventId+'\' ';
           List<Session__c> sessions = getSessionsList(clause);
           
           if (sessions.size() > 0) {
               return sessions;
           }
           return null;    
       } 
   
   
   
       /**
        * 
        * @param id 
        * @return  `List<Session__c>`
        * @description retruns Sessions List by Session Id
        */
       public  List<Session__c> getSessionById(String id){
           String clause = 'Id = \''+id+'\' ';
           List<Session__c> sessions = getSessionsList(clause);
           
           if (sessions.size() > 0) {
               return sessions;
           }
           return null;    
       }
       
       
   
   
   
   
       /**
        * @description gets session by name field
        * @param id 
        * @return  `List<Session__c>`
        */
       public  List<Session__c> getSessionByName(String Name){
           String clause = 'Name = \''+Name+'\' ';
           List<Session__c> sessions = getSessionsList(clause);
           
           if (sessions.size() > 0) {
               return sessions;
           }
           return null;    
       }
   
   
   
   
       public  static List<Session__c> getSessionsListForFlow(String whereClause){
           String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;
           String queryOnEventSpeaker = 'SELECT Id, Name, Session_Track__c, Session_Title__c, Session_Start_Time__c, Session_End_Time__c, Session_Start_Date__c, Session_End_Date__c, Session_Duration__c, Session_Description__c, Event__r.Id '
               +' FROM Session__c '
               + clause  ;
           List<Session__c> lstofSessions = Database.query(queryOnEventSpeaker);
           return   lstofSessions;
       }
   
   
       @InvocableMethod(label='Get Parsed Session Info' )
       public static  List<OutputVariable> getSessionByIdForFlow(List<id> id){
           System.debug(id);
           String clause = 'Id = \''+String.valueof(id[0])+'\' ';
           List<Session__c> sessions = getSessionsListForFlow(clause);
           
           if (sessions.size() > 0) {
               OutputVariable result = new OutputVariable();
              
             String sessionStartTimeString  = String.valueOf(sessions[0].Session_Start_Time__c);
            String  formattedStartTime = formatTime(sessionStartTimeString);
             String sessionEndTimeString  = String.valueOf(sessions[0].Session_End_Time__c);
           String  formattedEndTime = formatTime(sessionEndTimeString);
           
   
               result.sessionTitle = sessions[0].Session_Title__c;
               result.sessionTrack = sessions[0].Session_Track__c;
               result.sessionStartTime = formattedStartTime;
               result.sessionEndTime = formattedEndTime;
               List<OutputVariable> parsedSessionList = new List<OutputVariable>();
               parsedSessionList.add(result);
   
               return parsedSessionList;
             //  return sessions;
           }
           return null;    
       }
   
   
       public static String formatTime(String timeString){
   
           Time timeValue = Time.newInstance(
               Integer.valueOf(timeString.substring(0, 2)),
               Integer.valueOf(timeString.substring(3, 5)),
               Integer.valueOf(timeString.substring(6, 8)),
               0
           );
           
           // Create a dummy date (today's date)
           Date dummyDate = Date.today();
           
           // Combine time and date to create a DateTime instance
           DateTime dateTimeValue = DateTime.newInstance(dummyDate, timeValue);
           
           // Format the datetime value with respective AM/PM and local time zone
           String formattedTime = dateTimeValue.format('h:mm a');
   
           return formattedTime;
           
       }
       public class InputVariable{
           @InvocableVariable
           public List<String> id;
       }
   
       public class OutputVariable{
   
           @InvocableVariable
           public String sessionStartTime;
           @InvocableVariable
           public String sessionEndTime;
           @InvocableVariable
           public String sessionTrack;
           @InvocableVariable
           public String sessionTitle;
         
         
           @InvocableVariable
           public List<String> parsedSession;
   
           
   
       }
       public static List<Session__c> searchAllSessions( ){
        List<Session__c> lstOfSessions=[select Id, Session_Title__c, Session_Start_Time__c, Session_End_Time__c, Speaker_Name__c
         FROM Session__c ];
         System.debug('Session'+lstOfSessions);
         return lstOfSessions;
    }
       
      
public static List<Session__c> filteredSessions(List<String> levels, List<String> keywords, List<String> trackedProducts, List<String> speakerRole) {
    
   
    List<Session__c> lstOfSpeakersSessions = new List<Session__c>();
    if (speakerRole != null && !speakerRole.isEmpty()) {
        lstOfSpeakersSessions = SessionSpeakerSelector.searchSessionsByRole(speakerRole);
    }
    
    
    List<Id> sessionIds = new List<Id>();
    for (Session__c sessionSpeaker : lstOfSpeakersSessions) {
        sessionIds.add(sessionSpeaker.Id);
    }
    

    String query = 'SELECT Id, Session_Title__c, Session_Start_Time__c, Session_End_Time__c, Speaker_Name__c ' +
                   'FROM Session__c';
    
    
    if (!sessionIds.isEmpty()) {
        query += ' WHERE Id IN :sessionIds';
    } else {
        query += ' WHERE Id != NULL'; 
    }
    

    if (keywords != null && !keywords.isEmpty()) {
        List<String> keywordClauses = new List<String>();
        for (String keyword : keywords) {
            keywordClauses.add('Session_Title__c LIKE \'%' + String.escapeSingleQuotes(keyword) + '%\'');
        }
        query += ' AND (' + String.join(keywordClauses, ' OR ') + ')';
    }
    
   
    if (levels != null && !levels.isEmpty()) {
        List<String> levelClauses = new List<String>();
        for (String level : levels) {
            levelClauses.add('Level__c INCLUDES (\'' + String.escapeSingleQuotes(level) + '\')');
        }
        query += ' AND (' + String.join(levelClauses, ' OR ') + ')';
    }
    
   
    if (trackedProducts != null && !trackedProducts.isEmpty()) {
        List<String> trackedProductClauses = new List<String>();
        for (String product : trackedProducts) {
            trackedProductClauses.add('Session_Track__c LIKE \'%' + String.escapeSingleQuotes(product) + '%\'');
        }
        query += ' AND (' + String.join(trackedProductClauses, ' OR ') + ')';
    }

    
    System.debug('Query:: ' + query);
    
   
    List<Session__c> lstOfSessions = Database.query(query);
    
   
    System.debug('Sessions: ' + lstOfSessions);

    return lstOfSessions;
}

   }