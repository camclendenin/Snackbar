//
//  SnackbarConfiguration.swift
//  SnackbarExample
//
//  Created by Cam Clendenin on 11/3/15.
//
//  MIT License
//

import UIKit

struct SnackbarConfiguration {
  let backgroundColor: UIColor!
  let foregroundColor: UIColor!
  let headerFont: UIFont!
  let subHeaderFont: UIFont!
  let presentationAnimationDuration: NSTimeInterval!
  let dismissalAnimationDelay: NSTimeInterval!

  static func defaultConfiguration() -> SnackbarConfiguration {
    return SnackbarConfiguration(
      backgroundColor: UIColor(white: 0.9, alpha: 1),
      foregroundColor: UIColor(white: 0.3, alpha: 1),
      headerFont: UIFont(name: "HelveticaNeue", size: 18),
      subHeaderFont: UIFont(name: "HelveticaNeue", size: 14),
      presentationAnimationDuration: 0.2,
      dismissalAnimationDelay: 2.0
    )
  }
}
