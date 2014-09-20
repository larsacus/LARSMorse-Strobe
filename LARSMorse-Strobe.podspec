Pod::Spec.new do |s|
	s.name = 'LARSMorse-Strobe'
	s.version = '1.0.0'
	s.summary = 'Enables the LED flash on the back of an iDevice with a flash to be used to encode strings into visual Morse transmissions'
	s.homepage = 'https://github.com/larsacus/LARSMorse-Strobe'
	s.author = {
		'Lars Anderson' => 'iAm@theonlylars.com'
	}
	s.license = {:type => 'MIT', :file => 'LICENSE'}
	s.platform = :ios, '5.0'
	s.source = {
		:git => 'https://github.com/larsacus/LARSMorse-Strobe.git',
		:tag => s.version.to_s
	}
	s.requires_arc = true
	s.source_files = '*.{h,m}'
  s.resources = 'MorseDict.plist'
end