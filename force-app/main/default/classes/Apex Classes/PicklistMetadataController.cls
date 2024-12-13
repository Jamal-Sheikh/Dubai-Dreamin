public with sharing class PicklistMetadataController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getPicklistValues(String objectApiName, String fieldApiName) {
        Map<String, List<String>> picklistValues = new Map<String, List<String>>();
       Map<String, String> pikvals = new Map<String, String>();
       List<Map<String, String>> pikvalsList = new List<Map<String, String>>();
        // Retrieve object metadata
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = gd.get(objectApiName);
        Schema.DescribeSObjectResult objDescribe = objectType.getDescribe();
        
        // Retrieve field metadata
        Schema.DescribeFieldResult fieldDescribe = objDescribe.fields.getMap().get(fieldApiName).getDescribe();
        
        // Check if the field is a picklist
        if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
            // Retrieve picklist values
            List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
            List<String> values = new List<String>();
            for (Schema.PicklistEntry entry : picklistEntries) {
                values.add(entry.getLabel());
                pikvals.put('label',String.valueof(entry.getLabel()));
                pikvalsList.add(pikvals);
            }
            picklistValues.put(fieldApiName, values);
        }
        system.debug('my array :'+ pikvalsList);
        return picklistValues;
    }
}