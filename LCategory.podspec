#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "LCategory"
  s.version          = "0.1.5"
  s.summary          = "Categories of LFramework."
  s.description      = <<-DESC
                       Categories of LFramework.

                       * Include LCategory.h to use.
                       DESC
  s.homepage         = "http://www.superarts.org"
  s.screenshots      = "http://www.superarts.org/_/rsrc/1299485048239/home/world_256.png", 
					   "http://www.superarts.org/_/rsrc/1299485069968/home/disc_256.png"
  s.license          = 'MIT'
  s.author           = { "Leo" => "superartstudio@gmail.com" }
  s.source           = { :git => "https://github.com/superarts/LCategory.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/superarts_org'

  s.platform     = :ios, '5.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'category/**/*.{h,m}'
  # s.resources = 'assets/*.png'

  s.ios.exclude_files = 'Classes/osx/**/*.{h,m}'
  s.osx.exclude_files = 'Classes/ios/**/*.{h,m}'
  # s.public_header_files = 'classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'JSONKit', '~> 1.4'
end
