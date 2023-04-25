public class ProjectCalloutServiceMock implements HttpCalloutMock{
   // Implement this interface method
   public HTTPResponse respond(HTTPRequest req){


      // Create a fake response
      HttpResponse res = new HttpResponse();

      res.setStatusCode(201);
      return res;
   }

}