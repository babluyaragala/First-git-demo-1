public class DMLEXAMPLES 
{
    public Static void DatabaseinsertClass()
    {
        List<Lead> le =new List<Lead>();
        
        for(integer i=1; i<=50 ;i++)
        {
            Lead ldRecord = new Lead();
            
            ldRecord.FirstName = 'Abhishek';
        	ldRecord.LastName = 'Varma'+i;
        	if(i!= 47)
            {
                ldRecord.Company = 'Wipro Technologies';
            }
        	ldRecord.Title = 'Project Lead';
        	ldRecord.Status = 'Working - Contacted';
        	ldRecord.Rating = 'Hot';
        	ldRecord.Industry = 'Manufacturing';
        	ldRecord.AnnualRevenue = 2600000;
        	ldRecord.Phone = '9900337782';
        	ldRecord.Fax = '8800999922';
            ldRecord.Email = 'abhishek'+ i +'@gmail.com';
            ldRecord.LeadSource = 'Web';
        	ldRecord.Website = 'www.gmail.com';
        	ldRecord.Street = '#207, Rama Residency, BTM Layout, Phase#2.';
        	ldRecord.City = 'Bangalore';
        	ldRecord.State = 'Karnataka';
        	ldRecord.Country = 'India';
        	ldRecord.PostalCode = '800990';
            
            le.add(ldRecord);
        }
      if(! le.isempty())
      {
           Database.SaveResult[] results = Database.Insert(le , false);
          
          for(Database.SaveResult res : results)
          {
              if(res.isSuccess())
              {
                  System.debug('inserted');
                  System.debug(res.getId());
              }
              else
              {
                  for(Database.Error err : res.getErrors())
                  {
                      System.debug(err.getMessage());
                      System.debug(err.getStatuscode());
                     System.debug(err.getFields());
                  }
              }
          }
      }
    }
    public static void undeleterecord()
    {
        unDelete [select id ,name,location__c , Desigination__c
                                  from Hiring_manager__c
                                     where isdeleted =true and Name Like : 'la'+'%'
                                        all rows ]; 
    }
    public static void deleterecord(String str)
    {
        Delete [select id ,FirstName
                                  from Lead
                                     where  Name Like : str+'%'];
        
        
        
    }
   Public static void UpdateEnergyAccountRecords()
    {
        List<Account> lstAccounts = [Select Id, Name, Rating, Type, Annualrevenue, 
                                     			Industry, SLA__C, Active__c
                                    				from Account
                                    					Where Industry = 'Energy'];
        
        if(! lstAccounts.isEmpty())
        {
         	for(Account accRecord : lstAccounts)   
            {
                accRecord.Rating = 'Hot';
                accRecord.Type = 'Customer - Direct';
                accRecord.AnnualRevenue = 7900000;
                accRecord.SLA__c = 'Platinum';
                accRecord.Active__c = 'Yes';
            }
            
            Update lstAccounts;
        }        
    }
    public static void insertrecord()
    {
        lead lerec =new lead();
        lerec.FirstName = 'Bablu';
        lerec.LastName ='Yadav';
        lerec.Company ='Bicks Global';
        lerec.Title ='Project Lead';
        lerec.Status ='Working - contacted';
        lerec.Rating ='Hot';
        lerec.Industry ='Manufacturing';
        lerec.AnnualRevenue =534700;
        lerec.Phone ='6309363588';
        lerec.fax ='369874521';
        lerec.Email ='bablu.yadav@gmail.com';
        lerec.LeadSource ='Web';
        lerec.Website ='www.google.com';
        lerec.Street ='PJR GARDENS';
        lerec.City ='MUMBAI';
        lerec.State ='Mharashtra';
        lerec.Country ='INDIA';
        lerec.PostalCode ='8009';
        
        insert lerec;
        if(lerec.id !=null)
            system.debug(lerec.id);
        
        relatedtask(lerec.id);
    }
    public static void relatedtask(id leadrecordid)
    {
        if(leadrecordid != null)
        {  
            Task tskr =new Task();
        
tskr.subject ='Regarding system allocation';
        tskr.Description='having a new ticket';
        tskr.Priority ='High';
        tskr.Status ='In prgress';
        tskr.ActivityDate = system.today().adddays(2);
        
        tskr.WhoId = leadrecordid;
            insert tskr;
           
        }
    }

}