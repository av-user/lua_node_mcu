require "global"

function sendmail() --will be called from 'wifi.lua' after successful wi-fi connect
	print("wi-fi connected mail can be sent")
    dofile("smtp.lua")
end

function error(text)
    print(text)
end

dofile("wifi.lua")
