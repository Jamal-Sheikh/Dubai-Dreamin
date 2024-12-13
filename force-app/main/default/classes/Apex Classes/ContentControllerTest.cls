@isTest
private class ContentControllerTest {
    @isTest static void testCreatePublicLink() {
        // Set up test data
        // Assuming 'Speaker' is the object type for speakerId
        Speaker__c testSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Approval_Status__c = 'Pending'
        );
        insert testSpeaker;
        // insert testSpeaker;

        // Create a ContentDocument and ContentDocumentLink linked to the testSpeaker
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
            
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='SampleTitle', 
            PathOnClient ='SampleTitle.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                        FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = testSpeaker.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        // Call the method under test
        Test.startTest();
        ContentController.createPubliclink(new List<Id>{testSpeaker.Id});
        Test.stopTest();

        // Query for the created ContentDistribution
        List<ContentDistribution> cdList = [SELECT Id FROM ContentDistribution WHERE Name = 'Test' LIMIT 1];
        System.assertEquals(1, cdList.size(), 'ContentDistribution should be created');

        // Additional assertions can be added here to verify the properties of the created ContentDistribution
    }
}