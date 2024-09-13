# ----------------------------------------------------------------------
#
# Jenkins
#
# ----------------------------------------------------------------------

module Jenkins

	def self.print
		table = TerminalTable.new
		table.title = "Jenkins Environment Summary"
		table.add_environment_variable('JOB_NAME')
		table.add_environment_variable('BUILD_URL')

		if ENV['CHANGE_ID']
			table.add_environment_variable('CHANGE_AUTHOR')
			table.add_environment_variable('CHANGE_TITLE')
			table.add_environment_variable('CHANGE_BRANCH')
		end

		table.display
	end
end
