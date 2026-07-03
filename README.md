qml-remote
===

Repository for a project aiming at developing an application, allowing to deport the interface of [ossia-score](https://github.com/ossia/score) on a mobile device, and thus to use the software remotely.

The project aims to deport the use of this software on a mobile connected device. The goal is to allow the user to execute his scenario remotely, and to vary the parameters of his show from the stage, thus avoiding numerous trips to his computer.

Tree Structure
===

All files are located in the `src/` directory, which itself is divided into several subdirectories :

- **ControlSurface :** Contains the list of control surfaces and all different type of controls (sliders, buttons, comboboxes...)
- **Icons :** Contains all icons used in the app (button icons...)
- **ObjectSkeletons :** Contains a skeleton slider used in the speed sliders (Speed and Speeds directories)
- **PlayPauseStop :** Contains buttons that allow you to interract with time (play, pause and stop buttons)
- **Skeleton :** Contains the skeleton file of the app. This file instanciate all of the obects displayed on the srceen.
- **Speed :** Contains the speed slider of the main scenario
- **Speeds :** Contains the list of speed sliders of the sub-scenarios
- **Timeline :** Contains the timeline of the main scenario. It is an additional feature compared to ossia score
- **Triggers :** Contains the list of triggers
- **Utility :** Contains some global functions and variables
- **Volume :** Contains the volume of the main scenario. Does not work at the momenbt
- **WebSocket :** Contains the file which etablishes the websocket connection

Getting Started
===

Pre-built applications for every platform are published on the [releases page](https://github.com/ossia/qml-remote/releases). There are two channels:

- **[Continuous](https://github.com/ossia/qml-remote/releases/tag/continuous)** — a rolling build of the latest commit on `main`. It is flagged as a *pre-release*, but it is the actively maintained build and the recommended download for most users.
- **[Tagged releases](https://github.com/ossia/qml-remote/releases/latest)** — stable, versioned snapshots.

Download the artifact for your platform and run it:

| Platform | Artifact | How to run |
| --- | --- | --- |
| **Linux** | `ossia-remote-x86_64.AppImage` | `chmod +x ossia-remote-x86_64.AppImage`, then launch it |
| **Windows** | `ossia-remote-windows-x86_64.exe` | Run it directly |
| **macOS** | `ossia-remote-macos-arm64.tar.gz` (Apple Silicon) or `ossia-remote-macos-x86_64.tar.gz` (Intel) | Extract, then run the `ossia_remote` binary. The build is unsigned, so you may need to allow it under *System Settings → Privacy & Security* |
| **Android** | `ossia-remote.apk` | Install the APK on your device |
| **Web (WebAssembly)** | `ossia-remote-wasm.tar.gz` | Serve over HTTP — see below |

Once running, enter the IP address of the machine hosting [ossia score](https://github.com/ossia/score); the remote connects to it over WebSocket to drive playback and controls.

### Running the WebAssembly build

The Web build must be served over HTTP (opening the `.html` straight from disk will not work):

```bash
mkdir ossia-remote-wasm && tar -xzf ossia-remote-wasm.tar.gz -C ossia-remote-wasm
cd ossia-remote-wasm
python -m http.server 8087
```

Then browse to `http://<ip-address>:8087/ossia_remote.html`.

Building from source
===

The application is a standard CMake + Qt 6 project (Qt ≥ 6.11, with the Quick, Qml and WebSockets modules):

```bash
cmake -S src -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

The releases above are built against ossia's static Qt SDK; see the workflows in `.github/workflows/` for the exact per-platform build and packaging steps.
