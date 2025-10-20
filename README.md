# Transport Relay Tool for Star Trek Modules

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![GMod](https://img.shields.io/badge/GMod-Compatible-green.svg)
![License](https://img.shields.io/badge/license-Proprietary-orange.svg)

A standalone Garry's Mod addon that adds a Transport Relay toolgun to the Star Trek Modules ecosystem. Mark entities as transport destinations and beam them aboard with style!



## 🌟 Features

- **🎯 Mark Any Entity** - Target props, NPCs, ragdolls, or players as transport relays
- **✏️ Custom Naming** - Name your relays or use automatic numbering
- **👁️ Visual Feedback** - Blue beam indicators show marked entities
- **🔗 Seamless Integration** - Appears in transporter "External Sensors" interface
- **🔄 Smart Auto-Removal** - Relays disappear after successful transport
- **🌐 Multiplayer Ready** - Fully networked and synchronized

## 📋 Requirements

- [Star Trek Modules (Base)](https://github.com/oninoni/startrekmodules) - **Required**
- Star Trek Modules - Transporter - **Required**
- Garry's Mod

## 🎮 Usage

### Marking a Relay

1. Equip the Tool Gun
2. Select **"Transport Relay Tool"** from **ST:RP** category
3. *(Optional)* Enter a custom name in the text field
4. **Left-Click** on any valid entity
5. Entity is now marked with a blue beam indicator

### Using a Relay

1. Open any transporter console
2. Switch to **"External Sensors"** mode
3. Select your relay from the list
4. Transport as normal
5. Relay automatically removes after successful transport!

### Removing a Relay

1. Select the Transport Relay Tool
2. **Right-Click** on a marked entity
3. Relay marker is removed

## 🎨 Visual Indicators

When holding the tool, marked entities display:
- Blue vertical beams extending upward
- Ring indicator at the top
- 3D text label with the relay name
- Only visible to the player using the tool

## 💡 Use Cases

| Scenario | Example |
|----------|---------|
| **Cargo Operations** | Mark supply crates as "Medical Supplies (Relay)" |
| **Equipment Transport** | Tag weapons for beam-up to armory |
| **Emergency Evacuation** | Mark injured NPCs for medical transport |
| **Mission Objectives** | Create RP scenarios with specific items to recover |
| **Resource Management** | Track and transport valuable items across your ship |

## 🔧 Installation

### Steam Workshop (Recommended)

1. Subscribe to this addon on Steam Workshop
2. Subscribe to [Star Trek Modules](https://steamcommunity.com/sharedfiles/filedetails/?id=BASEID)
3. Restart your server
4. Tool automatically appears in the Tool Gun

### Manual Installation

1. Download the latest release
2. Extract to `garrysmod/addons/startrekmodules_transport_relay`
3. Ensure Star Trek Modules is installed
4. Restart server or run `lua_refresh`

## 📁 File Structure

```
startrekmodules_transport_relay/
├── addon.json
├── README.md
└── lua/
    ├── autorun/
    │   └── stm_loader_transport_relay.lua       # Module loader
    ├── star_trek/
    │   └── transport_relay/
    │       └── sh_index.lua                     # Module initialization
    └── weapons/
        └── gmod_tool/
            └── stools/
                └── transport_relay.lua          # Tool implementation
```

## 🎯 Valid Entity Types

| Type | Status |
|------|--------|
| Props (`prop_physics`) | ✅ Supported |
| NPCs (all types) | ✅ Supported |
| Ragdolls (`prop_ragdoll`) | ✅ Supported |
| Players | ✅ Supported |
| Entities with physics | ✅ Supported |
| Map entities/brushes | ❌ Not supported |
| Frozen props | ❌ Not supported |

## 🔌 API Integration

The addon hooks into the Star Trek Modules transporter system:

### Hooks Used

```lua
-- Adds relays to external markers list
hook.Add("Star_Trek.Transporter.AddExternalMarkers", ...)

-- Removes relays after successful transport
hook.Add("Star_Trek.Transporter.EndTransporterCycle", ...)

-- Syncs relay updates to clients
hook.Add("Star_Trek.Transporter.ExternalsChanged", ...)
```

### Storage

Relays are stored in:
- `Star_Trek.Transporter.Relays` - Table of all active relays (indexed by EntIndex)
- `Star_Trek.Transporter.RelayCounter` - Auto-increment counter for unnamed relays

## 🐛 Troubleshooting

<details>
<summary><b>Tool not appearing in toolgun?</b></summary>

1. Verify Star Trek Modules (Base) is installed and working
2. Check server console for Lua errors
3. Ensure file is at `lua/weapons/gmod_tool/stools/transport_relay.lua`
4. Run `lua_refresh` command or restart server
</details>

<details>
<summary><b>Relays not showing in transporter?</b></summary>

1. Ensure the transporter system is functional
2. Check specifically in "External Sensors" mode
3. Verify the entity is still valid (not deleted)
4. Check server console for errors
</details>

<details>
<summary><b>Can't mark an entity?</b></summary>

1. Ensure entity has a valid physics object
2. Check if entity is a map entity (not supported)
3. Verify entity isn't already marked
4. Try a different entity type to isolate the issue
</details>

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for more detailed solutions.

## 📖 Documentation

- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick controls and tips
- **[INSTALLATION.md](INSTALLATION.md)** - Detailed installation guide
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and fixes
- **[WORKSHOP_PUBLISHING_GUIDE.md](WORKSHOP_PUBLISHING_GUIDE.md)** - Workshop publishing instructions

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. ???
3. Profit


## 🎭 Perfect for Roleplay

This tool is designed for serious Star Trek roleplay servers:

- **Away Teams**: Mark artifacts for retrieval
- **Engineering**: Tag damaged components for repair bay
- **Medical**: Mark patients for emergency beam-out
- **Security**: Track contraband for confiscation
- **Science**: Catalog specimens for lab transport



## 📊 Version History

### v1.0.0 (2025-10-20)
- Initial release
- Basic relay marking and removal
- Transporter integration
- Visual feedback system
- Auto-numbering and custom naming
- Automatic cleanup on transport

## 🌟 Credits
- **[https://HouseofPoe.co.uk)** - Aidan Poe made this tool
- **Original Star Trek Modules**: [Jan 'Oninoni' Ziegler](https://github.com/oninoni)
- **Transport Relay Tool**: Created for the Star Trek Modules ecosystem
- **Compatible with**: All Star Trek Modules addons

## 📜 License

This software can be used freely on your server.  
Redistribution outside of usage on a server is not permitted.

**Copyright © 2025 Jan Ziegler**

## 🔗 Links
- **[[https://HouseofPoe.co.uk](https://houseofpoe.co.uk/portfolio.html))** - Portfollio
- **[Star Trek Modules (Base)](https://github.com/oninoni/startrekmodules)** - Required dependency
- **[[Steam Workshop](#)](https://steamcommunity.com/sharedfiles/filedetails/?id=3590538752)** - Subscribe to this addon *(Coming Soon)*
- **[Issue Tracker](../../issues)** - Report bugs or request features
- **[Discussions](../../discussions)** - Ask questions and share ideas




## 🖖 Live Long and Prosper!

Enjoy using the Transport Relay Tool on your Star Trek roleplay server!

---

*If you enjoy this addon, please ⭐ star this repository and share it with others!*
