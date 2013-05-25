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