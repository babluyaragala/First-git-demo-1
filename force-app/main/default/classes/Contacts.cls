public class Contacts extends fflib_SObjectDomain{
    public Contacts(list<Contact> recordsids){
      super(recordsids);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new Contacts(sObjectList);
        }
    }    
    Public Void updateFirstName(String fname){
      List<Contact>  contacts =  (List<Contact>) records ;
        for(Contact  con : contacts){
            con.firstname = fname;
            break;
        }
    }
    Public Void  updateLastname(String lname){
       List<Contact>  contacts =  (List<Contact>) records ;
        for(Contact  con : contacts){
            con.Lastname = lname;
            break;
        } 
    } 
    
    public override void onAfterinsert() {
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : (List<Contact>) records) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        if (!accountIds.isEmpty()) {
            Account_Service.updateNumberOfContacts(accountIds);
        }
    }   
    public override void onAfterUpdate(Map<Id, SObject> existingRecords){
    Set<Id> accountIds = new Set<Id>(); 
    for (Contact c : (List<Contact>) records) {
        if (c.AccountId != null) {
            accountIds.add(c.AccountId);
        }
        Contact existingContact = (Contact) existingRecords.get(c.Id);
        if (existingContact != null && existingContact.AccountId != null && existingContact.AccountId != c.AccountId) {
            accountIds.add(existingContact.AccountId);
        }
    }
    if (!accountIds.isEmpty()) {
        Account_Service.updateNumberOfContacts(accountIds);
    }
   }
    public override void onAfterDelete(){
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : (List<Contact>) records) {
            if (c.AccountId != null){
                accountIds.add(c.AccountId);
            }
        }
        if (!accountIds.isEmpty()) {
            Account_Service.updateNumberOfContacts(accountIds);
        }
    }
    public override void onAfterUndelete() {
       Set<Id> accountIds = new Set<Id>();
        for (Contact c : (List<Contact>) records) {
            if (c.AccountId != null){
                accountIds.add(c.AccountId);
            }
        }
        if (!accountIds.isEmpty()) {
            Account_Service.updateNumberOfContacts(accountIds);
        }
    }
   
}