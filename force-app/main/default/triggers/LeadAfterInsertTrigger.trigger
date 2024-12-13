trigger LeadAfterInsertTrigger on Lead (after insert, after update) {
    if (Trigger.isAfter && Trigger.isInsert) {
        List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();
        List<Lead> leadsToUpdate = new List<Lead>(); 

        Set<Id> contentVersionIds = new Set<Id>();

        for (Lead newLead : Trigger.new) {
            contentVersionIds.add(newLead.Content_Id__c);
        }

        Map<Id, ContentVersion> cvMap = new Map<Id, ContentVersion>([Select Id, ContentDocumentId from ContentVersion where Id in: contentVersionIds]);
        for (Lead newLead : Trigger.new) {
            String contentDocumentId = cvMap.get(newLead.Content_Id__c).ContentDocumentId;

            if (String.isNotBlank(contentDocumentId)) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = contentDocumentId;
                cdl.LinkedEntityId = newLead.Id;
                cdl.ShareType = 'V'; // Viewer
                insert cdl;

                ContentVersion cv = [SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId LIMIT 1];
                ContentDistribution conDis = new ContentDistribution();
                conDis.Name = cv.Title;
                conDis.ContentVersionId = cv.Id;
                conDis.PreferencesAllowViewInBrowser = true;
                insert conDis;

                conDis = [SELECT ContentDownloadUrl FROM ContentDistribution WHERE Id = :conDis.Id];
                String publicUrl = conDis.ContentDownloadUrl;

               // newLead.Company_Image_Url__c = publicUrl;
                Lead lead = new Lead();
                lead.id = newLead.id;
                lead.Company_Image_Url__c=publicUrl;
                leadsToUpdate.add(lead); 
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate; 
        }
    }
}