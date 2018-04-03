//
//  MasterViewController.swift
//  Repose
//
//  Created by Derrick Hathaway on 4/2/18.
//  Copyright © 2018 Derrick Hathaway. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

  @IBOutlet weak var stalkButton: UIButton!
  @IBOutlet weak var loginTextField: UITextField!
  var detailViewController: DetailViewController? = nil

  override func viewDidLoad() {
    super.viewDidLoad()

    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    
    updateStalkButton()
  }
  
  func updateStalkButton() {
    stalkButton.isEnabled
      = loginTextField.text != nil
      && loginTextField.text != ""
  }
  
  @IBAction func loginChanged(_ sender: Any) {
    updateStalkButton()
  }
  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
      controller.login = loginTextField.text ?? "derrh"
    }
  }
}
