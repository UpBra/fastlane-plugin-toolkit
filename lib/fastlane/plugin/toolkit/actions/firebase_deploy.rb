module Fastlane

	module Actions

		module SharedValues
			FIREBASE_DEPLOY_APP_DISPLAY_NAME = :FIREBASE_DEPLOY_APP_DISPLAY_NAME
			FIREBASE_DEPLOY_APP_CONSOLE_URL = :FIREBASE_DEPLOY_APP_CONSOLE_URL
		end

		FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-firebase_app_distribution', require_gem: true)

		class FirebaseDeployAction < FirebaseAppDistributionAction

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'Summary for firebase_deploy',
					mask_keys: [:cli_token, :service_credentials_file]
				)

				super(params)
				update_status(params)
			end

			def self.update_status(params)
				return unless properties ||= lane_context[SharedValues::FIREBASE_APP_DISTRO_RELEASE]

				version = properties[:displayVersion]
				build_number = properties[:buildVersion]
				app_display_name = [version, "(#{build_number})"].join(' ')

				lane_context[SharedValues::FIREBASE_DEPLOY_APP_DISPLAY_NAME] = app_display_name
				lane_context[SharedValues::FIREBASE_DEPLOY_APP_CONSOLE_URL] = properties[:firebaseConsoleUri]
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Deploy apps with firebase app distribution and constructs app display name and consule url'
			end

			def self.available_options
				Fastlane::Actions::FirebaseAppDistributionAction.available_options
			end

			def self.output
				[
					['FIREBASE_DEPLOY_APP_DISPLAY_NAME', 'Constructed app display name from name version and build number'],
					['FIREBASE_DEPLOY_APP_CONSOLE_URL', 'Link to distributed app in the Firebase console']
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
