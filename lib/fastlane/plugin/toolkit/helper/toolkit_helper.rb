require 'fastlane_core/ui/ui'

module Fastlane

	UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

	module Helper

		module Toolkit

			def self.test_message
				UI.message("test message")
			end
		end
	end
end
