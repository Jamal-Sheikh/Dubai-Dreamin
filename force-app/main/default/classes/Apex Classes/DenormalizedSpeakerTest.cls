@isTest
private class DenormalizedSpeakerTest {

    @isTest
    static void testSetSpeakerName() {
        DenormalizedSpeaker speaker = new DenormalizedSpeaker();
        
        speaker.setSpeakerName('John Doe');
        
        System.assertEquals('John Doe', speaker.speakerName, 'Speaker name should be set correctly');
    }
    
    @isTest
    static void testSetSpeakerPhone() {
        DenormalizedSpeaker speaker = new DenormalizedSpeaker();
        
        speaker.setSpeakerPhone('123-456-7890');
        
        System.assertEquals('123-456-7890', speaker.speakerPhone, 'Speaker phone number should be set correctly');
    }

}