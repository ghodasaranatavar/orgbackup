public class facebookpagepostlistapi {

    public Feed feed;
    public String id;

    public class Paging {
        public String previous;
        public String next;
    }

    public class Data {
        public String message;
        public String created_time;
        public String id;
        public String story;
    }

    public class Feed {
        public List<Data> data;
        public Paging paging;
    } 
    public static facebookpagepostlistapi  parse(String json) {
        return (facebookpagepostlistapi ) System.JSON.deserialize(json, facebookpagepostlistapi .class);
    }  
    
}