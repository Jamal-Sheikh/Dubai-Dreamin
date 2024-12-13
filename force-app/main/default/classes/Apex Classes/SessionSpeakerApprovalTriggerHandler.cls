public with sharing class SessionSpeakerApprovalTriggerHandler extends TriggerHandler {
    
    private List<Session__c> triggerNew;
    private List<Session__c> triggerOld;
    private Map<Id, Session__c> triggerMapNew;
    private Map<Id, Session__c> triggerMapOld;

    
    public override void afterUpdate(){


        for(Session__c session : this.triggerNew){
            
            if(session.Session_Approval_Status__c == 'Approved'){
                SessionSpeakerSelector sessionSpeakerSelector=new SessionSpeakerSelector();

                // get session speakers junction obj
                List<Speaker__c> speakers = sessionSpeakerSelector.getSpeakersBySessionId(session.Id);
               
                                   
                // update speakers
                List <Speaker__c> speakersToUpdate= new List <Speaker__c>();
                for(Speaker__c speaker : speakers){
                    speaker.Approval_Status__c='Approved'; 
                    speaker.Voucher_Code__c=voucherCodeGen.voucherCodeGeneration(); //ali gardezi functionality
                    speakersToUpdate.add(speaker);
                }
                

                update speakersToUpdate;
                
               
                //sessionIds.add(session.Id);


    }
    else if (session.Session_Approval_Status__c == 'Rejected') {
        SessionSpeakerSelector sessionSpeakerSelector=new SessionSpeakerSelector();

        List<Speaker__c> speakers = sessionSpeakerSelector.getSpeakersBySessionId(session.Id);
               
        List<Speaker__c> speakersToUpdate = new List<Speaker__c>();               
        for (Speaker__c speaker : speakers) {
           
            if (speaker.Approval_Status__c != 'Approved') {
                speaker.Approval_Status__c = 'Rejected';
                speaker.Voucher_Code__c=voucherCodeGen.voucherCodeGeneration();
                speakersToUpdate.add(speaker);
            }
        }
        update speakersToUpdate;
    }

    
}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public SessionSpeakerApprovalTriggerHandler() {

        this.triggerOld = (List<Session__c>) Trigger.old;
        this.triggerNew = (List<Session__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, Session__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Session__c>) Trigger.oldMap;

    }
}