module Fastlane

	module Actions

		module SharedValues
			FIREBASE_DEPLOY_APP_DISPLAY_NAME = :FIREBASE_DEPLOY_APP_DISPLAY_NAME
			FIREBASE_DEPLOY_APP_CONSOLE_URL = :FIREBASE_DEPLOY_APP_CONSOLE_URL
		end

		class FirebaseDeployAction < Action

			FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-firebase_app_distribution', require_gem: true)

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'Summary for firebase_deploy',
					mask_keys: [:cli_token, :service_credentials_file]
				)

				if params[:dsym_path] || params[:dsym_paths]
					distriibute_dsym(params)
				end

				if params[:ipa_path] || params[:apk_path] || params[:android_artifact_path]
					distribute_apps(params)
				end
			end

			def self.distribute_apps(params)
				available = Fastlane::Actions::FirebaseAppDistributionAction.available_options.map(&:key)
				options = params.values.clone.keep_if { |k,v| available.include?(k) }
				options.transform_keys(&:to_sym)

				other_action.firebase_app_distribution(options)
				update_status(params)
			end

			def self.distriibute_dsym(params)
				return unless params[:app]
				return unless params[:googleservice_info_plist_path]
				return unless params[:dsym_path] || params[:dsym_paths]

				available = Fastlane::Actions::UploadSymbolsToCrashlyticsAction.available_options.map(&:key)
				options = params.values.clone.keep_if { |k,v| available.include?(k) }
				options.transform_keys(&:to_sym)
				options[:app_id] = params[:app]
				options[:gsp_path] = params[:googleservice_info_plist_path]
				options[:debug] = params[:debug]

				other_action.upload_symbols_to_crashlytics(options)
			end

			def self.update_status(params)
				return unless properties ||= lane_context[SharedValues::FIREBASE_APP_DISTRO_RELEASE]
				return unless name ||= params[:name]

				version = properties[:displayVersion]
				build_number = properties[:buildVersion]
				app_display_name = [name, version, "(#{build_number})"].join(' ')

				lane_context[SharedValues::FIREBASE_DEPLOY_APP_DISPLAY_NAME] = app_display_name
				lane_context[SharedValues::FIREBASE_DEPLOY_APP_CONSOLE_URL] = properties[:firebaseConsoleUri]
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Deploy apps and dsyms to Firebase'
			end

			def self.details
				'Combines firebase app distribution (google) and upload symbols to crashlytics (fastlane) into one action'
			end

			def self.available_options
				Fastlane::Actions::FirebaseAppDistributionAction.available_options + [
					FastlaneCore::ConfigItem.new(
						key: :name,
						env_name: 'FL_FIREBASE_DEPLOY_API_TOKEN',
						description: 'API Token for FirebaseDeployAction',
						default_value: 'Sample App'
					),
					FastlaneCore::ConfigItem.new(
						key: :dsym_path,
						env_name: "FL_UPLOAD_SYMBOLS_TO_CRASHLYTICS_DSYM_PATH",
						description: "Path to the DSYM file or zip to upload",
						default_value: lane_context[SharedValues::DSYM_OUTPUT_PATH],
						default_value_dynamic: true,
						optional: true,
						verify_block: proc do |value|
							UI.user_error!("Couldn't find file at path '#{File.expand_path(value)}'") unless File.exist?(value)
							UI.user_error!("Symbolication file needs to be dSYM or zip") unless value.end_with?(".zip", ".dSYM")
						end
					),
					FastlaneCore::ConfigItem.new(
						key: :dsym_paths,
						env_name: "FL_UPLOAD_SYMBOLS_TO_CRASHLYTICS_DSYM_PATHS",
						description: "Paths to the DSYM files or zips to upload",
						optional: true,
						type: Array,
						verify_block: proc do |values|
							values.each do |value|
								UI.user_error!("Couldn't find file at path '#{File.expand_path(value)}'") unless File.exist?(value)
								UI.user_error!("Symbolication file needs to be dSYM or zip") unless value.end_with?(".zip", ".dSYM")
							end
						end
					),
					FastlaneCore::ConfigItem.new(
						key: :api_token,
						env_name: "CRASHLYTICS_API_TOKEN",
						sensitive: true,
						optional: true,
						description: "Crashlytics API Key"
					),
					FastlaneCore::ConfigItem.new(
						key: :binary_path,
						env_name: "FL_UPLOAD_SYMBOLS_TO_CRASHLYTICS_BINARY_PATH",
						description: "The path to the upload-symbols file of the Fabric app",
						optional: true,
						verify_block: proc do |value|
							value = File.expand_path(value)
							UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
						end
					),
					FastlaneCore::ConfigItem.new(
						key: :platform,
						env_name: "FL_UPLOAD_SYMBOLS_TO_CRASHLYTICS_PLATFORM",
						description: "The platform of the app (ios, appletvos, mac)",
						default_value: "ios",
						verify_block: proc do |value|
							available = ['ios', 'appletvos', 'mac']
							UI.user_error!("Invalid platform '#{value}', must be #{available.join(', ')}") unless available.include?(value)
						end
					),
					FastlaneCore::ConfigItem.new(
						key: :dsym_worker_threads,
						env_name: "FL_UPLOAD_SYMBOLS_TO_CRASHLYTICS_DSYM_WORKER_THREADS",
						type: Integer,
						default_value: 3,
						optional: true,
						description: "The number of threads to use for simultaneous dSYM upload",
						verify_block: proc do |value|
							min_threads = 1
							UI.user_error!("Too few threads (#{value}) minimum number of threads: #{min_threads}") unless value >= min_threads
						end
					)
				]
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
