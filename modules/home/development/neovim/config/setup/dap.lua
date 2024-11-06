local dap = require('dap')

dap.configurations.c = {
  {
    type = "c",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 8000,
  },
}
