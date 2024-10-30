# ----------------------------------------------------------------------
#
# Global
#
# ----------------------------------------------------------------------

module Toolkit::Platform
	ALL = :all
	IOS = :ios
	TVOS = :tvos
	ANDROID = :android
	ANDROIDTV = :androidtv
end

module Toolkit::Product
	GENERIC = :generic
end

module Toolkit::Configuration
	DEBUG = :debug
	ALPHA = :alpha
	BETA = :beta
	MAIN = :main
	STAGING = :staging
	HOTFIX = :hotfix
	MILESTONE = :milestone
end

module Fastlane::Actions::SharedValues
	NAME = :TOOLKIT_NAME
	PLATFORM = :TOOLKIT_PLATFORM
	PRODUCT = :TOOLKIT_PRODUCT
	CONFIGURATION = :TOOLKIT_CONFIGURATION
	DEPLOY = :TOOLKIT_DEPLOY
	NOTIFY = :TOOLKIT_NOTIFY
	IS_CI = :TOOLKIT_IS_CI
end

module Toolkit

	Actions = Fastlane::Actions
	SharedValues = Actions::SharedValues

	def self.setup(name:, options:)
		self.name = name
		self.platform = options.fetch(:platform, Toolkit::Platform::IOS).to_sym
		self.product = options.fetch(:product, Toolkit::Product::GENERIC).to_sym
		self.configuration = options.fetch(:configuration, Toolkit::Configuration::MAIN).to_sym
		self.deploy = options.fetch(:deploy, false)
		self.notify = options.fetch(:notify, false)
		self.is_ci = FastlaneCore::Helper.ci?

		print
	end

	def self.print
		params = {}
		params[:platform] = self.platform
		params[:product] = self.product
		params[:configuration] = self.configuration
		params[:deploy] = self.deploy?
		params[:notify] = self.notify?
		params[:is_ci] = self.is_ci?

		FastlaneCore::PrintTable.print_values(
			title: "Toolkit Summary",
			config: params
		)
	end

	def self.lane_context
		Actions.lane_context
	end

	def self.name
		lane_context[SharedValues::NAME]
	end

	def self.name=(value)
		lane_context[SharedValues::NAME] = value.to_s
	end

	def self.platform
		lane_context[SharedValues::PLATFORM]
	end

	def self.platform=(value)
		lane_context[SharedValues::PLATFORM] = value.to_sym
	end

	def self.product
		lane_context[SharedValues::PRODUCT]
	end

	def self.product=(value)
		lane_context[SharedValues::PRODUCT] = value.to_sym
	end

	def self.configuration
		lane_context[SharedValues::CONFIGURATION]
	end

	def self.configuration=(value)
		lane_context[SharedValues::CONFIGURATION] = value.to_sym
	end

	def self.deploy?
		lane_context[SharedValues::DEPLOY]
	end

	def self.deploy=(value)
		lane_context[SharedValues::DEPLOY] = value
	end

	def self.notify?
		lane_context[SharedValues::NOTIFY]
	end

	def self.notify=(value)
		lane_context[SharedValues::NOTIFY] = value
	end

	def self.is_ci?
		lane_context[SharedValues::IS_CI] ||= FastlaneCore::Helper.ci?
	end

	def self.is_ci=(value)
		lane_context[SharedValues::IS_CI] = value.to_s.downcase == 'true'
	end
end

# Terminal Table

class TerminalTable

	attr_accessor :rows, :title

	def initialize
		@rows = []
		@title = ''
	end

	def add_environment_variable(key, upcase: false)
		value = ENV.fetch(key, '')
		value = value.upcase if upcase
		rows << [key, value]
	end

	def display
		params = {title: title.green, rows: rows}
		table = Terminal::Table.new(params)

		puts('')
		puts(table)
		puts('')
	end
end
