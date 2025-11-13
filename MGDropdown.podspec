Pod::Spec.new do |s|
  s.name             = 'MGDropdown'
  s.version          = '1.0.7'
  s.summary          = 'A clean, customizable dropdown for iOS (SwiftUI + UIKit).'

  s.description      = <<-DESC
MGDropdown is a SwiftUI + UIKit dropdown component with:
- Material animations
- Search support
- Tap-outside-to-dismiss
- Clean reusable API
DESC

  s.homepage         = 'https://github.com/Mohanraj-Freelancer/MGDropdown'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mohanraj G' => 'moto37970@gmail.com' }

  s.source           = {
     :git => 'https://github.com/Mohanraj-Freelancer/MGDropdown.git',
     :tag => s.version.to_s
  }

  # Minimum iOS version that fully supports SwiftUI + animations
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.9'
  s.module_name = "MGDropdown"

  # Include ONLY library files
  s.source_files = 'Sources/**/*.{swift}'
  s.exclude_files = 'ExampleApp/**/*'
end
