/**
 * @author  
 * @since    
 * @description  This class is used to query on ContentVersion records
 */
public with sharing class ContentVersionSelector {

    /**
     * @param whereClause It will help to filter out the ContentVersion records
     * @return        List of ContentVersion
     * @description   This method is querying on ContentVersion & returns the list of ContentVersion
     */

    public List<ContentVersion> getContentVersion(String whereClause) {

        whereClause = whereClause != null && whereClause != '' ? ' Where ' + whereClause : '';
        String query = 'Select Id, ContentDocument.Title, ContentDocumentId, PathOnClient from ContentVersion';
        query = query + whereClause;
        
        List<ContentVersion> contentVersions = Database.query(String.valueOf(query)); 
        return contentVersions;
    } 
}