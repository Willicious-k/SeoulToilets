//
//  clusterView.swift
//  SeoulToilets
//
//  Created by 김성종 on 2018. 6. 5..
//  Copyright © 2018년 Willicious-k. All rights reserved.
//

import MapKit

final class ClusterView: MKAnnotationView {
  
  override var annotation: MKAnnotation? {
    willSet {
      newValue.flatMap(configure(with:))
    }
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    displayPriority = .defaultHigh
    collisionMode = .circle
    centerOffset = CGPoint(x: 0.0, y: -8.0)
  }
  
  required init? (coder aDecoder: NSCoder) {
    fatalError("Coder is not implemented")
  }

}

private extension ClusterView {
  func configure(with annotation: MKAnnotation) {
    guard let annotation = annotation as? MKClusterAnnotation else { return }
    
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 32.0, height: 32.0))
    let count = annotation.memberAnnotations.count
    image = renderer.image { _ in
      
      UIColor(named: "markerTint")?.setFill()
      UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 32.0, height: 32.0)).fill()
      
      let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0)]
      let text = "\(count)"
      let size = text.size(withAttributes: textAttributes)
      let rect = CGRect(x: 16 - size.width / 2, y: 16 - size.height / 2, width: size.width, height: size.height)
      text.draw(in: rect, withAttributes: textAttributes)
    }
  }
  
}
