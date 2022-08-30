# liblau

**Updated until Nano's World version a1.14.4 build 9354387**

This package consists of:

  - Libraries to expand the basic Lua functionality;
  - A generic initialization system;
  - A live package reloading system.

For singleplayer and multiplayer.

# Instructions

Check [SublimeBase](https://github.com/Xalalau/SublimeBase) if you want to see a small example of real usage.

## 1) Download

<details>
<summary>Expand</summary><p>
Clone or download the lib, place it in your server Packages directory and rename the folder to "liblau".

```sh
git clone https://github.com/Xalalau/liblau.git
```

![image](https://user-images.githubusercontent.com/5098527/187351046-dc71d025-12ba-4882-9ae1-596449e5dc9c.png)
</p></details>

## 2) Including the lib

<details>
<summary>Expand</summary><p>
Just include the code in another package like this:

1. Choose a package or create a new one, like ``Packages/MyPack``
1. Open or create and open ``Packages/MyPack/Shared/Index.lua``
1. Write ``Call Package.RequirePackage("liblau")`` at the top of the file and save it

![image](https://user-images.githubusercontent.com/5098527/187350946-5ccfff73-af29-4b9f-a263-9a47950af288.png)

At this point all liblau's functions are already accessible on your package. Check the console after reloading the packages/game:

![image](https://user-images.githubusercontent.com/5098527/187351831-33861c2a-538f-460e-8acf-9c31f3719194.png)

</p></details>

## 3) Initializing your code

<details>
<summary>Expand</summary><p>
You can simply write your code as usual, but if you want to give a try there's a included loading system that's pretty straight forward.

All you need to do is set up your file structure following this logic:
> - /Server/Lib1.lua
> - /Server/Subfolder/ICanSafelyAccessLib1GlobalVariables.lua
> - /Server/Subfolder/Zz_ImTheLastFileBecauseOfTheAlphabeticalOrder.lua

E.g.

![image](https://user-images.githubusercontent.com/5098527/187353323-7e503e2c-4ac8-47f9-8518-a4c4b65f8c09.png)

And add this line to Index.lua (in this case on the server):
> LL.RequireScope(Package.GetFiles())

![image](https://user-images.githubusercontent.com/5098527/187351578-b7e7d279-24d0-4d36-97b8-818ce81e220f.png)

That's it! Reload the packages/game and check the console:

![image](https://user-images.githubusercontent.com/5098527/187355045-605ca08e-ad10-48b5-bc81-7bd4a68f28a1.png)

You can also set up a folder structure like this:
> - Packages/MyPack/Shared/IncludeMe
> - Packages/MyPack/Shared/IgnoreMe

And selectively load it (in this case on the Index.lua from the shared scope):
> LL.RequireFolder("IncludeMe", Package.GetFiles())
</p></details>

## 4) Setting up Live Reloading

<details>
<summary>Expand</summary><p>
To facilitate development you can configure some folders to reload the packages if any file inside them is updated. This procedure is always set up on the server side.

1. Choose a folder like ``Scope/MyAddon``. e.g _Client/FlyingCars_
1. Open or create and open ``Server/Index.lua``
1. Call ``LL.SetLiveReloading("Client", "MyAddon", Package.GetFiles())``. e.g _LL.SetLiveReloading("Client", "FlyingCars", Package.GetFiles())_

The available scope options are "Shared", "Server", "Client" and "All". "All" is a shortcut to configure all the scopes at once.

E.g.

![image](https://user-images.githubusercontent.com/5098527/187356233-0ad2bd5e-f267-425d-835e-79784460791a.png)

![image](https://user-images.githubusercontent.com/5098527/187356453-31a43243-2020-4974-a54d-1effdb6444bb.png)

</p></details>

# Functions

<!---
  Shared: https://i.imgur.com/jsK5p2b.png
  Server: https://i.imgur.com/0QDsDU6.png
  Client: https://i.imgur.com/NTaK5Vd.png

  Shared Command: https://i.imgur.com/sNwqGrO.png
  Server Command: https://i.imgur.com/18cor6U.png
  Client Command: https://i.imgur.com/DEGvkBi.png
 --->

:white_medium_small_square: | 🔗 [Filex](https://github.com/Xalalau/liblau/blob/master/Shared/libs/sub/Filex.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | Filex.Find

<br/>

:white_medium_small_square: | 🔗 [Bind](https://github.com/Xalalau/liblau/blob/master/Client/libs/Bind.lua)
------------ | -------------
![img](https://i.imgur.com/NTaK5Vd.png) | Bind.Exists
![img](https://i.imgur.com/NTaK5Vd.png) | Bind.Get
![img](https://i.imgur.com/NTaK5Vd.png) | Bind.GetAll
![img](https://i.imgur.com/DEGvkBi.png) | ```bind```
![img](https://i.imgur.com/DEGvkBi.png) | ```bind_list```
![img](https://i.imgur.com/DEGvkBi.png) | ```unbind```
![img](https://i.imgur.com/DEGvkBi.png) | ```unbind_all```

<br/>

:white_medium_small_square: | 🔗 [ConCommand](https://github.com/Xalalau/liblau/blob/master/Shared/libs/sub/ConCommand.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Add
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Exists
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Get
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.GetAll
![img](https://i.imgur.com/jsK5p2b.png) | ConCommand.Run

<br/>

:white_medium_small_square: | 🔗 [CVar](https://github.com/Xalalau/liblau/blob/master/Shared/libs/sub/CVar.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | CVar.Add
![img](https://i.imgur.com/jsK5p2b.png) | CVar.Exists
![img](https://i.imgur.com/jsK5p2b.png) | CVar.Get
![img](https://i.imgur.com/jsK5p2b.png) | CVar.GetValue
![img](https://i.imgur.com/jsK5p2b.png) | CVar.GetAll
![img](https://i.imgur.com/jsK5p2b.png) | CVar.SetValue

<br/>

:white_medium_small_square: | 🔗 [Global](https://github.com/Xalalau/liblau/blob/master/Shared/libs/global.lua)
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
![img](https://i.imgur.com/jsK5p2b.png) | ToBool

<br/>

:white_medium_small_square: | 🔗 [Events](https://github.com/Xalalau/liblau/blob/master/Shared/libs/events.lua)
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

:white_medium_small_square: | 🔗 [string](https://github.com/Xalalau/liblau/blob/master/Shared/libs/sub/string.lua)
------------ | -------------
![img](https://i.imgur.com/jsK5p2b.png) | string.Explode
![img](https://i.imgur.com/jsK5p2b.png) | string.FormatPattern
![img](https://i.imgur.com/jsK5p2b.png) | string.FormatVarargs
![img](https://i.imgur.com/jsK5p2b.png) | string.GetExtension
![img](https://i.imgur.com/jsK5p2b.png) | string.GetLines
![img](https://i.imgur.com/jsK5p2b.png) | string.StripExtension

<br/>

:white_medium_small_square: | 🔗 [table](https://github.com/Xalalau/liblau/blob/master/Shared/libs/sub/table.lua)
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

:white_medium_small_square: | 🔗 [Timerx](https://github.com/Xalalau/liblau/blob/master/Shared/libs/sub/Timerx.lua)
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
