public class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
   // Implement this interface method
   public HTTPResponse respond(HTTPRequest req){


      // Create a fake response
      HttpResponse res = new HttpResponse();

      res.setStatusCode(500);
      return res;
   }

}