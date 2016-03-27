var mysql = require('mysql');
var connection = mysql.createConnection({
    host:process.env.dbhost,
    user:process.env.dbuser,
    password:process.env.dbpassword,
    database:process.env.database
});

connection.connect(function(err) {
    if(!err){
        connection.query('SELECT 1 + 1 AS solution', function(err, rows, fields) {
            if (err) throw err;
            console.log('The solution is: ', rows[0].solution);
            connection.end();
        });
    }else{
        throw err;
    }
});
