//
//  Toilets.swift
//  SeoulToilets
//
//  Created by 김성종 on 2018. 5. 3..
//  Copyright © 2018년 Willicious-k. All rights reserved.
//

import MapKit
import Contacts

class ToiletAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  
  init(fullName: String, longitude: Double, latitude: Double) {
    self.title = fullName
    self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    super.init()
  }
  
  func makeMapItem() -> MKMapItem {
    let addressDict = [CNPostalAddressStreetKey: title!] // <- might be a trouble point
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }
  
}

struct Toilet: Codable {
  
  var id: String = ""
  var fName: String = ""
  var aName: String!
  var cName: String!
  var xLocWgs84: String = ""
  var yLocWgs84: String = ""
  var xLocIrtf: String = ""
  var yLocIrtf: String = ""
  var insertDate: String = ""
  var updateDate: String = ""
  
  enum CodingKeys: String, CodingKey {
    case id = "poi_id"
    case fName = "fname"
    case aName = "aname"
    case cName = "cname"
    case xLocWgs84 = "x_wgs84"
    case yLocWgs84 = "y_wgs84"
    case xLocIrtf = "center_x1"
    case yLocIrtf = "center_y1"
    case insertDate = "insertdate"
    case updateDate = "updatedate"
  }
  
}
