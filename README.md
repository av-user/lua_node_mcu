# lua_node_mcu
sending email using smtp.gmail.com

There is a code example circulating in the web, where a timer is started, and every 5 seconds the next part of communication protocol is being sent, does not matter if the server has received, accepted and respond it, or not.
Here I try to make it differently, and send the next part only when (and if) the previous responded with ACK.
In 'init.lua' we try to connect to our access point (do not forget to substitute <your_accesspoint_name> & <your_accesspoint_password> with the real values), and when (and if) the connection is established, proceed with code in 'smtp_tls.lua' (Do not forget to substitute <your_account_name>@gmail.com>, <your_test_receiving_email> and <yourencodedcredentials> with your real values as well), trying to send an email.
This code is working for me, but I can send only an empty email (no data after smtp "DATA" command, only "end of data" ("\r\n.\r\n"). If I try to send some data, the host does not respond. I could not solve this issue. Maybe I am wrong, but I guess, that my "\r\n.\r\n" is not encripted properly with nodemcu firmware. This is the only thing I can suppose at the moment. I am about to try it with some other smtp server, and will report the result here. Don't know how soon I will be...
