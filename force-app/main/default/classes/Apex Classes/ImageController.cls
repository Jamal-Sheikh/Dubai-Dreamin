@RestResource(urlMapping='/api/EmployeeImage/*')
global with sharing class ImageController {
 @HttpPost
    global static void decodeImage() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    Map<String, Object> requestBody = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
    ImageResponseWrapper responseWrapper = new ImageResponseWrapper ();
   
    String employeeId;
    String base64Image;

    if (requestBody.containsKey('Employee_ID__c') && requestBody.containsKey('Profile_Image__c')) {
   
     employeeId = (String)requestBody.get('Employee_ID__c');
     base64Image = (String)requestBody.get('Profile_Image__c');
     Blob imageBlob = EncodingUtil.base64Decode(base64Image);
  
    //ContentVersion getCV =  [Select id, VersionData, Title, VersionNumber from ContentVersion where VersionData = :imageBlob];
     
     ContentVersion cv = new ContentVersion(
      Title = 'Profile Image',
      VersionData = imageBlob,
      PathOnClient = 'profile_image.jpg',
      FirstPublishLocationId = employeeId
     );
      insert cv;

    ContentVersion file =  ImageSelector.getCVRecord(cv.Id);

    //   List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :employeeId and ContentDocumentId =: file.ContentDocumentId];  
    //   system.debug('document link' + documentLinks );
    //  if (documentLinks.size()==0) {
    //   ContentDocumentLink cdl = new ContentDocumentLink();
    //    cdl.LinkedEntityId = employeeId;
    //    cdl.ContentDocumentId = file.ContentDocumentId;
    //    insert cdl;
    //        }


      ContentDistribution cd = new ContentDistribution(
       Name = file.Title,
       ContentVersionId = file.Id,
       PreferencesAllowViewInBrowser= true
           );
       insert cd;
        
       cd = ImageSelector.getCDRecord(cd.Id);

      String publicLink = cd.ContentDownloadUrl;

      list<Employee__c> ImageLink = ImageSelector.getImageLink(employeeId, publicLink );

       responseWrapper.message= 'success';
       responseWrapper.statusCode='200';
       responseWrapper.imageUrl = ImageLink[0].Profile_Image__c;
       response.addHeader('Content-Type', 'application/json');
       response.responseBody = Blob.valueOf(JSON.serialize(responseWrapper));
        }

      if (requestBody.containsKey('Employee_ID__c')) {
         employeeId = (String)requestBody.get('Employee_ID__c');
        }

      if (requestBody.containsKey('Profile_Image__c')) {
         base64Image = (String)requestBody.get('Profile_Image__c');
        }

      if (String.isBlank(employeeId)) {
       responseWrapper.message= 'Employee ID is missing';
       responseWrapper.statusCode='400';
       responseWrapper.imageUrl = '';
       response.addHeader('Content-Type', 'application/json');
       String jsonResponse = JSON.serialize(responseWrapper);
       response.responseBody = Blob.valueOf(jsonResponse);
       return;
        }
     
      if (String.isBlank(base64Image)) {
        responseWrapper.message= 'Profile image is missing';
        responseWrapper.statusCode='400';
        responseWrapper.imageUrl = '';
        response.addHeader('Content-Type', 'application/json');
        String jsonResponse = JSON.serialize(responseWrapper);
        response.responseBody = Blob.valueOf(jsonResponse);
       return;
        }
    }
}