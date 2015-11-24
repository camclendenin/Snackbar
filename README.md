# Snackbar #

A handy Swift toolbar-like widget for quickly displaying status updates and errors at the bottom of the screen. See the [Android snackbar](https://www.google.com/design/spec/components/snackbars-toasts.html), which this is named after.

![Snackbar demo](http://i.giphy.com/I4Ulxm3RU1vVu.gif)
### What can Snackbar do? ###

Asynchronously displays...

* a status *title* and *message* with animation 
* an error *title* and *message* with animation as well as a customizable retry action
* a success / confirmation *title* and *message* with animation, and then auto-hide

### Installation ###

To install via Cocoapods

```sh
pod 'Snackbar', '~> 0.1.0'
```

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

#### Customizing the appearance ####

`Snackbar` can be initialized with a customized `SnackbarConfiguration` instance. The following attributes can be customized via the `SnackbarConfiguration`.

- `backgroundColor`
- `foregroundColor`
- `headerFont` - First line of text
- `subHeaderFont` - Second line of text
- `presentationAnimationDuration`
- `dismissalAnimationDelay` - Length of time that status updates will remain on screen before dismissing. Default is 2 seconds.

Initialize the configuration and pass it as the `configuration` parameter when initializing the `Snackbar`.
```swift
let configuration = SnackbarConfiguration(
  backgroundColor: UIColor.whiteColor(),
  foregroundColor: ...
)
let customizedSnackbar = Snackbar(configuration: configuration)
```

### Requirements ###

* Swift 1.2 or later
* [Cartography](https://github.com/robb/Cartography)
