public class BillingCalloutService{
    //Implement business and callout logic methods here
    public static void callBillingService(Map<Id, Project__c> newMap, Map<Id, Project__c> oldMap){
        List<Project__c> updateStatusOfProject = new List<Project__c>();
        for (Project__c current : newMap.values()){

            if (current.Status__c.equals('Billable') && !oldMap.get(current.id).Status__c.equals('Billable')){
                calloutToInvoce(current.Billable_Amount__c, current.Id);
            }

        }
        for (Project__c current : updateStatusOfProject){
            current.Status__c = 'Billed';
        }
        update updateStatusOfProject;
    }

    @future(callout = true)
    public static void calloutToInvoce(Decimal billAmount, Id projectId){
        ServiceCredentials__c srvcCrd = ServiceCredentials__c.getValues('BillingServiceCredential');

        BillingServiceProxy.project projectInstance = new BillingServiceProxy.project();
        projectInstance.username = srvcCrd.Username__c;
        projectInstance.password = srvcCrd.Password__c;
        projectInstance.billAmount = billAmount;
        BillingServiceProxy.InvoicesPortSoap11 invoiceCallout = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invoiceCallout.billProject(projectInstance);
        System.debug('response: ' + response);
        if (response.equalsIgnoreCase('OK')){
            update new Project__c(Id = projectId, Status__c = 'Billed');
        }
    }

}