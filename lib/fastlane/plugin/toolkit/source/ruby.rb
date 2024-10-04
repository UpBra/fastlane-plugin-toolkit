# -------------------------------------------------------------------------
#
# Ruby Additions
#
# -------------------------------------------------------------------------

# String

class ::String

	def tail(n = 15)
		value = self.clone
		lines = value.lines
		start = [ lines.count - n, 0 ].max
		truncated = lines[start..-1].join
		truncated
	end
end
