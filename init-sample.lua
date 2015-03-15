wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')')
print('MAC: ',wifi.sta.getmac())
print('chip: ',node.chipid())
print('heap: ',node.heap())
-- wifi config start
wifi.sta.config("<YOUR SSID HERE>","<YOUR PASSWORD HERE>")
-- wifi config end
cfg={};
cfg.ip="192.168.XXX.YYY";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.XXX.ZZZ";
wifi.sta.setip(cfg);
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)
dofile("c.lc")