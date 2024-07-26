trigger Leads_Trigger on Lead (before insert,After Insert ,after update , after delete , before update , before delete) 
{
fflib_SObjectDomain.triggerHandler(leads.class);
}