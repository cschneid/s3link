Gem::Specification.new do |s|
  s.name        = 's3link'
  s.version     = '0.0.4'
  s.date        = '2012-10-02'
  s.summary     = "Quick upload to S3, with time limited share URL"
  s.description = "Quick upload to S3, with time limited share URL"
  s.authors     = ["Chris Schneider"]
  s.email       = 'chris@christopher-schneider.com'
  s.files       = ["lib/s3link.rb"]
  s.homepage    = 'http://rubygems.org/gems/s3link'
  s.add_dependency('aws-s3', '>= 0.6.3')
  s.executables << "s3link"
end

