'use strict';

var response = require('./res');
var connection = require('./connection');

exports.data = function(req, res) {
    connection.query('SELECT * from employees', function (err, results, fields) {
        if (err) {
            response.err(err, res);
        } else {
            response.ok(results.rows, res);
        }
    });
};

exports.index = function(req, res) {
    res.render('intro');
};

exports.query = function(req, res) {
    connection.query(req.body.query, function (err, results, fields) {
        if (err) {
            response.err(err, res);
        } else {
            console.log(results.rows);
            response.ok(results.rows, res);
        }
    });
}

exports.intro = function(req, res) {
    res.render('intro');
};

exports.result = function(req, res) {
    res.render('result');
}

exports.creator = function(req, res) {
    res.render('creator');
}