//
//  SearchViewController.swift
//  SeoulToilets
//
//  Created by 김성종 on 2018. 6. 7..
//  Copyright © 2018년 Willicious-k. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  //MARK:- IBOutlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var resultTable: UITableView!
  
  //MARK:- internal data
  var pickedAnnotation: ToiletAnnotation!
  var toiletsAnnotations: [ToiletAnnotation] = []
  var searchingResult: [ToiletAnnotation] = []
  var predicate: NSPredicate!
  
  var isSearching: Bool = false {
    didSet {
      if isSearching {
        resultTable.separatorStyle = .singleLine
      } else {
        resultTable.separatorStyle = .none
      }
      view.layoutIfNeeded()
    }
  }
  
  //MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    resultTable.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.setShowsCancelButton(true, animated: true)
    searchBar.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()
  }
  
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    performSegue(withIdentifier: "returnToMap", sender: self)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText != "" {
      isSearching = true
    } else {
      isSearching = false
    }
    
    guard let targetText = searchBar.text else { return }
    predicate = NSPredicate(format: "%K contains %@", "title", targetText)
    
    searchingResult = toiletsAnnotations.filter{ toiletAnnotation -> Bool in
      self.predicate.evaluate(with: toiletAnnotation)
    }
    
    resultTable.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    // enables button manually
    // accessing button by keypath
    if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
      cancelButton.isEnabled = true
    }
    
    guard let targetText = searchBar.text else { return }
    predicate = NSPredicate(format: "%K contains %@", "title", targetText)

    
    searchingResult = toiletsAnnotations.filter{ toiletAnnotation -> Bool in
      self.predicate.evaluate(with: toiletAnnotation)
    }
    
    resultTable.reloadData()
  }
  
}

extension SearchViewController: UITableViewDataSource {
  // annotationCell, countCell
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      return 1
    }
    
    return searchingResult.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 {
      guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "countCell") as? CountCell
      else { return UITableViewCell() }
      
      cell.countLabel.text = isSearching ? "\(searchingResult.count) toilets found" : "\(toiletsAnnotations.count) toilets total"
      return cell
      
    } else {
      guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "annotationCell") as? AnnotationCell,
        searchingResult.count > 0
      else { return UITableViewCell() }
      
      let distance = searchingResult[indexPath.row].distance
      
      cell.buildingNameLabel.text = searchingResult[indexPath.row].title
      cell.distanceLabel.text = distance > 1000 ? String(format: "%.2f km away", distance / 1000.0) : "\(Int(distance)) m away"
      
      return cell
    }
  }
  
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pickedAnnotation = searchingResult[indexPath.row]
    performSegue(withIdentifier: "returnToMap", sender: self)
  }
}


