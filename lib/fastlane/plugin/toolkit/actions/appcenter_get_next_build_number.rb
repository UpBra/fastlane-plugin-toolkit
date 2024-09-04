module Fastlane

	module Actions

		module SharedValues
			APPCENTER_GET_NEXT_BUILD_NUMBER_RESULT = :APPCENTER_GET_NEXT_BUILD_NUMBER_RESULT
		end

		class AppcenterGetNextBuildNumberAction < Action

			FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-appcenter', require_gem: true)

			def self.run(params)
				FastlaneRequire.install_gem_if_needed(gem_name: 'fastlane-plugin-appcenter', require_gem: true)
				available = Fastlane::Actions::AppcenterFetchVersionNumberAction.available_options.map(&:key)
				options = params.values.clone.keep_if { |k,v| available.include?(k) }
				options.transform_keys(&:to_sym)

				FastlaneCore::PrintTable.print_values(
					config: options,
					title: 'Summary for appcenter_get_next_build_number',
					mask_keys: [:api_token]
				)

				begin
					result = other_action.appcenter_fetch_version_number(options)
					build_number = result.fetch('build_number')
				rescue => error
					puts error
					build_number = 0
				end

				build_number = build_number.to_i.next.to_s

				UI.success("Appcenter build number: #{build_number}")
				lane_context[SharedValues::APPCENTER_GET_NEXT_BUILD_NUMBER_RESULT] = build_number
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				Fastlane::Actions::AppcenterFetchVersionNumberAction.description
			end

			def self.details
				Fastlane::Actions::AppcenterFetchVersionNumberAction.details
			end

			def self.available_options
				Fastlane::Actions::AppcenterFetchVersionNumberAction.available_options
			end

			def self.output
				[
					['TLK_BUILD_NUMBER_APPCENTER_CUSTOM_VALUE', 'A description of what this value contains']
				]
			end

			def self.return_value
				# If your method provides a return value, you can describe here what it does
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
