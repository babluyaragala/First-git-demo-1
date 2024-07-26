trigger Customerorderstatus on Customer_Status__c (after update) 
{
    List<Customer_Status__c> customerUpdateList = new List<Customer_Status__c>();

    for (Id cusid : Trigger.newMap.keySet()) 
    {
       
        Customer_Status__c newCustomer = Trigger.newMap.get(cusid);
        
        Customer_Status__c oldCustomer = Trigger.oldMap.get(cusid);

        if (oldCustomer.Order_Status__c == 'In-Progress' && newCustomer.Order_Status__c == 'Complete') 
        { 
            Customer_Status__c updatedCustomer = new Customer_Status__c();
               updatedCustomer.Id = newCustomer.Id; 
            updatedCustomer.Order_Description__c = 'Congrats, your order is completed.';

            customerUpdateList.add(updatedCustomer);
        }else if(oldCustomer.Order_Status__c == 'Complete'  && (newCustomer.Order_Status__c == 'In-Progress'|| oldCustomer.Order_Status__c == 'Start' || oldCustomer.Order_Status__c == 'Close'))
        {
           
            Customer_Status__c updatedCustomer = new Customer_Status__c();
               updatedCustomer.Id = newCustomer.Id; 
            updatedCustomer.Order_Description__c = Null;

            customerUpdateList.add(updatedCustomer); 
        }
    }
    if (!customerUpdateList.isEmpty()) 
    {
        update customerUpdateList;
    }
}