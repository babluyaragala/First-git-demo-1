public With Sharing class Campagin_Service 
{
  public static void updateEmailObtain(Set<Id> contactIds) {
   fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();      
   CampaignMember_Selector campaignMemberSelector = (CampaignMember_Selector) Application.selector.newInstance(CampaignMember.SObjectType);
        List<CampaignMember> campaignMembers = campaignMemberSelector.selectById(contactIds);
      system.debug('campaignMembers :'+campaignMembers);
        Set<Id> campaignMemberIds = new Set<Id>();
        for (CampaignMember cm : campaignMembers) {
            campaignMemberIds.add(cm.Id);
        }
        if (!campaignMemberIds.isEmpty()) {
            Campaign_Selector campaignSelector = (Campaign_Selector) Application.selector.newInstance(Campaign.SObjectType);
            List<Campaign> campaigns = campaignSelector.selectCampaignbyCampaignMember(campaignMemberIds);
        system.debug('campaigns :'+campaigns);
    if (!campaigns.isEmpty()) {
        Campaigns domain = (Campaigns) new Campaigns.Constructor().construct(campaigns);     
       List<Campaign> campaignsToUpdate = new List<Campaign>();        
       Contact_Selector contactSelector = (Contact_Selector) Application.selector.newInstance(Contact.SObjectType);        
        List<Contact>  contactrec = contactSelector.selectcampaignsforsubscribed(contactIds);        
         system.debug('contactrec :'+contactrec);
       if(!contactrec.isempty()){
           campaignsToUpdate.addAll(domain.setemailobtainforsubcribe());
       }else{
           campaignsToUpdate.addAll(domain.setemailobtainforunsubcribe());
       }
      if (!campaignsToUpdate.isEmpty()) {
                unitOfWork.registerDirty(campaignsToUpdate);
                unitOfWork.commitWork();
            }         
    }
}
}
}