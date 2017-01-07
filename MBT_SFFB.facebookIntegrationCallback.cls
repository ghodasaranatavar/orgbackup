/**
@author Innodel Technologies PVT LTD
@date 9 th NOV 2016
@description Class Handles Integration Callback from Facebook. facebook will redirect here. Access token will be retrived from here.
*/
public with sharing class facebookIntegrationCallback
{
 public string code {get;set;} 
 public string accesstoken {get;set;} 
    string publishpages='';
    string managepages =''; 
public facebookIntegrationCallback()
{

}
   /**
@date 9 th NOV 2016
@description Method is used to retrive code from URL and get accesstoken from facebook and forward accesstoken to facebookintegrationhome page.
*/
    public pagereference redirecttohome()
    {
        pagereference p = ApexPages.currentPage(); 
        code = p.getParameters().get('code');
        Facebook_oauth_Setting__c objfb_oauth_setting =[select client_id__c,client_secret__c from Facebook_oauth_Setting__c limit 1];
         
        if ((!(string.isBlank(code))))
        {
            // have params
            // check for permissions which are granted.
            Pagereference ps=new Pagereference('/apex/facebookintegrationerrorhandling?accesstoken='+(facebookAPI.gotAccessTocken(code)));
            ps.setredirect(true);
            return ps;
            /* accesstoken=facebookAPI.gotAccessTocken(code);
           userpermissionAPI objuserpermissionAPI = new userpermissionAPI();
            objuserpermissionAPI=userpermissionAPI.parse(facebookAPI.getuserpermission(accesstoken));
            List<userpermissionAPI.Data> objuserpermission=objuserpermissionAPI.Permissions.data;
            if(objuserpermission.size()>0)
            {
                for(integer i=0;i<objuserpermission.size();i++)
                {
                    if(objuserpermission[i].permission=='publish_pages')
                    {
                        publishpages=objuserpermission[i].status;
                    }
                    else if(objuserpermission[i].permission=='manage_pages')
                    {
                        managepages=objuserpermission[i].status;
                    }
                }
                if((publishpages=='granted')&&(managepages=='granted'))
                {
                    Pagereference ps=new Pagereference('/apex/facebookintegrationhome?access_token='+accesstoken);
                    ps.setredirect(true);
                    return ps;
                }
                else if((publishpages!='granted')||(managepages!='granted'))
                {
                    Pagereference ps=new Pagereference('/apex/facebookloginerrorpage?error=neededpermissiondeclined');
                    ps.setredirect(true);
                    return ps;
                }                
            }*/
           
        }
        else
        {
            // error one of the is null
            string error = p.getParameters().get('error');            
            string access_denied= p.getParameters().get('access_denied');
            string error_description= p.getParameters().get('error_description');
            Pagereference ps=new Pagereference('/apex/facebookloginerrorpage?error='+error);
            ps.setredirect(true);
            return ps;            
            
        }
        return null;
 
    }
     /**
@date 9 th NOV 2016
@description Method is used to retrive client with App secret and App ID.
*/
     public Facebook_oauth_Setting__c getclient()
       {
           return [select client_id__c,client_secret__c from Facebook_oauth_Setting__c limit 1]; 
           
       } 
}