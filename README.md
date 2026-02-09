# Godot Multiplayer Example

A four player multiplayer example in Godot.
Uses [Netfox](https://github.com/foxssake/netfox) for lag compensation and interpolation, and [Godot Steam](https://godotsteam.com/) for online support.
Also includes support for Godot's ENet implementation.

### Using ENet

Currently there is no option in the GUI for LAN play.
To enable, open the file __network_handler.gd__ and look for the following variables at the top:
```
## TESTING VARIABLES
var IP_ADDRESS: String = "127.0.0.1"
var PORT: int = 42069
var USE_ENET: bool = false
```
Set the __USE_ENET__ flag to __true__ and adjust the other variables if necessary.

### Libraries Required
- Godot Steam <https://godotsteam.com/>
- Netfox <https://github.com/foxssake/netfox>

### Assets Used
- <https://rgsdev.itch.io/free-cc0-modular-animated-vector-characters-2d>
