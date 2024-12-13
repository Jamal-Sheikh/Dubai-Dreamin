global without sharing class ContentController {
    
    @InvocableMethod(label='Create Public Link' )
    public static void createPubliclink(List<id> id){
        id speakerId  = id[0];
        List<ContentDocumentLink> cdl = [select contentdocument.id, contentdocument.title, contentdocument.filetype from contentdocumentlink where linkedentityid =:speakerId];
    
    if(cdl.size()>0){
        ContentVersion cv = [select id from contentversion where contentdocumentid = :cdl[0].contentdocument.id];
    ContentDistribution cd = new ContentDistribution();
    cd.Name = 'Test';
    cd.ContentVersionId = cv.id;
    cd.PreferencesAllowViewInBrowser= true;
    cd.PreferencesLinkLatestVersion=true; 
    cd.PreferencesNotifyOnVisit=false;
    cd.PreferencesPasswordRequired=false;
    cd.PreferencesAllowOriginalDownload= true;
       
    insert cd;
        
    }   
            // ContentDistribution    cdlink = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :cd.Id LIMIT 1];
    // return 

    // OutputVariable result = new OutputVariable(); 
    // result.publicLink = cdlink.DistributionPublicUrl;

    // SYStem.debug('faraz'+cdlink.DistributionPublicUrl);
        
        
    //    return cd; 
    }
    public class OutputVariable{

        @InvocableVariable
        public String publicLink;
    

        

    }
    // createlink('a0AGB000014y3RA2AY');
}