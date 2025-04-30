public class demoController {
    public String accountId { get; set; }
    public List<Opportunity> opps { get; set; }
    public ApexPages.StandardSetController accountSetController { get; set; }

    public demoController(ApexPages.StandardSetController controller) {
        accountSetController = controller;
        accountSetController.setPageSize(10); 
    }

    public List<Opportunity> getOpps() {
        if (accountId != null) {
            System.debug('Opportunitiesfetching of account id '+accountId);
            opps = [SELECT Id, Name FROM Opportunity WHERE AccountId = :accountId];
        } else {
            opps = new List<Opportunity>();
        }
        return opps;
    }

    public void setAccount() {
        opps = getOpps();
    }

}