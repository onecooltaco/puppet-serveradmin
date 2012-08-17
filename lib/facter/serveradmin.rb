Facter.add("serveradminversion") do
  ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"

  setcode do
    output = `serveradmin -v 2>&1`
    if $?.exitstatus.zero?
      m = /Version ([\d\.]+)/.match output
      if m
        m[1]
      end
    end
  end
end
