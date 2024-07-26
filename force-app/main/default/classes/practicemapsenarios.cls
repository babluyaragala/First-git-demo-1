public class practicemapsenarios 
{
    public static void AccountrecordsGroup()
    {
        /*
         Scenario: You have a list of Account records and you need to group them based on their industry.
       Create a map where the key is the industry name and the value is a list of Account records belonging to
        that industry.
        */
      List<Account>    accrec = [Select id , name ,Industry From Account ];
        
      Map<String , List<Account>>   accountsByIndustry = new Map<String , List<Account>>();
      //  accrecords.put('Banking' , accrec);
      for(Account acc : accrec)
      {
        if (!accountsByIndustry.containsKey(acc.Industry)) 
        {
        // If the industry is not already a key in the map, initialize a new list
        accountsByIndustry.put(acc.Industry, new List<Account>());
    }
    // Add the account to the list corresponding to its industry
    accountsByIndustry.get(acc.Industry).add(acc);
      }

        
    }

}
/*
Scenario: You have a list of Account records and you need to group them based on their industry.
Create a map where the key is the industry name and the value is a list of Account records belonging to
that industry.

Scenario: You want to store a collection of Contact records in a way that allows you to quickly access a Contact
by its email address.Create a map where the key is the email address and the value is the Contact record.

Scenario:You have a list of Opportunity records and you want to calculate the total amount of opportunities for
each stage.Create a map where the key is the stage name and the value is the total amount of opportunities in
that stage.

Scenario:You need to store information about products and their prices.
Create a map where the key is the product name and the value is the price.

Scenario:You have a list of Lead records and you need to group them based on their Lead Source. 
Create a map where the key is the Lead Source and the value is a list of Lead records belonging to that Lead Source.

Scenario: You want to maintain a collection of user preferences for each user in your system. 
Create a map where the key is the user's Id and the value is a custom object representing user preferences.

Scenario: You have a list of Opportunity records and you need to quickly access an Opportunity by its Id.
Create a map where the key is the Opportunity Id and the value is the Opportunity record.

Scenario: You want to store a collection of related records, such as Tasks related to an Opportunity.
Create a map where the key is the Opportunity Id and the value is a list of Task records related
to that Opportunity.



*/