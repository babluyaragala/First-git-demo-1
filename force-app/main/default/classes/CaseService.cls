public class CaseService 
{
   public static void closeCases(set<ID> caseids , String closereason)
   {
       List<Case>    caserecords = [Select id , reason from Case Where id =: caseids];
       
       for(Case  caseclose :caserecords )
       {
           caseclose.Reason = closereason;
           caseclose.Status = ' Closed' ;
       }
       update caserecords;
   }
}