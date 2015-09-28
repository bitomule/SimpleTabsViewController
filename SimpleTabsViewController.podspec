#
#  Be sure to run `pod spec lint NSDate+RelativeFormatter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SimpleTabsViewController"
  s.version      = "0.2.5"
  s.summary      = "iOS view controller for custom and dynamic horizontal tabs."

  s.description  = <<-DESC
                  Simple horizontal tab menu.
                  * Easy to customize
                  * Easy to use
                  * Uses auto layout
                  * Show/Hide count at each tab
                  * Dinamycally hides count when it's 0 (option to force showing count always)
                   DESC

  s.homepage     = "https://github.com/bitomule/SimpleTabsViewController"
  s.license      = "MIT"


  s.author             = { "David Collado Sela" => "bitomule@gmail.com" }
  s.social_media_url   = "http://twitter.com/bitomule"

  s.platform     = :ios
  s.platform     = :ios, "8.1"

  s.source       = { :git => "https://github.com/bitomule/SimpleTabsViewController.git", :tag => "0.2.5" }

  s.source_files = 'Source/*.swift'
  s.requires_arc = true

end
