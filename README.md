# zhlLuaSocketFix

A DLL mod that fixes LuaSocket compatibility issues in REPENTOGON for The Binding of Isaac: Rebirth.

## ⚠️ Security Disclaimer

**IMPORTANT**: This mod involves installing a DLL file that will be loaded by your game. Please be aware of the following:

- DLL files can execute arbitrary code on your system
- Only download from trusted sources (official releases on this GitHub repository)
- Scan files with your antivirus before installation
- The author provides this software "as is" with no warranty or liability
- Use at your own risk - you are responsible for any consequences

**By downloading and using this mod, you acknowledge these risks and agree to hold the author harmless from any damages or issues that may arise.**

For maximum safety, you can review the source code (or even build it yourself) in this repository before installation.

## The Problem

REPENTOGON's built-in LuaSocket library was compiled for Lua 5.1, which causes crashes when mods attempt to use `require("socket")`. This incompatibility prevents Isaac mods from utilizing networking functionality that should be available through LuaSocket.

### Error Symptoms
- Game crashes when calling `require("socket")` in mod code

## The Solution

zhlLuaSocketFix replaces REPENTOGON's incompatible LuaSocket with a properly compiled version that works with REPENTOGON's Lua environment. The mod:

- ✅ Fixes `require("socket")` crashes
- ✅ Enables full LuaSocket 3.1.0 functionality
- ✅ Maintains compatibility with existing mods
- ✅ Requires no changes to mod code

## Installation

### Option 1: Automatic Installer (Recommended)

1. Download the latest `zhlLuaSocketFix_Setup.exe` from the [Releases](../../releases/latest) page
2. Run the installer - it will automatically:
   - Detect your Isaac installation (Steam or manual)
   - Validate you have REPENTOGON installed
   - Install the fix to the correct location

### Option 2: Manual Installation

1. Download `zhlLuaSocketFix.dll` from the [Releases](../../releases/latest) page
2. Locate your Isaac installation directory (where `isaac-ng.exe` is located)
3. Ensure you have REPENTOGON installed (look for `zhlREPENTOGON.dll`)
4. Copy `zhlLuaSocketFix.dll` to the Isaac directory
5. Start The Binding of Isaac: Rebirth with REPENTOGON

## Verification

After installation, you can verify the fix is working:

1. Start Isaac with REPENTOGON enabled **and --luadebug parameter**
2. Open the Debug Console (backtick ` key)
3. Enter: `lua local s = require("socket"); print(s._VERSION);`
4. You should see the LuaSocket version printed without any crashes

**Note**: If you don't have --luadebug enabled, LuaSocket functions will not work even with this fix installed.

## Requirements

- **The Binding of Isaac: Rebirth**
- **REPENTOGON** ([installation guide](https://github.com/TeamREPENTOGON/REPENTOGON))
- **Windows** (the mod is compiled as a Windows DLL)
- **--luadebug launch parameter** (LuaSocket functionality requires this to be enabled)

### Important: Launch Parameter Required

LuaSocket will **only work** if you launch Isaac with the `--luadebug` parameter:

- **Steam**: Right-click Isaac → Properties → Launch Options → Add `--luadebug`
- **Other platforms**: Add `--luadebug` to your launch command or shortcut

## For Mod Developers

Once installed, you can use LuaSocket in your mods normally:

```lua
local socket = require("socket")
local tcp = socket.tcp()

-- Your networking code here
tcp:connect("example.com", 80)
-- etc.
```

No special setup or compatibility code is needed - the fix works transparently.

## Support

Having issues? Need help?

- 🐛 **Bug Reports**: [Create an issue](../../issues)
- 💬 **General Help**: [Join our Discord](https://discord.com/invite/5R9CSxzcep)
- 📖 **REPENTOGON Docs**: [REPENTOGON Documentation](https://github.com/TeamREPENTOGON/REPENTOGON)

## Technical Details

For developers interested in the implementation details, see the [`src/`](src/) directory which contains:

- Source code architecture and explanation
- Build instructions for compiling from source
- Technical details about the LuaSocket injection method

## License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

**TL;DR**: You can do whatever you want with this code - use it, modify it, distribute it, sell it. No restrictions, no warranty, no liability.

---

**Created by**: [sublimnl](https://twitch.tv/sublimnl)  
**Discord**: https://discord.com/invite/5R9CSxzcep
