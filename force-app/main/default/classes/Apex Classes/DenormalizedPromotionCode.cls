public with sharing class DenormalizedPromotionCode {
    public DenormalizedPromotionCode() {

    }
   
    @AuraEnabled
    public String couponId { get; set; }
    @AuraEnabled
    public String promoCode { get; set; }
    @AuraEnabled
    public Date activationDate { get; set; }
    @AuraEnabled
    public Date expiryDate { get; set; }
    @AuraEnabled
    public Boolean isActive { get; set; }
    @AuraEnabled
    public Integer discountPercentage { get; set; }
    @AuraEnabled public Speaker__c speaker; // Add the speaker details
    @AuraEnabled public String approvalStatus;
    @AuraEnabled public String errorMessage;



}