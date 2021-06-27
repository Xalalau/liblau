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
> - /Server/MyStuff/Lib1.lua
> - /Server/MyStuff/Subfolder/ICanAccessLib1GlobalThings.lua

1. Create your Lua files like ``Scope/MyAddon/mycode.lua``. e.g _Client/FlyingCars/tothemoon.lua_
1. Open or create ``Scope/Index.lua``. e.g. _Client/Index.lua_
1. Call ``LL:RequireFolder("MyAddon")``. e.g _LL:RequireFolder("FlyingCars")_

### 4) (Optional) Set live reloading to some folders
> To facilitate development you can configure some folders to reload their package if any files inside them are updated. This procedure is always managed at server scope.

1. Choose a folder like ``Scope/MyAddon``. e.g _Client/FlyingCars_
1. Open or create ``Server/Index.lua``
1. Call ``LL:SetLiveReloading("Client", "MyAddon")``. e.g _LL:SetLiveReloading("Client", "FlyingCars")_

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

:white_medium_small_square: | _File
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [_File:Find](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_File.lua)

<br/>

:white_medium_small_square: | Bind
------------ | -------------
![img](https://i.imgur.com/NTaK5Vd.png) | [Bind:Exists](https://github.com/Xalalau/liblau/blob/master/Client/liblau/objects/Bind.lua)
![img](https://i.imgur.com/NTaK5Vd.png) | [Bind:Get](https://github.com/Xalalau/liblau/blob/master/Client/liblau/objects/Bind.lua)
![img](https://i.imgur.com/NTaK5Vd.png) | [Bind:GetAll](https://github.com/Xalalau/liblau/blob/master/Client/liblau/objects/Bind.lua)
![img](https://i.imgur.com/DEGvkBi.png) | bind
![img](https://i.imgur.com/DEGvkBi.png) | unbind

<br/>

:white_medium_small_square: | ConCommand
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [ConCommand:Add](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/ConCommand.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [ConCommand:Exists](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/ConCommand.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [ConCommand:Get](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/ConCommand.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [ConCommand:GetAll](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/ConCommand.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [ConCommand:Run](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/ConCommand.lua)

<br/>

:white_medium_small_square: | CVar:Add
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [CVar:Add](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/CVar.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [CVar:Exists](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/CVar.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [CVar:Get](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/CVar.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [CVar:GetValue](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/CVar.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [CVar:GetAll](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/CVar.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [CVar:SetValue](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/CVar.lua)

<br/>

:white_medium_small_square: | Global
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [IsBasicTable](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsBool](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsColor](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsFunction](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsNumber](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsQuat](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsRotator](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsString](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsTable](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsVector](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsVector2D](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [IsUserdata](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [SortedPairs](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [toBool](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/global.lua)

<br/>

:white_medium_small_square: | Global - Events
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [Subscribe](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/events.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [Unubscribe](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/events.lua)

<br/>

:white_medium_small_square: | LibLau
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [LL:GetCallInfo](https://github.com/Xalalau/liblau/blob/master/Shared/Index.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [LL:ReadFolder](https://github.com/Xalalau/liblau/blob/master/Shared/Index.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [LL:RequireFolder](https://github.com/Xalalau/liblau/blob/master/Shared/Index.lua)
![img](https://i.imgur.com/0QDsDU6.png) | [LL:SetLiveReloading](https://github.com/Xalalau/liblau/blob/master/Server/Index.lua)

<br/>

:white_medium_small_square: | string
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [string.Explode](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/string.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [string.GetExtension](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/string.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [string.GetLines](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/string.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [string.PatternFormat](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/string.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [string.StripExtension](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/string.lua)

<br/>

:white_medium_small_square: | table
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [table.Copy](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.Concat](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.Count](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.HasValue](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.IsEmpty](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.Print](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.TosTring](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [table.Transfer](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/table.lua)

<br/>

:white_medium_small_square: | _Timer
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Change](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Create](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Exists](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Get](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:GetAll](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Pause](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Remove](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:RepsLeft](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Restart](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Simple](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:TimeLeft](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:Toggle](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
![img](https://i.imgur.com/jsK5p2b.png) | [_Timer:UnPause](https://github.com/Xalalau/liblau/blob/master/Shared/liblau/objects/_Timer.lua)
