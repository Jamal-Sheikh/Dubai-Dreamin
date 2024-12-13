trigger SessionSpeakerApprovalTrigger on Session__c (after update) {

    new SessionSpeakerApprovalTriggerHandler().run();

}