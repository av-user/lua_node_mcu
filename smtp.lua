require "queue"

print ("smtp enter")

local smtp_tls_socket = tls.createConnection()

local sending = false
local outq = queue.new()

local function send(text)
	if sending then
		print ("socket is busy. add to out queue")
		queue.add_tail(outq, text)
	else
		smtp_tls_socket:send(text.."\r\n")
		print("sent: "..text)
		sending = true
	end
end

local function sent_hdl(sck)
	print ("sent_hdl enter")
	sending = false
	if queue.size(outq) > 0 then
		print ("sent_hdl size: "..queue.size(outq))
		return send(queue.get_head(outq))
	end
	print ("sent_hdl exit")
end

local state = "connected"

local function response_hdl(sck,response)
	print("state: "..state.."; response: "..response)
	if state == "connected" then
		if  string.sub(response,1,3) == "220" then
			print("state_connected OK")
			send("EHLO test")
			state = "ehlo_sent"
		else
			print("state_connected ERR")
			state = "error"
		end
	elseif state == "ehlo_sent" then
		if  string.sub(response,1,3) == "250" then
			print("state_ehlo_sent OK")
			send("AUTH PLAIN")
			state = "auth_plain_sent"
		else
			print("state_ehlo_sent ERR")
			state = "error"
		end
	elseif state == "auth_plain_sent" then
		if  string.sub(response,1,3) == "334" then
			print("state_auth_plain_sent OK 334")
			send(MY_CREDENTIALS)
			state = "credentials_sent"
		elseif string.sub(response,1,3) == "250" then
			print("state_auth_plain_sent OK 250")
			send("AUTH PLAIN")
		else
			print("state_auth_plain_sent ERR")
			state = "error"
		end
	elseif state == "credentials_sent" then
		if  string.sub(response,1,3) == "235" then
			print("state_credentials_sent OK")
			send("MAIL FROM:<"..MY_EMAIL..">")
			state = "mail_from_sent"
		else
			print("state_credentials_sent ERR")
			state = "error"
		end
	elseif state == "mail_from_sent" then
		if  string.sub(response,1,3) == "250" then
			print("state_mail_from_sent OK")
			send("RCPT TO:<"..MAIL_TO..">")
			state = "rcpt_to_sent"
		else
			print("state_mail_from_sent ERR")
			state = "error"
		end
	elseif state == "rcpt_to_sent" then
		if  string.sub(response,1,3) == "250" then
			print("state_rcpt_to_sent OK")
			send("DATA")
			state = "data_sent"
		else
			print("state_rcpt_to_sent ERR")
			state = "error"
		end
	elseif state == "data_sent" then
		if  string.sub(response,1,3) == "354" then
			print("state_data_sent OK")
	        send("From: test gmail <"..MY_EMAIL..">")
			send("To: "..MAIL_TO)
			send("Subject: "..SUBJECT)
			send("")
			if file.open('message_body') then 
				send(file.read())
				file.close()
			end
			send(".")
			state = "mail_sent"
		else
			print("state_data_sent ERR")
			state = "error"
		end
	elseif state == "mail_sent" then
		if  string.sub(response,1,3) == "250" then
			print("state_mail_sent OK")
			send("RSET")
			state = "rset_sent"
		else
			print("state_mail_sent ERR")
			state = "error"
		end
	elseif state == "rset_sent" then
		if  string.sub(response,1,3) == "250" then
			print("state_rset_sent OK")
			send("QUIT")
			state = "quit_sent"
		else
			print("state_rset_sent ERR")
			error_string = response
		end
	elseif state == "quit_sent" then
		if  string.sub(response,1,3) == "221" then
			print("state_quit_sent OK")
		else
			print("state_quit_sent ERR")
			state = "error"
		end
	end
end

local function connected(sck)
    print("smtp tls connected")
    smtp_tls_socket:send("EHLO test\r\n")
end

current_state = state_connected
if smtp_tls_socket ~= nil then
	smtp_tls_socket:on("sent", sent_hdl)
    smtp_tls_socket:on("connection",connected)
    smtp_tls_socket:on("receive", response_hdl)
    smtp_tls_socket:connect(SMTP_PORT, SMTP_SERVERNAME)
end

print ("smtp exit")
