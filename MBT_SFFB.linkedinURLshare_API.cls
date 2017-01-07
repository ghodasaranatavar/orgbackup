public class linkedinURLshare_API 
{
    public String comment='';
    public Content content{get;set;}
    public Visibility visibility{get;set;}
    public class Content 
    {
        public String title='';
        public String description='';
        public String submitted_url='';
        public String submitted_image_url='';        
    }
    public class Visibility 
    {
        public String code='';
    } 
    
}