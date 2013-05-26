# Jelly.js Routing Plugin System

## General Guidelines

Because most of the code created with the framework should be reusable, a large part of the templates will be in a partial form.

**Example:**

A login form can have two templates :

  - A login form template
  - A 'forget password' form template

Both of these templates will be included in the final page, to make this possible, the code of the final page should be kept as small as possible.
Each component that can be used on another project should be kept in a separate module.

The final web page will look a bit like this (this is an example, not a working code) :

```html
<html>
<head>
  [include scripts of "menu" and "login"]
</head>
<body>
[include "horizontal" from "menu"]
[include "form" from "login"]
</body>
</html>
```

The routing plugin should only handle modules and general files only (not simple files).

Additional parameters can be specified on the module configuration file :

```json
  modulePluginParameters : {
      'routing':{
        file:'routes.json'
      }
  }
```
**file** : The filename to read on the module to gather the list of routes, if not specified, 'routes.json' is the default value.

### Routes.json Module specification

Here is an example of a 'routes.json' file :

```json
 {
    routes: [
        {method:["get"],id:"listUsers",url:"/user/{id}",call:
          {
            "type":"controller",
            "name":"listUsers"
          }
        },
        {method:["get","post"],id:"login",url:"/login", call:
          {
            "type":"controller",
            "name":"login"
          }
        },
        {method:["get"],id:"test",url:"/test", call:
          {
            "type":"view",
            "name":"testPage"
          }
        }
    ]
 }
```
The main goal for the routing system is to keep most of the logic on the module side to help when copying the module into another project.

Here is a detailed explanation of everything in this file :

**routes** : Should return an Array of route.

#### Route parameters :

**method**: An array of HTTP methods where the route can be triggered. Possible values are : "get", "post", "put", "delete".

**id**: An id referencing the route from the outside (especially in the general configuration file).

**url**: The local url to trigger the route.
Because these urls are locally bound to the module, everything can be used before this url.

Example: if the general configuration file is bounding the moduleName before each url, the local url "/user/{id}" can be transformed into "/login/user/{id}"

Notice: Each url should begin with a slash character and end without any slash character.

**call**: This Object is determining what to do when the route is triggered.

Two parameters can be used :

  - **type**: The type of object to trigger. Two values are available :

    - **"controller"** : The routing plugin will call the method specified by **name** into the server side code. (the serverload module **MUST** be loaded for this to work).
    - **"view"** : The routing plugin will directly associate the route to a view. THis is equivalent of creating a controller which will return imediatly a view. As everywere in the framework, only the local name of the view is necessary ("login" should trigger &lt;MODULE_NAME&gt;-login.tpl in the right directory). **Notice**:The template builtin module is required for this parameter to work.

### Routes.json General File Specification

To bind all the local routes to the general website without conflicts, the routing plugin can handle a global route file.

Additional parameters can be specified on the global configuration file :

```json
  pluginParameters : {
      'routing':{
        file:'routes.json'
      }
  }
```

**file** : The filename to read on the module to gather the list of routes, if not specified, 'routes.json' is the default value.

Here is an example of a 'routes.json' file (for general configuration files):

```json
 {
    routes: [
        {type:"autoBind","modules":["login"]},
        {type:"autoBindAll"},
    ]
 }
```
Autobinding is currently the only option available for the routing system.
The Autobinding mode is appending the moduleName as a prefi for each url.

Example with a login module :
 - [get]      /user/{id}
 - [get,post] /login
 - [get,post] /forgotpassword

will become :
 - [get] /login/user/{id}
 - [get,post] /login/login
 - [get,post] /login/forgotpassword