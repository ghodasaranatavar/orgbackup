@isTest
public class oninserttriggerTestClass {
   
   public static testMethod void testoninserttrigger() {
        pba_Listing__c newlisting = new pba_Listing__c(PropertyOwnerEmail__c = 'John@gmail.com',no_of_activities__c=1,refno1__c='1',refno2__c='2',sales_advisor_user__c='00528000004cU4B');
        insert newlisting;
        
        pba_Request__c newrequest = new pba_Request__c(Listing__c= newlisting.ID,no_of_activities__c=1,refno1__c='1');
        try {
           insert newrequest;
        }
        catch (Exception e) {
           System.debug('Exception');
        }
        newrequest.no_of_activities__c=2;
        try {
           update newrequest;
        }
        catch (Exception e) {
           System.debug('Exception');
        } 
   }
}