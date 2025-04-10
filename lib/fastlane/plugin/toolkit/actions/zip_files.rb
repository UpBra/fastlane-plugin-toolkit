module Fastlane

	module Actions

		module SharedValues
			ZIP_FILES_OUTPUT_FILE = :ZIP_FILES_OUTPUT_FILE
		end

		class ZipFilesAction < Action

			def self.run(params)
				require 'shellwords'

				FastlaneCore::PrintTable.print_values(
					config: params,
					title: "Summary for zip_files",
					mask_keys: []
				)

				# Archive Path and Filename
				output_path = params[:path]
				output_path += '/' unless output_path.end_with?('/')

				# Ensure output path folder exists
				sh("mkdir -p #{output_path}")

				filename = params[:name]
				filename += '.zip' unless filename.end_with?('.zip')
				zipfile = File.expand_path(output_path + filename)

				# File list
				file_paths = params[:file_paths].compact.reject(&:blank?)
				file_paths = file_paths.map { |i| Shellwords.shellescape(i) }

				file_paths.each do |file|
					folder = File.dirname(file)
					basename = File.basename(file)

					Dir.chdir(folder) do
						sh("zip -ur9 #{zipfile} #{basename}")
					end
				end

				UI.success("Successfully created zipfile: #{zipfile}")
				sh("unzip -l #{zipfile}")

				lane_context[SharedValues::ZIP_FILES_OUTPUT_FILE] = zipfile
				zipfile
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'This action will create a zip file given a list of artifacts'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :name,
						env_name: 'ZIP_FILES_NAME',
						description: 'Name of the output zip file'
					),
					FastlaneCore::ConfigItem.new(
						key: :path,
						env_name: 'ZIP_FILES_PATH',
						description: 'The path where to save the generated zip file. The name is appended to this path for you',
						default_value: 'artifacts'
					),
					FastlaneCore::ConfigItem.new(
						key: :file_paths,
						type: Array,
						optional: false,
						description: 'Array of absolute paths to files to be included in the zip'
					)
				]
			end

			def self.output
				[
					[SharedValues::ZIP_FILES_OUTPUT_FILE, return_value]
				]
			end

			def self.return_value
				'Path to the output zip file'
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
