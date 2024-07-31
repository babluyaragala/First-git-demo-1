trigger Contact_Trigger on Contact (After Insert ,After update ,After delete ,After Undelete, Before Update,Before Insert) {
fflib_SObjectDomain.triggerHandler(Contacts.class);
}