# What?

Conferencing software in a Docker container.

# Why ?

Some conferencing software is available as Debian/Ubuntu package.
But I still don't like it on my computer as is.

Skype is closed source software. Discord brings its own copy of Chromium, and hasn't gone through Debian scrutiny anyway. 
Other packages run scripts as root during install that I do not want to have elevated permissions. Most require dpkg instead of apt anyway.
Funny stuff may be compiled in.

# Why not just...

* run a privileged Docker container?
* disable the sandbox?
* give the Docker container the SYS_ADMIN capability?

Well, my point is to (slightly) enhance security, not to decrease it.

# Is this bullet-proof?

No. The kernel is still exposed to software downloaded from the web, as is some hardware and (part of) the file system.

We're just protecting ourselves from packages that don't clean up after themselves when purged, have kludgy maintainer scripts (those run as root!), and generally bring in stuff you don't want to mix with a well-maintained Debian system.

If you want bullet-proof, run conferencing software under full virtualization, or better yet, on separate hardware.
(A smartphone comes to mind.) While you're at it, do the same with your browser.

# How?

Run the software in Docker, but give it only what it needs.

# No really, how?

_These instructions are not suitable for copy-pasting._
_You have to understand what they mean, and modify them accordingly._

* Identify your hardware (speaker, microphone, camera). Mine is all USB, so I use these commands:

  lsusb
  find /dev -iname \*usb\*

* Modify the Dockerfile to reflect your devices instead of mine.

While you're editing the Dockerfile anyway...
BlueJeans and Slack need further work.
You may want to remove them.
(Skype, Discord and Wire work.)

* Put the Docker file in a directory, cd over there, and build the container:

  docker image build --tag skype .
  
('skype' is the name I use for this container, 'cause that's the first thing I put in it.)

* Start the docker container.

    ./run.sh
	
This starts a new shell that runs inside the container. Notice that it uses the chromium.json.
	
* Start whatever conferencing software you want, e.g.

    nohup discord &
	nohup wire-desktop &
	nohup skypeforlinux &


# Relevant links

* https://discord.com
* https://wire.com
* https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md
* https://ndportmann.com/chrome-in-docker/ (really good)
* https://medium.com/better-programming/running-desktop-apps-in-docker-43a70a5265c4
* https://unix.stackexchange.com/questions/66901/how-to-bind-usb-device-under-a-static-name
