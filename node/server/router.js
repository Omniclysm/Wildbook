//
// TODO: Uncomment when you are ready to us the database.
//
//var mongodb = require('mongodb');
//var dbPort = 27017;
//var dbHost = 'localhost';
//var dbName = 'wildbook';
//
//// establish the database connection
//var db = new mongodb.Db(dbName, new mongodb.Server(dbHost, dbPort, {auto_reconnect: true}), {w: 1});
//    db.open(function(ex, db) {
//    if (ex) {
//        console.log(ex);
//    } else {
//        console.log('connected to database [' + dbName + ']');
//    }
//});

module.exports = function(app, config) {
    //
    // Main site
    //
    app.get('/', function(req, res) {
        //
        // i18n available as req.i18n.t or just req.t
        // Also res.locals.t
        //
        var variables = {user: null,
                config: config,
                spotlight: {
                    name: "Frosty",
                    species: "Humpback Whale",
                    id: "Cascadia #12492",
                    place: "Monterey Bay, CA"
                }};
        res.render('home', variables);
    });

    //=================
    // Catch-all
    //=================

    app.get('*', function(req, res) {
        res.render('404', config);
    });
};
