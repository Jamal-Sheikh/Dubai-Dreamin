/**
 * @author      
 * @since        
 * @description   This class is being used to create ContentDocumentLink
 */
public with sharing class ContentDocumentUtils { 

    /**
     * @param pageContent content of the file which is being created
     * @param fileName name of the document/file which is being created
     * @return         Content Version of the file
     * @description    This method creates the ContentVersion with some attributes 
     */
    
    public ContentVersion constructContentVersion(Blob pageContent, String fileName) {

        ContentVersion conVer  = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient    = fileName;
        conVer.IsMajorVersion  = true;
        conVer.versionData     = pageContent;
        return conVer;
    }

    /**
     * @param fileName   file/document name to be used for contentDocumentLink Creation
     * @param recordId   it is used for creating document/file on the relative record whose Id is being used
     * @param contentIds it is used for the creation of contentdocumentlink
     * @return       ContentDocumentLink
     * @description  This method creates the ContentDocumentLink against each ContentVersion
     */

    public ContentDocumentLink createContentDocumentLink (String fileName, Id recordId, List<ContentVersion> contentIds){
    
        for (ContentVersion cv : contentIds){
            if (cv.PathOnClient.startsWith(fileName)) {
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = recordId;
                conDocLink.ContentDocumentId = cv.ContentDocumentId;
                conDocLink.shareType = 'V';
                conDocLink.Visibility='AllUsers';
                return conDocLink;
            }
        }
        return null;
    }
}