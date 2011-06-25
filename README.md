HelloGoodbye
===============
A daemon manager with a TCP interface built on top of EventMachine.

The Foremen Manager
-------------------
The foremen manager is the mother-ship for all your custom foremen that will spawn workers (or do whatever you wish).  
A foreman itself, the manager creates a TCP console of its own so foremen can be reviewed and managed from the manager
itself.

    manager = HelloGoodbye::ForemenManager.new(:port => 8080, :server => "127.0.0.1")
    # or...
    manager = HelloGoodbye.manager(8080, "127.0.0.1")

To register foremen (before "start!"ing the manager), execute code like the following:

    manager.register_foreman( :port => 8081, :class => HelloGoodbye::TestForeman )

If you want to capture errors (and you should -- if the manager goes down, everything is liable to go down with it),
pass a block to the on_error method as follows:

    manager.on_error do |e|
      # Do stuff. 
    end

When you're all set up, fire away with the start! method:

    manager.start!

This will block.  After this is executed, all your manager and all your foremen should be listening in on their respective ports
for your command.

Consoles
-------------
After making a TCP connection to one of the consoles, communication should occur to and from the console using one of the following standard JSON packages.

Commands issued to a service should be formatted as follows:

    {
      "command": "YOUR COMMAND"
    }

Responses from the service will be formatted as follows:

    {
      "success": true,
      "message": "MESSAGE FROM SERVICE",
      "results": []
    }

Note the following: 

* **success** can be **true** for **false**
* **results** will either be an array of data relavent to the command, or will be absent.

The Manager Console
--------------------
Once started, your manager will be available for TCP connections, and will respond to the following commands:
<table>
  <tr>
    <th>Command</th><th>Response Message</th><th>Results</th><th>Action Performed</th>
  </tr>
  <tr>
    <td>
      hello
    </td>
    <td>
      hello
    </td>
    <td>
      None.
    </td>
    <td>
      Nothing.  Just a convenient way to "ping" the service.
    </td>
  </tr>
  <tr>
    <td>
      goodbye
    </td>
    <td>
      goodbye
    </td>
    <td>
      None.
    </td>
    <td>
      Closes the connection.
    </td>
  </tr>
  <tr>
    <td>
      foremen 
    </td>
    <td>
      ok
    </td>
    <td>
      An array of hashes with details about each forman. 
    </td>
    <td>
      Nothing.
    </td>
  </tr>
  <tr>
    <td>
      start XX 
    </td>
    <td>
      "ok" if successful.
    </td>
    <td>
      An array of started foreman.  E.g. ["test"]
    </td>
    <td>
      The foreman with the name XX is started.  If XX is "all", all stopped foremen
      will be started. 

      XX will be "test" if the foreman name is TestForman.
      Otherwise, if XX is an integer, the ID of the active foreman will be consulted
      instead of the name.
    </td>
  </tr>
  <tr>
    <td>
      stop XX 
    </td>
    <td>
      "ok" if successful.
    </td>
    <td>
      An array of stopped foreman.  E.g. ["test"]
    </td>
    <td>
      The foreman with the name XX is stopped.  If XX is "all", all active foremen
      will be stopped. 

      XX will be "test" if the foreman name is TestForman.
      Otherwise, if XX is an integer, the ID of the active foreman will be consulted
      instead of the name.
    </td>
  </tr>
  <tr>
    <td>
    (Anything else)
    </td>
    <td>
      unknown command
    </td>
    <td>
      None.
    </td>
    <td>Nothing.</td>
  </tr>
</table>



Custom Foremen
-------------------
Foremen that you build must inherit from HelloGoodbye::Foreman.  Beyond that, you should only have to implement a few instance methods that will be executed when the corresponding console commands are executed during a TCP connection:

    def start
      # Start listening for events to respond to.
    end

    def stop
      # Stop listening for events.
    end


Foremen Console
-------------------
Once started, your foreman will be available for TCP connections, and will respond to the following commands:
<table>
  <tr>
    <th>Command</th><th>Response Message</th><th>Results</th><th>Action Performed</th>
  </tr>
  <tr>
    <td>
      hello
    </td>
    <td>
      hello
    </td>
    <td>
      None.
    </td>
    <td>
      Nothing.  Just a convenient way to "ping" the service.
    </td>
  </tr>
  <tr>
    <td>
      goodbye
    </td>
    <td>
      goodbye
    </td>
    <td>
      None.
    </td>
    <td>
      Closes the connection.
    </td>
  </tr>
  <tr>
    <td>
      start
    </td>
    <td>
      ok
    </td>
    <td>
      Nothing. 
    </td>
    <td>
      Executes the foreman's static "start" method.  Typically, this would execute whatever "daemon" will listen for events and spawn workers.
    </td>
  </tr>
  <tr>
    <td>
      stop
    </td>
    <td>
      ok
    </td>
    <td>
      Nada 
    </td>
    <td>
      Executes the forman's "stop" method, stopping the foreman's daemon.
    </td>
  </tr>
  <tr>
    <td>
      status 
    </td>
    <td>
      "running" or "stopped" 
    </td>
    <td>
      Nada 
    </td>
    <td>
      Nothing.
    </td>
  </tr>
  <tr>
    <td>
      (Anything else not implemented by your custom foreman)
    </td>
    <td>
      unknown command
    </td>
    <td>
      None.
    </td>
    <td>
      Nothing.
    </td>
  </tr>
</table>

Custom Consoles
------------------
Although there is a generic 
```ruby 
HelloGoodbye::ForemanConsole
``` 
that will hopefully suit the needs for most usecases, custom consoles can easily be created and attached to custom foremen as needed.

First, to implement your custom console, inherit from 
```ruby 
HelloGoodbye::ForemanConsole
```
and override 
```ruby
receive_command
```
.

To make your own class extensible, and to make use of the built in console commands implemented in the
```ruby
HelloGoodbye::ForemanConsole
```
class, you'll want to start with the template below when overriding this method:

  def receive_command(command)
    # Process additional commands here.
    # Return if processes successfully
    super   # Process the default commands.  If no match, a failure response will be returned. 
  end

The last little catch is this: you must let your custom forman class know which console to use.  To do this, in your Foreman class, assuming your console class is HelloGoodbye::TestConsole (yes, your console **must** be in the HelloGoodbye module ):

    set_console_type :test   # i.e. ":test" for TestConsole

Thus, the rules are as follow:

* Your console's class name must be prefixed with "Console".
* When setting this type with the class method, you must pass in a symbol matching the de-classified class name, minus the "Console" prefix.

