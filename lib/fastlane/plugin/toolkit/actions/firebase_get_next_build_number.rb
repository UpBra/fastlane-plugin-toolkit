module Fastlane

	module Actions
	
		module SharedValues
			FIREBASE_GET_NEXT_BUILD_NUMBER_RESULT = :FIREBASE_GET_NEXT_BUILD_NUMBER_RESULT
		end

		class FirebaseGetNextBuildNumberAction < Action

			module KEY
				LATEST_RELEASE = :latest_release
			end

			def self.run(params)
				latest_release = params[KEY::LATEST_RELEASE]
				latest_release ||= lane_context[SharedValues::FIREBASE_APP_DISTRO_LATEST_RELEASE]
				latest_release ||= {}
				build_number = latest_release[:buildVersion].to_i
				build_number = build_number.next

				UI.success("Firebase Build Number: #{build_number}")
				lane_context[SharedValues::FIREBASE_GET_NEXT_BUILD_NUMBER_RESULT] = build_number.to_s
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
				[
					FastlaneCore::ConfigItem.new(
						key: KEY::LATEST_RELEASE,
						env_name: 'FIREBASE_GET_NEXT_BUILD_NUMBER_LATEST_RELEASE',
						description: 'API Token for FirebaseGetNextBuildNumberAction',
						optional: true
					)
				]
			end

			def self.output
				# Define the shared values you are going to provide
				# Example
				[
					['FIREBASE_GET_NEXT_BUILD_NUMBER_CUSTOM_VALUE', 'A description of what this value contains']
				]
			end

			def self.return_value
				# If your method provides a return value, you can describe here what it does
			end

			def self.authors
				# So no one will ever forget your contribution to fastlane :) You are awesome btw!
				['Your GitHub/Twitter Name']
			end

			def self.is_supported?(platform)
				# you can do things like
				#
				#  true
				#
				#  platform == :ios
				#
				#  [:ios, :mac].include?(platform)
				#

				platform == :ios
			end
		end
	end
end
