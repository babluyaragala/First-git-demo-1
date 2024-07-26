trigger CloseResolvedCases on Case (after update) 
{
    List<Case> casesToUpdate = new List<Case>();
 if(Trigger.isAfter && Trigger.isUpdate)
 {
     
 
    for (Case cs : Trigger.new) 
    { 
        if (cs.Status == 'Resolved') 
        {
            Case oldCase = Trigger.oldMap.get(cs.Id);
            if (oldCase.Status != 'Resolved') 
            {
                Integer daysResolved = Date.today().daysBetween(cs.LastModifiedDate.date());
                
                if (daysResolved > 7) 
                {
                    cs.Status = 'Closed';
                    casesToUpdate.add(cs);
                }
            }
        }
    }
 }

    
    if (!casesToUpdate.isEmpty()) 
    {
        update casesToUpdate;
    }
}