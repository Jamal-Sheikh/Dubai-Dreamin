@isTest
public with sharing class VoucherCodeGenTest {
@isTest
public static void UnitTest(){

    
    Event__c event=EventTestDataFactory.createEvent();
    Speaker__c speaker=EventTestDataFactory.createSpeaker(event);
    Session__c session= EventTestDataFactory.createSession(event);
    Session_Speaker__c sessionSpeaker=EventTestDataFactory.createSessionSpeaker(session,speaker);

    Test.startTest();
    voucherCodeGen.speakersVC(speaker.id);
    voucherCodeGen.voucherGenEncrypt(speaker.id);
    Test.stopTest();

    Assert.areEqual('KSJ492H40J', speaker.Voucher_Code__c,'Voucher Code Exist ');

}   
}