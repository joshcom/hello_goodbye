require 'rubygems'
require 'eventmachine'

require File.expand_path('lib/hello_goodbye/foremen_manager')

module HelloGoodbye

  # Resets the current foremen manager, so that the next time
  # self.manager is called, a new ForemenManager instance will be
  # created.
  def self.reset!
    @manager = nil
  end

  # Create a new manager or use the existing manager.  If an existing manager exists,
  # port and server will be ignored.
  # Parameters:
  # * port:   The port the manager should connect to.
  # * server: The server the service will run from.
  def self.manager(port=ForemenManager.default_manager_port,server=Foreman.default_server)
    @manager ||= ForemenManager.new(:port => port, :server => server)
  end

end
