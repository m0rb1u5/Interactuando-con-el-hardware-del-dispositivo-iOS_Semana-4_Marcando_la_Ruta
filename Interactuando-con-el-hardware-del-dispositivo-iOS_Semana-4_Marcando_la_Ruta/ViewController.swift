//
//  ViewController.swift
//  Interactuando-con-el-hardware-del-dispositivo-iOS_Semana-4_Marcando_la_Ruta
//
//  Created by Juan Carlos Carbajal Ipenza on 2/06/17.
//  Copyright © 2017 Juan Carlos Carbajal Ipenza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    private var penultimo: CLLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.manejador.delegate = self
        self.manejador.desiredAccuracy = kCLLocationAccuracyBest
        self.manejador.distanceFilter = 50
        self.manejador.requestWhenInUseAuthorization()
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegionMake(self.mapa.centerCoordinate , span)
        self.mapa.setRegion(region, animated: true)
        self.mapa.mapType = MKMapType.standard
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manejador.startUpdatingLocation()
            self.mapa.showsUserLocation = true
        }
        else {
            self.manejador.stopUpdatingLocation()
            self.mapa.showsUserLocation = false
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pin = MKPointAnnotation()
        pin.title = "(\(String(describing: (manager.location?.coordinate.longitude)!)), \(String(describing: (manager.location?.coordinate.latitude)!)))"
        pin.subtitle = ""
        if self.penultimo == nil {
            self.penultimo = manager.location
        }
        else {
            pin.subtitle = "\(String(describing: (manager.location?.distance(from: self.penultimo!))!)) m"
            self.penultimo = manager.location
        }
        pin.coordinate = (manager.location?.coordinate)!
        self.mapa.setCenter((manager.location?.coordinate)!, animated: true)
        self.mapa.addAnnotation(pin)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let nserror = error as NSError
        let title = NSLocalizedString("Error \(nserror.code)", comment: "")
        let message = NSLocalizedString(nserror.localizedDescription, comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { action in
            NSLog("La alerta acaba de ocurrir.")
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func cambiarTipoMapa(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapa.mapType = MKMapType.standard
            break
        case 1:
            self.mapa.mapType = MKMapType.satelliteFlyover
            break
        case 2:
            self.mapa.mapType = MKMapType.hybridFlyover
            break
        default:
            break
        }
    }
}

