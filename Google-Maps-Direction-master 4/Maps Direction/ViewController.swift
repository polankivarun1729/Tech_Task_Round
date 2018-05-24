//
//  ViewController.swift
//  Maps Direction
//
//  Created by varun.polanki
//  Copyright varun.polanki. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum Location {
	case startLocation
	case destinationLocation
}
extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
}
class ViewController: UIViewController , GMSMapViewDelegate ,  CLLocationManagerDelegate {
 
    @IBAction func btn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.viewcnstrnt.constant = -200
        }
        
    }
    
    
    @IBOutlet weak var vw: customView!
    
    @IBOutlet weak var viewcnstrnt: NSLayoutConstraint!
    
    @IBAction func panGeas(_ sender: UIPanGestureRecognizer) {
       
            
        DispatchQueue.main.async {
            
        
        if sender.state == .began || sender.state == .changed {
            
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 {
                
                if self.viewcnstrnt.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.viewcnstrnt.constant += translation / 10
                        self.view.layoutIfNeeded()
                        
                    })
                }
                
            }else {
                if self.viewcnstrnt.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.viewcnstrnt.constant += translation / 10
                        self.view.layoutIfNeeded()
                        
                    })
                }
            }
            
            
        } else if sender.state == .ended {
            
            if self.viewcnstrnt.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.viewcnstrnt.constant = -175
                    self.view.layoutIfNeeded()
                    
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.viewcnstrnt.constant = 0
                    self.view.layoutIfNeeded()
                    
                })
            }
            
        }
        
        
        
        
        }}
    

    
    @IBOutlet weak var googleMaps: GMSMapView!
	@IBOutlet weak var startLocation: UITextField!
	@IBOutlet weak var destinationLocation: UITextField!
	

	var locationManager = CLLocationManager()
	var locationSelected = Location.startLocation
	
	var locationStart = CLLocation()
	var locationEnd = CLLocation()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
       vw.backgroundColor = UIColor.clear
        
         viewcnstrnt.constant = -200
        
        
        
        
        
        
        
        
        
        
     
     
        self.googleMaps.mapStyle(withFilename: "dark", andType: "json")
       
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startMonitoringSignificantLocationChanges()
		
		
		let camera = GMSCameraPosition.camera(withLatitude: 19.0760, longitude: 72.8777, zoom: 15.0)
		
		self.googleMaps.camera = camera
		self.googleMaps.delegate = self
		self.googleMaps?.isMyLocationEnabled = true
		self.googleMaps.settings.myLocationButton = true
		self.googleMaps.settings.compassButton = true
		self.googleMaps.settings.zoomGestures = true
		
	}
	
	
	func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2DMake(latitude, longitude)
		marker.title = titleMarker
		marker.icon = iconMarker
		marker.map = googleMaps
	}
	
	
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error to get location : \(error)")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		let location = locations.last
		

        
		let locationTujuan = CLLocation(latitude: 19.0760, longitude: 72.8777)
		
		createMarker(titleMarker: "Mumbai", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: locationTujuan.coordinate.latitude, longitude: locationTujuan.coordinate.longitude)
		
		createMarker(titleMarker: "Mumbai", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
		
		drawPath(startLocation: location!, endLocation: locationTujuan)
		

		self.locationManager.stopUpdatingLocation()
		
	}
	

	
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
		googleMaps.isMyLocationEnabled = true
	}
	
	func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
		googleMaps.isMyLocationEnabled = true
		
		if (gesture) {
			mapView.selectedMarker = nil
		}
	}
	
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		googleMaps.isMyLocationEnabled = true
		return false
	}
	
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		print("COORDINATE \(coordinate)") // when you tapped coordinate
	}
	
	func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
		googleMaps.isMyLocationEnabled = true
		googleMaps.selectedMarker = nil
		return false
	}
	
	
	func drawPath(startLocation: CLLocation, endLocation: CLLocation)
	{
		let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
		let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
		
		
		let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
		
		Alamofire.request(url).responseJSON { response in
			
			print(response.request as Any)
			print(response.response as Any)
			print(response.data as Any)
			print(response.result as Any)
			
			let json = JSON(data: response.data!)
			let routes = json["routes"].arrayValue
			
			
			for route in routes
			{
				let routeOverviewPolyline = route["overview_polyline"].dictionary
				let points = routeOverviewPolyline?["points"]?.stringValue
				let path = GMSPath.init(fromEncodedPath: points!)
				let polyline = GMSPolyline.init(path: path)
				polyline.strokeWidth = 10
				polyline.strokeColor = UIColor.black
				polyline.map = self.googleMaps
			}
		}
	}
	
	@IBAction func openStartLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		locationSelected = .startLocation
		
		
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	
	
	@IBAction func openDestinationLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		
		locationSelected = .destinationLocation
		
		
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	
	
	
	@IBAction func showDirection(_ sender: UIButton) {
		
		self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        
        self.viewcnstrnt.constant = -200
	}
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		print("Error \(error)")
	}
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		
		
		let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
		)
		
		
		if locationSelected == .startLocation {
			startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
			locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		} else {
			destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
			locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		}
		self.googleMaps.camera = camera
		self.dismiss(animated: true, completion: nil)
	}
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		self.dismiss(animated: true, completion: nil)
	}
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
       
	}
    
}

public extension UISearchBar {
	
	public func setTextColor(color: UIColor) {
		let svs = subviews.flatMap { $0.subviews }
		guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
		tf.textColor = color
	}
    
    
    
    
    
	
}
