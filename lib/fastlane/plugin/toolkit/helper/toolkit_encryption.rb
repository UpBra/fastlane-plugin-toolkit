require 'fastlane_core/ui/ui'

module Fastlane

	UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

	module Helper

		module Toolkit

			def self.iterate(source_path)
				require 'pathname'

				# check that source_path exists
				UI.user_error!("Source path #{source_path} does not exist!") unless File.exist?(source_path)

				Pathname.new(source_path).children.each do |path|
					next if File.directory?(path)
					next if path.basename.to_s.start_with?('.')
					yield(path)
				end
			end
		end
	end
end
