public class AccountsSelector extends fflib_SobjectSelector{
     public Schema.SobjectType getsobjectType(){
         return Account.SobjectType;
     }    
    public List<Schema.Sobjectfield>  getSobjectfieldlist(){
        return new List<Schema.Sobjectfield>{
                Account.name,
                Account.Number_of_Contacts__c};
    }
    public List<Account>  Selectbyid(Set<id>  idset){
        return (List<Account>) SelectSobjectsbyid(idset);
    } 
    /*
   public List<Account> selectContactswithAccount(Set<Id> accIds){
      fflib_QueryFactory query = newQueryFactory();
      query.setCondition('Id IN :accIds');
      new Contact_Selector().
            addQueryFactorySubselect(query,'Contacts');
      return (List<Account>) Database.query(query.toSOQL());
   } 
*/
}