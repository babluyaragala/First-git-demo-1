Global class Caluculatetotalrevenuebatch implements Database.Batchable<SObject>,Database.Stateful
{
    Global  Decimal Totalanuualrevenue =0.0; 
    
    Global Database.Querylocator Start(Database.Batchablecontext bcontext)
    {
        String Accquery ='Select Name , ID , Annualrevenue ,Industry ,Rating  from Account ';
         return   Database.getQuerylocator(Accquery);    
    }
    Global void execute(Database.Batchablecontext bcontext,List<Sobject>  Newobj)
    {
       List<Account>   Accountstoupdate = new List<Account>(); 
        if(! newobj.isempty())
        {
            for(SObject  objrec :Newobj)
            {
             Account  Accrecord= (Account)objrec;
                Totalanuualrevenue +=accrecord.AnnualRevenue;
            }
        }
    }
    Global void Finish(Database.Batchablecontext bcontext)
    {
         System.debug('Batch Job Id is.....: '+ bContext.getJobId());
        
        AsyncApexJob jobDetails = [Select ID, Status, totalJobItems, jobItemsProcessed,
                                  			numberOfErrors, createdBy.Email
                                  				from AsyncApexJob
                                  					Where Id =: bContext.getJobId()];
        
        // Call the Method to Send the Email...
        Emailapexprogramming.SendBatchJobStatusAlert(jobDetails, 'Caluculatetotalrevenuebatch', Totalanuualrevenue);
    }

}