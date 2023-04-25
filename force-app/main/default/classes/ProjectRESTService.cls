@RestResource(urlMapping = '/project')
global class ProjectRESTService{
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){
        Savepoint sp = Database.setSavepoint();
        try{
            Project__c project = new Project__c(ProjectRef__c = ProjectRef, Name = ProjectName, Opportunity__c = OpportunityId, Start_Date__c = StartDate, End_Date__c = EndDate, Billable_Amount__c = Amount, Status__c = Status);
            insert project;
            if (String.isNotBlank(OpportunityId)){
                Opportunity oppToUpdate = new Opportunity(Id = OpportunityId, DeliveryInstallationStatus__c = 'In progress');
                update oppToUpdate;
            }

        } catch (Exception e){
            Database.rollback(sp);
            return e.getMessage();
        }
        return 'OK';
    }

}