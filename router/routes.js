'use strict';

module.exports = function(app) {
    var task = require('./controller');

    app.route('/')
        .get(task.index);
    
    app.route('/intro')
        .get(task.intro);

    app.route('/data')
        .get(task.data);

    app.route('/result')
        .get(task.result);
};