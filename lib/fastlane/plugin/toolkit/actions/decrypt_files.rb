module Fastlane

	module Actions

		class DecryptFilesAction < Action

			require 'match'

			def self.run(params)
				path = params[:path]
				password = params[:password]

				Helper::Toolkit.iterate(path) do |current|
					decrypt_file(path: current, password: password)
					UI.success("🔓	Decrypted '#{File.basename(current)}'") if FastlaneCore::Globals.verbose?
				end

				UI.success("🔓	Successfully decrypted files in path: #{path}")
			end

			def self.decrypt_file(path: nil, password: nil)
				e = Match::Encryption::MatchFileEncryption.new
				e.decrypt(file_path: path, password: password)
			rescue => error
				UI.error(error.to_s)
				UI.error("Error decrypting '#{path}'")
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Decrypt files in folder at path'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :path,
						env_name: 'DECRYPT_FILES_PATH',
						description: 'Path to folder containing files to decrypt',
					),
					FastlaneCore::ConfigItem.new(
						key: :password,
						env_name: 'DECRYPT_FILES_PASSWORD',
						description: 'Password used to decrypt files',
					)
				]
			end

			def self.output
				[ ]
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
