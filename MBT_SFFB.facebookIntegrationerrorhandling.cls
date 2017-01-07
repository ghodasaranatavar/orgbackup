public with sharing class facebookIntegrationerrorhandling
{
    public string accesstoken {get;set;}
    string publishpages='';
    string managepages =''; 
    public pagereference redirecttohome()
    {
        pagereference p = ApexPages.currentPage(); 
        accesstoken= p.getParameters().get('accesstoken');
        if ((!(string.isBlank(accesstoken)))&&(accesstoken!='null'))
        {
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
            }
        }
        return null;
    }
}