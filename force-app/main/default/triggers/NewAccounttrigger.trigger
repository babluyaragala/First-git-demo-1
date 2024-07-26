trigger NewAccounttrigger on Account (before insert)
{
    If(trigger.isinsert && trigger.Isbefore)
    {
        for(Account accrec : trigger.new)
        {
            if(accrec.Rating == Null || accrec.Rating =='')
                accrec.rating.Adderror('Please enter the value');
            else if(accrec.Industry == null || accrec.Industry =='')
                accrec.industry.Adderror('Please enter the value');
               
        }
    }

}