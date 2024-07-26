public class Assignments 
{
    public static void Uniquevalid(String Name)
    {
        List<Lead> existigrecord = [Select Id, FirstName, LastName, Title, Company, Status, Rating,
                              					Industry, Phone, Fax, Email
                              							from Lead
                                                      Where FirstName =: Name ];
        
        if(existigrecord.isempty())
        {
                    lead lerec = new Lead();
            
            lerec.Firstname =Name ;
            lerec.LastName ='Kumar';
            lerec.Title = 'CEO';
            lerec.Company =' Wipro Technologies';
            lerec.Status =' High';
            lerec.Rating ='Hot';
            lerec.Industry = 'Finance';
            lerec.Phone ='9876567890';
            lerec.Fax ='8765434568';
            lerec.Email ='kishore123@gmail.com';
  //          lerec.Address ='Road no-8, jubliee hills, Hydrabad';
            lerec.AnnualRevenue = 76000000;
            
            insert lerec;
           System.debug('Record inserted successfully.');   
        }
        else
        {
            system.debug('Record with value ' + Name + ' already exists.');
        }       
               
        
    }
         
 public static void evenodd()
   {
       // •	Question: Given a List of integers,
    //    how would you filter out the even numbers and 
    //    create a new List with only the odd numbers?
       list<Integer>  num = new List<Integer>{1,2,3,4,5,6,7,8,9,10};
           list<Integer>  odd = new List<Integer>();
           for(Integer even :num)
       {
           /*
           if(even/2 == 0)
           {
              system.debug('even numbers are '+ even); 
           }

            if(even%2 != 0)
           {
          //     list<integer> odd =new list<integer>{even};
             odd.add(even);
           }   
           */
       }
    
   }
    Public static void GetCount()
    {
        // Static SOQL Query...
        	Integer recordsCount =	[Select count() from Contact];
        	System.debug('Static - Contact Records Count is.....: '+ recordsCount);
        
        // Dynamic SOQL Query..
        	String contactsQuery = 'Select count() from Contact';
        	Integer contactsCount =	Database.countQuery(contactsQuery);
        	System.debug('Dynamic - Contact Records Count is.....: '+ contactsCount);
    }
    Public static void dynamicquery(String searchText)
    {
        if(searchText != Null && searchText != '')
        {
            String leadsQuery = 'Select Id, FirstName, LastName, Email, Phone, Fax, Company, Status from Lead ';
            
            if(Pattern.Matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', searchText))
            {
                System.debug('Input String an Email Address.');
                
                leadsQuery += 'Where Email =: searchText';
            }
            else
            {
                System.debug('Input String a Normal String.');
                
                searchText += '%';
                leadsQuery += 'Where LastName Like : searchText';
            }
            
            List<Lead> lstLeads = Database.Query(leadsQuery);
            
            System.debug('Number of Records Returned......: '+ lstLeads.Size());
            
            if(! lstLeads.isEmpty())
            {
                for(Lead ldRecord : lstLeads)
                {
                    System.debug('Lead Record is.....: '+ ldRecord);
                }
            }
        }
    }
    public static void maphighestprice()
    {
        map<String , Integer>   price = new map<String , Integer>();
        price.put('pen',10);
        price.put('Book',30);
        price.put('laptop',20000);
        price.put('mouse',435);
        system.debug(price.keyset());
        system.debug(price.values());
        string maxprice;
        integer pri =0;
        for(string mapprice : price.keyset())
        {
            integer p1 =price.get(mapprice);
            if(p1>pri)
            {
                pri =p1;
                maxprice =mapprice;
            }
          
        }
        System.debug('Product with the highest price: ' + maxPrice + ' ($' + Pri + ')');
          }
    public static void samestrings()
    {
          set<string>   setA = new set<string>{'Apple', 'Banana', 'Cherry', 'Date'};
            system.debug(setA);
        set<string>  setB  = new set<string>{'Banana', 'Date', 'Orange', 'Grapes'};
            system.debug(setB);
        if(setA.equals(setB))
            system.debug('both are same:'+setA +'  '+ setB);
        else
            system.debug('both r not same');
        
        // Find elements common to both sets
        Set<String> setA1 = new Set<String>{'Apple', 'Banana', 'Cherry', 'Date'};
Set<String> setB2 = new Set<String>{'Banana', 'Date', 'Orange', 'Grapes'};
Set<String> commonElements = new Set<String>(setA1);
commonElements.retainAll(setB2);

System.debug('Common Elements: ' + commonElements);

    }
    public static void samevalues()
    {
        set<integer>   setA = new set<integer>{1,2,3,4,5,6,7,8,9};
            system.debug(setA);
        set<integer>  setB  = new set<integer>{1,2,3,4,5,6,8,9};
            system.debug(setB);
        if(setA.equals(setB))
            system.debug('both are same:'+setA +'  '+ setB);
        else
            system.debug('both r not same');
    }
    public static void swapstrings()
    {
        List<String> stringList = new List<String>{'Apple', 'Banana', 'Cherry', 'Date'};

// Swap elements at index 1 and index 3
stringList[1] = stringList[1] + stringList[3];
stringList[3] = stringList[1].substring(0, stringList[1].length() - stringList[3].length());
stringList[1] = stringList[1].substring(stringList[3].length());

System.debug('List after swapping strings: ' + stringList);
        
    //     original stringList: ['Apple', 'Banana', 'Cherry', 'Date']

    //  Concatenation: 'Banana' + 'Date' results in 'BananaDate'
   //Extracting part for stringList[3]: 'BananaDate'.substring(0, 6) results in 'Banana'
    //Extracting part for stringList[1]: 'BananaDate'.substring(6) results in 'Date'
         

    }
    public static void swapintegers()
    {
        list<integer>  str = new list<integer>{1,2,3,4,5,6,7,8,9};
    
    
     system.debug(str);
    
    str[1]=str[1] ^ str[3];
    str[3]= str[3] ^ str[1];
    str[1]=str[1] ^ str[3];        
    
    
     system.debug(str);
    
    }
    public static void mapcollection()
    {
        // Map Declaration and Initialization
Map<String, Integer> fruitQuantityMap = new Map<String, Integer>
{
    'Apple' => 10,
    'Banana' => 15,
    'Cherry' => 8
};

// Add a new key-value pair to the map
fruitQuantityMap.put('Date', 5);

// Access a value using the key
Integer bananaQuantity = fruitQuantityMap.get('Banana');
System.debug('Banana Quantity: ' + bananaQuantity);

// Iterate through the map
for (String fruit : fruitQuantityMap.keySet()) {
    System.debug('Fruit: ' + fruit + ', Quantity: ' + fruitQuantityMap.get(fruit));
}

// Remove a key-value pair from the map
fruitQuantityMap.remove('Cherry');

// Display the updated map
System.debug('Updated Map: ' + fruitQuantityMap);

    }
    public static void touppercase()
    {
      list<string> names =new list<string>();
        
        
        names.add('india');
        names.add('japan');
        names.add('australia');
        names.add('usa');
        names.add('russia');
        
       system.debug(names.size());
     
        for(Integer i=0; i<names.size(); i++)
        {
            names[i] = names[i].toUpperCase();
            system.debug(names[i]);
        }
      
        
                                     
        
        
        
        
        
        
    }
    public static void relationquery(String industryname)
    {
      if(industryname !=null && industryname !=' ')
      {
          map<id , Account>  mapacc= new map<id , Account>([select id ,name,industry
                                                            from  account
                                                                 Where Industry =: industryname]);
          system.debug(mapacc.size());
          
              system.debug(mapacc);
          if( ! mapacc.isempty())
          {
            list<Case>  ca =[select id , casenumber , priority , reason ,accountid
                                   from case
                                        where accountid in :mapacc.keyset()];
              for(  case cs:ca)
                  system.debug(cs);
          }
          
      }    
    }

}