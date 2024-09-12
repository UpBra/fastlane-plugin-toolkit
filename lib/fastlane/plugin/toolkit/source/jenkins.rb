# ----------------------------------------------------------------------
#
# Jenkins
#
# ----------------------------------------------------------------------

module Jenkins

	def self.print
		table = TerminalTable.new
		table.title = "Jenkins Environment Summary"
		table.addEnvironmentVariable('JOB_NAME')
		table.addEnvironmentVariable('BUILD_URL')

		if ENV['CHANGE_ID']
			table.addEnvironmentVariable('CHANGE_AUTHOR')
			table.addEnvironmentVariable('CHANGE_TITLE')
			table.addEnvironmentVariable('CHANGE_BRANCH')
		end

		table.display
	end
end
