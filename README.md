# lua_node_mcu
sending email using smtp.gmail.com

There is a code example circulating in the web, where a timer is started, and every 5 seconds the next part of communication protocol is being sent, does not matter if the server has received, accepted and respond it, or not.
Here I try to make it differently, and send the next part only when (and if) the previous responded with ACK.
In 'init.lua' we try to connect to our access point (do not forget to substitute <your_accesspoint_name> & <your_accesspoint_password> with the real values), and when (and if) the connection is established, proceed with code in 'smtp_tls.lua' (Do not forget to substitute <your_account_name>@gmail.com>, <your_test_receiving_email> and <yourencodedcredentials> with your real values as well), trying to send an email.
This code is working for me, but I can currently send only all email data in one string. I have previously thought, the socket works as any conventional socket, but here we should not call the next "socket:send()" before the socket finish the previosly sent data. I'll try to enhance the code next days. Many thanks to user pjsg, who has kindly explained my issue.
