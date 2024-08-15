# wanem

## Requirements

- `netem` tools & `python3-flask` are required
  - Ubuntu 18.04 : Install with `sudo apt install iproute2 python3-flask`
  - Ubuntu 20.04 : Install with `sudo apt install iproute2 python3-flask`
  - Ubuntu 22.04 : Install with `sudo apt install iproute2 python3-flask`
- More information:
  - [network_emulation_loss](https://calomel.org/network_loss_emulation.html)
  - [netem](https://wiki.linuxfoundation.org/networking/netem)

## Usage

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

### Management Script

Create a start script named `start_tcgui.sh` in /home.
```bash
#! /bin/bash

sudo screen -d -m -S "tcgui"

com="python3 <path-to-main.py> --ip x.x.x.x --port 80 --regex <regex>"

sudo screen -S "tcgui" -X screen $com

exit 0
```

Add `wanem   ALL=(ALL) NOPASSWD: /home/wanem/start_tcgui.sh` to sudoers file via `sudo visudo` (under root).
