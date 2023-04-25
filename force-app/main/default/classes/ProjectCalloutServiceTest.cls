@isTest
private class ProjectCalloutServiceTest{
  public static Opportunity getOpportunity(Id AccId){
    return new Opportunity(Name = 'Testing', Amount = 1000, CloseDate = Date.today(), AccountId = AccId, StageName = 'Closed Won', Type = 'New Project');
  }

  public static Account getAccount(){
    return new Account(Name = 'Testing Acc');
  }

  @isTest
  public static void positive_Test(){

    ServiceTokens__c servToken = new ServiceTokens__c();
    servToken.Name = 'ProjectServiceToken';
    servToken.Token__c = 'test';
    insert servToken;


    Account acc = getAccount();
    insert acc;
    Opportunity opp = getOpportunity(acc.id);
    insert opp;
    System.debug('opp: sss' + opp);
    //opp.StageName = 'Closed Won';

    List<Id> oppId = new List<Id>();
    oppId.add(opp.Id);
    // System.debug('opp: ' + oppId);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(oppId);
    //update opp;
    Test.stopTest();

    Opportunity updatedOpp = [SELECT Id, StageName
                          FROM Opportunity
                          WHERE Id = :opp.id];
    // system.assertEquals(updatedOpp.StageName, 'Submitted Project');
  }

  @isTest
  public static void negative_Test(){

    ServiceTokens__c servToken = new ServiceTokens__c();
    servToken.Name = 'ProjectServiceToken';
    servToken.Token__c = 'test';
    insert servToken;


    Account acc = getAccount();
    insert acc;
    Opportunity opp = getOpportunity(acc.id);
    insert opp;
    System.debug('opp: sss' + opp);
    //opp.StageName = 'Closed Won';

    List<Id> oppId = new List<Id>();
    oppId.add(opp.Id);
    // System.debug('opp: ' + oppId);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(oppId);
    //update opp;


    Opportunity updatedOpp = [SELECT Id, StageName
                          FROM Opportunity
                          WHERE Id = :opp.id];
    //system.assertEquals(updatedOpp.StageName, 'Resubmit Project');
    Test.stopTest();
  }

}