public class SOQLstaticexample1 
{
    Public static void childparentcustomrecords()
    {
        List<Hiring_manager__c>  Hrrecord =[Select Id, Name, Location__c, Contact_Number__c,Email_Address__C,Desigination__C, 
                                            (Select Name, Location__c from positions__r)
								                     from Hiring_Manager__c 
                                                             Where Name ='bablu'];  
        
        
            
      
    }
    public static void childparentstandardrecords()
    {
        Case csrecord =[select id, caseNumber, Status, Priority, origin, reason, subject,
                              Contact.FirstName, Contact.LastName, Contact.email,
                                Contact.Account.Name, Contact.Account.Rating, Contact.Account.Industry,
                                   Contact.Account.Owner.FirstName, Contact.Account.Owner.LastName,
                                       Contact.Account.Owner.Profile.Name,
                                          Contact.Account.Owner.Profile.UserLicense.Name
                                     from case
                                         Where CaseNumber ='00001004'];
        System.debug(csrecord.id);
        System.debug(csrecord.CaseNumber);
        System.debug(csrecord.Status);
        System.debug(csrecord.priority);
        System.debug(csrecord.Subject);
        System.debug(csrecord.Origin);
        System.debug(csrecord.Contact.FirstName+ ' ' + csrecord.Contact.LastName);
        System.debug(csrecord.Contact.email);
        System.debug(csrecord.Contact.Account.Name);
        
    }
    Public static void GetLeadRecords()
    {       
            for(Lead ldRecord : [Select Id, FirstName, LastName, Title, Company, Status, Rating,
                              					Industry, Phone, Fax, Email
                              							from Lead])
            {
                System.debug('Lead Record Id is.....: '+ ldRecord.Id);
                System.debug('Lead Person Name is....: '+ ldRecord.FirstName + ' '+ ldRecord.LastName);
                System.debug('Company Name is.....: '+ ldRecord.Company);
                System.debug('Lead Status is......: '+ ldRecord.Status);
                System.debug('Contact Number is....: '+ ldRecord.Phone);
                System.debug('Email Address is.....: '+ ldRecord.Email);
                System.debug('Lead Title is......: '+ ldRecord.Title);
				System.debug('Industry Name is.....: '+ ldRecord.Industry);
                System.debug('----------------------------------------------');
            }
        
        	System.debug('Number of SOQL Queries used.....: '+ System.Limits.getQueries());
        	System.debug('Number of Records Returned......: '+ System.Limits.getQueryRows());
    }
    public static void parentchildstandardRecords(string accountRecordName) 
    {
        if(accountRecordName != Null && accountRecordName != '')
        {
            List<Account> lstAccounts = [Select Id, Name, Rating, Industry, AnnualRevenue, Phone, Fax, Active__c,
                                            (Select ID, FirstName, LastName, Email, Title, Phone from Contacts),
                                                (Select Id, Name, Amount, CloseDate, StageName, Probability from Opportunities),
                                                    (Select ID, CaseNumber, Status, Priority, Origin, Reason from Cases)
                                                        from Account
                                                            Where Name =: accountRecordName];

            System.debug('Number of Matching Account Records Found....: '+ lstAccounts.Size());

            for(Account accRecord : lstAccounts)
            {
                System.debug('Account Name is......: '+ accRecord.Name);
                System.debug('Rating Value is......: '+ accRecord.Rating);
                System.debug('Industry Name is.....: '+ accRecord.Industry);
                System.debug('Annual Revenue is....: '+ accRecord.AnnualRevenue);
                System.debug('Contact Number is....: '+ accRecord.Phone);
                System.debug('Fax Number is........: '+ accRecord.Fax);
                System.debug('Active Status is.....: '+ accRecord.Active__c);

                System.debug('----------------------------------------------');
                List<Contact> lstContacts = accRecord.Contacts;
                System.debug('Number of Related Contacts.....: '+ lstContacts.Size());
                    for(Contact conRecord : lstContacts)
                    {
                        System.debug('Contact Record is.....: '+ conRecord);
                    }
                
                System.debug('-----------------------------------------------');
                List<Opportunity> lstOppty = accRecord.Opportunities;
                System.debug('Number of Related Opportunities.....: '+ lstOppty.Size());
                    for(Opportunity oppty : lstOppty)
                    {
                        System.debug('Opportunity Record is...: '+ oppty);
                    }

                System.debug('----------------------------------------------');
                System.debug('Number of Related Cases......: '+ accRecord.Cases.Size());
                    for(Case csRecord : accRecord.Cases)
                    {
                        System.debug('Case Record is......: '+ csRecord);
                    }
            }
        }

        System.debug('Number of SOQL Queries used......: '+ System.Limits.getQueries());
    }  
    public static void meth1()
    {
        List<Task> relatedTasks = [SELECT Id, Subject, ActivityDate, Status 
                           FROM Task 
                           ];
        system.debug(relatedTasks);

    }
}