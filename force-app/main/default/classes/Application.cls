public with sharing class Application {
    public static final fflib_Application.UnitOfWorkFactory UOW  =
                                                            new fflib_Application.UnitOfWorkFactory(new List<SObjectType>{
                                                                         Lead.SObjectType,
                                                                         Contact.SObjectType,
                                                                         Account.SObjectType,
                                                                         User.SObjectType});
    public static final fflib_Application.SelectorFactory selector =
                                                            new fflib_Application.SelectorFactory(new Map<SObjectType, Type>{
                                                                         Lead.SObjectType => Lead_Selector.class,
                                                                         Account.SObjectType => AccountsSelector.class,
                                                                         Contact.SObjectType => Contact_Selector.class});
    public static final fflib_Application.DomainFactory domain   =
                                                            new fflib_Application.DomainFactory(Application.selector,new Map<SObjectType, Type>{
                                                                         Lead.SObjectType => Leads.Constructor.class,
                                                                         Contact.SObjectType  => contacts.Constructor.class,
                                                                         Account.SobjectType => Accounts.Constructor.class});
    public static final fflib_Application.ServiceFactory service =
                                                            new fflib_Application.ServiceFactory(new Map<Type, Type>{
                                                                         LeadServiceInterface.class => LeadServiceImpl.class,
                                                                         LeadFactory.class => LeadFactory.class,
                                                                         UserserviceInterface.class => UserserviceImp.class});
}