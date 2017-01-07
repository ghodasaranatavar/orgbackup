/**

@author Innodel Technologies PVT LTD
@date 26 th OCT 2016
@description Authentication code , Autherisation
*/
public with sharing class google_Auth_Callback
{
    public string accesstoken {get;set;}
    
    public google_Auth_Callback()
    {
         //default constructor
    }
    public pagereference Retrieve_Accesstoken()
    {
        accesstoken= googleCalendarIntegration_API.Request_Google_token();
        if ((!(string.isBlank(accesstoken))))
        {
             Pagereference ps=new Pagereference('/apex/google_home_vf?access_token='+accesstoken);
            ps.setredirect(true);
            return ps;
        }
        return null;
       
    }
}