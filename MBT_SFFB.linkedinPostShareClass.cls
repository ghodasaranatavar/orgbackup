/**

@author Innodel Technologies PVT LTD
@date 19 th OCT 2016
@description Class is used to get accesstoken from linked IN
*/
public with sharing class linkedinPostShareClass 
{
    
    public string accesstoken {get;set;}
    public string postresult {get;set;}
    public string ownprofile {get;set;}
    public string ownformatedname{get;set;}
     public string ownphoto{get;set;}
     public string ownemail{get;set;}
     public string code {get;set;}
    public linkedinPostShareClass()
    {
        // default Construct
    }
    /**
@date 19 th OCT 2016
@description gets parameter of the page and sends values from param to the linkedin_API class for post request
*/
    public Pagereference getParamsOfPage()
    {
        Pagereference p = ApexPages.currentPage(); 
        code = p.getParameters().get('access_token');

        if ((!(string.isBlank(code))))
        {
            // have params
          //linkedin_API.LINKEDIN_ACCESSTOKEN= linkedin_API.gotAccessTocken(code,state);          
           ownprofile = linkedin_API.getOwnProfile(code);
          ownformatedname=linkedin_API.getOwnFormatedName(ownprofile);
          ownphoto=linkedin_API.getOwnPhoto(ownprofile);
          ownemail=linkedin_API.getOwnEmail(ownprofile);
        }
        else
        {
            // error one of the is null
            string error = p.getParameters().get('error');            
            string access_denied= p.getParameters().get('access_denied');
            string error_description= p.getParameters().get('error_description');
            
            
        }
        return null;
 
    }
    @RemoteAction
    public static String sharepost(String post,String access_token)
    {  
        return linkedin_API.sharePost(post,access_token);       
        
    }
}