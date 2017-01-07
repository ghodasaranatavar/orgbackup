public with sharing class getcalenderlist
{
    public static final string CALENDER_LIST_URL='https://www.googleapis.com/calendar/v3/users/me/calendarList';
     public static final string CALENDER_EVENT_URL='https://www.googleapis.com/calendar/v3/calendars/';
    public string bodyprint{get;set;}
    public string bodyprint1{get;set;}
    public Map<String, Object> parse(string jsonstring) 
    {
        // returns primary account
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonstring);
        List<Object> items = (List<Object>)root.get('items');
        Map<String, Object> primary =  new  Map<String, Object>();
        for (Object item : items) 
        {
            Map<String, Object> i = (Map<String, Object>)item;
            if(i.get('primary')==true)
            {
               primary =i;
            }
        }
        return primary;
    }  
    public void autoRun()
        {
            PageReference pr=ApexPages.currentPage();
            String tokenparam=pr.getParameters().get('token');
            String tokentypeparam=pr.getParameters().get('token_type');
            Datetime expiredatetime=Datetime.valueOf(pr.getParameters().get('expiresin')); 
            if(((tokenparam)!='')&&((tokenparam)!=null)&&((tokentypeparam)!='')&&((tokentypeparam)!=null)&&((expiredatetime)!=null))
            {
               Http h = new Http(); 
               HttpRequest req = new HttpRequest();
               req.setEndpoint(CALENDER_LIST_URL);
               req.setHeader('authorization',tokentypeparam+' '+tokenparam);
               req.setHeader('Content-Type','application/http');
               req.setMethod('GET');               
               HttpResponse res = h.send(req);                        
               system.debug('body'+res.getbody());
               bodyprint=res.getbody();
               Map<String, Object> primarycal = (Map<String, Object>)parse(bodyprint);
               bodyprint1='';
               bodyprint1=bodyprint1+primarycal.get('id');
              // CalendarService service = new CalendarService();
             //  service.setAuthSubToken(tokenparam);
             //  GoogleData.Calendar cal = service.getCalendarByTitle(bodyprint1);
             //  GoogleData evs = service.getFeed(cal.alternate);
              // List<object> event = (List<object>)evs;
              
            }
            
         }
    
}