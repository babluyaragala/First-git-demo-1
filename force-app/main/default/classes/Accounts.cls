public class Accounts extends fflib_SobjectDomain{
  public Accounts(list<Account> accountrecords){
      super(accountrecords);}
  public class Constructor implements fflib_SObjectDomain.IConstructable {
     public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new Accounts(sObjectList);}
  }    
  Public List<Account>  setNumberofContacts(){
         List<Account>  accountsToUpdate = (List<Account>) records;
        for (Account acc : accountsToUpdate) {
            acc.Number_of_Contacts__c = acc.Contacts.size();}
        return accountsToUpdate;
  }    
}