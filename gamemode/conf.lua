local conf = {
    autoSaveTime = 30,
    player = {
        maxLevel = 80,
        growthFactor = 1
    },
    playerDB = {
        host = "localhost",
        user = "basewars",
        pass = "password",
        port = "3306", 
        sock = "/run/mysqld/mysqld.sock"
    }
}

return conf