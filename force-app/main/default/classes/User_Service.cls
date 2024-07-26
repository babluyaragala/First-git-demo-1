public With Sharing class User_Service {
  public static Void usercreation(String lname ,String fname, String email, String alias){
      fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance(); 
      Contact_Selector  contactselector = (Contact_Selector) Application.selector.newInstance(Contact.SObjectType);
      Set<String> emailSet = new Set<String>{email};
      List<Contact> existingContacts = contactselector.selectContactbyemail(emailSet);
      if (existingContacts == null) {
            existingContacts = new List<contact>();}
            System.debug('existingContacts: ' + existingContacts);
      Contacts domain = (Contacts) new Contacts.Constructor().construct(existingContacts); 
      if (!existingContacts.isEmpty()) {
            Contact existingContact = existingContacts[0];
            if (existingContact != null){
                System.debug('Updating existing Contact: ' + existingContact);         
                domain.updateFirstName(fname);
                domain.updateLastName(lname);
                unitOfWork.registerDirty(existingContact);
                unitOfWork.commitWork();
                System.debug('Existing Contact updated and committed.');
            } else {
                throw new userException('Existing lead record is null.');
            }
       }else {
            List<user> newuser = new User_Factory().Insertuser(lname ,fname, email ,alias);  
            if (newuser != null) {
                System.debug('New User created: ' + newuser);
                unitOfWork.registerNew(newuser);
                unitOfWork.commitWork();
                System.debug('New User registered and committed.'); 
                For(User u : newuser){
                throw new userException('New User created  ID :'+ u.id); //New User created  ID :005J4000000YUTdIAO
                } 
            } else {
                throw new userException('Failed to create a new user.');
            }         
        }
  }
}