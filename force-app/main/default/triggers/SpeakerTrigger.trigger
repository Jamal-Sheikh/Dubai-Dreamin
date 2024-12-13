/**
 *@author: Fatima
* @since: 07/05/24
 */

trigger SpeakerTrigger on Speaker__c (before update) {
    new SpeakerTriggerHandler().run();
}