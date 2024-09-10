# ----------------------------------------------------------------------
#
# Global
#
# ----------------------------------------------------------------------

module Platform
	ALL = :all
	IOS = :ios
	TVOS = :tvos
	ANDROID = :android
	ANDROIDTV = :androidtv
end

module Configuration
	DEBUG = :debug
	ALPHA = :alpha
	BETA = :beta
	MAIN = :main
	STAGING = :staging
	HOTFIX = :hotfix
	MILESTONE = :milestone
end

module Global

end

class Settings < Hash
	attr_accessor :alpha
	attr_accessor :beta
	attr_accessor :staging
	attr_accessor :milestone

	def initialize()
		self.alpha = {}
		self.beta = {}
		self.staging = {}
		self.milestone = {}
	end
end
