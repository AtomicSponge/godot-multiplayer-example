# Godot Multiplayer Example

A four player multiplayer example in Godot.
Uses [Netfox](https://github.com/foxssake/netfox) for lag compensation and interpolation, and [Godot Steam](https://godotsteam.com/) for online support.
Also includes support for Godot's ENet implementation.

## Using ENet

Currently there is no option in the GUI for LAN play.
To enable, open the file __network_handler.gd__ and look for the following variables at the top:
```
## TESTING VARIABLES
var IP_ADDRESS: String = "127.0.0.1"
var PORT: int = 42069
var USE_ENET: bool = false
```
Set the __USE_ENET__ flag to __true__ and adjust the other variables if necessary.
You would then connect to a game as if you were connecting through a Steam lobby, but it will use ENet instead.  Select any lobby as they will all point to the ENet connection.

## Using Steam

The example uses Steam's public AppID of 480.  Because of this when starting a multiplayer game, *other lobbies will show up* and selecting one will cause the game to freeze.  Unfortunately there is no way around this unless you have purchased a Steam page and have your own AppID.

## Libraries Required
- Godot Steam <https://godotsteam.com/>
- Netfox <https://github.com/foxssake/netfox>

## Assets Used
- <https://rgsdev.itch.io/free-cc0-modular-animated-vector-characters-2d>
