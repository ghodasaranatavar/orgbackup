public class userpermissionAPI {

    public Permissions permissions;
    public String id;

    public class Permissions {
        public List<Data> data;
    }

    public class Data {
        public String permission;
        public String status;
    }

    
    public static userpermissionAPI parse(String json) {
        return (userpermissionAPI) System.JSON.deserialize(json, userpermissionAPI.class);
    }
}