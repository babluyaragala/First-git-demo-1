@Restresource(URLMapping='/Allrestiintegration/*')
Global class Integrationexamples 
{
    @HttpGet()
    Global Static List<Account> meth1()
    {
        Map<String , String >   inputParams = Restcontext.request.params;
        
         List<Account>   acc  = [Select id,name, Rating ,industry, AnnualRevenue,Type , Phone ,Fax
                                                                       from Account
                                                                               Where industry =: inputParams.Get('indName')];
        return acc;
        
    }

}