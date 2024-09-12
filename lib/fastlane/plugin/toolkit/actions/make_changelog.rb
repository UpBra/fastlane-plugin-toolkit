module Fastlane

	module Actions

		module SharedValues
			GET_DEPLOY_CHANGELOG_RESULT = :GET_DEPLOY_CHANGELOG_RESULT
		end

		class MakeChangelogAction < Action

			module Key
				PREVIOUS = :previous_git_commit
				COMMIT = :git_commit
			end

			def self.run(params)
				return lane_context[SharedValues::FL_CHANGELOG] if lane_context.include?(SharedValues::FL_CHANGELOG)

				previous = params[Key::PREVIOUS]
				commit = params[Key::COMMIT]
				between = previous && commit && previous != commit

				if between
					other_action.changelog_from_git_commits(
						between: [
							previous,
							commit
						]
					)
				end

				# Fallback to last_git_commit
				lane_context[SharedValues::FL_CHANGELOG] ||= other_action.last_git_commit[:message]

				# Fallback to default value
				lane_context[SharedValues::FL_CHANGELOG] ||= 'No changelog given'

				lane_context[SharedValues::FL_CHANGELOG]
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'A short description with <= 80 characters of what this action does'
			end

			def self.details
				# Optional:
				'You can use this action to do cool things...'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: Key::PREVIOUS,
						env_name: 'GIT_PREVIOUS_SUCCESSFUL_COMMIT',
						description: 'Previous git commit',
						type: String,
						optional: true
					),
					FastlaneCore::ConfigItem.new(
						key: Key::COMMIT,
						env_name: 'GIT_COMMIT',
						description: 'Current git commit',
						type: String,
						optional: true
					)
				]
			end

			def self.output
				[
					['GET_DEPLOY_CHANGELOG_CUSTOM_VALUE', 'A description of what this value contains']
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
