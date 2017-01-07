public class testing
{
    public string jsonstring='{"id": "100007118702451","name": "Staff Innodel","cover": {"id": "1836971723216767","offset_y": 0,"source": "https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/15079027_1836971723216767_6452940710532788510_n.jpg?oh=c5a6d635be2c76d9cb3f36d04e3acb60&oe=58D1BFEB"},"email": "staff@innodel.com"}';
    public string coded {get;set;}
    public PageReference listd()
    {
         coded = deserializejson(jsonstring,'email');       
        return null;
    }
     public String deserializejson(string jsonstring,string fieldname) 
    {
        JSONParser parser = JSON.createParser(jsonstring);
        string LINKEDIN_JSONTOKEN='';
        while (parser.nextToken() != null) 
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == fieldname)) 
            {              
                parser.nextToken();
               LINKEDIN_JSONTOKEN=parser.getText();
             
            }
        }
        return LINKEDIN_JSONTOKEN;
    } 
    public String deserializejson2(string jsonstring,string fieldname,string secondfield) 
    {
        JSONParser parser = JSON.createParser(jsonstring);
        string LINKEDIN_JSONTOKEN='';
        while (parser.nextToken() != null) 
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == fieldname)) 
            {              
                parser.nextToken();
               LINKEDIN_JSONTOKEN=parser.getText();
                 
            }
        }
        return LINKEDIN_JSONTOKEN;
    }   
}