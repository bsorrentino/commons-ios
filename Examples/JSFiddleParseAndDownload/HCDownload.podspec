Pod::Spec.new do |s|
  s.name     = 'HCDownload'
  s.version  = '1.0'
  s.license  = 'BSD'
  s.summary  = 'Drop-in download manager view controller for iOS.'
  s.homepage = 'https://github.com/H2CO3/HCDownload'
  s.authors  = { 'H2CO3' => 'arpad.goretity@gmail.com', 'Abizern' => 'abizern@abizern.org' }
  s.source   = { :git => 'https://github.com/H2CO3/HCDownload.git' }
  s.source_files = '*.{h,m}'
  s.requires_arc = false

  s.ios.deployment_target = '5.0'
  #s.ios.frameworks = 'MobileCoreServices', 'SystemConfiguration', 'Security', 'CoreGraphics'

  #s.osx.deployment_target = '10.7'
  #s.osx.frameworks = 'CoreServices', 'SystemConfiguration', 'Security'

end

