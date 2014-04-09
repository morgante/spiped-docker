Recently, I've been getting more concerned in security. As an American living in a Middle Eastern *monarchy*, multiple government agencies are likely monitoring my internet traffic—not to mention that I frequently connect to servers from sketchy internet cafes while traveling in the developing world. To mitigate these risks, I proxy all my traffic through a secure server—but with the recent [heartbleed bug](http://www.vox.com/2014/4/8/5593654/heartbleed-explainer-big-new-web-security-flaw-compromise-privacy), I decided to step my security up a notch.

Now, all traffic is routed through (spiped)[http://www.tarsnap.com/spiped.html], a simple and secure utility. Using Docker, I've automated most of the setup for this system, so you can easily route your traffic securely as well.

# Server Setup
Setting up the server for this is quite simple, assuming you have [Docker](http://docker.io) installed.

1. Clone my Dockerfile, which handles setting up a Socks proxy (with SSH) and the spiped server.
	```git clone https://github.com/morgante/spiped-docker /home/spiped```
2. Enter the spiped directory, where the magic happens:
	```cd /home/spiped```
3. Generate a secure key for the spiped socket to use for communication across the internet.
	```dd if=/dev/urandom bs=32 count=1 of=spiped.key```
4. Build the Docker image (it will automatically load the key you just generated)
	```docker build -t spiped .```
5. Start the spiped server with Docker:
	```docker run -d -p 49168:8089 -t spiped```

You now have a fully functional SOCKS proxy listening on port 49168 and secured using a private key.

# Client Setup
On the client, all you need to do is installed spiped and connect to the server. These instructions are for OS X, but the process should be similar for other operating systems.

1. Install spiped (with [Homebrew](http://brew.sh)).
	```brew install spiped```
2. Copy the private key from your server.
	```scp username@server.name:/home/spiped/spiped.key ~/spiped.key```
3. Start the spiped client:
	```spiped -e -f -s '[0.0.0.0]:8089' -t '[107.170.94.89]:49168' -k ~/spiped.key```
4. In System Preferences, configure your network to connect to a SOCKS proxy at **localhost:8089**.

Now all your internet activity is securely routed through your server. In my experience, this technique is also faster than standard SSH tunnels and handles disconnects more gracefully.

Leave any questions in the comments and I'll do my best to answer.