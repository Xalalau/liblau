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

1. Choose a package or create your own, like ``Packages/MyPack``
1. Open or create ``Packages/MyPack/Shared/Index.lua``
1. Write ``Call Package.RequirePackage("liblau")`` before anything and save

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
> - /Server/MyStuff/Lib1.lua
> - /Server/MyStuff/Subfolder/ICanAccessLib1GlobalThings.lua

1. Create your Lua files like ``Scope/MyAddon/mycode.lua``. e.g _Client/FlyingCars/tothemoon.lua_
1. Open or create ``Scope/Index.lua``. e.g. _Client/Index.lua_
1. Call ``LL.RequireFolder("MyAddon")``. e.g _LL.RequireFolder("FlyingCars")_

### 4) (Optional) Set live reloading to some folders
> To facilitate development you can configure some folders to reload their package if any files inside them are updated. This procedure is always managed at server scope.

1. Choose a folder like ``Scope/MyAddon``. e.g _Client/FlyingCars_
1. Open or create ``Server/Index.lua``
1. Call ``LL.SetLiveReloading("Client", "MyAddon")``. e.g _LL.SetLiveReloading("Client", "FlyingCars")_

Note: The available scope options are "Shared", "Server", "Client" and "All". "All" is a shortcut to configure all the scopes at once.

## Functions

<!---
  Shared: https://i.imgur.com/jsK5p2b.png
  Server: https://i.imgur.com/0QDsDU6.png
  Client: https://i.imgur.com/NTaK5Vd.png

  Shared Command: https://i.imgur.com/sNwqGrO.png
  Server Command: https://i.imgur.com/18cor6U.png
  Client Command: https://i.imgur.com/DEGvkBi.png
 --->

:white_medium_small_square: | 🔗 [_File](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_File.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | _File.Find

<br/>

:white_medium_small_square: | 🔗 [Bind](https://github.com/Xalalau/liblau/blob/master/Client/liblau/objects/Bind.lua)
------------ | -------------
![img](https://i.imgur.com/NTaK5Vd.png) | Bind.Exists
![img](https://i.imgur.com/NTaK5Vd.png) | Bind.Get
![img](https://i.imgur.com/NTaK5Vd.png) | Bind.GetAll
![img](https://i.imgur.com/DEGvkBi.png) | ```bind```
![img](https://i.imgur.com/DEGvkBi.png) | ```bind_list```
![img](https://i.imgur.com/DEGvkBi.png) | ```unbind```
![img](https://i.imgur.com/DEGvkBi.png) | ```unbind_all```

<br/>

:white_medium_small_square: | 🔗 [ConCommand](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/ConCommand.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Add
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Exists
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Get
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.GetAll
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Run

<br/>

:white_medium_small_square: | 🔗 [CVar](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/CVar.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | CVar.Add
![img](https://i.imgur.com/jsK5p2b.png) | CVar.Exists
![img](https://i.imgur.com/jsK5p2b.png) | CVar.Get
![img](https://i.imgur.com/jsK5p2b.png) | CVar.GetValue
![img](https://i.imgur.com/jsK5p2b.png) | CVar.GetAll
![img](https://i.imgur.com/jsK5p2b.png) | CVar.SetValue

<br/>

:white_medium_small_square: | 🔗 [Global](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | IsBasicTable
![img](https://i.imgur.com/jsK5p2b.png) | IsBool
![img](https://i.imgur.com/jsK5p2b.png) | IsColor
![img](https://i.imgur.com/jsK5p2b.png) | IsFunction
![img](https://i.imgur.com/jsK5p2b.png) | IsNil
![img](https://i.imgur.com/jsK5p2b.png) | IsNumber
![img](https://i.imgur.com/jsK5p2b.png) | IsQuat
![img](https://i.imgur.com/jsK5p2b.png) | IsRotator
![img](https://i.imgur.com/jsK5p2b.png) | IsString
![img](https://i.imgur.com/jsK5p2b.png) | IsTable
![img](https://i.imgur.com/jsK5p2b.png) | IsVector
![img](https://i.imgur.com/jsK5p2b.png) | IsVector2D
![img](https://i.imgur.com/jsK5p2b.png) | IsUserdata
![img](https://i.imgur.com/jsK5p2b.png) | SortedPairs
![img](https://i.imgur.com/jsK5p2b.png) | toBool

<br/>

:white_medium_small_square: | 🔗 [Events](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/events.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | Subscribe
![img](https://i.imgur.com/jsK5p2b.png) | Unubscribe

<br/>

:white_medium_small_square: | 🔗 LibLau [sh](https://github.com/Xalalau/liblau/blob/master/Shared/Index.lua) [sv](https://github.com/Xalalau/liblau/blob/master/Server/Index.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | LL.GetCallInfo
![img](https://i.imgur.com/jsK5p2b.png) | LL.ReadFolder
![img](https://i.imgur.com/jsK5p2b.png) | LL.RequireFolder
![img](https://i.imgur.com/0QDsDU6.png) | LL.SetLiveReloading

<br/>

:white_medium_small_square: | 🔗 [string](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/string.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | string.Explode
![img](https://i.imgur.com/jsK5p2b.png) | string.FormatPattern
![img](https://i.imgur.com/jsK5p2b.png) | string.FormatVarargs
![img](https://i.imgur.com/jsK5p2b.png) | string.GetExtension
![img](https://i.imgur.com/jsK5p2b.png) | string.GetLines
![img](https://i.imgur.com/jsK5p2b.png) | string.StripExtension

<br/>

:white_medium_small_square: | 🔗 [table](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | table.Copy
![img](https://i.imgur.com/jsK5p2b.png) | table.Concat
![img](https://i.imgur.com/jsK5p2b.png) | table.Count
![img](https://i.imgur.com/jsK5p2b.png) | table.HasValue
![img](https://i.imgur.com/jsK5p2b.png) | table.IsEmpty
![img](https://i.imgur.com/jsK5p2b.png) | table.Print
![img](https://i.imgur.com/jsK5p2b.png) | table.TosTring
![img](https://i.imgur.com/jsK5p2b.png) | table.Transfer

<br/>

:white_medium_small_square: | 🔗 [Timerx](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/Timerx.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Change
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Create
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Exists
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Get
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.GetAll
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Pause
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Remove
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.RepsLeft
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Restart
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Simple
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.TimeLeft
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.Toggle
![img](https://i.imgur.com/jsK5p2b.png) | Timerx.UnPause
