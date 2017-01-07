global class listallonmap
{
    public static List<pba_listingobj__c> Names { get; set; }
    public static Set<pba_listingobj__c> uniquenameset { get; set;}
     public static Set<pba_listingobj__c> anotheruniquenameset { get; set;}
    public static List<pba_listingobj__c> unqiueNames { get; set; }
    @RemoteAction
    global static List<AggregateResult> getAccountnames() 
    {
        return [SELECT Account_lookup__r.Name FROM pba_listingobj__c GROUP BY Account_lookup__r.Name];
               
    }
    @RemoteAction
    global static List<AggregateResult> getAccountstages(String namejs) 
    {
        return [SELECT sales_stage__c FROM pba_listingobj__c where Account_lookup__r.Name=:namejs GROUP BY sales_stage__c];
       
    }
    @RemoteAction
    global static List<pba_listingobj__c > getAccountlocation(String namejs,String stage) 
    {
    
        if(stage=='All')
        {
            return [SELECT  Name__c,address__c,latitude__c, longitude__c,sales_stage__c FROM pba_listingobj__c where Account_lookup__r.Name=:namejs];
        }
        else
        {
            return [SELECT  Name__c,address__c,latitude__c, longitude__c,sales_stage__c FROM pba_listingobj__c where Account_lookup__r.Name=:namejs and sales_stage__c=:stage];
        }

        
        
    }
}