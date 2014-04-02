Pod::Spec.new do |s|
  s.name     = 'HTMLDownloader'
  s.version  = '1.1'
  s.license  = 'BSD'
  s.summary  = 'HTML download manager  for iOS.'
  #s.homepage = ''
  s.authors  = { 'bsorrentino' => 'bartolomeo.sorrentino@gmail.com' }
  s.source   = { :git => '/Volumes/BSC/WORKSPACES/JSFiddleParseAndDownload.git', :tag => '1.1' }
  s.source_files = 'HTMLDownloader/*.{h,m}'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  
  s.dependency 'GDataXML-HTML', '~> 1.1.0'
  s.dependency 'ErrorKit/Core', '~> 0.0.5'
  #s.dependency 'HCDownload', '~> 1.0'

  s.libraries = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }


end

