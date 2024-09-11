
module ConfigManager

	def self.add(filename, platform)
		@@platforms ||= {}
		@@platforms[platform] = Config.new(filename)
	end

	class Config

		def initialize(filename)
			paths = []
			paths << File.join(filename)
			paths << File.join("..", filename)
			paths.map { |p| File.expand_path(p) }
			path = paths.detect { |p| File.exist?(p) }

			raise "Could not find #{filename} at path '#{path}'".red if path.nil?

			full_path = File.expand_path(path)
			content = File.read(full_path, encoding: "utf-8")

			# From https://github.com/orta/danger/blob/master/lib/danger/danger_core/dangerfile.rb
			if content.tr!('“”‘’‛', %(""'''))
				puts("Your #{File.basename(path)} has had smart quotes sanitised. " \
							'To avoid issues in the future, you should not use ' \
							'TextEdit for editing it. If you are not using TextEdit, ' \
							'you should turn off smart quotes in your editor of choice.'.red)
			end

			# rubocop:disable Security/Eval
			eval(content)
			# rubocop:enable Security/Eval
		end

		def [](k)
			data[k]
		end

		def data
			@data ||= {}
		end

		def method_missing(method_name, *args, &block)
			# data[method_name.to_sym] = args[0]
			setter(method_name.to_sym, args, block)
		end

		# Setters

		# Override Appfile configuration for a specific lane.
		#
		# lane_name  - Symbol representing a lane name. (Can be either :name, 'name' or 'platform name')
		# block - Block to execute to override configuration values.
		#
		# Discussion If received lane name does not match the lane name available as environment variable, no changes will
		#             be applied.
		def for_lane(lane_name)
			if ENV["FASTLANE_LANE_NAME"] == lane_name.to_s
				yield
			end
		end

		# Override Appfile configuration for a specific platform.
		#
		# platform_name  - Symbol representing a platform name.
		# block - Block to execute to override configuration values.
		#
		# Discussion If received platform name does not match the platform name available as environment variable, no changes will
		#             be applied.
		def for_platform(platform_name)
			if ENV["FASTLANE_PLATFORM_NAME"] == platform_name.to_s
				yield
			end
		end

		def for_configuration(configuration_name)
			if ENV["FASTLANE_CONFIGURATION_NAME"] == platform_name.to_s
				yield
			end
		end

		private

		def setter(key, *args, &block)
			if block
				value = block.call
			else
				value = args.shift
			end

			data[key] = value if value && value.to_s.length > 0
		end
	end
end
