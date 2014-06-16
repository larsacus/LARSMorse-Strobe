Pod::Spec.new do |s|
  s.name         = 'LARSMorse-Strobe'
  s.version      = '1.0.0'
  s.summary      = 'Lightweight AVFoundation-based interface to access your iDevice\'s LED torch.'
  s.homepage     = 'https://github.com/larsacus/LARSTorch'
  s.author = {
    'Lars Anderson' => 'iAm@theonlylars.com'
  }
  s.license = 'MIT'
  s.platform = :ios, '4.0'
  s.source = {
    :git => 'https://github.com/larsacus/LARSTorch.git',
    :tag => s.version.to_s
  }
  s.requires_arc = true
  s.source_files = '*.{h,m}'
  s.frameworks = 'AVFoundation'
  s.dependency 'LARSTorch'
end