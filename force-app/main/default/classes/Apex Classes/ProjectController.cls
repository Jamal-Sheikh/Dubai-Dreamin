@RestResource(urlMapping='/api/Project/*')
 global  with sharing class ProjectController {
@HttpGet
    global static void getProjects( ){
    RestResponse response = RestContext.response;
    list<Project__c> getAllProjects = ProjectSelector.getProjects( );
    if(!getAllProjects.isEmpty( )){
    response.statusCode = 200;
    response.addHeader('Content-Type', 'application/json');
    String projectJSOn = JSON.serialize(getAllProjects);
    response.responseBody = Blob.valueOf(projectJSOn);
     }
     else{
     response.statusCode = 400;
     response.addHeader('Content-Type', 'application/json');
     String projectJSOn = JSON.serialize('Found No Project');
     response.responseBody = Blob.valueOf(projectJSOn);
     }
    }
}