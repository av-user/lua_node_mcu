# lua_node_mcu
sending email using smtp.gmail.com

There is a code example circulating in the web, where a timer is started, and every 5 seconds the next part of communication protocol is being sent, does not matter if the server has received, accepted and respond it, or not.
Here is an attemt to make it differently, and send the next part only when (and if) the previous responded with ACK.
All user-specific data placed in the file 'global.lua'
In 'init.lua' we try to connect to our access point, and when (and if) the connection is established, proceed with code in 'smtp_tls.lua', trying to send an email.
  This code is working for me as is, but I can imagine that it does not work properly in some other environment. Feel free make all changes you want, remove all unnecessary 'print(...)' statements, ...
