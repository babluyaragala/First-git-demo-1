public class CampaignMember_Selector extends fflib_SobjectSelector{
    public Schema.SObjectType getSObjectType() {
        return CampaignMember.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            CampaignMember.CampaignId,
            CampaignMember.ContactId
        };
    }
    public List<CampaignMember> selectById(Set<Id> idSet) {
        return (List<CampaignMember>) Database.query(
            newQueryFactory().selectField(CampaignMember.Id).
                             selectField(CampaignMember.CampaignId).
                             selectField(CampaignMember.ContactId).
                             setCondition('ContactId IN :idSet').
                             toSOQL());
    }
}