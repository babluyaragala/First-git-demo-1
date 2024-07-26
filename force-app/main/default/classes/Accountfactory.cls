public class Accountfactory {    
   Public static Account accountInsert(String Name , string phone ,String Email){
   fflib_SObjectUnitOfWork insertaccount = new fflib_SObjectUnitOfWork( new Schema.SObjectType[] {Account.SObjectType});
          Account  newaccountrecord = new account();
       newaccountrecord.Name = Name;
       newaccountrecord.Phone = phone;
       newaccountrecord.Email__c = Email;
           insertaccount.registerNew(newaccountrecord);        
     insertaccount.commitWork();          
     return newaccountrecord;
   }
  }