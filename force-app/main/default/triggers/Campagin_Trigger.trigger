trigger Campagin_Trigger on Campaign (After insert , After update , After Delete) 
{
fflib_SObjectDomain.triggerHandler(Campaigns.class);
}