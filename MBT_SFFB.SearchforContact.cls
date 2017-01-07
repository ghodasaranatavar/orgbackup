public with sharing class SearchforContact {
    protected List<List<sObject>> searchResults  = new List<List<sObject>>{};
    
    public List<Contact> resultListContacts;
  
    public String searchFirstname{ get; set; }
    public String searchLastname{ get; set; }
    public String searchCompany{ get; set; }
    public String searchPhone{ get; set; }
    public String searchEmail{ get; set; }
    
    public boolean noContactResult{ get; set; }
   
    public boolean emptyContactList{ get; set; }
   
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; }
    public String errorSeverity{ get; set; }
  
    public Integer numContacts{ get; set; }
  
    
    public SearchforContact ( ) {
            
            emptyContactList = true;
         
            numContacts = 0;
            
            noContactResult = false;
         
            errorShow = false;
            errorTitle = '';
            errorMessage = '';
            errorSeverity = ''; 
    }
    
   

    public List<Contact> getresultListContacts() {
        return resultListContacts;
    }
    
   
    
    public PageReference search() {
        errorShow = false;
        string tablesFields = 'contact(id, phone, email, firstname, lastname, accountId)';
        string searchString = getSearchCriteria();
        string checkString = searchString.replace('*','').replace('?','');
        if (checkString.length() > 1) {
            try {
                searchString = 'find \'' + searchString + '\' in ALL FIELDS RETURNING ' + tablesFields;
                searchResults = search.query(searchString);
                
                resultListContacts = ((List<Contact>)searchResults[0]);
                numContacts = resultListContacts.size();
                emptyContactList = resultListContacts.isEmpty() ? true : false;
                noContactResult = emptyContactList;
               
            } catch (Exception e) {
                // System.debug('Error when executing the search: ' + e);
                errorTitle = e.getMessage();
                errorMessage = e.getMessage();
                errorSeverity = 'error';
                errorShow = true;
            }
        } else if (checkString.length() == 1) {
           
            numContacts = 0;
            
           
            emptyContactList = true;
           
           
            noContactResult = false;
           
            errorTitle = System.Label.sfError;
            errorMessage = System.Label.sfErrorMessage ;
            errorSeverity = 'error';
            errorShow = true;
        }       
        // return to the same page
        return null;
    }
 
    public PageReference reset() {
        
        numContacts = 0;
       
       
        emptyContactList = true;
       
        searchFirstname = '';
        searchLastname = '';
        searchCompany = '';
        searchPhone = '';
        searchEmail = '';
        errorTitle = '';
        errorMessage = '';
        errorSeverity = '';
        errorShow = false;        
        noContactResult = false;        
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

    

    public PageReference createNewContact(){
        PageReference pageRef = new PageReference('/003/e?retURL=%2F003%2Fo' + (searchFirstname != ''?'&name_firstcon2='+ searchFirstname : '') + (searchLastname != ''?'&name_lastcon2='+ searchLastname : '') + (searchPhone != ''?'&con10='+ searchPhone : '') + (searchEmail != ''?'&con15='+ searchEmail : ''));
        return pageRef; // + (searchCompany != ''?'&con4='+ searchCompany : '') 
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