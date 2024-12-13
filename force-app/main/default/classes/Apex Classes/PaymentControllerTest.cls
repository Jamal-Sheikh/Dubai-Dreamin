@isTest
global  class PaymentControllerTest {
 
    // Mock response data
    private static final String MOCK_API_RESPONSE = '{"data":[{"id":"price_1","nickname":"EARLY BIRD","unit_amount":1000,"currency":"usd"},{"id":"price_2","nickname":"FULL TICKET","unit_amount":2000,"currency":"usd"}]}';

    @isTest
    static void testRetrievePrice() {
        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method under test
        Test.startTest();
        List<Price> prices = PaymentController.retrievePrice();
        Test.stopTest();

        // Verify the results
        System.assertEquals(2, prices.size(), 'Incorrect number of prices returned');

        // Additional assertions based on specific data in MOCK_API_RESPONSE
        Price standardPrice = prices[0];
        Price premiumPrice = prices[1];

        System.assertEquals('EARLY BIRD', standardPrice.nickname, 'Incorrect nickname for early bird price');
        System.assertEquals(10, standardPrice.unitAmount, 'Incorrect unit amount for early bird price');
        // More assertions for standardPrice...

        System.assertEquals('FULL TICKET', premiumPrice.nickname, 'Incorrect nickname for full ticket price');
        System.assertEquals(20, premiumPrice.unitAmount, 'Incorrect unit amount for full ticket price');
        // More assertions for premiumPrice...
    }

    // Inner class to generate mock HTTP response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(MOCK_API_RESPONSE);
            res.setStatusCode(200);
            return res;
        }
    }
   
    
    
}