//
//  ViewController.swift
//  SnackbarExample
//
//  Created by Cam Clendenin on 11/5/15.
//  Copyright © 2015 Cam Clendenin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var snackbar: Snackbar!

  override func viewDidLoad() {
    super.viewDidLoad()

    snackbar = Snackbar()
    view.addSubview(snackbar)
  }

  override func viewDidAppear(animated: Bool) {

  }

  @IBAction func updateWithStatusPressed() {
    snackbar.updateWithStatus("Downloading User Data...", message: "Sit tight, this could be awhile ;)")
  }

  @IBAction func completeWithStatusPressed() {
    snackbar.completeWithStatus("Downloading Complete", message: "Your data seems to all be here.")
  }

  @IBAction func updateWithErrorPressed() {
    snackbar.updateWithError("Connectivity Error",
      message: "Please check your connection and RETRY.",
      actionOptions: (buttonTitle: "RETRY", statusTitle: "Retrying", statusMessage: "Sit tight...", onSelect: { Void in
        
      })
    )
  }
}

