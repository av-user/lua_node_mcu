wifi.setmode(wifi.STATION)
wifi.sta.config({ssid=SSID, pwd=PWD_WIFI})

function is_wifi_connected()
    return wifi.sta.status() == wifi.STA_GOTIP
end

local count = 0

function timer_callback()
    if is_wifi_connected() then
        print(wifi.sta.status())
        print(wifi.sta.getip())
        timer:unregister()
        return sendmail()
    else
		count = count + 1
		if count > WIFI_CONN_TRYCOUNT then
			timer:unregister()
			return error("failed to connect. "..WIFI_CONN_TRYCOUNT.." tries")
		else
			print("...")
		end
    end
end

timer = tmr.create()
if not timer:alarm(1000, tmr.ALARM_AUTO, timer_callback) then
    return error("could not create timer")
end
