HelloGoodbye
===============
A daemon manager with a TCP interface built on top of EventMachine.

The Foremen Manager
-------------------
The foremen manager is the mother-ship for all your custom foremen that will spawn workers (or do whatever you wish).  
A foreman itself, the manager creates a TCP console of its own so foremen can be reviewed and managed from the manager
itself.

You can configure the manager on initialization:
```ruby
  manager = HelloGoodbye::ForemenManager.new(:port => 8080, :server => "127.0.0.1")
``` 

To register foremen (before "start!"ing the manager), execute code like the following:
```ruby
  manager.register_foreman( :port => 8081, :class => HelloGoodbye::TestForeman )
```

If you want to capture errors (and you should -- if the manager goes down, everything is liable to go down with it),
pass a block to the on_error method as follows:
```ruby
  manager.on_error do |e|
    # Do stuff. 
  end
```

When you're all set up, fire away with the start! method:
```ruby
  manager.start!
```

This will block.  After this is executed, all your manager and all your foremen should be listening in on their respective ports
for your command.

Once started, your manager will be available for TCP connections, and will respond to the following commands:
<table>
  <tr>
    <th>Command</th><th>Response</th><th>Action</th>
  </tr>
  <tr>
    <td>
      {
        "command": "hello"
      }
    </td>
    <td>
     {
        "success": true,
        "message": "hello"
     }
    </td>
    <td>
      Nothing.  Just a convenient way to "ping" the service.
    </td>
  </tr>
  <tr>
    <td>
      {
        "command": "goodbye"
      }
    </td>
    <td>
     {
        "success": true,
        "message": "goodbye"
     }
    </td>
    <td>
      Closes the connection.
    </td>
  </tr>
  <tr>
    <td>
      {
        "command": "report"
      }
    </td>
    <td>
      (A list of all foreman)
    </td>
    <td>
      Closes the connection.
    </td>
  </tr>
  <tr>
    <td>
    (Anything else)
    </td>
    <td>
     {
        "success": false,
        "message": "Unknown command"
     }
    </td>
    <td>Nothing.</td>
  </tr>
</table>



Custom Foremen
-------------------
Foremen that you build must inherit from HelloGoodbye::Foreman.

Once started, your forema will be available for TCP connections, and will respond to the following commands:
<table>
  <tr>
    <td>
      {
        "command": "hello"
      }
    </td>
    <td>
     {
        "success": true,
        "message": "hello"
     }
    </td>
    <td>
      Nothing.  Just a convenient way to "ping" the service.
    </td>
  </tr>
  <tr>
    <td>
      {
        "command": "goodbye"
      }
    </td>
    <td>
     {
        "success": true,
        "message": "goodbye"
     }
    </td>
    <td>
      Closes the connection.
    </td>
  </tr>
  <tr>
    <td>
      {
        "command": "start"
      }
    </td>
    <td>
     {
        "success": true,
        "message": "ok"
     }
    </td>
    <td>
      Executes the foreman's static "start" method.  Typically, this would execute whatever "daemon" will listen for events and spawn workers.
    </td>
  </tr>
  <tr>
    <td>
      {
        "command": "stop"
      }
    </td>
    <td>
     {
        "success": true,
        "message": "ok"
     }
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
     {
        "success": false,
        "message": "Unknown command"
     }
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
