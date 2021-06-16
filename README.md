# liblau

A Nano's World package that consists of:

  - Libraries to expand the basic Lua functionality;
  - A generic initialization system;
  - A live package reloading system.

For singleplayer and multiplayer.

## Usage Instructions

Check [SublimeBase](https://github.com/Xalalau/SublimeBase) if you want to see an example of real usage.

### 1) Download
> Obviously you'll need to download the lib and place it in your Packages folder on your server before anything. The folder name must be "liblau".

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
![img](https://i.imgur.com/jsK5p2b.png) | [LL:GetCallInfo](https://github.com/Xalalau/liblau/blob/master/Shared/Index.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [LL:ReadFolder](https://github.com/Xalalau/liblau/blob/master/Shared/Index.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [LL:RequireFolder](https://github.com/Xalalau/liblau/blob/master/Shared/Index.lua)
![img](https://i.imgur.com/0QDsDU6.png) | [LL:SetLiveReloading](https://github.com/Xalalau/liblau/blob/master/Server/Index.lua)

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [isbool](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [isfunction](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [isnumber](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [isrotator](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [isstring](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [istable](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [isvector](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [isvector2d](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/global.lua)

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [string.getextension](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/string/string.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [string.getlines](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/string/string.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [string.split](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/string/string.lua)

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [Subscribe](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/events.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [Unubscribe](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global/events.lua)

<br/>

:white_medium_small_square: | Function
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [table.count](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/table/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.hasvalue](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/table/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.print](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/table/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.tostring](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/table/table.lua)
