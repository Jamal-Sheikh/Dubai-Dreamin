public with sharing class ProjectSelector {
    public static list<Project__c> getProjects( ){
        list<Project__c> getProjectList = [Select Id, Name, Description__c, Status__c From Project__c WHERE Status__c = 'Active'];
        return getProjectList;
    }
}