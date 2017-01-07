public class Calendar_Controller
{
    
    private Date currentDay;
    public CalendarMonthV2 month{get;set;}
    private ID SObjectID{get;set;}
    public Contact currentContact {get;set;}
    public String typeview{get;set;}
    
    public boolean contactType {get;set;}
    
    
    public PageReference goBack()
    {

        PageReference PR = new PageReference('/'+SObjectID);
        PR.setRedirect(true);
        return PR;
        
    }
    public Calendar_Controller()
    {
         currentDay = system.today();  // default to today 
        integer mo = currentDay.month(); 
        
        String m_param = System.currentPageReference().getParameters().get('mo');
        String y_param = System.currentPageReference().getParameters().get('yr');
        System.debug('m_param' + m_param);
        SObjectID = System.currentPageReference().getParameters().get('ID');
        currentContact = new Contact();
        if(system.currentPageReference().getParameters().get('type')=='contact')
        {
            typeview = 'contact';
            contactType = true;
            currentContact = [select id,name, phone,Salutation,RecordType.Name from Contact where id=:SObjectID limit 1];
        }
        else
        {
            typeview = 'listing';
        }
         
        
        month = new CalendarMonthV2(System.date.today(),SObjectID);
        // allow a month to be passed in on the url as mo=10
        if (m_param != null) { 
            integer mi = integer.valueOf(m_param); 
            if (mi > 0 && mi <= 12) {
                currentDay = Date.newinstance(currentDay.year(),mi,currentDay.day());
            }
        }
        // and year as yr=2008
        if (y_param != null) { 
            integer yr = integer.valueOf(y_param); 
            currentDay = Date.newinstance(yr, currentDay.month(), currentDay.day());
        }
        
    }
    public Calendar_Controller(ApexPages.StandardController STD) 
    {
         
        currentDay = system.today();  // default to today 
        integer mo = currentDay.month(); 
        
        String m_param = System.currentPageReference().getParameters().get('mo');
        String y_param = System.currentPageReference().getParameters().get('yr');
        SObjectID = System.currentPageReference().getParameters().get('ID');
        currentContact = new Contact();
        if(system.currentPageReference().getParameters().get('type')=='contact')
        {
            typeview = 'contact';
            contactType = true;
            currentContact = [select id,name, phone,Salutation,recordType.Name from Contact where id=:SObjectID limit 1];
        }
        else
        {
            typeview = 'listing';
        }
         
        
        month = new CalendarMonthV2(System.date.today(),SObjectID);
        // allow a month to be passed in on the url as mo=10
        if (m_param != null) { 
            integer mi = integer.valueOf(m_param); 
            if (mi > 0 && mi <= 12) {
                currentDay = Date.newinstance(currentDay.year(),mi,currentDay.day());
            }
        }
        // and year as yr=2008
        if (y_param != null) { 
            integer yr = integer.valueOf(y_param); 
            currentDay = Date.newinstance(yr, currentDay.month(), currentDay.day());
        }
        
    }    
    
    public CalendarMonthV2 getMonth() 
    { 
        return month; 
    } 
    
    public void setMonth(Date d)
    {
        month = new CalendarMonthV2(d,SObjectID);
    }
    public void addMonth(integer val)
    { 
        Date d = month.getFirstDate();
        d = d.addMonths(val);
        setMonth(d);
    }    
    public List<Event> getMyTasksOnly(Date[] da)
    {
        List<Event> events = [select id from Event];
        
        
        return events;
    }    
    public void prev() 
    { 
        addMonth(-1); 
    }
    public void next() 
    { 
        addMonth(1);
    }
    public List<CalendarMonthV2.Week> getWeeks() { 
    system.assert(month!=null,'month is null');
    return month.getWeeks();
  }
}