require 'date'
require 'json'

module LabMapper

  class HostPoller

    @@hostnames = ::LabMapper::Config.hosts

    @@hosts = []
    @@hostnames.each do |hostname|
      @@hosts << Host.new(hostname)
    end

    def self.poll
      @@hosts.map(&:poll)
    end

    def self.serialize(file)
      File.open(file, 'w') do |f|
        output = {timestamp: DateTime.now, hosts: {}}
        @@hosts.each do |host|
          output[:hosts][host.name] = {
            user: host.user,
            nossh: host.nossh,
            uptime: host.uptime
          }
        end
        f.puts output.to_json
      end
    end

  end

end
