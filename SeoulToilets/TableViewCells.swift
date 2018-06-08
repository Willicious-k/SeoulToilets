//
//  TableViewCells.swift
//  SeoulToilets
//
//  Created by 김성종 on 2018. 6. 8..
//  Copyright © 2018년 Willicious-k. All rights reserved.
//

import UIKit

class CountCell: UITableViewCell {
  
  @IBOutlet weak var countLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}

class AnnotationCell: UITableViewCell {
  
  @IBOutlet weak var buildingNameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let bgView = UIView()
    bgView.backgroundColor = UIColor(named: "markerFarTint")
    self.selectedBackgroundView = bgView
  }
  
}
