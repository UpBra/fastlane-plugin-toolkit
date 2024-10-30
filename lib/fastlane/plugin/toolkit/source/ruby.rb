# -------------------------------------------------------------------------
#
# Ruby Additions
#
# -------------------------------------------------------------------------

# String

class String

	def tail(n = 15)
		value = self.clone
		lines = value.lines
		start = [ lines.count - n, 0 ].max
		lines[start..-1].join
	end
end
