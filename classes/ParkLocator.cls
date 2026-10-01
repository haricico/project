public class ParkLocator {
    public static List<String> country(String countryName) {
        // Instantiate the generated ParkService.ParksImplPort class
        ParkService.ParksImplPort parkService = new ParkService.ParksImplPort();
        
        // Call the byCountry method and return the result
        return parkService.byCountry(countryName);
    }
}