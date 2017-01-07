public with sharing class SearchForLead {
    protected List<List<sObject>> searchResults  = new List<List<sObject>>{};
    public List<Lead> resultListLeads;
    
    public String searchFirstname{ get; set; }
    public String searchLastname{ get; set; }
    public String searchCompany{ get; set; }
    public String searchPhone{ get; set; }
    public String searchEmail{ get; set; }
    public boolean noLeadResult{ get; set; }
    
    public boolean emptyLeadList{ get; set; }
    
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; }
    public String errorSeverity{ get; set; }
    public Integer numLeads{ get; set; }
    
    
    public SearchForLead ( ) {
            emptyLeadList = true;            
            numLeads = 0;
            noLeadResult = false;
            errorShow = false;
            errorTitle = '';
            errorMessage = '';
            errorSeverity = ''; 
    }
    
    public List<Lead> getresultListLeads() {
        return resultListLeads;
    } 
    
    public PageReference search() {
        errorShow = false;
        string tablesFields = 'lead(id, phone, company, email, firstname, Status, lastname)';
        string searchString = getSearchCriteria();
        string checkString = searchString.replace('*','').replace('?','');
        if (checkString.length() > 1) {
            try {
                searchString = 'find \'' + searchString + '\' in ALL FIELDS RETURNING ' + tablesFields;
                searchResults = search.query(searchString);
                resultListLeads = ((List<Lead>)searchResults[0]);
                numLeads = resultListLeads.size();
                emptyLeadList = resultListLeads.isEmpty() ? true : false;
                noLeadResult = emptyLeadList;
                
            } catch (Exception e) {
                // System.debug('Error when executing the search: ' + e);
                errorTitle = e.getMessage();
                errorMessage = e.getMessage();
                errorSeverity = 'error';
                errorShow = true;
            }
        } else if (checkString.length() == 1) {
            numLeads = 0;
            
            emptyLeadList = true;
            
            noLeadResult = false;
            
            errorTitle = System.Label.sfError;
            errorMessage = System.Label.sfErrorMessage ;
            errorSeverity = 'error';
            errorShow = true;
        }       
        // return to the same page
        return null;
    }
 
    public PageReference reset() {
        numLeads = 0;
        
        emptyLeadList = true;
        
        searchFirstname = '';
        searchLastname = '';
        searchCompany = '';
        searchPhone = '';
        searchEmail = '';
        errorTitle = '';
        errorMessage = '';
        errorSeverity = '';
        errorShow = false;
        noLeadResult = false;
        
        return null;
    }

   
    private string getSearchCriteria() {
        String fullSearchString = '';
        String searchName = searchFirstname;
        if (searchName != ''){
            if (searchLastname != '') {
                searchName = searchFirstname + ' ' + searchLastname;
            }
        } else {
            searchName = searchLastname;    
        }
        fullSearchString = appendToSearchString(fullSearchString, searchName);
        fullSearchString = appendToSearchString(fullSearchString, searchCompany);
        fullSearchString = appendToSearchString(fullSearchString, searchPhone);
        fullSearchString = appendToSearchString(fullSearchString, searchEmail);
        return fullSearchString;
    }

    public PageReference createNewLead(){
        PageReference pageRef = new PageReference('/00Q/e?retURL=%2F00Q%2Fo' + (searchCompany != ''?'&lea3='+ searchCompany : '') + (searchFirstname != ''?'&name_firstlea2='+ searchFirstname : '') + (searchLastname != ''?'&name_lastlea2='+ searchLastname : '') + (searchPhone != ''?'&lea8='+ searchPhone : '') + (searchEmail != ''?'&lea11='+ searchEmail : ''));
        return pageRef;
    }
       
    private string appendToSearchString(String searchString, String newValue) {
        if (newValue != '') {
            if (searchString == '') {
                searchString = newValue;
            } else {
                searchString += ' OR ' + newValue;
            }
        }
        return searchString;
    }
}