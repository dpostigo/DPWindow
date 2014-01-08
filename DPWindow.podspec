Pod::Spec.new do |s|
  s.name         = "DPWindow"
  s.version      = "0.0.2"
  s.summary      = "In development."
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }
  s.source       = { :git => "https://github.com/dpostigo/FirstCocoapod.git", :tag => s.version.to_s }
  s.platform     = :osx
  s.source_files = 'DPWindow/*.{h,m}'
  s.frameworks   = 'QuartzCore'
  s.requires_arc = true

  s.dependency   'CALayer-DPUtils'
  s.dependency   'NSView-DPAutolayout'
end
