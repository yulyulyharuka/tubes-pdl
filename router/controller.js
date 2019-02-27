'use strict';

var response = require('./res');
var connection = require('./connection');

exports.data = function(req, res) {
    connection.query('SELECT * from employees', function (err, rows, fields) {
        if (err) {
            console.log(err);
        } else {
            console.log(rows);
            response.ok(rows, res);
        }
    });
};

exports.index = function(req, res) {
    res.render('index');
};

exports.intro = function(req, res) {
    res.render('intro');
};

exports.result = function(req, res) {
    res.render('result');
}
