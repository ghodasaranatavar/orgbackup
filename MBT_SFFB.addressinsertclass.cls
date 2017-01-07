global class addressinsertclass {
public static ID testID { get; set; } 
public static List<test__c> testlist { get; set; }   
 public static test__c newlocation { get; set; }
    public addressinsertclass(ApexPages.StandardController stdController) {
    
        testID=ApexPages.currentPage().getParameters().get('id');
    }
    @RemoteAction
    global static List<test__c> gettest(String IDJS) 
    {
         return testlist=[select ID,address__c,latitude__c,longitude__c from test__c where ID=:IDJS];
    }
 @RemoteAction
    global static String insertlocation(String locationJS,String longitudeJS,String latitudeJS) 
    {
        try
        {
            newlocation= new test__c();
            newlocation.address__c=locationJS;
            newlocation.latitude__c=latitudeJS;
            newlocation.longitude__c=longitudeJS;            
            insert newlocation;
           

        }
    catch (Exception ex)
    {
       return 'Exception';
    }
        
        return'';
    }
    
}