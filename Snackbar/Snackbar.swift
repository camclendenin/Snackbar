//
//  Snackbar.swift
//  SnackbarExample
//
//  Created by Cam Clendenin on 11/3/15.
//  
//  MIT License
//

import UIKit
import Cartography

private let viewHeight: CGFloat = 60
private let spinnerWidth: CGFloat = 60
private let controlsWidth: CGFloat = 80
typealias completionClosure = () -> Void

class Snackbar: UIView {
  private var configuration: SnackbarConfiguration!
  private let spinnerView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
  private let titleLabel = UILabel()
  private let statusLabel = UILabel()
  private let actionButton = UIButton(type: .System)
  private let dismissButton = UIButton(type: .System)
  private var actionOptions: (buttonTitle: String, statusTitle: String, statusMessage: String, onSelect: completionClosure)?
  private let labelContainer = UIView()
  private let controlContainer = UIView()
  private let keyConstraints = ConstraintGroup()
  private var canAutoHide = false

  init(configuration: SnackbarConfiguration) {
    super.init(frame: CGRect(x: 0, y: CGFloat.max, width: spinnerWidth + controlsWidth, height: viewHeight))
    autoresizesSubviews = false
    self.configuration = configuration
    backgroundColor = configuration.backgroundColor

    spinnerView.hidesWhenStopped = true
    addSubview(spinnerView)

    titleLabel.font = configuration.headerFont
    titleLabel.textColor = configuration.foregroundColor
    labelContainer.addSubview(titleLabel)

    statusLabel.font = configuration.subHeaderFont
    statusLabel.textColor = configuration.foregroundColor
    labelContainer.addSubview(statusLabel)

    actionButton.addTarget(self, action: "actionButtonTapped:", forControlEvents: .TouchUpInside)
    actionButton.titleLabel?.font = configuration.headerFont
    actionButton.setTitleColor(configuration.foregroundColor, forState: .Normal)
    controlContainer.addSubview(actionButton)

    dismissButton.addTarget(self, action: "dimsissSnackbarTapped:", forControlEvents: .TouchUpInside)
    dismissButton.setTitle("HIDE", forState: .Normal)
    dismissButton.titleLabel?.font = configuration.headerFont
    dismissButton.setTitleColor(configuration.foregroundColor, forState: .Normal)
    controlContainer.addSubview(dismissButton)

    addSubview(labelContainer)
    addSubview(controlContainer)

    setupConstraints()
  }

  convenience init() {
    self.init(configuration: SnackbarConfiguration.defaultConfiguration())
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  //MARK: updates
  func updateWithStatus(title: String, message: String) {
    canAutoHide = false
    updateContstraintsShowingSpinner(true, andControls: false)
    let updates = { () -> Void in
      self.titleLabel.text = title
      self.statusLabel.text = message
      self.spinnerView.startAnimating()
    }
    animateUpdates(updates)
  }

  func updateWithError(title: String, message: String,
    actionOptions: (buttonTitle: String, statusTitle: String, statusMessage: String, onSelect: completionClosure)?) {
    canAutoHide = false
    updateContstraintsShowingSpinner(false, andControls: true)
      let updates = { () -> Void in
        self.spinnerView.stopAnimating()
        self.titleLabel.text = title
        self.statusLabel.text = message
        if let options = actionOptions {
          let actionText = options.buttonTitle
          self.actionButton.setTitle(actionText, forState: .Normal)
          self.actionOptions = options
        }
      }
      animateUpdates(updates)
  }

  func completeWithStatus(title: String, message: String) {
    canAutoHide = true
    updateContstraintsShowingSpinner(false, andControls: false)
    let updates = { () -> Void in
      self.spinnerView.stopAnimating()
      self.titleLabel.text = title
      self.statusLabel.text = message
    }
    animateUpdates(updates)
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(configuration.dismissalAnimationDelay * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] () -> Void in
      if let strongSelf = self {
        if strongSelf.canAutoHide {
          strongSelf.hideSnackbar()
        }
      }
    }
  }

