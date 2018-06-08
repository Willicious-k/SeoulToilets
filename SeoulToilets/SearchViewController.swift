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
  var toiletsAnnotations: [ToiletAnnotation] = []
  var searchingResult: [ToiletAnnotation] = []
  
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    searchBar.resignFirstResponder()
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    dismiss(animated: true, completion: nil)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText != "" {
      isSearching = true
    } else {
      isSearching = false
    }
    //TODO: partial search here
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    //TODO: full search here
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
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "countCell") as? CountCell else { return UITableViewCell() }
      
      cell.countLabel.text = isSearching ? "\(searchingResult.count) toilets found" : "\(toiletsAnnotations.count) toilets total"
      return cell
      
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "annotationCell") as? AnnotationCell else { return UITableViewCell() }
      //TODO: result cell drawing here
      return cell
    }
  }
  
}

extension SearchViewController: UITableViewDelegate {
}
