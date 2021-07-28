//
//  ViewController.swift
//  climaAppIos
//
//  Created by chekir walid on 25/7/2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self//for the extesion location to can be used by requestLocation
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //When using this method, the associated delegate must implement the locationManager(_:didUpdateLocations:) and locationManager(_:didFailWithError:) methods. Failure to do so is a programmer error.
        
        weatherManager.delegate = self //protocol communication view controller get data into the phone
        searchTextField.delegate = self //btn go clavier
    }
    @IBAction func currentLocationButtonPresed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
// MARK: -UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{//UITextFieldDelegate btn go clavier
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    //btn go clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)//end selection
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            searchTextField.endEditing(true)
            return true
        }else{
            textField.placeholder = "Type something"
            return false // we do not end Editing
        }
    }
    //when endEditing true
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(cityName: searchTextField.text!)
        searchTextField.text = ""
    }
    
}

// MARK: -WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate { //WeatherManagerDelegate protocol
    //method of the protocole WeatherManagerDelagate
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    //method of the protocole WeatherManagerDelagate
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: -CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()//save power phone only when we press btn or run app they get location
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            print(lon)
            print(lat)
            weatherManager.fetchWeather(lon: lon, lat: lat)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
