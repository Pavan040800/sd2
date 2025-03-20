// Import express.js
const express = require("express");

// Create express app
var app = express();

// Add static files location
app.use(express.static("static"));
// Use the Pug templating engine
app.set('view engine', 'pug');
app.set('views', './app/views');

// Get the functions in the db.js file to use
const db = require('./services/db');


// // Create a route for root - /
app.get("/", function(req, res) {
    res.render("home");
});


// Route to render dashboard with food items
app.get("/dashboard", function(req, res) {
    const sql = 'SELECT * FROM FoodItems';  
    db.query(sql).then(results => {
        res.render('dashboard', { foodItems: results });
    }).catch(error => {
        console.error('Error fetching food items:', error);
        res.status(500).send('Error fetching food items.');
    });
});

// Create a route for /goodbye
// Responds to a 'GET' request
app.get("/goodbye", function(req, res) {
    res.send("Goodbye world!");
});

// Create a dynamic route for /hello/<name>, where name is any value provided by user
// At the end of the URL
// Responds to a 'GET' request
app.get("/hello/:name", function(req, res) {
    // req.params contains any parameters in the request
    // We can examine it in the console for debugging purposes
    console.log(req.params);
    //  Retrieve the 'name' parameter and use it in a dynamically generated page
    res.send("Hello " + req.params.name);
});

// Start server on port 3000
app.listen(3000,function(){
    console.log(`Server running at http://127.0.0.1:3000/`);
});