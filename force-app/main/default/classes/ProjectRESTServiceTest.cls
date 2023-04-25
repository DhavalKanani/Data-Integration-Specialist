@isTest
private class ProjectRESTServiceTest{
  //Implement Apex REST service tests here
  @isTest
  public static void positive_Test(){

    Opportunity opp = new Opportunity(Name = 'Test project', CloseDate = Date.today(), StageName = 'Closed Won');
    insert opp;
    ProjectRESTService.postProjectData('TestRef', 'MyTestProject', opp.Id, Date.today(), Date.today() + 5, 1000, 'Billable');

    System.assertEquals([SELECT count()
                     FROM Project__C], 1);
    System.assertEquals([SELECT count()
                     FROM Opportunity
                     WHERE DeliveryInstallationStatus__c = 'In progress'], 1);
  }

  @isTest
  public static void negative_Test(){


    ProjectRESTService.postProjectData('TestRef', 'MyTestProject', '123', Date.today(), Date.today() + 5, 1000, 'Billable');

    System.assertEquals([SELECT count()
                     FROM Project__C], 0);
    System.assertEquals([SELECT count()
                     FROM Opportunity
                     WHERE DeliveryInstallationStatus__c = 'In progress'], 0);
  }

}