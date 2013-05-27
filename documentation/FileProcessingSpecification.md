# Jelly.js File Processing Specification

## File Reading Order

Files are supposed to be read in this order. If the live reload is activated, any modification in a block will trigger the execution of the other blocks  

[JellyConf.json]

[General Configuration file]

[Module Configuration file]
 
[Individual file]

## Operation order


[read JellyConf.json]

[read each general configuration file]

[read each module configuration file]

[read plugin directory]

[load plugin]

[read each file]

[apply each plugin]

Done.






