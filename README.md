HelloGoodbye
===============
A daemon manager with a TCP interface built on top of EventMachine.

The Foremen Manager
-------------------
The foremen manager is the mother-ship for all your custom foremen that will spawn workers (or do whatever you wish).  
A foreman itself, the manager creates a TCP console of its own so foremen can be reviewed and managed from the manager
itself.

    manager = HelloGoodbye::ForemenManager.new(:port => 8080, :server => "127.0.0.1")

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
      (A list of all foreman)
    </td>
    <td>
      Nothing.
    </td>
  </tr>
  <tr>
    <td>
    (Anything else)
    </td>
    <td>
      Unknown command
    </td>
    <td>
      None.
    </td>
    <td>Nothing.</td>
  </tr>
</table>



Custom Foremen
-------------------
Foremen that you build must inherit from HelloGoodbye::Foreman.

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
      (Anything else not implemented by your custom foreman)
    </td>
    <td>
      Unknown command
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

Usage Examples
-------------------
