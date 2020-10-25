# Contributing to My GTemplate

This project is primarily written in C.  GUI elements are written
in XML.  You don't have to be an expert in C to contribute.  Find
a simple bug to work on and send a merge request.


## Filing a bug

Please file bugs for issues, enhancements and features at the
[bug tracker](https://gitlab.com/sadiq/my-gtemplate/issues).

Create a Merge request and I’d be happy to review your patch
and help you get it merged.


## Coding style

All contributions to My GTemplate should follow its coding style.
The style can mostly be inferred from the code.  The following
is a shorter version:

* Code should be indented with spaces only - **No tabs ever**
* Use 2 space for each indentation level
* Except for functions, structs, unions, and enum definitions,
  curly braces should have a new indentation level.
* Use curly braces only for multi-statement blocks.
* For function definitions and declarations, each argument should
  go to separate line.
* When calling a function, never add a newline between the function
  call paren, or immediatly after (ie, before the first argument).
* Almost always put a space before a paren.

This project follows GTK coding style.  Read it online
at https://gitlab.gnome.org/GNOME/gtk/blob/master/docs/CODING-STYLE

The following exceptions apply:

1. Maximum line width is 100 characters.
2. Header files should use `#pragma once` as include guard.
3. Use 2 spaces after the end of a sentence.
   * This helps navigation in GNU Emacs better.

```c
/* FIXME: This is a hack.  How to get the window width right? */
```

4. Include the full URL to the bug report in commit messages so that
   they can be accessed from local git log (or mirror repositories).

```
settings: Fix a memory leak

g_get_current_dir() returns a newly allocated string.
It should be freed using g_free()

Closes: https://gitlab.com/sadiq/my-gtemplate/issues/23
```


## Be explicit about ownership transfers

Since `GLib 2.44`, we've had helpful macros and functions to be
explit about ownership transfers.  Please use them as it drastically
saves time when tracking down memory leaks.

These include:

 * `g_autoptr()`, `g_auto()`, and `g_autofree`.
 * `g_steal_pointer()`
 * `g_clear_object()` and `g_clear_pointer()`

We prefer that you zero fields in structures when freeing the contents.
