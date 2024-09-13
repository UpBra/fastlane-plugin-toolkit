module Fastlane

	module Actions

		module SharedValues
			FIREBASE_NEXT_BUILD_NUMBER_RESULT = :FIREBASE_NEXT_BUILD_NUMBER_RESULT
		end

		class FirebaseNextBuildNumberAction < Action

			FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-firebase_app_distribution', require_gem: true)

			def self.run(params)
				available = Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.available_options.map(&:key)
				options = params.values.clone.keep_if { |k,v| available.include?(k) }
				options.transform_keys(&:to_sym)

				FastlaneCore::PrintTable.print_values(
					config: options,
					title: 'Summary for pft_build_number_firebase',
					mask_keys: [:cli_token, :service_credentials_file]
				)

				latest_release = other_action.firebase_app_distribution_get_latest_release(options)
				latest_release ||= {}
				build_number = latest_release[:buildVersion].to_i
				build_number = build_number.next

				UI.success("Firebase Build Number: #{build_number}")
				lane_context[SharedValues::FIREBASE_NEXT_BUILD_NUMBER_RESULT] = build_number.to_s
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'A short description with <= 80 characters of what this action does'
			end

			def self.details
				# Optional:
				# this is your chance to provide a more detailed description of this action
				'You can use this action to do cool things...'
			end

			def self.available_options
				Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.available_options
			end

			def self.output
				[
					['FIREBASE_GET_NEXT_BUILD_NUMBER_CUSTOM_VALUE', 'A description of what this value contains']
				]
			end

			def self.return_value
				# If your method provides a return value, you can describe here what it does
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
