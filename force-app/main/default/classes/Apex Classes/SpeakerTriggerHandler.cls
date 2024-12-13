public with sharing class SpeakerTriggerHandler extends TriggerHandler {
    
    private List<Speaker__c> triggerNew;
    private Map<Id, Speaker__c> triggerOldMap;

    public override void beforeUpdate() {
        triggerOldMap = (Map<Id, Speaker__c>)Trigger.oldMap;
        triggerNew = (List<Speaker__c>)Trigger.new;

        Set<String> speakerNames = new Set<String>();
        Set<String> speakerEmails = new Set<String>();

        for (Speaker__c newSpeaker : triggerNew) {
            Speaker__c oldSpeaker = triggerOldMap.get(newSpeaker.Id);
            
            // Handling Approved Speakers
            if (newSpeaker.Approval_Status__c == 'Approved' && oldSpeaker.Approval_Status__c != 'Approved') {
                speakerNames.add(newSpeaker.Speaker_Name__c);
                speakerEmails.add(newSpeaker.Email__c);
            }
            
            // Handling Rejected Speakers
            if (newSpeaker.Approval_Status__c == 'Rejected' && oldSpeaker.Approval_Status__c != 'Rejected') {
                // handleRejectedSpeaker(newSpeaker, oldSpeaker);
                  speakerNames.add(newSpeaker.Speaker_Name__c);
                speakerEmails.add(newSpeaker.Email__c);
            }
        }

        if (!speakerNames.isEmpty() && !speakerEmails.isEmpty()) {
            Map<String, Id> attendeeMap = AttendeeSelector.getAttendeesbyNameandEmail(speakerNames, speakerEmails);

            Set<Id> attendeeIds = new Set<Id>(attendeeMap.values());
            Map<Id, Decimal> ticketAmountMap = TicketSelector.getTicketAmounts(attendeeIds);

            for (Speaker__c speaker : triggerNew) {
                String attendeeKey = speaker.Speaker_Name__c + '|' + speaker.Email__c;
                if (attendeeMap.containsKey(attendeeKey) && attendeeIds.contains(attendeeMap.get(attendeeKey))) {
                    speaker.Attendee__c = attendeeMap.get(attendeeKey);
                    System.debug('speaker attendee ' + speaker.Attendee__c);
                    speaker.Ticket_Amount__c = ticketAmountMap.get(attendeeMap.get(attendeeKey));

                    if(speaker.Approval_Status__c=='Approved'){
                         speaker.Amount_To_Be_Refund__c = speaker.Ticket_Amount__c;
                         speaker.Refund_Amount__c = speaker.Ticket_Amount__c;

                    }
                   if (speaker.Approval_Status__c == 'Rejected') {
                                Decimal discountAmount = speaker.Ticket_Amount__c * 0.20;
                           speaker.Amount_To_Be_Refund__c = discountAmount;
                         speaker.Refund_Amount__c =discountAmount;
                   }
                
                }
            }
        }
    }

  

    public SpeakerTriggerHandler() {
        this.triggerNew = (List<Speaker__c>)Trigger.new;
    }
}