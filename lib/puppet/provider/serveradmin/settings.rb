Puppet::Type.type(:serveradmin).provide(:settings) do
	require 'tempfile'
    @doc = "apply serveradmin settings for os x server"
	defaultfor :operatingsystem => :darwin
	commands :serveradmin => "/usr/sbin/serveradmin"

	# compare property values with retrieved values.
	def exists?
		@returned = get_values
		begin
			case resource[:settings]
			when Hash
				debug("retrieve: command returned multiple lines, will split into hash")
				data = Hash[*@returned.scan(/^#{Regexp.escape(resource[:name])}:(.*) = (.*)$/).flatten]
				debug("retrieve: Analyzing:\n #{data.inspect}\n and\n #{resource[:settings].inspect}")
				resource[:settings].select{|k,v| return false if data[k]!=v}
				return true
			when String
				debug("retrieve: scanning returned line: ...")
				debug("retrieve: results: #{@returned.scan(/^#{Regexp.escape(resource[:name])} = (.*)$/)}")
				data = @returned.scan(/^#{Regexp.escape(resource[:name])} = (.*)$/)
				return true if data.to_s == resource[:settings]
			end
		rescue
			return false
		end
		return false
	end

	# remove array entries, only applies to arrays.
	def destroy
		lines = Array.new
		begin
			execute("#{:serveradmin} settings '#{resource[:name]}' = delete")
		rescue Puppet::ExecutionFailure
			raise Puppet::Error.new("Unable to delete serveradmin: #{resource[:name]}")
		end
	end

	#Apply value in serveradmin, creating entry if needed.
	def create
		lines = Array.new
		begin
			case resource[:settings]
			when Hash
				resource[:settings].rehash
				resource[:settings].sort_by { |k, v| k.scan(/[0-9]+|[^0-9]+/).map {|s| s[/[^0-9]/] ? s : s.to_i} }.each do |k,v|
					lines << "#{resource[:name]}:#{k} = #{v}"
				end
				if @returned.nil?
					debug("empty array: needs #{resource[:name]} = create")
					lines.unshift("#{resource[:name]} = create")
				end
			when String
				lines << "#{resource[:name]} = #{resource[:settings]}"
			else
				puts "Wrong class"
			end
			set_value(lines)
			ensure
			lines = nil
			@data = nil
		end
	end

	private

	# read the settings from the serveradmin command line tool.
	def get_values
		pairs = ""
		begin
			execute("#{:serveradmin} settings '#{resource[:name]}'").split("\n").each do |l|
				pairs << "#{l}\n"
			end
		rescue Puppet::ExecutionFailure
			raise Puppet::Error.new("Unable to read serveradmin service: #{resource[:name]}")
		end
		debug("retrieve: Analyzing returned results: #{pairs}")
		debug("retrieve: found #{pairs.count('=')} lines of info")
		if pairs.count('=') < 2 && pairs.match(/\A.*(_empty_array).*$/)
			debug("retrieve: looks like and empty array or bogus setting")
			pairs = nil
		end
		return pairs
	end

	# Set the values, passing to serveradmin settings
	def set_value( values )
		cmd = "echo '#{values.join('\n')}' | #{:serveradmin} settings"
		commandOutput = ""
		begin
			execute(cmd).split("\n").each do |l|
				commandOutput << "#{l}\n"
			end
		rescue Puppet::ExecutionFailure
			raise Puppet::Error.new("Unable to modify serveradmin setting: #{resource[:name]}")
		end

		return commandOutput
	end

end
