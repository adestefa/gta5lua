

## GTA V Modding: Getting Started with the Lua scripting language


## Background

As with other versions before it, modding GTA V requires someone spend the time to go through the code to figure out how to access a way to inject other code into the core game. A way to set a "hook" that will allow other code to run in the game loop. In this way, developers who are skilled enough searched run-time memory and decomplied code for native functions in the game. Once these are found, tested and known they release a scripthook, which is complied down to .asi files. These files are then simply copied to the GTA V game folder, and will give other developers a "hook" for their scripts to run on top of.
```
 ---------------
[  USER MODS    ]
 ---------------
[  SCRIPT HOOK  ]
 ---------------
[  GTA V        ]
 ---------------
```

This model of developement requires a lot of trial and error early on as the native functions are being discovered and documented. After some time, the inital scripthook devs published a long list of all known "native" functions. These are the actual functions the Rockstar devs use in the game code. Having access to these functions, their names, argument types and descriptions is part of the fun to discover and use as you grow and learn the game API.

List of native functions can be found here: http://www.dev-c.com/nativedb/


## Lua

So far, from what we know about ScriptHook, to make a mod you would have to write C++ (DLL) and complie down to .asl file. This gives you the most power and with .NET and C#, we may see what the future looks like for modding. But to get Visual Studio, .Net and C# up and running takes a bit more than most may have the time/desire to edure early on.

This getting started guide is with you in mind. Instead of treading up the steep hill we can take an much easier path and be up and running within 10 mins just by copying a few simple flies into the GTA folder. We will do this using Lua, a relatively simple declarative laungauge written in ANSI C which makes working with GTA natives very straight forward and very "English like" for those more curious than die-hard hackers.

Using Lua, our stack now looks like this, and adding a mod is as simple as saving your script in the /addons folder!

```
 ---------------
[  USR SCRIPTS  ]
 ---------------
[  LUAHOOK      ]
 ---------------
[  SCRIPT HOOK  ]
 ---------------
[  GTA V        ]
 ---------------
```

### History

Lua has an interesting history as a language. It is born from limtations posed on engineers in Brazil, import laws did not allow them to use intellectual property from other countries. To expand past C, (which they already had) they would have to develop their own higher level languages themselves. Lua came from this effort, as a scripting lanuage over C, Lua is very easy to work with. It feels more like Python than say Java or C itself and has no dependancies.  This makes setting up and working with Lua in GTA V very easy and a great choice for someone wanting to get their feet wet with minimal invested time and learning curve.

For the geek, Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics. Lua is dynamically typed, runs by interpreting bytecode for a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

Along with the history, (if that hasn't won you over yet) the name Lua, also has a rich story as it is stated on the offical page: 

*"Lua" (pronounced LOO-ah) means "Moon" in Portuguese. As such, it is neither an acronym nor an abbreviation, but a noun. More specifically, "Lua" is a name, the name of the Earth's moon and the name of the language. Like most names, it should be written in lower case with an initial capital, that is, "Lua". Please do not write it as "LUA", which is both ugly and confusing, because then it becomes an acronym with different meanings for different people. So, please, write "Lua" right!*

From Wikipedia [1]:

*Lua 1.0 was designed in such a way that its object constructors, being then slightly different from the current light and flexible style, incorporated the data-description syntax of SOL (hence the name Lua – sol is Portuguese for sun; lua is moon). Lua syntax for control structures was mostly borrowed from Modula (if, while, repeat/until), but also had taken influence from CLU (multiple assignments and multiple returns from function calls, as a simpler alternative to reference parameters or explicit pointers), C++ ("neat idea of allowing a local variable to be declared only where we need it"[3]), SNOBOL and AWK (associative arrays). In an article published in Dr. Dobb's Journal, Lua's creators also state that LISP and Scheme with their single, ubiquitous data structure mechanism (the list) were a major influence on their decision to develop the table as the primary data structure of Lua.[5]*

Official site: http://www.lua.org/



## Setup

A few simple steps to get up and running. First we must download ScriptHook, and copy the file to the GTA folder, then we must download the LuaScript file and copy that too, to the GTA folder

1. Install Script Hook https://www.gta5-mods.com/tools/script-hook-v 
2. Install the LUA script plugin for Scripthook http://gtaforums.com/topic/789139-vrelhook-lua-plugin-for-script-hook-v/

## First script

After you have installed both ScriptHook and LuaHook, you should have a /script/addons/ folder added in GTA main directory. This is where we will save .lua files.

Here is a very simple hello world module. It does not print to GTA game, but the console instead. It is a good first test to make sure things are working for you.

```
local test = {}

function test.tick()
    print("Hello World!")
end

return test
```



 Copy this code and save it as test.lua in /scripts/addons/ directory under your GTA install directory. Then fire up the game and you should see the game load normally. Once your player is moving around you can pause the game and alt-tab out to your desktop. There you can check the console for your print statement.
 
The 'tick()' function here is what is run every frame of the game. This is where the code hooks into the run-time code, so be careful what you put in here as it can freeze or crash the game if you are not careful. The two files will get you started with some code. The zombie file can run as is, while the "&lt;TT&gt;" file is used as a template. Simply search and replace "&lt;TT&gt;" with your "Modulename" and it will create a new module with common functions you can use to create interesting changes to the game.

## Keys
keys.lua contains mapping of common keyboard keys. Use this for refference or add this to your project for direct use.

## Skins.txt
Every object in GTA V will have both a string name and an actual hash reference value. This hash acts as the actual value stored in memory. You can use either, but if you use the string name, ```model = GAMEPLAY.GET_HASH_KEY(modelName)``` you have to do a look-up to get the hash value before you can use it in game. This is why it is faster just to include the hash and skip the overhead.

## again.lua
Like any development, a cycle of change and test is common work-flow. Without any help, you must exit the game and restart before any changes to files in the addins folder will show up in game. Again.lua to the rescue! This simple file will let you press a key to have your code reload without having to exit the game! This was such a game changer for me as it increased my dev cycle by 1000x. 

Simply include this file in our addins folder ```\SteamLibrary\SteamApps\common\Grand Theft Auto V\scripts\addins``` to use. Currently set to key 35 (del) which is not always available on all keyboards. Feel free to change.

```
local again = {}
function again.tick()
    -- end key 35--
	if(get_key_pressed(35)) then
		loadAddIns()
		print("AddIns ReLoaded")
		wait(4999);	
	end
end
return again
```

1) Edit Script, save file to /addins/

2) Alt-tab to GTA V game

3) Press Del key

4) Wait few seconds for the game to update

5) Changes will be shown in game


## Errors/Console
When you download Script hook you have the option of the Download SDK version. This will include a console. Use this as it will print any errors and line numbers.

![Image of Console](https://adestefawp.files.wordpress.com/2016/03/console.png)


## FlipAllTheThings
Here is a very simple mod I wrote using the same approach. I included it here to give you a real working example and includes some good practices, including on-screen menus and proper handling of memory in tick() which runs every frame.


###Have fun!


-------------------------------------------
1. https://en.wikipedia.org/wiki/Lua_(programming_language)

3.  Ierusalimschy, R.; Figueiredo, L. H.; Celes, W. (2007). "The evolution of Lua" (PDF). Proc. of ACM HOPL III. pp. 2–1–2–26. doi:10.1145/1238844.1238846. ISBN 978-1-59593-766-7.

5. Figueiredo, L. H.; Ierusalimschy, R.; Celes, W. (December 1996). "Lua: an Extensible Embedded Language. A few metamechanisms replace a host of features". Dr. Dobb's Journal 21 (12). pp. 26–33.
