public class Campaign_Selector extends fflib_SobjectSelector{
 public Schema.SobjectType getsobjectType(){
         return Campaign.SobjectType;
     }
     public List<Schema.Sobjectfield>  getSobjectfieldlist(){
        return new List<Schema.Sobjectfield>{
                Campaign.id,
                    Campaign.Email_optain__c
               };
    }
    public List<Campaign>  Selectbyid(Set<id>  idset){
        return (List<Campaign>) SelectSobjectsbyid(idset);
    }
    public List<Campaign> selectCampaignbyCampaignMember(Set<Id> campaignMemberIds) {
        return (List<Campaign>) Database.query(
            newQueryFactory()
                .selectField(Campaign.Id)
                .selectField(Campaign.Name)
                .selectField(Campaign.Email_Optain__c)
                .setCondition('Id IN (SELECT CampaignId FROM CampaignMember WHERE Id IN :campaignMemberIds)')
                .toSOQL()
        );
    }
}