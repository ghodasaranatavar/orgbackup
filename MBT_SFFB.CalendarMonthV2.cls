public with sharing class CalendarMonthV2 
{
    private List<Week> weeks; 
    public Date firstDate; // always the first of the month
    private Date upperLeft; 
    public Boolean fiveDayView = false;
    public ID SObjectID{get;set;}
    
    public List<Date> getValidDateRange() 
    { 
        // return one date from the upper left, and one from the lower right
        List<Date> ret = new List<Date>();
        ret.add(upperLeft);
        ret.add(upperLeft.addDays(5*7) );
        return ret;
    }
    
    public String getMonthName() 
    { 
        return DateTime.newInstance(firstDate.year(),firstdate.month(),firstdate.day()).format('MMMM');
    } 
    
    public String getYearName() 
    { 
        return DateTime.newInstance(
            firstDate.year(),firstdate.month(),firstdate.day()).format('yyyy');
    } 
    
    public String[] getWeekdayNames() 
    { 
        Date today = system.today().toStartOfWeek();
        DateTime dt = DateTime.newInstanceGmt(today.year(),today.month(),today.day());      
        list<String> ret = new list<String>();
        for(Integer i = 0; i < 7;i++) 
        { 
            ret.add( dt.formatgmt('EEEE') );
            dt= dt.addDays(1);
        } 
        return ret;
    }
    
    public Date getfirstDate() { return firstDate; } 
    
    public CalendarMonthV2( Date value,ID SObjectID ) 
    {
        
        this.SObjectID = SObjectID;
        weeks = new List<Week>();
        firstDate = value.toStartOfMonth();
        upperLeft = firstDate.toStartOfWeek();
        Date tmp = upperLeft;
        for (Integer i = 0; i < 5; i++) 
        {
            Week w = new Week(i+1,tmp,value.month(),SObjectID);   
            system.assert(w!=null); 
            this.weeks.add( w );
            tmp = tmp.addDays(7);
        }
        
    }
    
    public void clearEvents()
    {
        for(Week w:weeks) 
        { 
            for(Day c: w.getDays() ) 
            { 
                c.eventsToday = new List<EventItem>();
            } 
        } 
    }
    
    public void setEvents(List<EventItem> ev) 
    { 
        // merge these events into the proper day 
        for(EventItem ei:ev) 
        { 
            Event e = ei.v;
            for(Week w:weeks) 
            { 
                for(Day c: w.getDays() ) 
                { 
                    if ( e.ActivityDate.isSameDay(c.theDate))  
                    { 
                        // add this event to this calendar date
                        c.eventsToday.add(New EventItem(e));
                        // add only three events, then a More... label if there are more
                    } 
                } 
            } 
        }
    }
    
    public List<Week> getWeeks() 
    { 
        system.assert(weeks!=null,'could not create weeks list');
        return this.weeks; 
    }
    
    public List<Week> getCurrentWeek(Date d)
    {
        List<Week> returnWeek = new List<Week>();
        for(Week w:weeks)
        {
            for(Day c: w.getDays())
            {
                if( d.isSameDay(c.theDate))
                {
                    returnWeek.add(w);
                    break;
                }
            }
        }
        weeks = returnWeek;
        return returnWeek;
    }
    
    
    /* 
* helper classes to define a month in terms of week and day
*/
    public with sharing class Week 
    {
        public List<Day> days;
        public Integer weekNumber; 
        
        public Date startingDate; // the date that the first of this week is on
        // so sunday of this week
        
        public List<Day> getDays() { return this.days; }
        
        public Week ()
        { 
            days = new List<Day>();     
        }
        public Week(Integer value,Date sunday,Integer month,ID SObjectID) 
        { 
            this();
            weekNumber = value;
            startingDate = sunday;
            Date tmp = startingDate;
            for (Integer i = 0; i < 7; i++) 
            {
                Day d = new Day( tmp,month,SObjectID ); 
                tmp = tmp.addDays(1);
                d.dayOfWeek = i+1;          
                //  system.debug(d);
                days.add(d);
            } 
            
        }
        public Integer getWeekNumber() { return this.weekNumber;}
        public Date getStartingDate() { return this.startingDate;}
        
    }
    
    public with sharing class Day 
    {
        
        public Date  theDate{get;set;}
        public List<EventItem>   eventsToday; // list of events for this date
        public Integer      month, dayOfWeek;
        public String       formatedDate; // for the formated time  
        private String      cssclass = 'calActive';
        
        public Date         getDate() { return theDate; }
        public Integer      getDayOfMonth() { return theDate.day(); }
        public String       getDayOfMonth2() 
        { 
            if ( theDate.day() <= 9 ) 
                return '0'+theDate.day(); 
            return String.valueof( theDate.day()); 
        }
        public Integer getDayOfYear() { return theDate.dayOfYear(); }
        public List<EventItem>   getDayAgenda() { return eventsToday; }
        public String       getFormatedDate() { return formatedDate; }
        public Integer      getDayNumber() { return dayOfWeek; }
        public List<EventItem>   getEventsToday() { return eventsToday; }
        public String       getCSSName() {  return cssclass; }
        
        public Day(Date value,Integer vmonth,ID SObjectID) 
        { 
            theDate=value; month=vmonth;        
            formatedDate = '12 21 08';// time range..
            //9:00 AM - 1:00 PM
            eventsToday = new List<EventItem>(); 
            List<Event> eventList = new List<Event>();
            if(!Test.isRunningTest()){
            eventList = [select ID,who.Name,What.Name,Subject,StartDateTime,EndDateTime,recordType.Name from Event where ActivityDate =:theDate AND (WhoID=:SObjectID OR WhatID=:SObjectID)];
            }
            else
            {
               new EventItem(new Event(Subject = 'For testing only',StartDateTime = system.Date.today(),EndDateTime= system.Date.today()));
            }
            
            
            for(Event v: EventList)
            {
                eventsToday.add(new EventItem(v));
            }
            // three possible Inactive,Today,Active  
            if ( theDate.daysBetween(System.today()) == 0 ) cssclass ='calToday';
            // define inactive, is the date in the month?
            if ( theDate.month() != month) cssclass = 'calInactive';
        }
        
    }
    
    public class EventItem
    {
        Public Event v {get;set;}
        public Integer hourResult{get;set;}
        public Integer minuteResult{get;set;}
        
        public EventItem(Event v)
        {
            this.v = v;
            Integer startInSeconds = (v.StartDateTime.year() * 31556926) + (v.StartDateTime.dayOfYear() * 86400) + (v.StartDateTime.hour() * 3600) + (v.StartDateTime.minute() * 60) + (v.StartDateTime.second() * 1); 
            Integer endInSeconds = (v.EndDateTime.year() * 31556926) + (v.EndDateTime.dayOfYear() * 86400) + (v.EndDateTime.hour() * 3600) + (v.EndDateTime.minute() * 60) + (v.EndDateTime.second() * 1); 
            
            //Diffrence between Start and End Date/Time in seconds  
            Integer totalDurationInSeconds = (endInSeconds - startInSeconds);
            hourResult= math.mod(math.floor(totalDurationInSeconds/3600).intValue(),24);
            minuteResult= math.mod(math.floor(totalDurationInSeconds/60).intValue(),60);
            //Integer secondResult = math.mod(math.floor(totalDurationInSeconds/1).intValue(),60);
        }
        
    }
    
}