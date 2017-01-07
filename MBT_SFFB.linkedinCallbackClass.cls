/**

@author Innodel Technologies PVT LTD
@date 19 th OCT 2016
@description Class is used to get accesstoken from linked IN
*/
public with sharing class linkedinCallbackClass 
{
    public string code {get;set;}
    public string state {get;set;}
    public string accesstoken {get;set;}
    public string postresult {get;set;}
    public string ownprofile {get;set;}
    public string ownformatedname{get;set;}
     public string ownphoto{get;set;}
     public string ownemail{get;set;}
     
    public linkedinCallbackClass()
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
        code = p.getParameters().get('code');
        state = p.getParameters().get('state');  
        if ((!(string.isBlank(code)))&&(!(string.isBlank(state))))
        {
            // have params

          Pagereference ps=new Pagereference('/apex/linkedinpostsharevf?access_token='+linkedin_API.gotAccessTocken(code,state));
            ps.setredirect(true);
            return ps;          
       
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

}