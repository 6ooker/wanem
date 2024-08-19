# wanem

Flask front-end for TC based WAN Simulation. Uses TC for packetloss, corruption, etc.
TC should be already included in most Debian environments.
Use the [setup script](#quicklaunch) for convenient first setup.

## Quicklaunch

```bash
git clone https://github.com/6ooker/wanem.git
cd wanem
chmod +x setup.sh
./setup.sh
```

## Setup Script

The setup script will install needed dependencies and provide a ui (whiptail) for you to choose what you want to do.

Provided operations:

- Installing python3 (for first time installation).
- Generating an `auto_start` script file.
- Setting up a cronjob for `auto_start` to run after reboot.

---

### Manual WebGUI Usage

Execute the main.py file and go to [http://localhost:5000](http://localhost:5000):

```shell
sudo python3 main.py

--ip IP               The IP where the server is listening
--port PORT           The port where the server is listening
--dev [DEV [DEV ...]] The interfaces to restrict to
--regex REGEX         A regex to match interfaces
--debug               Run Flask in debug mode
```

The tool will read your interfaces and the current setup every time the site is reloaded
