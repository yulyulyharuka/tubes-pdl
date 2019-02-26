'use strict';

var response = require('./res');
var connection = require('./connection');

exports.intro = function(req, res) {
    res.render('intro')
};

exports.index = function(req, res) {
    res.render('intro');
};