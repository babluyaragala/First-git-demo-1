Global class Scheduletotalrevenue implements System.schedulable
{
    Global void Execute(System.schedulableContext scontext)
    {
        NewAccupdatebatch accbatch = new NewAccupdatebatch();
        
        Database.executebatch(accbatch , 4);
    }

}