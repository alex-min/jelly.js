# Jelly.js Configuration

## General Guidelines

All configuration files should be in JSON format. The main goal to use only the JSON file format is to provide an easy way to read and write file configuration (including from the browser)

All the general configuration files should be on the 'config' directory from the root project.

The file 'config/JellyConf.json' should be read first and will specify all the other configuration to read.

All the variables in every JSON config file should be written in camelCase format. 

## List of Configuration Files

Here is the list of all configuration files :
 - **Main Configuration file**: Its path is always 'config/JellyConfig.json', it contains a list of general configurations and general parameters. Only one can exist in a project.
 - **General Configuration file**: All of them should be under the config directory. They are here to process multiple files in different ways :
    - The Javascript of the Client and the Server should not be processed in the same way
    - Server files cannot be included in the client final file (it should have at least two general configuration file, one for the server and one for the client)
    - Which is the name of the configuration file to read in each module ?
    - What is the list of module to load ?
    - [...] (see the General Configuration File Specification Documentation for more details)

 - **Module Configuration File** : Specified by the General Configuration File, they defines how the framework will read when parsing a file :
  - What plugin to apply for each file extension ?
  - Post-Process and Pre-Process on file.
  - Specifing files to add only on development mode.
  - [...] (read the Module Configuration File Specification Documentation for more details)


(see ModuleConfigurationSpecification and MainConfigurationSpecification for more details)