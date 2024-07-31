public With Sharing class CampaignMembers extends fflib_SObjectDomain {
    public CampaignMembers(list<Campaign> recordids){
      super(recordids);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(list<SObject> sObjectList){
            return new CampaignMembers(sObjectList);
        }
    } 
     Public List<CampaignMember>  setemailobtainforsubcribe(){
         List<CampaignMember>  subcribeToUpdateemail = (List<CampaignMember>) records;
        for (CampaignMember cam : subcribeToUpdateemail) {
          // cam.Email_optain__c ='True' ;
      
        }
        return subcribeToUpdateemail;
  } 
     Public List<CampaignMember>  setemailobtainforunsubcribe(){
         List<CampaignMember>  unsubcribeToUpdateemail = (List<CampaignMember>) records;
        for (CampaignMember cam : unsubcribeToUpdateemail) {
       //    cam.Email_optain__c ='False' ;
        }
        return unsubcribeToUpdateemail;
  } 

}