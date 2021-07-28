//
//  WeatherManager.swift
//  climaAppIos
//
//  Created by chekir walid on 26/7/2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3b82889a5da9021fc0927de9def3d464&units=metric"
    var delegate: WeatherManagerDelegate?//protocol communication view controller
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(lon: Double, lat: Double) {
        let urlString = "\(weatherURL)&lon=\(lon)&lat=\(lat)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {//with when method call and urlString use inside method
        if let url = URL(string: urlString) {//1
            let session = URLSession(configuration: .default)//2
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)//protocol communication view controller
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)//protocol communication view controller
                    }
                }
            }//3
            task.resume()//4 start the task
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)//WeatherData struc herit from decodable
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weatherModel = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weatherModel
        } catch {
            delegate?.didFailWithError(error: error)//protocol communication view controller
            return nil
        }
    }
    
}
