public class ProjectCalloutService{
    //Complete the implementation for business and callout logic
    @InvocableMethod(label = 'Post Opportunity To PMS'category = 'Opportunity')
    public static void postOpportunityToPMS(List<Id> OpportunityId){
        System.debug('OpportunityId: ' + OpportunityId);
        String token = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        Opportunity opp = [SELECT Name, Amount, CloseDate, Account.Name
                           FROM Opportunity
                           WHERE Id = :OpportunityId[0]
                           LIMIT 1];
        String body = '{ "opportunityId": "' + opp.Id + '", "opportunityName": "' + opp.Name + '", "accountName": "' + opp.Account.Name + '", "closeDate": "' + opp.CloseDate + '", "amount": ' + opp.Amount + ' }';
        System.enqueueJob(new QueueablePMSCall(opp.Id, token, body));
    }

    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts{
        String body;
        String token;
        Id id;
        public QueueablePMSCall(Id id, String token, String body){
            this.id = id;
            this.body = body;
            this.token = token;
        }

        public void execute(QueueableContext qc){
            System.debug('inside quable: ');
            postOpportunityToPMSCallout(id, token, body);
        }

    }

    @future(callout = true)
    public static void postOpportunityToPMSCallout(Id id, String token, String body){
        System.debug('inside callout: ');
        Http httpObject = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
        request.setHeader('token', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(body);
        HttpResponse response = httpObject.send(request);
        String responseBody = response.getBody();
        Opportunity opp = new Opportunity(Id = id);
        if (response.getStatusCode() == 201){
            opp.StageName = 'Submitted Project';
        } else{
            opp.StageName = 'Resubmit Project';
        }
        update opp;
        System.debug('opp Final: ' + opp);
    }

}