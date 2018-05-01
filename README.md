# Introduction

This container (later on called 'gateway') provides a RDP, VNC and SSH server and a XPRA for display mirroring purposes -- nothing more.
The actual X11 application is hosted by another container.
Both containers are connected via an optional XPRA display mirroring.
This container can be invoked beforehand/afterwards the X11 application container. There is no real tie between both.
Following use cases exists for splitting the gateway and the application into two containers:
- During a silent installation (based on a X11 installer), the gateway can optionally launched in case of errors to track down errors.
- Errors of other headleas X11-based applications can optionally be tracked down.
- The footprint of X11 applications is smaller.
- The always recurring installation steps of VNC, X11, SSH server are isoloted into a single container (Modularized software installations are by the way one of the main concepts of containers).
- Inside the X11 application container, you can focus on the X11 application.
- Inside the gateway container, you can focus on the configuration and hardening of the VNC, RDP and SSH server.
- If there are improvements or further hardenings of the gateways software, only this image has to be replaced but not the X11 application containers.

# Download image
```docker pull cubeearth/remote-desktop```

# Parameters
You should provide the environment variable ```PASSWORD``` for the container execution in order to set the password of the user ```desktop``` to a proper password!

# Example usage
## Startup
```
curl -O docker-compose-headless-desktop.yml https://raw.githubusercontent.com/Cube-Earth/container-headless-desktop/master/docker-compose.yml
curl -O docker-compose-remote-desktop.yml https://raw.githubusercontent.com/Cube-Earth/container-remote-desktop/master/docker-compose.yml

docker-compose -f docker-compose-headless-desktop.yml up -d
docker-compose -f docker-compose-remote-desktop.yml up -d
```

## Access via VNC
The VNC access is protected by SSH and is only possible via a SSH tunnel.
```
ssh -L 5900:localhost:5900 desktop@localhost -p 2222
```
After establishing the SSH tunnel, you can use VNC with the default port to access the desktop.
Use password "x" as VNC password.

## Access via RDP
Access the desktop via RDP and use the user ```desktop``` and the default password ```changeme``` (if not changed by the environment variable ```PASSWORD```).

# General hints
While the VNC/RDP desktop is initialized, existing XPRA displays are searched and automatically displayed inside the desktop.
If the X11 application container is launched after the gateway container has been launched, there is a menu item "Attach displays" inside the context menu (right click somewhere on the desktop).
    
# References
- [This image on Docker hub](https://hub.docker.com/r/cubeearth/remote-desktop/)
- [Container providing basic X11 libraries and XPRA mirror for hosting X11 applications](https://github.com/Cube-Earth/container-headless-desktop)
