<h1 align=center>caelestia-dashboard-decoupled</h1>

<div align=center>

A standalone Quickshell app that runs just the caelestia dashboard —
media panel, performance monitor, and weather tab — as its own popup
window, decoupled from [caelestia-shell](https://github.com/caelestia-dots/shell).

</div>

## What this is

This is **not** a fork of caelestia-shell, and it isn't a QML component you
import into an existing config either. It's a self-contained Quickshell
config (`shell.qml`) that opens its own focused popup window containing the
dashboard, so you can run it on top of any other bar/launcher/dotfiles setup
(e.g. [illogical-impulse](https://github.com/end-4/dots-hyprland)) without
pulling in caelestia's bar, launcher, lock screen, or notifications.

Under the hood it still uses the same C++/QML plugin as upstream
caelestia-shell (`Caelestia`, `Caelestia.Config`) for things like config
parsing, sensor readouts, and network stats — this repo trims which QML
*modules* are wired up (only `dashboard` and `drawers`), not the native
plugin that backs them. So it still needs a real build step.

## Credit where it's due

All of the original design and implementation of the dashboard comes from
[caelestia-dots/shell](https://github.com/caelestia-dots/shell), built on
[Quickshell](https://quickshell.outfoxxed.me) by
[@outfoxxed](https://github.com/outfoxxed) and made for
[Hyprland](https://hyprland.org). Go check out the full caelestia dots —
this project only exists because that shell is really well built.

This repo extracts and repackages one piece of it as a standalone runnable
app. If you want the whole shell experience (bar, launcher, lock screen,
notifications, etc.), use caelestia-shell directly instead of this.

## Components

-   Widgets: [`Quickshell`](https://quickshell.outfoxxed.me)
-   Window manager: [`Hyprland`](https://hyprland.org)
-   Origin project: [`caelestia-dots/shell`](https://github.com/caelestia-dots/shell)

## Dependencies

Runtime:

-   [`quickshell-git`](https://quickshell.outfoxxed.me) — must be the git version, same as upstream
-   `qt6-base`, `qt6-declarative`, `qt6-shadertools`
-   [`libqalculate`](https://github.com/Qalculate/libqalculate)
-   [`libpipewire`](https://pipewire.org)
-   [`aubio`](https://github.com/aubio/aubio)
-   [`libcava`](https://github.com/LukashonakV/cava) (or `cava`)
-   [`lm-sensors`](https://github.com/lm-sensors/lm-sensors) — for the performance panel
-   [`networkmanager`](https://networkmanager.dev) — for network stats
-   [`material-symbols`](https://fonts.google.com/icons)
-   [`caskaydia-cove-nerd`](https://www.nerdfonts.com/font-downloads)
-   `glibc`, `gcc-libs`

Build:

-   [`cmake`](https://cmake.org) (≥ 3.19)
-   [`ninja`](https://github.com/ninja-build/ninja)
-   `pkgconf`/`pkg-config`
-   `git` — the build reads `VERSION`/`GIT_REVISION` via `git describe`/`git rev-parse`, so build from a git clone, not an extracted tarball

> [!NOTE]
> The dependency list above mirrors what the plugin's `CMakeLists.txt`
> actually links against (`libqalculate`, `libpipewire-0.3`, `aubio`,
> `libcava`/`cava`, `libsensors`). It's carried over unchanged from
> upstream caelestia-shell — nothing here has been trimmed even though
> only the dashboard module ships. If you find any of these are unused by
> the dashboard specifically, that'd be a good thing to prune upstream in
> this repo.

## Installation

### Manual (CMake)

Clone the repo into your Quickshell config directory — the folder name
becomes the config name you pass to `qs -c`:

```sh
cd $XDG_CONFIG_HOME/quickshell   # usually ~/.config/quickshell
git clone https://github.com/Yashraj221B/caelestia-dashboard-decoupled.git dashboard

cd dashboard
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
sudo cmake --install build
```

This builds and installs the native `Caelestia` QML plugin plus the
`shell`, `extras`, and `m3shapes` modules (`m3shapes` is fetched
automatically from its own repo during configure) — same layout as
upstream caelestia-shell.

> [!TIP]
> To install somewhere other than the system prefix (e.g. for local
> testing without `sudo`), override the install dirs:
>
> ```sh
> mkdir -p ~/.config/quickshell/dashboard-install
> cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ \
>   -DINSTALL_QSCONFDIR=~/.config/quickshell/dashboard-install
> cmake --build build
> cmake --install build --prefix ~/.local
> ```
>
> If you install the native library to a non-default location, set
> `CAELESTIA_LIB_DIR` to that path (defaults to `/usr/lib/caelestia`) before
> launching the shell.

### Nix

> [!WARNING]
> `flake.nix` in this repo references a `./nix` directory (for the package
> derivation and home-manager module) that isn't actually present here —
> it looks like it was carried over from upstream caelestia-shell without
> the corresponding `nix/` folder. `nix run` / `nix build` will currently
> fail. Use the manual CMake install above until that's fixed, or pull the
> `nix/` directory over from [caelestia-dots/shell](https://github.com/caelestia-dots/shell) and adapt it.

## Usage

Run it directly with Quickshell, using the folder name you cloned it as:

```sh
qs -c dashboard
```

(Substitute `dashboard` for whatever you named the directory under
`$XDG_CONFIG_HOME/quickshell`.) This opens a centered popup window with a
close button and title bar wrapping the dashboard — press `Esc` or click
outside it (it grabs focus via Hyprland) to close.

Bind this to a key in your Hyprland config to toggle it on demand, e.g.:

```conf
bind = SUPER, D, exec, qs -c dashboard
```

## Configuring

The dashboard reads its options from `~/.config/caelestia/shell.json`
(respects `$XDG_CONFIG_HOME` if set) — same schema and same file path as
upstream caelestia-shell, just with everything outside the `dashboard`
block ignored:

```json
{
    "dashboard": {
        "enabled": true,
        "showOnHover": true,
        "showDashboard": true,
        "showMedia": true,
        "showPerformance": true,
        "showWeather": true,
        "mediaUpdateInterval": 500,
        "resourceUpdateInterval": 1000,
        "dragThreshold": 50,
        "performance": {
            "showBattery": true,
            "showGpu": true,
            "showCpu": true,
            "showMemory": true,
            "showStorage": true,
            "showNetwork": true
        }
    }
}
```

Any other top-level keys from the original `shell.json` (`bar`, `launcher`,
`lock`, etc.) are not read by this module and can be omitted.

## Updating

```sh
cd $XDG_CONFIG_HOME/quickshell/dashboard
git pull
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
sudo cmake --install build
```

The rebuild/reinstall step is needed because the native plugin can change
between commits — a plain `git pull` isn't enough on its own.

## FAQ

### Why not just use the full caelestia-shell?

Because I wanted the dashboard in a different dotfiles setup that already
has its own bar, launcher, and lock screen — running the whole shell
alongside those would've meant duplicate components fighting for the same
job.

### Will this stay in sync with upstream caelestia-shell?

Not automatically — this is a manual extraction, so dashboard changes
upstream will need to be pulled over by hand. Check
[caelestia-dots/shell](https://github.com/caelestia-dots/shell) for the
latest version of the original.

### Do I really need to build a C++ plugin just for a dashboard widget?

Yes, currently — the QML here still imports the `Caelestia` /
`Caelestia.Config` native plugin for config parsing, sensors, network
stats, and other services, so the full CMake build is required even
though the bar/launcher/lock QML modules were dropped.