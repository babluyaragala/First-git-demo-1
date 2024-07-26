public  class relationshipqueryexample 
{
    public static void accountrelationship()
    {
        List<Account> FirstAccount =[Select Id, Name, Rating, Industry, AnnualRevenue
                                   (select id ,FirstName,LastName,Email,Title,Phone from Contacts)
                                   (Select Id, Name , Amount, CloseDate ,StageName,Probability from Opportunities)
                                   (Select Id, CaseNumber , Status ,Priority ,Origin,Reason from Cases)
										from Account
                                         Where Name = 'Edge Communications'];

       System.debug('Number of records in account  = '+1stAccount.size());
       if(! 1stAccount.isempty())
       {
          for(Account  acc : 1stAccount)
          {
            system.debug(acc);
            system.debug('---------------------------------------');

            List<Contact> 1stcon = acc.Contacts;
            System.debug('Number of records found in contact = '+1stcon.size());
             for(Contact con : 1stcon)
             {
                system.debug(con);
                system.debug('---------------------------------------');
             }

             List<Opportunity> 1stopp = acc.Opportunities;
              for(Opportunity opp : 1stopp)
              {
                system.debug(opp);
                system.debug('---------------------------------------');
              }

              List<Case>  1stCase = acc.Cases;
               for(Case  cs : 1stcase)
               {
                system.debug(cs);

               }

          }
          



       }

    }
}
   
   