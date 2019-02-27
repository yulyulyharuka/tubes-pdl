// Diisi menyesuaikan settingan pgsql masing2
var pg = require('pg')
var conString = "postgres://postgres:password@localhost:5432/tubes";

var client = new pg.Client(conString);
client.connect()

module.exports = client;