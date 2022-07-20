# frozen_string_literal: true

module Gem::Platform::Patch
  def initialize(arch)
    case arch
    when Array then
      @cpu, @os, @version = arch
    when String then
      arch = arch.split '-'

      if arch.length > 2 and arch.last !~ /\d+(\.\d+)?$/ # reassemble x86-linux-{libc}
        extra = arch.pop
        arch.last << "-#{extra}"
      end

      cpu = arch.shift

      @cpu = case cpu
             when /i\d86/ then 'x86'
             else cpu
             end

      if arch.length == 2 and arch.last =~ /^\d+(\.\d+)?$/ # for command-line
        @os, @version = arch
        return
      end

      os, = arch
      @cpu, os = nil, cpu if os.nil? # legacy jruby

      @os, @version = case os
                      when /aix(\d+)?/ then             [ 'aix',       $1  ]
                      when /cygwin/ then                [ 'cygwin',    nil ]
                      when /darwin(\d+)?/ then          [ 'darwin',    $1  ]
                      when /^macruby$/ then             [ 'macruby',   nil ]
                      when /freebsd(\d+)?/ then         [ 'freebsd',   $1  ]
                      when /hpux(\d+)?/ then            [ 'hpux',      $1  ]
                      when /^java$/, /^jruby$/ then     [ 'java',      nil ]
                      when /^java([\d.]*)/ then         [ 'java',      $1  ]
                      when /^dalvik(\d+)?$/ then        [ 'dalvik',    $1  ]
                      when /^dotnet$/ then              [ 'dotnet',    nil ]
                      when /^dotnet([\d.]*)/ then       [ 'dotnet',    $1  ]
                      when /linux-?((?!gnu)\w+)?/ then  [ 'linux',     $1  ]
                      when /mingw32/ then               [ 'mingw32',   nil ]
                      when /(mswin\d+)(\_(\d+))?/ then
                        os, version = $1, $3
                        @cpu = 'x86' if @cpu.nil? and os =~ /32$/
                        [os, version]
                      when /netbsdelf/ then             [ 'netbsdelf', nil ]
                      when /openbsd(\d+\.\d+)?/ then    [ 'openbsd',   $1  ]
                      when /bitrig(\d+\.\d+)?/ then     [ 'bitrig',    $1  ]
                      when /solaris(\d+\.\d+)?/ then    [ 'solaris',   $1  ]
                      # test
                      when /^(\w+_platform)(\d+)?/ then [ $1,          $2  ]
                      else                              [ 'unknown',   nil ]
                      end
    when Gem::Platform then
      @cpu = arch.cpu
      @os = arch.os
      @version = arch.version
    else
      raise ArgumentError, "invalid argument #{arch.inspect}"
    end
  end

  def ===(other)
    return nil unless Gem::Platform === other

    # cpu
    ([nil,'universal'].include?(@cpu) or [nil, 'universal'].include?(other.cpu) or @cpu == other.cpu or (@cpu == 'arm' and other.cpu.start_with?("arm"))) and

      # os
      @os == other.os and

      # version
      (
        (@os != 'linux' and (@version.nil? or other.version.nil?)) or
          (@os == 'linux' and (!@version.nil? and other.version.nil?)) or
          @version == other.version
      )
  end
end

# apply monkeypatch
Gem::Platform.prepend Gem::Platform::Patch
# reset cached values
Gem::Platform.instance_eval { @local = nil }
Gem.instance_eval { @platforms = nil }

source 'https://rubygems.org'

# Specify your gem's dependencies in grc.gemspec
gemspec

gem 'rake', '~> 13.0'

gem 'minitest', '~> 5.0'

gem 'rubocop', '~> 1.21'

gem 'unicode-name', '~> 1.10.0'

gem 'rubocop-minitest', '~> 0.20.1'

gem 'rubocop-rake', '~> 0.6.0'

gem 'unicode-data', '~> 0.1.1'

gem 'coveralls', require: false
