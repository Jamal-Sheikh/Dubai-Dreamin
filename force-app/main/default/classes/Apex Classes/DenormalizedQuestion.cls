/**
* @author: Aneela Oad
* @description: Handles the denormalization process for Question data.
* @since: 05/01/24
* @Last Modified by:   Aneela Oad
*/
public class DenormalizedQuestion {

    @AuraEnabled public string questionName;
    @AuraEnabled public string questionId;
    @AuraEnabled public string questionType;
    @AuraEnabled public Boolean showTextOptions;
    @AuraEnabled public Boolean showSingleSelectOptions;
    @AuraEnabled public Boolean showMultiSelectOptions;
    @AuraEnabled public List<DenormalizedOption> questionOptionList;

    public DenormalizedQuestion(){
        
    }
}