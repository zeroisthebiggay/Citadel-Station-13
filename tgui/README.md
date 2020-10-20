<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [tgui](#tgui)
	- [Concepts](#concepts)
	- [Using It](#using-it)
	- [Copypasta](#copypasta)

<!-- /TOC -->

# tgui
tgui is the user interface library of /tg/station. It is rendered clientside,  based on JSON data sent from the server. Clicks are processed on the server, in  a similar method to native BYOND `Topic()`.

Basic tgui consists of defining a few procs. In these procs you will handle a request to open or update a UI (typically by updating a UI if it exists or setting up and opening it if it does not), a request for data, in which you build a list to be passed as JSON to the UI, and an action handler, which handles any user input. In addition, you will write a HTML template file which renders your data and provides actionable inputs.

tgui is very different from most UIs you will encounter in BYOND programming, and is heavily reliant of Javascript and web technologies as opposed to DM. However, if you are familiar with NanoUI (a library which can be found on almost every other SS13 codebase), tgui should be fairly easy to pick up.

<<<<<<< HEAD
tgui is a fork of NanoUI. The server-side code (DM) is similar and derived from NanoUI, while the clientside is a wholly new project with no code in common.

## Concepts
tgui is loosely based a MVVM architecture. MVVM stands for model, view, view model.
- A model is the object that a UI represents. This is the atom a UI corresponds to in the game world in most cases, and is known as the `src_object` in tgui.
- The view model is how data is represented in terms of the view. In tgui, this is the `ui_data` proc which munges whatever complex data your `src_object` has into a list.
- The view is how the data is rendered. This is the template, a HTML (plus mustaches and other goodies) file which is compiled into the tgui blob that the browser executes.
=======
- [Node v12.18.3+](https://nodejs.org/en/download/)
- [Yarn v1.22.4+](https://yarnpkg.com/en/docs/install) (optional)
- [Git Bash](https://git-scm.com/downloads)
  or [MSys2](https://www.msys2.org/) (optional)

**DO NOT install Chocolatey if Node installer asks you to!**
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

Not included in the MVVM model are other important concepts:
- The action/topic handler, `ui_act`, is what recieves input from the user and acts on it.
- The request/update proc, `ui_interact` is where you open your UI and set options like title, size, autoupdate, theme, and more.
- Finally, `ui_state`s (set in `ui_interact`) dictate under what conditions a UI may be interacted with. This may be the standard checks that check if you are in range and conscious, or more.

<<<<<<< HEAD
States are easy to write and extend, and what make tgui interactions so powerful. Because states can over overridden from other procs, you can build powerful interactions for embedded objects or remote access.

## Using It
All these examples and abstracts sound great, you might say. But you also might say, "How do I use it?"

Examples can be as simple or as complex as you would like. Let's start with a very basic hello world.

```DM
/obj/machinery/my_machine/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
  ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
  if(!ui)
    ui = new(user, src, ui_key, "my_machine", name, 300, 300, master_ui, state)
    ui.open()
```

This is the proc that defines our interface. There's a bit going on here, so let's break it down. First, we override the ui_interact proc on our object. This will be called by `interact` for you, which is in turn called by `attack_hand` (or `attack_self` for items). `ui_interact` is also called to update a UI (hence the `try_update_ui`), so we accept an existing UI to update. The `state` is a default argument so that a caller can overload it with named arguments (`ui_interact(state = overloaded_state)`) if needed.

Inside the `if(!ui)` block (which means we are creating a new UI), we choose our template, title, and size; we can also set various options like `style` (for themes), or autoupdate. These options will be elaborated on later (as will `ui_state`s).

After `ui_interact`, we need to define `ui_data`. This just returns a list of data for our object to use. Let's imagine our object has a few vars:

```DM
/obj/machinery/my_machine/ui_data(mob/user)
  var/list/data = list()
  data["health"] = health
  data["color"] = color

  return data
```

The `ui_data` proc is what people often find the hardest about tgui, but its really quite simple! You just need to represent your object as numbers, strings, and lists, instead of atoms and datums.

Finally, the `ui_act` proc is called by the interface whenever the user used an input. The input's `action` and `params` are passed to the proc.

```DM
/obj/machinery/my_machine/ui_act(action, params)
  if(..())
    return
  switch(action)
    if("change_color")
      var/new_color = params["color"]
      if(!(color in allowed_coors))
        return
      color = new_color
      . = TRUE
  update_icon()
```

The `..()` (parent call) is very important here, as it is how we check that the user is allowed to use this interface (to avoid so-called href exploits). It is also very important to clamp and sanitize all input here. Always assume the user is attempting to exploit the game.
=======
**For Git Bash, MSys2, WSL, Linux or macOS users:**

Change your directory to `tgui`.

Run `bin/tgui --install-git-hooks` to install merge drivers which will
assist you in conflict resolution when rebasing your branches. Only has
to be done once.

Run `bin/tgui` with any of the options listed below.

**For Windows CMD or PowerShell users:**

If you haven't opened the console already, you can do that by holding
Shift and right clicking on the `tgui` folder, then pressing
either `Open command window here` or `Open PowerShell window here`.

Run `.\bin\tgui.bat` with any of the options listed below.

> If using PowerShell, you will receive errors if trying to run
> `.\bin\tgui.ps1`, because default Windows policy does not allow direct
> execution of PS1 scripts. Run `.\bin\tgui.bat` instead.

**Available commands:**

- `bin/tgui` - Build the project in production mode.
- `bin/tgui --dev` - Launch a development server.
  - tgui development server provides you with incremental compilation,
  hot module replacement and logging facilities in all running instances
  of tgui. In short, this means that you will instantly see changes in the
  game as you code it. Very useful, highly recommended.
  - In order to use it, you should start the game server first, connect to it
  and wait until the world has been properly loaded and you are no longer
  in the lobby. Start tgui dev server, and once it has finished building,
  press F5 on any tgui window. You'll know that it's hooked correctly if
  you see a green bug icon in titlebar and data gets dumped to the console.
- `bin/tgui --dev --reload` - Reload byond cache once.
- `bin/tgui --dev --debug` - Run server with debug logging enabled.
- `bin/tgui --dev --no-hot` - Disable hot module replacement (helps when
doing development on IE8).
- `bin/tgui --lint` - Show problems with the code.
- `bin/tgui --fix` - Auto-fix problems with the code.
- `bin/tgui --analyze` - Run a bundle analyzer.
- `bin/tgui --clean` - Clean up project repo.
- `bin/tgui [webpack options]` - Build the project with custom webpack
options.

**For virgins:**

You can double-click these batch files to achieve the same thing:

- `bin\tgui.bat` - Build the project in production mode.
- `bin\tgui-dev-server.bat` - Launch a development server.
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

Also note the use of `. = TRUE` (or `FALSE`), which is used to notify the UI that this input caused an update. This is especially important for UIs that do not auto-update, as otherwise the user will never see their change.

Finally, you have a template. This is also a source of confusion for many new users. Some basic HTML knowledge will get you a long way, however.

<<<<<<< HEAD
A template is regular HTML, with mustache for logic and built-in components to quickly build UIs. Here's how we might show some data (components will be elaborated on later).

In a template there are a few special values. `config` is always the same and is part of core tgui (it will be explained later), `data` is the data returned from `ui_data`, and `adata` is the same, but with certain values (numbers at this time) interpolated in order to allow animation.
=======
**Development server is crashing**

Make sure path to your working directory does not contain spaces or special
unicode characters. If so, move codebase to a location which does not contain
spaces or unicode characters.

This is a known issue with Yarn Berry, and fix is going to happen someday.

**Development server doesn't find my BYOND cache!**

This happens if your Documents folder in Windows has a custom location, for
example in `E:\Libraries\Documents`. Development server tries its best to find
this non-standard location (searches for a Windows Registry key), but it can
fail. You have to run the dev server with an additional environmental
variable, with a full path to BYOND cache.
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d

```html
<ui-display>
  <ui-section label='Health'>
    <span>{{data.health}}</span>
  </ui-section>
  <ui-section label='Color'>
    <span>{{data.color}}</span>
  </ui-section>
</ui-display>
```
<<<<<<< HEAD

Templates can be very confusing at first, as ternary operators, computed properties, and iterators are used quite a bit in more complex interfaces. Start with the basics, and work your way up. Much of the complexity stems from performance concerns. If in doubt, take the simpler approach and refactor if performance becomes an issue.

## Copypasta
We all do it, even the best of us. If you just want to make a tgui **fast**, here's what you need (note that you'll probably be forced to clean your shit up upon code review):

```DM
/obj/copypasta/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state) // Remember to use the appropriate state.
  ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
  if(!ui)
    ui = new(user, src, ui_key, "copypasta", name, 300, 300, master_ui, state)
    ui.open()

/obj/copypasta/ui_data(mob/user)
  var/list/data = list()
  data["var"] = var

  return data

/obj/copypasta/ui_act(action, params)
  if(..())
    return
  switch(action)
    if("copypasta")
      var/newvar = params["var"]
      var = Clamp(newvar, min_val, max_val) // Just a demo of proper input sanitation.
      . = TRUE
  update_icon() // Not applicable to all objects.
```

And the template:

```html
<ui-display title='My Copypasta Section'>
  <ui-section label='Var'>
    <span>{{data.var}}</span>
  </ui-section>
  <ui-section label='Animated Var'>
    <span>{{adata.var}}</span>
  </ui-section>
</ui-display>
```
=======
BYOND_CACHE="E:/Libraries/Documents/BYOND/cache"
```

## Developer Tools

When developing with `tgui-dev-server`, you will have access to certain
development only features.

**Debug Logs.**
When running server via `bin/tgui --dev --debug`, server will print debug
logs and time spent on rendering. Use this information to optimize your
code, and try to keep re-renders below 16ms.

**Kitchen Sink.**
Press `F12` to open the KitchenSink interface. This interface is a
playground to test various tgui components.

**Layout Debugger.**
Press `F11` to toggle the *layout debugger*. It will show outlines of
all tgui elements, which makes it easy to understand how everything comes
together, and can reveal certain layout bugs which are not normally visible.

## Project Structure

- `/packages` - Each folder here represents a self-contained Node module.
- `/packages/common` - Helper functions
- `/packages/tgui/index.js` - Application entry point.
- `/packages/tgui/components` - Basic UI building blocks.
- `/packages/tgui/interfaces` - Actual in-game interfaces.
Interface takes data via the `state` prop and outputs an html-like stucture,
which you can build using existing UI components.
- `/packages/tgui/layouts` - Root level UI components, that affect the final
look and feel of the browser window. They usually hold various window
elements, like the titlebar and resize handlers, and control the UI theme.
- `/packages/tgui/routes.js` - This is where tgui decides which interface to
pull and render.
- `/packages/tgui/layout.js` - A root-level component, holding the
window elements, like the titlebar, buttons, resize handlers. Calls
`routes.js` to decide which component to render.
- `/packages/tgui/styles/main.scss` - CSS entry point.
- `/packages/tgui/styles/functions.scss` - Useful SASS functions.
Stuff like `lighten`, `darken`, `luminance` are defined here.
- `/packages/tgui/styles/atomic` - Atomic CSS classes.
These are very simple, tiny, reusable CSS classes which you can use and
combine to change appearance of your elements. Keep them small.
- `/packages/tgui/styles/components` - CSS classes which are used
in UI components. These stylesheets closely follow the
[BEM](https://en.bem.info/methodology/) methodology.
- `/packages/tgui/styles/interfaces` - Custom stylesheets for your interfaces.
Add stylesheets here if you really need a fine control over your UI styles.
- `/packages/tgui/styles/layouts` - Layout-related styles.
- `/packages/tgui/styles/themes` - Contains all the various themes you can
use in tgui. Each theme must be registered in `webpack.config.js` file.

## Component Reference

See: [Component Reference](docs/component-reference.md).

## License

Source code is covered by /tg/station's parent license - **AGPL-3.0**
(see the main [README](../README.md)), unless otherwise indicated.

Some files are annotated with a copyright header, which explicitly states
the copyright holder and license of the file. Most of the core tgui
source code is available under the **MIT** license.

The Authors retain all copyright to their respective work here submitted.
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
