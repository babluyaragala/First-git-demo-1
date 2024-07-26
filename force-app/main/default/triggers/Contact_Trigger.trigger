trigger Contact_Trigger on Contact (After Insert ,After update ,After delete ,After Undelete) {
fflib_SObjectDomain.triggerHandler(Contacts.class);
}