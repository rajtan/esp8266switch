start_init = function()

sw_label={};
sw_label[1] = "SW-1";
sw_label[2] = "SW-2";
sw_label[3] = "SW-3";
sw_label[4] = "SW-4";

gpio_st={};
for i=1,4,1 do
  gpio.mode(i,gpio.OUTPUT);
  gpio.write(i,gpio.HIGH);
end

end
-- 
sendFileContents = function(conn, filename) 
    if file.open(filename, "r") then 
        repeat  
        local line=file.readline()  
        if line then  
            conn:send(line); 
        end  
        until not line  
        file.close(); 
    else 
        conn:send(responseHeader("404 Not Found","text/html")); 
        conn:send("Page not found"); 
    end 
end 
 
--
responseHeader = function(code, type) 
    return "HTTP/1.1 "..code.."\r\n Content-Type: "..type.."\r\n\r\n";  
end 
--
httpserver = function () 
start_init(); 
srv=net.createServer(net.TCP)  
    srv:listen(80,function(conn)  
      conn:on("receive",function(conn,request)
        conn:send("HTTP/1.1 200 OK\n");
        conn:send("Cache-Control: no-cache, no-store, must-revalidate\n");
	conn:send("Content-type: text/html\n\n");
        for i=1,4,1 do
          gpio_st[i]=gpio.read(i);
        end
	i=string.match(request,"gpio=([1-4])");
	if (i) then
	    if (gpio.read(i)==0) then
		gpio_st[i]=1;
		gpio.write(i,gpio.HIGH);
	    else
		gpio_st[i]=0;
		gpio.write(i,gpio.LOW);
	    end
	else
          sendFileContents(conn,"header.htm");
	  for i=1,4,1 do
	    if (gpio_st[i]==0) then
	        chk="checked=\"checked\"";
	    else
	        chk="";
	    end
	    idname="checkbox"..i;
	    f1="loadXMLDoc("..i..")";
            conn:send("<div><input type=\"checkbox\" id=\"");
	    conn:send(idname);
	    conn:send("\" name=\""..idname.."\" ");
            conn:send("class=\"switch\" onclick=\"loadXMLDoc(");
	    conn:send(i);
	    conn:send(")\" ");
	    conn:send(chk.." />"); 
	    conn:send("<label for=\"checkbox"..i.."\">");
	    conn:send(sw_label[i]);
	    conn:send("</label></div>");
	  end
	  conn:send("</div>"); 
        end 
--        print(request); 
      end)  
      conn:on("sent",function(conn)  
        conn:close();  
        conn = nil;     
      end) 
    end) 
end
httpserver()
