Pod::Spec.new do |s|
  s.name = 'NarrativeView'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Madlib style narrative forms'
  s.homepage = 'https://github.com/bennyinc/NarrativeView'
  s.social_media_url = 'http://twitter.com/litso'
  s.authors = { 'Robert Manson' => 'rob@usebenny.com' }
  s.source = { :git => 'https://github.com/bennyinc/NarrativeView', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'NarrativeView/*.swift'

  s.requires_arc = true
end
