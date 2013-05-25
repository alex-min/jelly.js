# Jelly.js Specifications

This document is detailing the current specifications for the Jelly.js framework.

## Introduction

### Description of the framework

Jelly.js will be a web framework on the top of nodejs, the main goal is to provide a module-oriented web framework for nodejs.

### Why creating another web framework on node ?

I tested a lot of web frameworks (on node and in other languages) but none of them had what I wanted to code a website.

(I tested Express, Towersjs, Meteor, Yeoman and some others)

### Basic principles of the Framework

The core of the framework should be kept as small as possible and any additional feature can be added with a plugin.
The main goal is to create a module oriented web framework.

The usual architecture on web development is looking like this :

```
app/
  js/
  css/
  templates/
static/
  images/
```
This architecture is one of the most popular in web development, however, this comes with downsides :
  - When creating a new website, you have to guess which file is important for using a particular component
  - They are no record of the version required of third-party libraries (jquery,...)
  - They are no connections between the server logic and the client logic (we cannot syncronize values between the template,css and server side code) 
  - There is no way to disable a component of your web page easily without looking at all source files

instead, Jelly.js should bring this architecture :

```
conf/
app/
 menu/
 newsletter/
 auth/
 [...] 
```
Each module will have its own subfolder with its own files. Using a module on another project is simple, just copy the folder.
