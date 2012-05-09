module Labmapper
  class Host

    attr_accessor :name, :user, :nossh, :uptime, :realname
    @@suffix = '.cs.ucsb.edu' # TODO grab from labrc
    @@invalid_users = ['(unknown)', 'root'] # TODO fix
    # build out ssh options
    @@options = '-o ConnectTimeout=5 ' # in seconds
    @@options += '-o UserKnownHostsFile=/dev/null '
    # doesn't check RSA fingerprint
    @@options += '-o StrictHostKeyChecking=no '

    def initialize(name, key='~/.ssh/id_rsa.pub')
      @name = name
      @nossh = false
      @user = @uptime = @realname = nil
      @vsim = nil
      @vsimsp2 = nil
      @quartus = nil
      @key = key
    end

    # TODO improve this -- place ssh keys before polling
    def send_key
      res = `ssh-copy-id #{@@options}-i #{@key} #{@name}#{@@suffix}`
      puts "Could not send key to #{@name}" unless $?.success?
    end

    def poll
      res = ssh(['uptime', 'who'])
      if res.nil?
        @nossh = true
      else
        @uptime, *whos = res.split("\n")
        whos.each do |who|
          user, tty, date, time, ip = who.split
          if ip.nil? || ip.size < 6 # TODO no magic number please
            unless @@invalid_users.index(user)
              @user = user 
              @realname = ssh(["/usr/bin/getent passwd #{@user} | cut -f 5 -d: | cut -f 1 -d,"])
            end
          end
          @vsimsp2 = ssh(["file /local/altera11.1sp2/modelsim_ase/linux/vsim"])
          @quartus = ssh(["file /local/altera11.1sp2/quartus/bin/quartus"])
          @vsim = ssh(["file /local/altera11.1/modelsim_ase/linux/vsim"])
        end
      end
      debug # TODO if $DEBUG ?
    end

    def debug
      # TODO let's use log4r
      if (@user)
        puts "#{@name}: #{@user}, #{@realname}"
      else
        puts "#{@name}:"
      end
      puts "#{@vsimsp2}"
      puts "#{@vsim}"
      puts "#{@quartus}"
    end

    def to_json(*a)
      {name: @name, nossh: @nossh, user: @user, realname: @realname}.to_json(*a)
    end

    private

    def ssh(cmds=['who'])
      out = `ssh -q #{@@options}#{@name}#{@@suffix} '#{cmds.join(' ; ')}'`
      # if ssh returned with non-0 exit status
      $?.success? ? out : nil
    end

  end
end
