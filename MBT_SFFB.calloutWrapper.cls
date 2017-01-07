public class calloutWrapper{

 public String body {get;set;}
 public String endpoint {get;set;}
 public String googleCalendarEmail {get;set;}
 public String googleEventId {get;set;}
 public String method {get;set;}
 public String ownerName {get;set;}
 public Id salesforceEventId {get;set;}
 public Id salesforceOwnerId {get;set;}
 //the constructor will allow us to automatically build wrapper
 public calloutWrapper(Event e){
 salesforceEventId = e.Id;
 if ( string.isNotBlank(e.Google_Id__c) ){
 googleEventId = e.Google_Id__c;
 }
 //call body build method
 body = googleCalendar_API.compileBodyFromEvent(e);
 }
 
}