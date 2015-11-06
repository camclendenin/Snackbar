# Snackbar #

A handy Swift toolbar-like widget for quickly displaying status updates and errors at the bottom of the screen. See the [Android snackbar](https://www.google.com/design/spec/components/snackbars-toasts.html), which this is named after.

![Snackbar demo](http://i.giphy.com/I4Ulxm3RU1vVu.gif)
### What can Snackbar do? ###

Without blocking the main UI:

* Display a status *title* and *message* with animation 
* Display an error *title* and *message* with animation as well as a customizable retry action
* Display a success / confirmation *title* and *message* with animation, and then auto-hide

### Usage ###

```swift
let snackbar = Snackbar()
view.addSubview(snackbar)

// Start some long-running task...
snackbar.updateWithStatus("Syncing Data", message: "This may take a moment...")

// If/when that task finishes...
snackbar.completeWithStatus("Syncing Complete", message: "Your data seems to all be here.")

// If the tasks fails, you can handle the error like so...
snackbar.updateWithError("Error",
  message: error.localizedDescription,
  actionOptions: (buttonTitle: "RETRY", statusTitle: "Retrying", statusMessage: "Sit tight...", onSelect: { Void in
     // fetchData()
  })
)
```

### Requirements ###

* Swift 1.2 or later
* [Cartography](https://github.com/robb/Cartography)