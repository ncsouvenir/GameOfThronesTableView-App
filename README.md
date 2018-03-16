# GameOfThronesTableView-App

SevenDay allows users to see their weekly forecast based on their zipcode and see additional information.

## Code Samples

### ZipCode Helper
- This helper class holds a function that takes in a zipcode as a string and returns the city's name based that zipcodes geographic location

```swift
class ZipCodeHelper {
    private init() {}
    static let manager = ZipCodeHelper()
    
    func getLocationName(from zipCode: String,
                         completionHandler: @escaping (String) -> Void,
                         errorHandler: @escaping (Error) -> Void) {
        
        let geocoder = CLGeocoder() // An interface for converting between geographic coordinates and place names.
        
        DispatchQueue.global(qos: .userInitiated).async {
            geocoder.geocodeAddressString(zipCode){(placemarks, error) -> Void in
                DispatchQueue.main.async {
                    if let placemark = placemarks?.first, let name = placemark.locality {
                        completionHandler(name)
                    } else if let error = error{
                        errorHandler(error)
                    }
                }
            }
        }
    }
}

```

### Weather API Client
- This API Client class is a singleton that wraps a function for getting a forecast
- The function does the following:
  - makes asynchronous calls to retrieve data from the internet
  - makes sure there is a valid url passed when the function is called
  - parses weather data from data model into an array of forecast
  - This information is passed into the Network Helper that facilitates internet access

```swift
class WeatherAPIClient {
    private init(){}
    static let manager = WeatherAPIClient()
    
    func getForecast(fromString urlStr: String,
                     completionHandler: @escaping ([SevenDayForecast]) -> Void,
                     errorHandler: @escaping (Error) -> Void){
        
        guard let url = URL(string: urlStr) else {return}
        
        let request = URLRequest(url: url)
        let parseDataIntoWeather: (Data) -> Void = {(data) in
            do{
                let decoder = JSONDecoder()
                let results = try decoder.decode(WeatherResponseWrapper.self, from: data)
                if let forecast = results.response.first?.periods{
                    completionHandler(forecast)
                }
            } catch {
                errorHandler(AppError.badData)
                print("bad data from weather")
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoWeather,
                                              errorHandler: errorHandler)
    }
}

```

## App Flow

Enter zipcode to retrieve weekly forecast | Select a day to view additional forecast information including a random image of the city matching the zip code. User can also add to favorites | Delete photos from list of favorites
:---: | :---: | :---: 
![gif](https://github.com/ncsouvenir/SevenDay/blob/master/Gifs/gettingForecastWithZipcode.gif) Weather Tab | ![gif](https://github.com/ncsouvenir/SevenDay/blob/master/Gifs/addingToFavorites.gif) Weather Tab / Favorites Tab | ![gif](https://github.com/ncsouvenir/SevenDay/blob/master/Gifs/deletingFavorites.gif) Favorites Tab



## Endpoints

1. [Aeris Weather API](https://www.aerisweather.com/support/docs/api/)
2. [Pixabay API](https://pixabay.com/api/docs/)




## Technologies used

- Progrommatic AutoLayout
- File Manager to store favorites
- UIView Animation



## Future Updates
In continuing to iterate on this project I would like to do the following:

- In the Favorites tab, incorporate a long press gesture on the image to present the city's name
- Add options for the user to see a 3-day forecast and an hourly forecast for the current day


### Thanks for reading and I welcome any feedback!

