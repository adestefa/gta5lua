# gta5lua
Getting started modding GTA V with the Lua scripting language


# GTA V Modding

As the game was developed using C++, a way to break into the code had to be standardized into a "hook". In this way, developers who searched memory and decomplied code for native functions in the game, they release a scripthook, which is complied down to .asi files which when placed in the GTA V game folder, will give other developers a "hook" for their scripts to run on top of.

This model of developement requires a lot of trial and error early on as the native functions are being discovered and documented. After some time, the inital scripthook devs published a long list of all known "native" functions. These are the actual functions the Rockstar devs use in the game code. Having access to these functions, their names, argument types and descriptions is part of the fun to discover and use as you grow and learn the game API.

List of native functions here: http://www.dev-c.com/nativedb/


# Lua

Lua is cross-platform since it is written in ANSI C, and has a relatively simple C API. Lua has an interesting history as a langage. It is born from limtations posed on engineers in Brazil, who's country did not allow them to import intellectual property into the country. To expand past C, they had to develop their own higher level languages themselves. Lua, was born from this effort. A scripting lanuage over C, Lua is very easy to work with. It feels more like Python than say Java or C itself. This makes working with Lua in GTA V very easy and a great choice for someone wanting to get their feet wet with minimal investned time and learning curve.

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
