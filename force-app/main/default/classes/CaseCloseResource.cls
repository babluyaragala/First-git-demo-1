@Restresource(URLMapping='/case/*/close')
Global class CaseCloseResource 
{
    @Httppost
   global static void closeCase(String reason)
   {
       CaseService.closeCases(new set<ID> { RestContext.request.requestURI.split('/')[2] } , reason);
   }
}