public class Price {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String nickname;
    @AuraEnabled
    public Decimal unitAmount;
    @AuraEnabled
    public Date activationDate;
    @AuraEnabled
    public Date expiryDate;
    @AuraEnabled
    public Boolean active;
    @AuraEnabled
    public String description;
     @AuraEnabled
    public Integer vatTax;
    @AuraEnabled
    public Decimal subTotalAmount;
    @AuraEnabled
    public Decimal totalAmount;
    
}