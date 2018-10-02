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
  s.platform = :ios, '9.0'
  s.frameworks = ["JavaScriptCore"]
  s.libraries = 'c++'

  s.requires_arc = true
  s.exclude_files = 'Source/Core/Plugin/Plugin/JDChoose.mm'

  s.subspec 'no-arc' do |smrc|
    smrc.source_files = 'Source/Core/Plugin/Plugin/JDChoose.mm'
    smrc.requires_arc = false
  end

  s.source_files = 'Source/**/*'
  s.public_header_files = 'Source/**/*.h'
  s.vendored_libraries = 'Source/Core/FFI/Vendor/libffi.a'
  
end