  //MARK: private
  @objc private func actionButtonTapped(sender: UIButton) {
    if let options = actionOptions {
      updateWithStatus(options.statusTitle, message: options.statusMessage)
      options.onSelect()
    }
  }

  @objc private func dimsissSnackbarTapped(sender: UIButton) {
    hideSnackbar()
  }

  private func showSnackbar() {
    assert(superview != nil, "Attempting to present snackbar without a superview.")
    superview!.bringSubviewToFront(self)

    let superFrame = superview!.bounds
    frame = CGRect(x: 0, y: superFrame.maxY, width: superFrame.width, height: viewHeight)

    UIView.animateWithDuration(configuration.presentationAnimationDuration,
      delay: 0,
      options: [.AllowAnimatedContent, .AllowUserInteraction],
      animations: { () -> Void in
        let yOffset = self.yOffsetForStateHidden(false)
        self.frame.origin.y = yOffset
      },
      completion: nil
    )
  }

  private func hideSnackbar() {
    UIView.animateWithDuration(configuration.presentationAnimationDuration,
      delay: 0,
      options: [.AllowAnimatedContent, .AllowUserInteraction],
      animations: { () -> Void in
        self.frame.origin.y = self.yOffsetForStateHidden(true)
      },
      completion: nil
    )
  }

  private func animateUpdates(updates: () -> Void) {
    if isPresented() {
      UIView.animateWithDuration(configuration.presentationAnimationDuration,
        delay: 0,
        options: [.AllowAnimatedContent, .CurveEaseOut],
        animations: { () -> Void in
          updates()
          self.layoutIfNeeded()
        },completion: nil)
    } else {
      UIView.animateWithDuration(0, animations: { () -> Void in
        updates()
        }, completion: { finished -> Void in
        self.showSnackbar()
      })
    }
  }

  private func isPresented() -> Bool {
    return frame.origin.y == yOffsetForStateHidden(false)
  }

  private func yOffsetForStateHidden(hidden: Bool) -> CGFloat {
    let rootViewBottomY = superview!.bounds.maxY
    return hidden ? rootViewBottomY : rootViewBottomY - bounds.height
  }

  private func setupConstraints() {
    constrain(titleLabel, statusLabel) { (title, status) -> () in
      title.size == status.size
      title.bottom == title.superview!.centerY
      status.top == status.superview!.centerY
      title.left == title.superview!.left
      title.right == title.superview!.right
      status.left == title.left
    }
    constrain(actionButton, dismissButton) { (action, dismiss) -> () in
      action.size == dismiss.size
      action.bottom == dismiss.top
      action.top == action.superview!.top
      dismiss.bottom == dismiss.superview!.bottom
      action.left == action.superview!.left
      action.right == action.superview!.right
      dismiss.left == action.left
    }
    constrain(spinnerView, labelContainer, controlContainer) { (spinner, labels, controls) -> () in
      spinner.width == spinnerWidth
      spinner.top == spinner.superview!.top
      spinner.bottom == spinner.superview!.bottom

      controls.top == controls.superview!.top
      controls.bottom == controls.superview!.bottom
      controls.width == controlsWidth

      labels.left == spinner.right + 10
      labels.top == labels.superview!.top
      labels.bottom == labels.superview!.bottom
      labels.right == controls.left
    }
    updateContstraintsShowingSpinner(true, andControls: false)
  }

  private func updateContstraintsShowingSpinner(showSpinner: Bool, andControls showControls: Bool) {
    constrain(self.spinnerView, self.controlContainer, replace: self.keyConstraints, block: { (spinner, controls) -> () in
      if showSpinner {
        spinner.left == spinner.superview!.left
      } else {
        spinner.left == spinner.superview!.left - spinnerWidth
      }

      if showControls {
        controls.right == controls.superview!.right
      } else {
        controls.right == controls.superview!.right + controlsWidth
      }
    })
  }
}
