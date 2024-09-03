# ----------------------------------------------------------------------
#
# Profile
#
# ----------------------------------------------------------------------

Profile = Struct.new(:platform, :configuration, :build_number) do

	attr_accessor :values

	def initialize(params = {})
		self.platform = params[:platform]
		self.configuration = params[:configuration]
		self.build_number = params.fetch(:build_number, '1')
		self.values = {}

		params.each do |k, v|
			self.values[k] = v
		end
	end

	def [](x)
		self.values[x]
	end

	def []=(x, value)
		self.values[x] = value
	end

	def print(title = [self.platform, self.configuration].map(&:to_s).join('-'))
		config = {
			platform: self.platform,
			configuration: self.configuration,
			build_number: self.build_number
		}.merge(self.values)

		FastlaneCore::PrintTable.print_values(
			config: config,
			title: title
		)
	end
end

class Profile

	def self.ios(params = {})
		params[:platform] ||= Platform::IOS
		Profile.new(params)
	end

	def self.android(params = {})
		params[:platform] ||= Platform::ANDROID
		Profile.new(params)
	end
end