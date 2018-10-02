Pod::Spec.new do |s|
  s.name             = 'JSDebugger'
  s.version          = '0.1.0'
  s.summary          = 'JavaScript-Based Debugger For Inspecting Running State Of Your Application'

  s.description      = <<-DESC
JavaScript-Based Debugger For Inspecting Running State Of Your Application
                       DESC

  s.homepage         = 'https://github.com/SatanWoo/JSDebugger'
  s.license          = { :type => 'GPL', :file => 'LICENSE' }
  s.author           = { 'SatanWoo' => 'xxx@xxx.com' }
  s.source           = { :git => 'https://github.com/SatanWoo/JSDebugger.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/**/*'
  s.public_header_files = 'Source/**/*.h'
  
end
