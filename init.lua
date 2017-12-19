wifi.setmode(wifi.STATION)
wifi.sta.config({ssid="<your_accesspoint_name>", pwd="<your_accesspoint_password>"})

function is_wifi_connected()
    return wifi.sta.status() == wifi.STA_GOTIP
end

function sendmail()
print ("sendmail enter")
    dofile("smtp_tls.lua")
print ("sendmail exit")
end

function timer_callback()
    if is_wifi_connected() then
        print(wifi.sta.status())
        print(wifi.sta.getip())
        timer:unregister()
        return sendmail();
    else
        print("...")
    end
end

timer = tmr.create()
if not timer:alarm(1000, tmr.ALARM_AUTO, timer_callback) then
    print("uuups!")
end

-- wifi.sta.getap(listap)
--function listap(t)
--    for ssid,v in pairs(t) do
--        authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
--        print(ssid,authmode,rssi,bssid,channel)
--    end
--end
