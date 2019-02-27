// Diisi menyesuaikan settingan pgsql masing2
require('dotenv').config();

var pg = require('pg');
let password = process.env.DB_PASSWORD;
let port = process.env.DB_PORT;
let db_name = process.env.DB_NAME;

var conString = "postgres://postgres:" + password + "@localhost:" + port + "/" + db_name + "";

var client = new pg.Client(conString);
client.connect()

module.exports = client;
