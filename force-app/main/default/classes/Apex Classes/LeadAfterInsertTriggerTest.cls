@isTest
private class LeadAfterInsertTriggerTest {
    static testMethod void testLeadAfterInsertTrigger() {
        // Create test ContentVersion
        ContentVersion testContentVersion = new ContentVersion();
        testContentVersion.Title = 'Test Content';
        testContentVersion.ContentLocation = 'S'; // S = within Salesforce, E = External
        testContentVersion.VersionData = Blob.valueOf('Test Content Data');
        testContentVersion.PathOnClient = 'TestPath';
        insert testContentVersion;

        // Retrieve the corresponding ContentDocumentId
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentVersion.Id].ContentDocumentId;

        // Create test Lead
        Lead testLead = new Lead();
        testLead.FirstName = 'Test';
        testLead.LastName = 'Lead';
        testLead.Company='Cloud-1';
        testLead.Status='Open';
        testLead.Content_Id__c = testContentVersion.Id; // Set the Content Id
        insert testLead;

        // Perform assertions based on the trigger logic
        testLead = [SELECT Id, Company_Image_Url__c FROM Lead WHERE Id = :testLead.Id];
        System.assertNotEquals(null, testLead); // Ensure Lead is not null
        System.assertNotEquals(null, testLead.Company_Image_Url__c); // Ensure Company_Image_Url__c is not null
        
    }
}