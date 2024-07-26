trigger AccountsTrigger on Account (before insert,After Insert ,after update , after delete , before update , before delete) 
{
fflib_SObjectDomain.triggerHandler(Accounts.class);
}