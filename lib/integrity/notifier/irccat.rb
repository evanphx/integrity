require 'integrity'
require 'socket'

module Integrity
  class Notifier
    class IRCCAT < Notifier::Base
      attr_reader :config

      def self.to_haml
        <<-HAML
%p.normal
  %label{ :for => "irccat_host" } Host
  %input.text#irccat_host{ :name => "notifiers[IRCCAT][host]", :type => "text", :value => config["host"] }

%p.normal
  %label{ :for => "irccat_port" } Port
  %input.text#irccat_port{ :name => "notifiers[IRCCAT][port]", :type => "text", :value => config["port"] }
        HAML
      end

      def deliver!
        last_line = build.output.split(/\n/).last

        if build.failed?
          speak "CI: #{short_message}. #{build_url}"
        else
          speak "CI: #{build.short_commit_identifier} success. #{last_line}"
        end
      end

      def speak(str)
        sock = TCPSocket.new(config['host'], config['port'].to_i)
        sock.puts str
        sock.close
      end
    end
  end
end

