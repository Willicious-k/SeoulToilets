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
  
  //MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    searchBar.becomeFirstResponder()
  }
  
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension SearchViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
    return cell
  }
  
}

extension SearchViewController: UITableViewDelegate {
  
  
}
