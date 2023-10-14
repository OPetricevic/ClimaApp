//
//  ViewController.swift
//  Clima
//
//  Created by Omar Petričević on 04.03.2023..
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // omogucava nestajanje tastature kad se prestane kucat sa true
        print(searchTextField.text!)
        return true
        // metod za koristenje "Go" na tastaturi na mobitelu
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (searchTextField.text != "") {
            return true
        } else {
            textField.placeholder = "Type something!"
            return false
        }
        
    }
    
//MARK: - WeatherManagerDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if let city = searchTextField.text{
            weatherManager.fetchWeather(citName: city)
        }
        // use searchTextField.text
        searchTextField.text = "" // čisti nakon "go" ili search buttona
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel){
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName // Ispis imena na ekranu zavisno od vrijednosti sa weather methoda iz Langtitute itd
        }
       
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitute: lat, longitute: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
