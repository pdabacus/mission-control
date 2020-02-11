# Mission Control
consists of 3 subprojects: *Stand Emulator*, *Database*, and *UI*

---

## Stand Emulator
 * emulate data coming from sensors and deliver that data to the Database
 * accept commands from the UI

## Database
 * store all data coming in from the Stand Emulator
 * provide methods of accessing and filtering the data to the UI

## UI
 * visualize the data from the database using [openmct](https://nasa.github.io/openmct/)
 * provide commands to control the Stand Emulator

---

## Setup
 * install docker and enable the service `sudo pacman -S docker` `sudo systemctl enable docker`
 * add local user to the docker group `sudo usermod -a -G docker $USER`
 * reboot your system
 * start local registry to work offline `docker run -d -p 5000:5000 --restart=always --name registry registry:2`
