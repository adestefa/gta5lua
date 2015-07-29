# gta5lua
GTA V Modding: Getting Started with the Lua scripting language


# GTA V Modding (background)

As with other versions before it, GTA V requires someone spend the time to find access into the core game code. A way to set a "hook" that will allow other code to run in the game loop. In this way, developers who are skilled enough searched run-time memory and decomplied code for native functions in the game. Once these are found, tested and known they release a scripthook, which is complied down to .asi files. These files are then simply copied to the GTA V game folder, and will give other developers a "hook" for their scripts to run on top of.

 ---------------
[  USER MODS    ]
 ---------------
[  SCRIPT HOOK  ]
 ---------------
[  GTA V        ]
 ---------------

This model of developement requires a lot of trial and error early on as the native functions are being discovered and documented. After some time, the inital scripthook devs published a long list of all known "native" functions. These are the actual functions the Rockstar devs use in the game code. Having access to these functions, their names, argument types and descriptions is part of the fun to discover and use as you grow and learn the game API.

List of native functions can be found here: http://www.dev-c.com/nativedb/


# Lua

So far, from what we know about ScriptHook, to make a mod you would have to write C++ (DLL) and complie down to .asl file. This gives you the most power and with .NET and C#, we may see what the future looks like for modding. But to get Visual Studio, .Net and C# up and running takes a bit more than most may have the time/desire to edure early on.

This Getting Started guide is with you in mind. Instead of treading up the steep hill we can take an much easier path and be up and running within 10 mins. We will do this using Lua, a relatively simple C API written in ANSI C which makes working with GTA natives very straight forward and very "English like" for those more curious than die-hard harckers.

Lua has an interesting history as a langage. It is born from limtations posed on engineers in Brazil, who's import laws did not allow them to use intellectual property from other countries. To expand past C, (which they already had) they would have to develop their own higher level languages themselves. Lua came from this effort. A scripting lanuage over C, Lua is very easy to work with. It feels more like Python than say Java or C itself. It has no dependancies like IDE/support apps/setup etc.. This makes working with Lua in GTA V very easy and a great choice for someone wanting to get their feet wet with minimal investned time and learning curve.

Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics. Lua is dynamically typed, runs by interpreting bytecode for a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

The name also has a rich story as it is stated on the offical page: 

*"Lua" (pronounced LOO-ah) means "Moon" in Portuguese. As such, it is neither an acronym nor an abbreviation, but a noun. More specifically, "Lua" is a name, the name of the Earth's moon and the name of the language. Like most names, it should be written in lower case with an initial capital, that is, "Lua". Please do not write it as "LUA", which is both ugly and confusing, because then it becomes an acronym with different meanings for different people. So, please, write "Lua" right!*

From Wikipedia [1]:

*Lua 1.0 was designed in such a way that its object constructors, being then slightly different from the current light and flexible style, incorporated the data-description syntax of SOL (hence the name Lua – sol is Portuguese for sun; lua is moon). Lua syntax for control structures was mostly borrowed from Modula (if, while, repeat/until), but also had taken influence from CLU (multiple assignments and multiple returns from function calls, as a simpler alternative to reference parameters or explicit pointers), C++ ("neat idea of allowing a local variable to be declared only where we need it"[3]), SNOBOL and AWK (associative arrays). In an article published in Dr. Dobb's Journal, Lua's creators also state that LISP and Scheme with their single, ubiquitous data structure mechanism (the list) were a major influence on their decision to develop the table as the primary data structure of Lua.[5]*

Official site: http://www.lua.org/


# Setup

A few simple steps to get up and running:

1. Install Script Hook https://www.gta5-mods.com/tools/script-hook-v 
2. Install the LUA script plugin for Scripthook https://www.gta5-mods.com/tools/lua-plugin-for-script-hook-v 





-------------------------------------------
1. https://en.wikipedia.org/wiki/Lua_(programming_language)

3.  Ierusalimschy, R.; Figueiredo, L. H.; Celes, W. (2007). "The evolution of Lua" (PDF). Proc. of ACM HOPL III. pp. 2–1–2–26. doi:10.1145/1238844.1238846. ISBN 978-1-59593-766-7.

5. Figueiredo, L. H.; Ierusalimschy, R.; Celes, W. (December 1996). "Lua: an Extensible Embedded Language. A few metamechanisms replace a host of features". Dr. Dobb's Journal 21 (12). pp. 26–33.
