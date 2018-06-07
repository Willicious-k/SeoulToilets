//
//  ViewController.swift
//  SeoulToilets
//
//  Created by 김성종 on 2018. 6. 5..
//  Copyright © 2018년 Willicious-k. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
  //MARK:- IBOutlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var bottomPane: UIView!
  @IBOutlet weak var bottomPaneTopAnchor: NSLayoutConstraint!
  @IBOutlet weak var navBtnBottomAnchor: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  
  //MARK:- InternalData
  var toilets: [Toilet] = []
  var toiletAnnotations: [ToiletAnnotation] = []
  var currentMapItem: MKMapItem!
  var currentLocation: CLLocation!
  var nearestAnnotation: ToiletAnnotation!
  let locationManager = CLLocationManager()
  
  var isLocationUpdated: Bool = false {
    didSet {
      if isLocationUpdated {
        locationManager.stopUpdatingLocation()
        updateDistances()
        pickNearest()
      } else {
        locationManager.startUpdatingLocation()
      }
    }
  }
  
  //MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadDataFromFile()
    makeAnnotations()
    bottomPane.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    mapView.delegate = self
    mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    
    // Asking user permission
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      print("To locate toilets nearby, we need your current location")
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isLocationUpdated = false
  }
  
  //MARK:- IBActions
  @IBAction func moveRegionToCurrentLocation(_ sender: Any) {
    isLocationUpdated = false
  }
  
  @IBAction func doNavigate(_ sender: Any) {
    guard let mapItem = currentMapItem else { return }
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
    mapItem.openInMaps(launchOptions: launchOptions)
  }
  
  //MARK:- Helpers
  func pickNearest() {
    mapView.selectAnnotation(nearestAnnotation, animated: true)
  }
  
  func updateDistances() {
    guard let currentLocation = currentLocation else { return }
    
    var nearestDistance: Double = 500.0
    for annotation in toiletAnnotations {
      let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
      let distance = currentLocation.distance(from: annotationLocation).rounded(.towardZero)
      annotation.distance = distance
      
      if distance < nearestDistance {
        nearestDistance = distance
        nearestAnnotation = annotation
      }
      
    }
  }
  
  func loadDataFromFile() {
    let jsonFilePath = URL(fileURLWithPath: Bundle.main.path(forResource: "SeoulToilets180602", ofType: "json")! )
    let jsonData = try! Data(contentsOf: jsonFilePath)
    toilets = try! JSONDecoder().decode([Toilet].self, from: jsonData)
  }
  
  func setRegionCamera(toPoint: CLLocationCoordinate2D) {
    let centerPoint = toPoint
    let regionSpan: CLLocationDistance = 500
    let region = MKCoordinateRegionMakeWithDistance(centerPoint, regionSpan, regionSpan)
    mapView.setRegion(region, animated: true)
  }
  
  func makeAnnotations() {
    for toilet in toilets {
      let buildingName = toilet.fName
      let longitude = Double(toilet.xLocWgs84)!
      let latitude = Double(toilet.yLocWgs84)!
      
      let annotation = ToiletAnnotation(fullName: buildingName, longitude: longitude, latitude: latitude)
      toiletAnnotations.append(annotation)
    }
    mapView.addAnnotations(toiletAnnotations)
  }
  
}

extension MainViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? ToiletAnnotation else { return nil }
    
    let identifier = "toiletMarker"
    var view = MKMarkerAnnotationView()
    
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
      // dequeuedView.prepareForReuse()
      // --> automatically called, but basically does nothing
      // instead of implementing prepare function, manually reset tintColor
      dequeuedView.annotation = annotation
      dequeuedView.markerTintColor = annotation.distance < 500.0 ? UIColor(named: "markerTint") : UIColor(named: "markerFarTint")
      view = dequeuedView
    } else {
      // creating new view
      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      
      view.glyphTintColor = UIColor.white
      view.glyphImage = UIImage(named: "markerImg")
      view.markerTintColor = annotation.distance < 500.0 ? UIColor(named: "markerTint") : UIColor(named: "markerFarTint")
      
      view.canShowCallout = false
      view.displayPriority = .defaultLow
      view.clusteringIdentifier = String(describing: MKMarkerAnnotationView.self)
    }
    return view
  }
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    guard !isLocationUpdated else { return }
    
    let currentLocation = userLocation.coordinate
    setRegionCamera(toPoint: currentLocation)
    self.isLocationUpdated = true
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard
      let selectedView = view as? MKMarkerAnnotationView,
      let annotation = selectedView.annotation as? ToiletAnnotation,
      let locationTitle = annotation.title
    else { return }
    
    selectedView.titleVisibility = .hidden
    titleLabel.text = locationTitle
    distanceLabel.text = "\(Int(annotation.distance))m away"
    view.layoutIfNeeded()
    
    currentMapItem = annotation.makeMapItem()
    
    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
      self.bottomPaneTopAnchor.constant = -80
      self.navBtnBottomAnchor.constant = 16
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    guard let selectedView = view as? MKMarkerAnnotationView else { return }

    selectedView.titleVisibility = .visible
    view.layoutIfNeeded()
    
    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
      self.bottomPaneTopAnchor.constant = 34
      self.navBtnBottomAnchor.constant = 50
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
}

extension MainViewController : CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last, !isLocationUpdated else { return }
    
    currentLocation = location
    
    let point = location.coordinate
    setRegionCamera(toPoint: point)
    self.isLocationUpdated = true
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("LocationAuth: didFailWithError: \(error.localizedDescription)")
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      print("User Authorized")
    default:
      print("User Unauthorized")
    }
  }

}

extension MainViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    defer {
      performSegue(withIdentifier: "toSearch", sender: self)
    }
    return false
  }
  
}


