//
//  DetailViewController.swift
//  Repose
//
//  Created by Derrick Hathaway on 4/2/18.
//  Copyright © 2018 Derrick Hathaway. All rights reserved.
//

import UIKit
import Apollo

class DetailViewController: UITableViewController {
  @IBOutlet weak var avatarContainerView: UIView!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var loadingView: UIView!
  
  enum LoadingStatus {
    case empty
    case loading
    case data(GetUserQuery.Data)
    case error(Error)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateView(status: .empty)
  }
  
  var login: String = "" {
    didSet {
      guard login != oldValue else {
        return
      }
      
      title = login
      updateView(status: .loading)
      refresh()
    }
  }
  
  func refresh() {
    ApolloClient.gitStalk.fetch(
      query: GetUserQuery(login: login)
    ) { [weak self] response, error in
      guard let me = self else { return }
      
      let status: LoadingStatus
      
      if let e = error {
        status = .error(e)
      } else if let data = response?.data {
        status = .data(data)
      } else {
        status = .empty
      }
      me.updateView(status: status)
    }
  }
  
  func updateView(status: LoadingStatus) {
    guard isViewLoaded else { return }
    
    var isLoading = true
    var name = ""
    var bio = ""
    var imageURL: URL? = nil
    
    switch status {
    case .data(let data):
      isLoading = false
      name = data.user?.name ?? ""
      bio = data.user?.bio ?? ""
    case .error(let error):
      isLoading = false
      let alert = UIAlertController(
        title: "Error",
        message: error.localizedDescription,
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
      present(alert, animated: true, completion: nil)
    case .empty:
      isLoading = false
    default:
      break
    }
    
    loadingView.isHidden = !isLoading
    nameLabel.isHidden = isLoading
    nameLabel.text = name
    bioLabel.text = bio
  }
}
