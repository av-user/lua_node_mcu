print ("smtp enter")
local my_email = "<your_account_name>@gmail.com>"
local smtp_server_name = "smtp.gmail.com"
local smtp_port = "465"
local mail_to = "<your_test_receiving_email>"

local smtp_socket = tls.createConnection()

local current_state
local state_connected
local state_ehlo_sent
local state_auth_plain_sent
local state_credentials_sent
local state_mail_from_sent
local state_rcpt_to_sent
local state_data_sent
local state_mail_sent
local state_rset_sent
local state_quit_sent
local state_error

local function send(text)
    smtp_socket:send(text.."\r\n")
    print("sent: "..text)
end

state_connected = function (response)
    print("state_connected response: "..response.."response end")
    if  string.sub(response,1,3) == "220" then
        print("state_connected OK")
        send("EHLO test")
        current_state = state_ehlo_sent
    else
        print("state_connected ERR")
        current_state = state_error
    end
end

state_ehlo_sent = function (response)
    print("state_ehlo_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "250" then
        print("state_ehlo_sent OK")
        send("AUTH PLAIN")
        current_state = state_auth_plain_sent
    else
        print("state_ehlo_sent ERR")
        current_state = state_error
    end
end

state_auth_plain_sent = function (response)
    print("statestate_auth_plain_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "334" then
        print("state_auth_plain_sent OK 334")
        send("<yourencodedcredentials>")
        current_state = state_credentials_sent
    elseif string.sub(response,1,3) == "250" then
        print("state_auth_plain_sent OK 250")
        send("AUTH PLAIN")
    else
        print("state_auth_plain_sent ERR")
        current_state = state_error
    end
end

state_credentials_sent = function (response)
    print("state_credentials_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "235" then
        print("state_credentials_sent OK")
        send("MAIL FROM:<"..my_email..">")
        current_state = state_mail_from_sent
    else
        print("state_credentials_sent ERR")
        current_state = state_error
    end
end

state_mail_from_sent = function (response)
    print("state_mail_from_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "250" then
        print("state_mail_from_sent OK")
        send("RCPT TO:<"..mail_to..">")
        current_state = state_rcpt_to_sent
    else
        print("state_mail_from_sent ERR")
        current_state = state_error
    end
end

state_rcpt_to_sent = function (response)
    print("state_rcpt_to_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "250" then
        print("state_rcpt_to_sent OK")
        send("DATA")
        current_state = state_data_sent
    else
        print("state_rcpt_to_sent ERR")
        current_state = state_error
    end
end

--dofile ("send_data.lua")

state_data_sent = function (response)
    print("state_data_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "354" then
        print("state_data_sent OK")
        send (".")
        current_state = state_mail_sent
    else
        print("state_data_sent ERR")
        current_state = state_error
    end
end

state_mail_sent = function (response)
    print("state_mail_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "250" then
        print("state_mail_sent OK")
        send("RSET")
        current_state = state_rset_sent
    else
        print("state_mail_sent ERR")
        current_state = state_error
    end
end

state_rset_sent = function (response)
    print("state_rset_sent response: "..response.."response end")
    if  string.sub(response,1,3) == "250" then
        print("state_rset_sent OK")
        send("QUIT")
        current_state = state_quit_sent
    else
        print("state_rset_sent ERR")
        error_string = response
    end
end

state_quit_sent = function (response)
    print("state the end response: "..response.."response end")
    if  string.sub(response,1,3) == "221" then
        print("state_quit_sent OK")
    else
        print("state_quit_sent ERR")
        current_state = state_error
    end
end

state_error = function (response)
    print("state_error response: "..response.."response end")
end

current_state = state_connected
if smtp_socket ~= nil then
    tmr.delay(50000)
    local function connected(sck)
        print("smtp tls connected")
        smtp_socket:send("EHLO test\r\n")
    end
    local function response_hdl(sck,response)
        return current_state (response)
    end
    smtp_socket:on("connection",connected)
    smtp_socket:on("receive", response_hdl)
    smtp_socket:connect(smtp_port, smtp_server_name)
end

print ("smtp exit")
