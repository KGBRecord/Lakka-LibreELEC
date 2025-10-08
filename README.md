# Lakka - The DIY retro emulation console

Lakka is a lightweight Linux distribution that transforms a small computer into a full blown emulation console.

## Why use Lakka?

* **Powerful** - Built on top of the famous RetroArch emulator, Lakka is able to emulate a large range of hardware and has some useful features such as Braid-like rewinding, joypad hotplug and video streaming.
* **User friendly** - Lakka is easy to setup and use. Once installed to your SD card, you just have to put your rom on the card, plug your joypad and enjoy your favorite old games. We also support PS3 and XBox360 controllers so you don't have to buy new ones. 
* **Low cost** - We try our best to keep the hardware required to run Lakka as cheap as possible. The software is optimized to run fast even on low end computers. The power can be supplied by any micro USB adapter like the one for your smartphone.
* **Open source** - Our code is free as in freedom and hosted on Github (though the project uses emulators that forbid commercialisation). We accept external contributions, and we do our best to integrate our own patches into upstream projects.
* **Java Support** - This fork includes Eclipse Temurin OpenJDK 8u422-b05 for extended development capabilities and Java-based applications support.

## Java Development Support

This Lakka fork includes built-in Java development environment with Eclipse Temurin OpenJDK 8u422-b05.

### Features:
- **Eclipse Temurin OpenJDK 8u422-b05** (includes JRE + development tools)
- **Cross-platform support** (x86_64, aarch64, arm)
- **BusyBox compatible** - designed for LibreELEC/Lakka environment
- **Automatic configuration** - Java available immediately after boot

### Usage:
After building and installing this Lakka version, Java is automatically available:

```sh
java -version                    # Check Java availability
javac MyProgram.java            # Compile Java programs
java MyProgram                  # Run Java programs
java -jar your-application.jar  # Run JAR files
```

### Environment:
Java environment is automatically configured with:
- **JAVA_HOME**: `/usr/lib/jvm/java-8-openjdk`
- **PATH**: Includes Java binaries
- **Compatibility**: Works with BusyBox ash shell
- **Persistence**: Configuration survives reboots

## Development Status & Known Issues

**⚠️ Work in Progress**: This fork is currently under active development with the following objectives:

### Current Goals:
- ✅ **Java Support**: Adding Eclipse Temurin OpenJDK 8u422-b05
- 🔄 **FreeJ2ME-Plus Integration**: Working on built-in FreeJ2ME-Plus emulator
- 🔍 **Build System Optimization**: Resolving compilation and dependency issues

### Known Issues:
- **DNS/Network Restrictions**: Build process encounters frequent failures due to regional DNS blocking of source repositories
  - Multiple build hosts are inaccessible from certain geographic regions
  - Source downloads timeout or fail completely
  - Mirror repositories may be blocked or unreachable
  - **Impact**: Significantly slows development and testing cycles

### Potential Solutions Being Investigated:
- [ ] Local mirror setup for frequently accessed repositories
- [ ] VPN/proxy solutions for build environment
- [ ] Alternative source repositories and mirrors
- [ ] Offline build cache implementation
- [ ] Docker-based build environment with pre-cached dependencies

### For Developers:
If you're experiencing similar DNS/network issues during build:
1. Consider using a VPN service during build process
2. Set up local mirrors for critical dependencies
3. Use Docker with pre-cached layers when possible
4. Contact maintainer for alternative download sources

**Note**: This is a personal fork focusing on Java and J2ME emulation capabilities. Stability and compatibility testing is ongoing.

## Installation instructions

Please refer to our website https://www.lakka.tv/get on how to setup Lakka.

## Support

* [FAQ](https://github.com/libretro/Lakka-LibreELEC/wiki/FAQ)
* #lakkatv on irc.libera.chat
* [Discord](https://discord.gg/BNFR4hM)
* [Forums](https://forums.libretro.com/c/libretro/lakka-tv-general)
