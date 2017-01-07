/**
@author Innodel Technologies PVT LTD
@date 14 th NOV 2016
@description 
*/
public with sharing class google_home
{
    public string calendarevents{get;set;}
    public string primarycalendarid{get;set;}
    public string accesstoken {get;set;}
    
    public pagereference getcalendardata()
    {
        Pagereference p = ApexPages.currentPage(); 
        accesstoken = p.getParameters().get('access_token');
        
        if ((!(string.isBlank(accesstoken))))
        {
        //calendars=googleCalendarIntegration_API.Request_Google_Calendarlist(accesstoken);
        primarycalendarid=googleCalendarIntegration_API.Request_Google_Primary_Calendar(accesstoken);
        calendarevents=googleCalendarIntegration_API.Request_Google_Calendar_by_ID(primarycalendarid,accesstoken);
        
        }
        return null;
         
    }
}