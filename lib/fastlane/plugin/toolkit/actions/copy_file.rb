# -------------------------------------------------------------------------
#
# Copy File
# Copies a file to a target path
#
# -------------------------------------------------------------------------

module Fastlane

	module Actions

		module SharedValues
			COPY_FILE_OUTPUT_PATH = :COPY_FILE_OUTPUT_PATH
		end

		class CopyFileAction < Action

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: "Summary for copy_file",
					mask_keys: []
				)

				file_path = File.expand_path(params[:file])
				target_path = File.expand_path(params[:target_path])

				# we want to make sure that our target folder exist already
				FileUtils.mkdir_p(target_path)

				filename = File.basename(file_path)
				target_file = File.join(target_path, filename)

				UI.command "cp #{file_path} #{target_file}"
				FileUtils.copy(file_path, target_file)

				lane_context[SharedValues::COPY_FILE_OUTPUT_PATH] = target_file
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Copy a specific file to new location'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :file,
						description: "Path to the file you want to copy",
						optional: false
					),
					FastlaneCore::ConfigItem.new(
						key: :target_path,
						description: "The directory in which you want your file copied",
						optional: false,
						default_value: 'artifacts'
					)
				]
			end

			def self.output
				[
					['COPY_FILE_OUTPUT_PATH', self.return_value]
				]
			end

			def self.return_value
				'Path to copied file'
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
