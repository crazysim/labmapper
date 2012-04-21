#!/usr/bin/env ruby

require 'yaml'
require 'date'

class Host

  attr_accessor :current_user
  @@suffix = '.cs.ucsb.edu'
  @@invalid_users = ['(unknown)', 'root']

  def initialize(name)
    @name = name
    @current_user = nil
  end

  def update_current_user
    output = ssh('who')
    entries = output.split("\n")
    entries.each do |entry|
      user, tty, date, time, ip = entry.split
      if ip.nil? || ip.size < 6
        @current_user = user unless @@invalid_users.index(user)
      end
    end
  end

  def debug
    puts "#{@name}: #{@current_user}"
  end

  private

  def ssh(cmd)
    # TODO check status (machine may be down)
    `ssh #{@name}#{@@suffix} #{cmd}`
  end

end

class CsilPoller

  # TODO add to these
  @@hostnames = [:cartman, :elroy, :dagwood, :calvin]

  @@hosts = []
  @@hostnames.each do |hostname|
    @@hosts << Host.new(hostname)
  end

  def self.poll
    @@hosts.each do |host|
      host.update_current_user
      host.debug
    end
  end

  def self.serialize(file)
    File.open(file, 'w') do |f|
      f.puts YAML::dump(DateTime.now)
      f.puts ''
      @@hosts.each do |host|
        f.puts YAML::dump(host)
        f.puts ''
      end
    end
  end

end

if $0 == __FILE__
  CsilPoller.poll
  CsilPoller.serialize('socket.yaml')
end
