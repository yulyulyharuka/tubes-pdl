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
            console.log(err);
            res.render('result', { check: 1, err: err, query : req.body.query });
        } else {
            console.log(results)
            let newresult = {};
            newresult['command'] = results.command;
            newresult['rows'] = results.rows;
            newresult['fields'] = results.fields;
            newresult['rowCount'] = results.rowCount;

            let message = "Query success. " + results.rowCount + " rows affected";

            res.render('result', { check:1, results: newresult, message : message, err : err, query : req.body.query});
        }
    });
}

exports.intro = function(req, res) {
    res.render('intro');
};

exports.result = function(req, res) {
    res.render('result', {query : "select * from employees_data"});
}

exports.creator = function(req, res) {
    res.render('creator');
}
