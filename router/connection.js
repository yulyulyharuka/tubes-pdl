// Diisi menyesuaikan settingan pgsql masing2
var pg = require('pg')
var conString = "postgres://postgres:ghosina11@localhost:5432/asdf";

var client = new pg.Client(conString);
client.connect()

module.exports = client;
