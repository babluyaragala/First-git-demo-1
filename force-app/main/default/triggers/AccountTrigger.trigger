trigger AccountTrigger on Account (before insert , before update)
{
        if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate))
    {
        for(Account accRecord : Trigger.New)
        {
            Switch ON accRecord.Industry
            {
                When 'Banking'
                {
                    accRecord.AnnualRevenue = 3100000;
                }
                When 'Finance'
                {
                    accRecord.AnnualRevenue = 4400000;
                }
                When 'Insurance'
                {
                    accRecord.AnnualRevenue = 2900000;
                }
                When 'Manufacturing'
                {
                    accRecord.AnnualRevenue = 2000000;
                }
                When 'Education'
                {
                    accRecord.AnnualRevenue = 5200000;
                }
                When 'Technology'
                {
                    accRecord.AnnualRevenue = 4600000;
                }
                When 'Communications'
                {
                    accRecord.AnnualRevenue = 6200000;
                }
                When 'Energy'
                {
                    accRecord.AnnualRevenue = 4400000;
                }
            }
        }
    }
}