public class facebookpagelistapi {

    public Accounts accounts;
    public String id;

    public class Paging {
        public Cursors cursors;
    }

    public class Cursors {
        public String before;
        public String after;
    }

    public class Data {
        public String access_token;
        public String category;
        public String name;
        public String id;
        public List<String> perms;
    }

    public class Accounts {
        public List<Data> data;
        public Paging paging;
    }

    
    public static facebookpagelistapi parse(String json) {
        return (facebookpagelistapi) System.JSON.deserialize(json, facebookpagelistapi.class);
    }
}