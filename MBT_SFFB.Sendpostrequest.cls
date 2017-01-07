public with sharing class Sendpostrequest 
{
public integer countvalue {get;set;}
public string calendarid {get;set;}
public string authenticationtoken {get;set;}
public string title {get;set;}
public string code {get;set;}
public User u {get;set;}
public List<String> jsonserial = new List<String>();
 public Pagereference doOnLoad(){
 //retrieve current page
 Pagereference p = ApexPages.currentPage();
 //does it have a code as parameter?
 code = p.getParameters().get('code');
 //no? then stop
 if (string.isBlank(code)) return null;
 //it had one! get the state, aka email we passed
 //note you don't want to use googleEmail here
 //since we came back to the page, it reloaded and
 //the controller was reinstantiated, overriding our
 //input with the user's email
 string passedEmail = p.getParameters().get('state');
 //query for the user, with token fields so we can modify
 u = [select id, Google_Access_Token__c,
 Google_Refresh_Token__c from User where id =
 :userInfo.getUserId()];
 //call our api method to get tokens parsed into user
 u = googleCalendar_API.obtainAccessToken(u, code,googleCalendar_API.SF_AUTH_PAGE);
 //if we had no error
 if (u.Google_Access_Token__c != 'error'){
 //set the google email
  u.google_email__c = passedEmail;
  authenticationtoken =u.Google_Access_Token__c;  
   //Map<String, Object> primarycalc =  googleCalendar_API.parsecalenderid(googleCalendar_API.getcalenderidlist(authenticationtoken));
            title ='';
            title =title+ googleCalendar_API.getcalenderidlist(authenticationtoken);
          //jsonserial = (List<String>)System.JSON.deserialize(title, List<String>.class);
 //update the user and display success message 



 //update u;
 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm,'Authorized Successfully!'));
 }
 else{
 //had an error? well then let us know <sadface>
 ApexPages.addMessage(new
 ApexPages.message(ApexPages.severity.error,'Authorization Error.'));
 }
 //stay here, not going anywhere!
 return null;
 }
 public Map<Integer, String> getListofevent() 
    {
        // returns primary account
        Integer k=0;
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(title);
        List<Object> items = (List<Object>)root.get('items');
        Map<Integer, String> idlist = new Map<Integer, String>();
        Map<String, Object> primary =  new  Map<String, Object>();
        for (Object item : items) 
        {
            Map<String, Object> i = (Map<String, Object>)item;
            if(i.get('id')!='')
            {
               idlist.put(k,string.valueof(i.get('id')));
               k++;
            }
        }
        return idlist;
    }  
 /*public List<Object> getListofevent()
 {
     Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(title);
        List<Object> items = (List<Object>)root.get('items');
     //jsonserial = (List<String>)System.JSON.deserialize(title, List<String>.class);
     return items;
 }*/
/* public integer getListofevent()
 {
      CalendarService service = new CalendarService(); 
 service.setAuthSubToken(authenticationtoken); 
 GoogleData feed = service.getFeed( CalendarService.ownCalendars );      
list<GoogleData.Calendar> cals = GoogleData.calendarFactory(feed.entries);
//countvalue=0;
//if((cals!=null) && (!cals.isEmpty()))
//{
//countvalue=cals.size();
//}
//return countvalue;
 }*/
   /* public GoogleData getListofevent()
    {
            Map<String, Object> primarycalc =  googleCalendar_API.parsecalenderid(googleCalendar_API.getcalenderidlist(authenticationtoken));
            title ='';
            title =title +primarycalc.get('summary');
             
            CalendarService service = new CalendarService(); 
            service.setAuthSubToken(authenticationtoken);
            GoogleData.Calendar cal = service.getCalendarByTitle(title);            
            GoogleData evs = service.getFeed(cal.alternate );
            return evs;
            GoogleData feed = service.getFeed(CalendarService.ownCalendars);      
            list<GoogleData.Calendar> cals = GoogleData.calendarFactory(feed.entries);
            return cals;
               
        
    }*/
}