@istest
public class unitofworktest
{
    @istest
  public static void challengeComplete()
  {
      fflib_SobjectUnitofwork  uow = new fflib_SobjectUnitofwork(
                           new Schema.SObjectType[] {
                                 Account.SobjectType,
                                  Contact.SobjectType,
                                  Note.SobjectType});
      for(integer i=1; i<=100; i++)
      {
        Account  acc = new Account();
          acc.Name = 'Test Account' + '_' + i ;
          
          uow.registernew(acc);
          
          for(Integer j=1 ; j <= 5; j++)
          {
            contact con = new contact();
              con.LastName = 'Test contact '+ i + '_'+ j;
              uow.registerNew(con, contact.Accountid, acc);
              
              Note n = new Note();
              n.Title = 'Test note '+ i + '_'+j;
              n.Body = 'testbody'+ i + '_'+j;
             uow.registerNew(n , Note.parentId, acc);
          }
          
          
      }
      uow.commitWork();
      System.assertEquals(100, [Select Id from Account].size());
      System.assertEquals(500, [Select Id from Contact].size());
      System.assertEquals(500, [Select Id from Note].size());
  }
}