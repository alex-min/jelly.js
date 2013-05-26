# Jelly.js Template Plugin System

## General Information

The template plugin should convert HTML template files into JavaScript.

### Parameters

```json
  pluginParameters : {
      'template':{
      }
  }
```
There is currently no additional parameter available.

### Processing of template files

Templates will be processed with the **dotjs** template system to provide a fast execution of templates.

### Inclusion of modules

Because most of the templates will be in a partial form, the template plugin needs to have a  simple way to include partials.

When including a partial into another template, the framework needs a way to determine which parameter is bound to a module.

**Example:** (this is not a working code)

- Content of template A :

```
The username is : {{;self.username;}}
```
- Content of template B :

```
{{#def.load(template A)}}
The color is {{;self.color;}}
```

The compiled output for template B will be similar to this code (this is not actual code):

```javascript
function (it) {
  it = it || {};
  var _stack = [];
  var ret = "";
  var self = null;
  _stack.push("Template B")
  self = it[_stack[0]] || {};

  _stack.push("Template A")
  self = it[_stack[0]] || {};
  ret += "The Username is : " + self.username;
  _stack.pop();
  self = it[_stack[0]] || {};

  ret += "The color is " + self.color;
  _stack.pop();
  self = it[_stack[0]] || {}; 
  return ret;
}
```

The self variable will always represent the current variable object.
This way, there is only one function call and no ```with``` statement (for performance reasons).


