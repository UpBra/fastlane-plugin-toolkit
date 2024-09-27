# -------------------------------------------------------------------------
#
# Post Status
# Posts status messages to multiple chat clients (Teams and Slack)
#
# -------------------------------------------------------------------------

module Status

	class << self
		attr_accessor :title, :message
		attr_accessor :facts, :builds
		attr_accessor :theme_color
		attr_accessor :activity_title
		attr_accessor :activity_subtitle
		attr_accessor :slack_webhook
		attr_accessor :teams_webhook
	end

	self.title = ''
	self.message = ''
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
		return unless FastlaneCore::Env.truthy?('JENKINS_HOME')

		self.title = "#{ENV['JOB_NAME']}: #{ENV['BUILD_NUMBER']}"

		if ENV['CHANGE_ID']
			self.add_fact('CHANGE_BRANCH', ENV['CHANGE_BRANCH'])
			self.add_fact('CHANGE_TITLE', ENV['CHANGE_TITLE'])
			self.add_fact('CHANGE_AUTHOR', ENV['CHANGE_AUTHOR'])
		else
			self.add_fact('BRANCH', ENV['BRANCH_NAME'])
			self.add_fact('HASH', ENV['GIT_COMMIT'])
			self.add_fact('GIT_LOG', `git log -1 --pretty=%B`.strip)
		end
	end

	def self.teams_params(success: true)
		teams_facts = self.facts.map { |fact| {name: fact.name, value: fact.value} }
		theme_color = success ? self.theme_color : 'FF0000'

		params = {
			teams_url: self.teams_webhook,
			title: self.title,
			text: self.message,
			activity_title: self.activity_title,
			activity_subtitle: self.activity_subtitle,
			facts: teams_facts,
			theme_color: theme_color
		}
	end

	def self.slack_params(success: true)
		payload = self.facts.clone.map { |fact| [fact.name, fact.value] }.to_h

		params = {
			pretext: self.title,
			message: self.message,
			slack_url: self.slack_webhook,
			payload: payload,
			success: success
		}
	end
end
