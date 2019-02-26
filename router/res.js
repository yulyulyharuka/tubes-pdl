'use strict';

exports.ok = function(values, res) {
  var data = {
      'status': 200,
      'values': values
  };
  res.json(data);
  res.end();
};

exports.err = function(values, res) {
  var data = {
    'status' : 400,
    'error' : values
  };
  res.json(data);
  res.end();
};