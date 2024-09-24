# -------------------------------------------------------------------------
#
# make_changelog
#
# -------------------------------------------------------------------------

module Fastlane

	module Actions

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
				'Generates changelog'
			end

			def self.details
				'Uses changelog_from_git_commits or last_git_commit depending on what is available'
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
					['FL_CHANGELOG', 'Generated changelog']
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
