public class ListingGoogleAddress1 {
private test__c  PBL;
public string  input{ get; set; }
public static ID RecordId{ get; set; } 
  
    public ListingGoogleAddress1(ApexPages.StandardController controller) {
    PBL = (test__c) controller.getRecord(); 
    PBL.address__c = input;
    //RecordId=ApexPages.currentPage().getParameters().get('id');
       }

    
   public PageReference save(){
         PBL.address__c= input;
          
         insert PBL;
         return null;
       }
}