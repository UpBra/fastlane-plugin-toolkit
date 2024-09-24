# -------------------------------------------------------------------------
#
# appcenter_next_build_number
# Alias for the `appcenter_fetch_version_number` action with extras
#
# -------------------------------------------------------------------------

module Fastlane

	module Actions

		module SharedValues
			APPCENTER_NEXT_BUILD_NUMBER = :APPCENTER_NEXT_BUILD_NUMBER
		end

		FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-appcenter', require_gem: true)

		class AppcenterNextBuildNumberAction < AppcenterFetchVersionNumberAction

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'Summary for appcenter_next_build_number',
					mask_keys: [:api_token]
				)

				begin
					result = super(params)
					build_number = result.fetch('build_number')
				rescue StandardError => e
					puts(e)
					build_number = 0
				end

				build_number = build_number.to_i.next.to_s

				UI.success("Appcenter build number: #{build_number}")
				lane_context[SharedValues::APPCENTER_NEXT_BUILD_NUMBER] = build_number
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Returns the next build number to use by fetching the latest build from Appcenter and incrementing it by 1'
			end

			def self.available_options
				Fastlane::Actions::AppcenterFetchVersionNumberAction.available_options
			end

			def self.output
				[
					['APPCENTER_NEXT_BUILD_NUMBER', self.return_value]
				]
			end

			def self.return_value
				'Current build number in Appcenter + 1'
			end

			def self.authors
				['UpBra']
			end

			def self.is_supported?(_)
				true
			end
		end
	end
end
