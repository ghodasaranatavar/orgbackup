public with sharing class SearchForAccount {
    protected List<List<sObject>> searchResults  = new List<List<sObject>>{};    
    public List<Account> resultListAccounts;
    public String searchFirstname{ get; set; }
    public String searchLastname{ get; set; }
    public String searchCompany{ get; set; }
    public String searchPhone{ get; set; }
    public String searchEmail{ get; set; }    
    public boolean noAccountResult{ get; set; }     
    public boolean emptyAccountList{ get; set; }
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; }
    public String errorSeverity{ get; set; }    
    public Integer numAccounts{ get; set; }
    
    public SearchForAccount ( ) {            
            emptyAccountList = true;            
            numAccounts = 0;            
            noAccountResult = false;
            errorShow = false;
            errorTitle = '';
            errorMessage = '';
            errorSeverity = ''; 
    }
    
    
    public List<Account> getresultListAccounts() {
        return resultListAccounts;
    }
    
    public PageReference search() {
        errorShow = false;
        string tablesFields = 'account(id, phone, type, name)';
        string searchString = getSearchCriteria();
        string checkString = searchString.replace('*','').replace('?','');
        if (checkString.length() > 1) {
            try {
                searchString = 'find \'' + searchString + '\' in ALL FIELDS RETURNING ' + tablesFields;
                searchResults = search.query(searchString);                
                resultListAccounts = ((List<Account>)searchResults[0]); 
                numAccounts = resultListAccounts.size();     
                emptyAccountList = resultListAccounts.isEmpty() ? true : false;
                noAccountResult = emptyAccountList;
            } catch (Exception e) {
                // System.debug('Error when executing the search: ' + e);
                errorTitle = e.getMessage();
                errorMessage = e.getMessage();
                errorSeverity = 'error';
                errorShow = true;
            }
        } else if (checkString.length() == 1) {
            
            numAccounts = 0;            
            emptyAccountList = true;           
            noAccountResult = false;
            errorTitle = System.Label.sfError;
            errorMessage = System.Label.sfErrorMessage ;
            errorSeverity = 'error';
            errorShow = true;
        }       
        // return to the same page
        return null;
    }
 
    public PageReference reset() {        
        numAccounts = 0;        
        emptyAccountList = true;
        searchFirstname = '';
        searchLastname = '';
        searchCompany = '';
        searchPhone = '';
        searchEmail = '';
        errorTitle = '';
        errorMessage = '';
        errorSeverity = '';
        errorShow = false;        
        noAccountResult = false;
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

   
    
    public PageReference createNewAccount(){
        PageReference pageRef = new PageReference('/001/e?retURL=%2F001%2Fo' + (searchCompany != ''?'&acc2='+ searchCompany : '') );
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