# -------------------------------------------------------------------------
#
# firebase_next_build_number
# Alias for the `firebase_app_distribution_get_latest_release` action with extras
#
# -------------------------------------------------------------------------

module Fastlane

	module Actions

		module SharedValues
			FIREBASE_NEXT_BUILD_NUMBER = :FIREBASE_NEXT_BUILD_NUMBER
		end

		FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-firebase_app_distribution', require_gem: true)

		class FirebaseNextBuildNumberAction < FirebaseAppDistributionGetLatestReleaseAction

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'Summary for firebase_next_build_number',
					mask_keys: [:cli_token, :service_credentials_file]
				)

				latest_release = super(params)
				latest_release ||= {}
				build_number = latest_release[:buildVersion].to_i
				build_number = build_number.next

				UI.success("Firebase Build Number: #{build_number}")
				lane_context[SharedValues::FIREBASE_NEXT_BUILD_NUMBER] = build_number.to_s
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Returns the next build number to use by fetching the latest build from Firebase and incrementing it by 1'
			end

			def self.available_options
				Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.available_options
			end

			def self.output
				[
					['FIREBASE_NEXT_BUILD_NUMBER', self.return_value]
				]
			end

			def self.return_value
				'Current build number in firebase + 1'
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
