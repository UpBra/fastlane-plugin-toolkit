module Fastlane

	module Actions

		class FirebaseDeployDsymAction < UploadSymbolsToCrashlyticsAction

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'Summary for firebase_deploy_dsym',
					mask_keys: [:cli_token, :service_credentials_file]
				)

				super(params)
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.available_options
				Fastlane::Actions::UploadSymbolsToCrashlyticsAction.available_options
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
