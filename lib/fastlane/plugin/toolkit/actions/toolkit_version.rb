module Fastlane

	module Actions

		module SharedValues
			TOOLKIT_VERSION_CUSTOM_VALUE = :TOOLKIT_VERSION_CUSTOM_VALUE
		end

		class ToolkitVersionAction < Action

			def self.run(params)
				# fastlane will take care of reading in the parameter and fetching the environment variable:
				UI.message("Parameter API Token: #{params[:profile]}")

				# sh "shellcommand ./path"

				# Actions.lane_context[SharedValues::TOOLKIT_VERSION_CUSTOM_VALUE] = "my_val"
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
				# Define all options your action supports.

				# Below a few examples
				[
					FastlaneCore::ConfigItem.new(
						key: :profile,
						env_name: 'TOOLKIT_PROFILE',
						description: 'API Token for ToolkitVersionAction',
						type: Fastlane::FastFile::Profile
					)
				]
			end

			def self.output
				# Define the shared values you are going to provide
				# Example
				[
					['TOOLKIT_VERSION_CUSTOM_VALUE', 'A description of what this value contains']
				]
			end

			def self.return_value
				# If your method provides a return value, you can describe here what it does
			end

			def self.authors
				['Your GitHub/Twitter Name']
			end

			def self.is_supported?(platform)
				platform == :ios
			end
		end
	end
end
