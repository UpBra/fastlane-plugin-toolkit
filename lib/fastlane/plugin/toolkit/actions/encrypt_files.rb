module Fastlane

	module Actions

		class EncryptFilesAction < Action

			require 'match'

			def self.run(params)
				path = params[:path]
				password = params[:password]

				Helper::Toolkit.iterate(path) do |current|
					encrypt_file(path: current, password: password)
					UI.success("🔒	Encrypted '#{File.basename(current)}'") if FastlaneCore::Globals.verbose?
				end

				UI.success("🔒	Successfully encrypted files in path: #{path}")
			end

			def self.encrypt_file(path: nil, password: nil)
				UI.user_error!("No password supplied") if password.to_s.strip.length == 0
				e = Match::Encryption::MatchFileEncryption.new
				e.encrypt(file_path: path, password: password)
			rescue FastlaneCore::Interface::FastlaneError
				raise
			rescue => error
				UI.error(error.to_s)
				UI.crash!("Error encrypting '#{path}'")
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Encrypt files in directory at path'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :path,
						env_name: 'ENCRYPT_FILES_PATH',
						description: 'Path to folder containing files to encrypt',
					),
					FastlaneCore::ConfigItem.new(
						key: :password,
						env_name: 'ENCRYPT_FILES_PASSWORD',
						description: 'Password used to encrypt files',
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
