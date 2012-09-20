Puppet::Type.type(:serveradmin).provide(:settings) do
require 'timeout'
    @doc = "apply serveradmin settings for os x server"
	defaultfor :operatingsystem => :darwin
	commands :serveradmin => "/usr/sbin/serveradmin"

	def check
		pairs = ""
		begin
			Timeout.timeout(30) do
				@pipe = IO.popen("/usr/sbin/serveradmin settings 2>/dev/null", "w+")
				debug("retrieve: reading info for #{resource[:name]}")
				@pipe.puts "\"#{resource[:name]}\""
				@pipe.close_write
				@pipe.read.split("\n").each do |line|
					debug("retrieve: line: #{line}")
					pairs << "#{line}\n"
				end
				@pipe.close
			end
		rescue Timeout::Error
			Process.kill 9, @pipe.pid
		end
		debug("retrieve: Analyzing returned results: #{pairs}")
		debug("retrieve: found #{pairs.count('=')} lines of info")
		if pairs.count('=') < 2
			debug("retrieve: checking single line for empty array")
			if pairs.match(/\A.*(_empty_array).*$/)
				debug("retrieve: looks like and empty array")
				@data = $1
				return :empty
				elseif    pairs.match(/\A.*(_empty_dictionary).*$/)
				debug("retrieve: found empty dictionary, looks like bogus setting")
				@data = $1
				return :outofsync
			end
		end
		case resource[:settings]
		when Hash
			debug("retrieve: command returned multiple lines, will split into hash")
			@data = Hash[*pairs.scan(/^#{Regexp.escape(resource[:name])}:(.*) = (.*)$/).flatten]
			debug("retrieve: Analyzing:\n #{@data.inspect}\n and\n #{resource[:settings].inspect}")
			resource[:settings].select{|k,v| return :outofsync if @data[k]!=v}
			return :insync
		when String
			debug("retrieve: scanning returned line: ...")
			debug("retrieve: results: #{pairs.scan(/^#{Regexp.escape(resource[:name])} = (.*)$/)}")
			@data = pairs.scan(/^#{Regexp.escape(resource[:name])} = (.*)$/)
			return :insync if @data.to_s == resource[:settings]
		end
		return :outofsync
	end

	def delete
		@lines = ""
		begin
			@lines << "#{resource[:name]} = delete"
			set_value(@lines)
			ensure
			@lines = nil
			@data = nil
		end
	end

	def write
		@lines = Array.new
		begin
			case resource[:settings]
			when Hash
				resource[:settings].rehash
				resource[:settings].sort_by { |k, v| k.scan(/[0-9]+|[^0-9]+/).map {|s| s[/[^0-9]/] ? s : s.to_i} }.each do |k,v|
					@lines << "#{resource[:name]}:#{k} = #{v}"
				end
			when String
				@lines << "#{resource[:name]} = #{resource[:settings]}"
			else
				puts "Wrong class"
			end
			if @data == "_empty_array"
				@lines.unshift("#{resource[:name]} = create")
			end
			set_value(@lines)
			ensure
			@lines = nil
			@data = nil
		end
	end

	private

	def set_value( values )
		commandOutput = ""
		command = "/usr/sbin/serveradmin settings"
		debug("Executing " + command)
		begin
			Timeout.timeout(30) do
				@pipe = IO.popen(command, "w+")
				values.each do |val|
					@pipe.puts val
				end
				@pipe.close_write
				@pipe.read.split("\n").each do |line|
					commandOutput << "#{line}\n"
				end
				@pipe.close
			end
		rescue Timeout::Error
			Process.kill 9, @pipe.pid
		end
		return commandOutput
	end

end
