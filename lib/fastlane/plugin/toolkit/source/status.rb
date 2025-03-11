# -------------------------------------------------------------------------
#
# Post Status
# Posts status messages to multiple chat clients (Teams and Slack)
#
# -------------------------------------------------------------------------

module Status

	class << self
		attr_accessor :title, :message, :success
		attr_accessor :facts, :builds, :theme_color
		attr_accessor :activity_title, :activity_subtitle
		attr_accessor :slack_webhook, :teams_webhook
	end

	self.title = ''
	self.message = 'Succeeded'
	self.success = true
	self.facts = []
	self.builds = []
	self.theme_color = '321244'
	self.activity_title = ''
	self.activity_subtitle = ''

	Property = Struct.new(:name, :value)

	def self.add_fact(name, value)
		Status.facts << Property.new(name, value)
	end

	def self.add_build(name, value)
		Status.builds << Property.new(name, value)
	end

	def self.setup_jenkins
		unless FastlaneCore::Env.truthy?('JENKINS_HOME')
			FastlaneCore::UI.important("Setup jenkins?! This isn't a jenkins...")
			return
		end

		self.title = "#{ENV.fetch('JOB_NAME', nil)}: #{ENV.fetch('BUILD_NUMBER', nil)}"

		if ENV['CHANGE_ID']
			self.add_fact('CHANGE_BRANCH', ENV.fetch('CHANGE_BRANCH', nil))
			self.add_fact('CHANGE_TITLE', ENV.fetch('CHANGE_TITLE', nil))
			self.add_fact('CHANGE_AUTHOR', ENV.fetch('CHANGE_AUTHOR', nil))
		else
			self.add_fact('BRANCH', ENV.fetch('BRANCH_NAME', nil))
			self.add_fact('HASH', ENV.fetch('GIT_COMMIT', nil))
			self.add_fact('GIT_LOG', `git log -1 --pretty=%B`.strip)
		end
	end

	def self.setup_github
		unless FastlaneCore::Env.truthy?('GITHUB_ACTIONS')
			FastlaneCore::UI.important("Setup github?! This isn't a github...")
			return
		end

		self.title = ENV.fetch('GITHUB_REPOSITORY', nil).to_s

		self.add_fact('WORKFLOW', ENV.fetch('GITHUB_WORKFLOW', nil))
		self.add_fact('EVENT', ENV.fetch('GITHUB_EVENT_NAME', nil))
		self.add_fact('SHA', ENV.fetch('GITHUB_SHA', nil))
		self.add_fact('GIT_LOG', `git log -1 --pretty=%B`.strip)
	end

	def self.failed(exception)
		self.success = false
		self.message = "Failed: #{exception.to_s.tail}"
	end

	def self.teams_params
		teams_facts = self.facts.map { |fact| {name: fact.name, value: fact.value} }
		theme_color = self.success ? self.theme_color : 'FF0000'

		{
			teams_url: self.teams_webhook,
			title: self.title,
			text: self.message,
			activity_title: self.activity_title,
			activity_subtitle: self.activity_subtitle,
			facts: teams_facts,
			theme_color: theme_color
		}
	end

	def self.slack_params
		payload = self.facts.clone.to_h { |fact| [fact.name, fact.value] }

		{
			pretext: self.title,
			message: self.message,
			slack_url: self.slack_webhook,
			payload: payload,
			success: self.success
		}
	end
end

module Status

	Actions = Fastlane::Actions
	SharedValues = Actions::SharedValues

	def self.add_appcenter_facts
		return unless name ||= Actions.lane_context.fetch(SharedValues::APPCENTER_DEPLOY_APP_DISPLAY_NAME)
		return unless value ||= Actions.lane_context.fetch(SharedValues::APPCENTER_DEPLOY_APP_CONSOLE_URL)

		Status.add_fact(name, value)
	end

	def self.add_firebase_facts
		return unless name ||= Actions.lane_context.fetch(SharedValues::FIREBASE_DEPLOY_APP_DISPLAY_NAME)
		return unless value ||= Actions.lane_context.fetch(SharedValues::FIREBASE_DEPLOY_APP_CONSOLE_URL)

		Status.add_fact(name, value)
	end
end
