
# zhlLuaSocketFix

## Architecture Overview

This REPENTOGON mod fixes LuaSocket compatibility by replacing the preloaded `socket.core` module with a version compiled for the correct Lua version.

### Key Components

**`mod.cpp`** - The main mod entry point that performs the LuaSocket injection:
- Hooks into REPENTOGON's mod loading system
- Accesses the Lua state during initialization
- Replaces the preloaded `socket.core` module with the updated version
- Uses Lua's `package.preload` table to override the default socket library

**`CMakeLists.txt`** - Build configuration that:
- Compiles LuaSocket 3.1.0 as part of the build process
- Links the LuaSocket library with the mod code
- Ensures compatibility with REPENTOGON's Lua version
- Generates the `zhlLuaSocketFix.dll` output

### How It Works

1. **Build Time**: CMake compiles LuaSocket 3.1.0 with the correct Lua version compatibility
2. **Load Time**: When REPENTOGON loads the mod, `mod.cpp` executes
3. **Injection**: The mod overwrites `package.preload["socket.core"]` with the new implementation
4. **Runtime**: When Lua code calls `require("socket")`, it gets the fixed version

### Technical Details

The fix addresses the core issue where REPENTOGON's existing LuaSocket was built for Lua 5.1, causing crashes when `require("socket")` was called. By injecting a properly compiled version at runtime, the mod ensures LuaSocket functions correctly within REPENTOGON's Lua environment.

## Building the Mod

### Prerequisites

To build this mod, you need:
- A local development environment set up for REPENTOGON with a successful build completed
- CMake 3.1.3 or higher
- Visual Studio with C++ support

Follow the [REPENTOGON build steps](https://github.com/TeamREPENTOGON/REPENTOGON?tab=readme-ov-file#building) to set up your development environment first.

### Compilation Steps

1. **Launch CMake GUI**
2. **Set source and build directories:**
   - "Where is the source code": Navigate to this project's root directory
   - "Where to put the binaries": Choose your preferred build directory
3. **Configure the project:**
   - Click "Configure" at the bottom of the CMake GUI
   - If prompted, select your compiler (must match your Visual Studio version)
   - Set platform to "Win32"
   - Leave other options as default and click "Finish"
4. **Set required configuration variables:**
   - **`REPENTOGON_SRC`**: Set to the root path of your REPENTOGON directory (required)
   - **`MOD_NAME`**: Set to "zhlLuaSocketFix" or your preferred mod name
   - **`ISAAC_DIRECTORY`**: (optional) Path to your Isaac installation directory (where `isaac-ng.exe` is located). If set, the compiled DLL will be automatically copied there.
5. **Generate project files:**
   - Click "Generate" to create the Visual Studio solution file
6. **Build in Visual Studio:**
   - Click "Open Project" to launch Visual Studio
   - Build the project (Debug or Release configuration)
7. **Deploy the mod:**
   - If `ISAAC_DIRECTORY` was set, the DLL is automatically copied to your Isaac folder
   - Otherwise, manually copy the built DLL from the build directory (Debug or Release folder) to your Isaac installation

### Testing

After deployment, start The Binding of Isaac with REPENTOGON enabled. In the Debug Console, test the fix with:
```lua
lua local s = require("socket"); print(s._VERSION);
```