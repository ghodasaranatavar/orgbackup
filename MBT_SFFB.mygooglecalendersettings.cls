public class mygooglecalendersettings{
    public String kind; //calendar#calendarList
    public String etag; //"p33g95rvhta9cu0g"
    public String nextSyncToken;    //COCS7_Hqks8CEhdzdGFmZi5pbm5vZGVsQGdtYWlsLmNvbQ==
    public cls_items[] items;
    class cls_items {
        public String kind; //calendar#calendarListEntry
        public String etag; //"1430400018092000"
        public String id;   //pjqnuaj3a4k60esnogq72740h8@group.calendar.google.com
        public String summary;  //Rose Task Manager
        public String timeZone; //UTC
        public String colorId;  //17
        public String backgroundColor;  //#9a9cff
        public String foregroundColor;  //#000000
        public String accessRole;   //owner
        public cls_defaultReminders[] defaultReminders;
    }
    class cls_defaultReminders {
    }
    public static mygooglecalendersettings parse(String json){
        return (mygooglecalendersettings) System.JSON.deserialize(json, mygooglecalendersettings.class);
    }   
    
}