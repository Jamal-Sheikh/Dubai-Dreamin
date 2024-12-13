public class PriceParser {
public static List<Price> parsePrices(String jsonString) {
        // Parse JSON string into a Map
        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        
        // Extract the 'data' array
        List<Object> dataList = (List<Object>) jsonData.get('data');
        
        // List to hold Price objects
        List<Price> prices = new List<Price>();
        
        // Iterate through each object in the 'data' array
        for (Object obj : dataList) {
            Map<String, Object> priceData = (Map<String, Object>) obj;
            
            // Create a new Price object
            Price price = new Price();
            
            // Fetch and assign 'id' and 'nickname' fields to the Price object
            price.id = (String) priceData.get('id');
            price.nickname = (String) priceData.get('nickname');
            price.unitAmount = ((Decimal) priceData.get('unit_amount')) / 100;
            // Add the Price object to the list
            prices.add(price);
        }
        // System.debug()
        // // Print the fetched data
        // for (Price p : prices) {
        //     System.debug('Nickname: ' + p.nickname + ', ID: ' + p.id);
        // }

        return prices;
    }
}