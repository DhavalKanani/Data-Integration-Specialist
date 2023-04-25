@isTest
private class BillingCalloutServiceTest{
  @isTest
  private static void PositiveTestCase(){
    // Test data setup

    ServiceCredentials__c servCred = new ServiceCredentials__c();
    servCred.Name = 'BillingServiceCredential';
    servCred.Username__c = 'test';
    servCred.Password__c = 'test';
    insert servCred;


    Opportunity testOpp = new Opportunity();
    testOpp.name = 'Test Opportunity';
    testOpp.type = 'New Project';
    testOpp.CloseDate = system.today();
    testOpp.StageName = 'Negotiation/Review';
    testOpp.Amount = 500000;
    insert testOpp;

    Project__c projectOld = new Project__c(ProjectRef__c = 'testingRef', Name = 'Test', Opportunity__c = testOpp.Id, Start_Date__c = Date.today(), End_Date__c = Date.today() + 10, Billable_Amount__c = 10000, Status__c = '');

    Project__c projectNew = new Project__c(ProjectRef__c = 'testingRef', Name = 'Test', Opportunity__c = testOpp.Id, Start_Date__c = Date.today(), End_Date__c = Date.today() + 10, Billable_Amount__c = 10000, Status__c = 'Billable');
    insert projectNew;

    Map<Id, Project__c> oldMap = new Map<Id, Project__c>();
    oldMap.put(projectNew.Id, projectOld);
    Map<Id, Project__c> newMap = new Map<Id, Project__c>();
    newMap.put(projectNew.Id, projectNew);

    System.debug('oldMap: ' + oldMap);
    System.debug('newMap: ' + newMap);
    // Actual test
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    Test.startTest();
    BillingCalloutService.callBillingService(newMap, oldMap);
    Test.stopTest();
    System.assertEquals([SELECT count()
                     FROM Project__c
                     WHERE Status__c = 'Billed'], 1);


    // Asserts
  }

  @isTest
  private static void NegativeTestCase(){
    // Test data setup

    ServiceCredentials__c servCred = new ServiceCredentials__c();
    servCred.Name = 'BillingServiceCredential';
    servCred.Username__c = 'test';
    servCred.Password__c = 'test';
    insert servCred;


    Opportunity testOpp = new Opportunity();
    testOpp.name = 'Test Opportunity';
    testOpp.type = 'New Project';
    testOpp.CloseDate = system.today();
    testOpp.StageName = 'Negotiation/Review';
    testOpp.Amount = 500000;
    insert testOpp;

    Project__c projectOld = new Project__c(ProjectRef__c = 'testingRef', Name = 'Test', Opportunity__c = testOpp.Id, Start_Date__c = Date.today(), End_Date__c = Date.today() + 10, Billable_Amount__c = 10000, Status__c = '');

    Project__c projectNew = new Project__c(ProjectRef__c = 'testingRef', Name = 'Test', Opportunity__c = testOpp.Id, Start_Date__c = Date.today(), End_Date__c = Date.today() + 10, Billable_Amount__c = 10000, Status__c = 'Billable');
    insert projectNew;

    Map<Id, Project__c> oldMap = new Map<Id, Project__c>();
    oldMap.put(projectNew.Id, projectOld);
    Map<Id, Project__c> newMap = new Map<Id, Project__c>();
    newMap.put(projectNew.Id, projectNew);

    System.debug('oldMap: ' + oldMap);
    System.debug('newMap: ' + newMap);
    // Actual test
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
    Test.startTest();
    BillingCalloutService.callBillingService(newMap, oldMap);
    Test.stopTest();
    System.assertEquals([SELECT count()
                     FROM Project__c
                     WHERE Status__c = 'Billed'], 0);


    // Asserts
  }

}