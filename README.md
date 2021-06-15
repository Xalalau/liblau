# liblau

A Nano's World package that consists of:

  - Libraries to expand the basic Lua functionality;
  - A generic initialization system;
  - A live package reloading system.

For singleplayer and multiplayer.

## Usage Instructions

### 1) Download
> Obviously you'll need to download the lib and place it in your Packages folder on your server before anything.

### 2) Initialize liblau to access its functions
> Now just include the code in another package and start using the custom functions.

1. Create your own package, like ``Packages/MyPack``
1. Create and open ``Packages/MyPack/Shared/Index.lua``
1. Write ``Call Package:RequirePackage("liblau")`` before anything and save

### 3) (Optional) Initialize your own code using liblau
> If you set up a folder structure like
> - Packages/MyPack/Shared/MyStuff
> - Packages/MyPack/Server/MyStuff
> - Packages/MyPack/Client/MyStuff
> 
> you can initialize "MyStuff" with liblau.
>
> If you want to do so, the files will be loaded from the most superficial folder layers to the deepest ones, following the alphabetical order. This means you can build code dependencies through the folder hierarchy. It looks like this:
> 
> - /Server/MyStuff/LibA.lua
> - /Server/MyStuff/Subfolder/ICanAccessLibAGlobalThings.lua

1. Create your Lua files like ``Scope/MyAddon/mycode.lua``. e.g _Client/FlyingCars/tothemoon.lua_
1. Open ``Scope/Index.lua``. e.g. _Client/Index.lua_
1. Call ``LL:RequireFolder("MyAddon")``. e.g _LL:RequireFolder("FlyingCars")_

### 4) (Optional) Set live reloading to some folders
> To facilitate development you can configure some folders to reload their package if any files inside them are updated. This procedure is always managed at server scope.

1. Choose a folder like ``Scope/MyAddon``. e.g _Client/FlyingCars_
1. Open ``Server/Index.lua``
1. Call ``LL:SetLiveReloading("Client", "MyAddon")``. e.g _LL:SetLiveReloading("Client", "FlyingCars")_

Note: The available scope options are "Shared", "Server", "Client" and "All". "All" is a shortcut to configure all the scopes at once.

## Functions

<!---
  Shared: https://i.imgur.com/jsK5p2b.png
  Server: https://i.imgur.com/0QDsDU6.png
  Client: https://i.imgur.com/NTaK5Vd.png
 --->

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | LL:GetCallInfo
![img](https://i.imgur.com/jsK5p2b.png) | LL:ReadFolder
![img](https://i.imgur.com/jsK5p2b.png) | LL:RequireFolder
![img](https://i.imgur.com/0QDsDU6.png) | LL:SetLiveReloading

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | isbool
![img](https://i.imgur.com/jsK5p2b.png) | isfunction
![img](https://i.imgur.com/jsK5p2b.png) | isnumber
![img](https://i.imgur.com/jsK5p2b.png) | isrotator
![img](https://i.imgur.com/jsK5p2b.png) | isstring
![img](https://i.imgur.com/jsK5p2b.png) | istable
![img](https://i.imgur.com/jsK5p2b.png) | isvector
![img](https://i.imgur.com/jsK5p2b.png) | isvector2d

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | print

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | string.getextension
![img](https://i.imgur.com/jsK5p2b.png) | string.getlines
![img](https://i.imgur.com/jsK5p2b.png) | string.split

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | table.hasvalue
![img](https://i.imgur.com/jsK5p2b.png) | table.print
![img](https://i.imgur.com/jsK5p2b.png) | table.tostring
