local TCP = require('tcp')
local PORT = 22222
local server = TCP.create_server("0.0.0.0", PORT, function (client)
  p("on_connection", client)

  client:on("data", function (chunk)
    p("on_read", chunk)
    client:write(chunk, function (err)
      p("on_written", err)
    end)

  end)
  client:on("end", function ()
    p("on_end")
    client:close(function ()
      p("on_closed")
    end)
  end)
  
end)

server:on("error", function (err)
  p("ERROR", err)
end)

print("terraform server on", PORT )

