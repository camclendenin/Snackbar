Pod::Spec.new do |s|

  s.name         = "Snackbar"
  s.version      = "0.1.0"
  s.summary      = "Lightweight feedback view in Swift"

  s.description  = <<-DESC
                   Display simple status updates and errors at the bottom of the screen.
                   DESC

  s.homepage     = "https://bitbucket.org/cameron_clendenin/snackbar"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Cam Clendenin" => "" }

  s.ios.deployment_target = "9.0"

  s.source = { :git => "git@github.com:camclendenin/Snackbar.git", :tag => "#{s.version}" }
  s.source_files  = "Snackbar/*.swift"
  s.framework    = "UIKit"
  s.dependency "Cartography"

  s.requires_arc = true

end
