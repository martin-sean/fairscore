# -*- encoding: utf-8 -*-
# stub: active_elastic_job 2.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "active_elastic_job".freeze
  s.version = "2.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tawan Sierek".freeze]
  s.date = "2019-10-15"
  s.description = "Run background jobs / tasks of Rails applications deployed in Amazon Elastic Beanstalk environments. Active Elastic Job is an Active Job backend which is easy to setup. No need for customised container commands or other workarounds.".freeze
  s.email = ["tawan@sierek.com".freeze]
  s.files = ["active-elastic-job.gemspec".freeze, "lib/active_elastic_job".freeze, "lib/active_elastic_job.rb".freeze, "lib/active_elastic_job/md5_message_digest_calculation.rb".freeze, "lib/active_elastic_job/message_verifier.rb".freeze, "lib/active_elastic_job/rack".freeze, "lib/active_elastic_job/rack/sqs_message_consumer.rb".freeze, "lib/active_elastic_job/railtie.rb".freeze, "lib/active_elastic_job/version.rb".freeze, "lib/active_job".freeze, "lib/active_job/queue_adapters".freeze, "lib/active_job/queue_adapters/active_elastic_job_adapter.rb".freeze]
  s.homepage = "https://github.com/tawan/active-elastic-job".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Active Elastic Job is a simple to use Active Job backend for Rails applications deployed on the Amazon Elastic Beanstalk platform.".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<aws-sdk>.freeze, ["~> 2"])
      s.add_runtime_dependency(%q<rails>.freeze, [">= 4.2"])
    else
      s.add_dependency(%q<aws-sdk>.freeze, ["~> 2"])
      s.add_dependency(%q<rails>.freeze, [">= 4.2"])
    end
  else
    s.add_dependency(%q<aws-sdk>.freeze, ["~> 2"])
    s.add_dependency(%q<rails>.freeze, [">= 4.2"])
  end
end
