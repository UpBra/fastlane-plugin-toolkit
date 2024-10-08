require 'fastlane/plugin/toolkit/version'

module Fastlane

	module Toolkit
		# Return all .rb files inside the "actions" "helper" and "source" directories
		def self.all_classes
			Dir[File.expand_path('**/{actions,helper,source}/*.rb', File.dirname(__FILE__))]
		end
	end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::Toolkit.all_classes.each do |current|
	require current
end
