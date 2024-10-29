require 'fastlane/plugin/toolkit/version'

module Toolkit

	def self.first_classes
		['fastlane/plugin/toolkit/source/global', 'fastlane/plugin/toolkit/source/fastfile']
	end

	def self.all_classes
		Dir[File.expand_path('**/{actions,helper,source}/*.rb', File.dirname(__FILE__))] - self.first_classes
	end
end

Toolkit.first_classes.each do |file|
	require file
end

Toolkit.all_classes.each do |file|
	require file
end
