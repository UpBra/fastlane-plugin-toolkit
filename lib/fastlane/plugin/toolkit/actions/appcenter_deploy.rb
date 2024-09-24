# -------------------------------------------------------------------------
#
# appcenter_deploy
# Alias for the `appcenter_upload` action with extras
#
# -------------------------------------------------------------------------

module Fastlane

	module Actions

		module SharedValues
			APPCENTER_DEPLOY_DISPLAY_NAME = :APPCENTER_DEPLOY_DISPLAY_NAME
		end

		FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-appcenter', require_gem: true)

		class AppcenterDeployAction < AppcenterUploadAction

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'Summary for appcenter_deploy',
					mask_keys: [:api_token]
				)

				super(params)
				update_status(params)
			end

			def self.update_status(params)
				return unless build_info ||= lane_context[SharedValues::APPCENTER_BUILD_INFORMATION]
				return unless app_display_name ||= build_info['app_display_name']
				return unless version ||= build_info['short_version']
				return unless build_number ||= build_info['version']

				name = [app_display_name, version, "(#{build_number})"].join(' ')
				lane_context[SharedValues::APPCENTER_DEPLOY_DISPLAY_NAME] = name
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Wrapper for appcenter_upload action'
			end

			def self.details
				'Constructs app display name from appcenter build information'
			end

			def self.available_options
				Fastlane::Actions::AppcenterUploadAction.available_options
			end

			def self.output
				[
					['APPCENTER_DEPLOY_DISPLAY_NAME', 'Constructed app display name from name version and build number']
				]
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
