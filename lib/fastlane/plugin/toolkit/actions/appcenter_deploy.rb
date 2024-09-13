module Fastlane

	module Actions

		module SharedValues
			APPCENTER_DEPLOY_DISPLAY_NAME = :APPCENTER_DEPLOY_DISPLAY_NAME
		end

		class AppcenterDeployAction < Action

			FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-appcenter', require_gem: true)

			def self.run(params)
				available = Fastlane::Actions::AppcenterUploadAction.available_options.map(&:key)
				options = params.values.clone.keep_if { |k,v| available.include?(k) }
				options.transform_keys(&:to_sym)

				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'Summary for appcenter_deploy',
					mask_keys: [:api_token]
				)

				appcenter_upload(params)

				properties = lane_context[SharedValues::APPCENTER_BUILD_INFORMATION]
				app_display_name = properties['app_display_name']
				version = properties['short_version']
				build_number = properties['version']
				name = [app_display_name, version, "(#{build_number})"].join(' ')
				lane_context[SharedValues::APPCENTER_DEPLOY_DISPLAY_NAME] = name
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'A short description with <= 80 characters of what this action does'
			end

			def self.details
				'You can use this action to do cool things...'
			end

			def self.available_options
				[
					Fastlane::Actions::AppcenterUploadAction.available_options
				]
			end

			def self.output
				[
					['TLK_APPCENTER_DEPLOY_CUSTOM_VALUE', 'A description of what this value contains']
				]
			end

			def self.return_value
				"Constructed display name from appcenter build information. name version and build number"
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
