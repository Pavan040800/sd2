const express = require("express");
const session = require("express-session");
const { User } = require("./models/user");
const db = require('./services/db'); // ✅ Only once
const bcrypt = require("bcryptjs");

// Create express app
const app = express();

// Static files
app.use(express.static("static"));

// Templating
app.set("view engine", "pug");
app.set("views", "./app/views");

// Body parser
app.use(express.urlencoded({ extended: true }));

// Session config
const oneHour = 60 * 60 * 1000;
app.use(session({
  secret: "secretkeysdfjsflyoifasd",
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false,
    maxAge: oneHour
  }
}));

// Routes
app.get("/", (req, res) => {
  if (req.session.uid) {
    res.send("Welcome back, " + req.session.uid + "!");
  } else {
    res.render("login", { loggedIn: req.session.loggedIn });
  }
});

app.get("/home", (req, res) => {
  res.render("home");
});

app.get("/register", (req, res) => {
  res.render("register");
});

app.get("/login", (req, res) => {
  res.render("login", { loggedIn: req.session.loggedIn, currentPage: "login" });
});

// Register or Set Password
app.post("/set-password", async (req, res) => {
  const { email, password, businessName, forename, surname, contactNumber } = req.body;
  const user = new User(email);
  user.businessName = businessName;
  user.forename = forename;
  user.surname = surname;
  user.contactNumber = contactNumber;

  try {
    const uId = await user.getIdFromEmail();
    if (uId) {
      await user.setUserPassword(password);
      res.render("register", { successMessage: "Password updated", loggedIn: req.session.loggedIn });
    } else {
      const newId = await user.addUser(password);
      res.render("register", { successMessage: "Account created", loggedIn: req.session.loggedIn });
    }
  } catch (err) {
    console.error("Error in set-password:", err.message);
    res.render("register", { errorMessage: "An error occurred", loggedIn: req.session.loggedIn });
  }
});

// Login authentication
app.post("/authenticate", async (req, res) => {
  const { email, password } = req.body;
  const user = new User(email);

  try {
    const uId = await user.getIdFromEmail();
    if (uId) {
      const match = await user.authenticate(password);
      if (match) {
        req.session.uid = uId;
        req.session.loggedIn = true;
        res.redirect("/dashboard");
      } else {
        res.render("login", { errorMessage: "Invalid password" });
      }
    } else {
      res.render("login", { errorMessage: "Email not found" });
    }
  } catch (err) {
    console.error("Authentication error:", err.message);
    res.render("login", { errorMessage: "Login failed" });
  }
});

// Logout
app.get("/logout", (req, res) => {
  req.session.destroy(() => {
    res.redirect("/login");
  });
});

// Dashboard with optional search and status filters
app.get("/dashboard", async (req, res) => {
  const { search, status } = req.query;
  let sql = "SELECT * FROM FoodItems WHERE 1";
  const params = [];

  if (search) {
    sql += " AND (name LIKE ? OR restaurant_id IN (SELECT restaurant_id FROM Restaurants WHERE name LIKE ?))";
    params.push(`%${search}%`, `%${search}%`);
  }

  if (status) {
    sql += " AND status = ?";
    params.push(status);
  }

  try {
    const results = await db.query(sql, params);
    res.render("dashboard", { foodItems: results });
  } catch (err) {
    console.error("Error fetching dashboard data:", err.message);
    res.status(500).send("Error loading dashboard.");
  }
});

// Food Item Details Page
app.get("/food/:id", async (req, res) => {
  const foodItemId = req.params.id;
  try {
    const results = await db.query("SELECT * FROM FoodItems WHERE item_id = ?", [foodItemId]);
    if (results.length) {
      res.render("details", { foodItem: results[0] });
    } else {
      res.status(404).send("Food item not found.");
    }
  } catch (err) {
    console.error("Error fetching food item:", err.message);
    res.status(500).send("Error loading item details.");
  }
});

// Misc Routes
app.get("/hello/:name", (req, res) => {
  res.send("Hello " + req.params.name);
});

app.get("/goodbye", (req, res) => {
  res.send("Goodbye world!");
});

// Render “New Food Item” form
app.get("/food_create", async (req, res) => {
  try {
    const restaurants = await db.query(
      "SELECT restaurant_id, name FROM Restaurants"
    );
    res.render("food-form", { foodItem: {}, restaurants });
  } catch (err) {
    console.error("Error loading form:", err);
    res.status(500).send("Error loading food item form.");
  }
});

// Handle creation
app.post("/food_create", async (req, res) => {
  const { restaurant_id, name, description, quantity, expiry_date } = req.body;
  try {
    await db.query(
      `INSERT INTO FoodItems
         (restaurant_id, name, description, quantity, expiry_date)
       VALUES (?, ?, ?, ?, ?)`,
      [restaurant_id, name, description, quantity, expiry_date]
    );
    res.redirect("/dashboard");
  } catch (err) {
    console.error("Error creating food item:", err.message);
    res.status(500).send("Failed to create food item.");
  }
});

// Render “Edit Food Item” form
app.get("/food/edit/:id", async (req, res) => {
  try {
    const [item] = await db.query(
      "SELECT * FROM FoodItems WHERE item_id = ?",
      [req.params.id]
    );
    if (!item) return res.status(404).send("Item not found.");

    const restaurants = await db.query(
      "SELECT restaurant_id, name FROM Restaurants"
    );
    res.render("food-form", { foodItem: item, restaurants });
  } catch (err) {
    console.error("Error fetching for edit:", err);
    res.status(500).send("Error loading edit form.");
  }
});

// Handle update
app.post("/food/edit/:id", async (req, res) => {
  const { restaurant_id, name, description, quantity, expiry_date } = req.body;
  try {
    await db.query(
      `UPDATE FoodItems
         SET restaurant_id=?, name=?, description=?,
             quantity=?, expiry_date=?
       WHERE item_id=?`,
      [
        restaurant_id, name, description,
        quantity, expiry_date, req.params.id
      ]
    );
    res.redirect("/dashboard");
  } catch (err) {
    console.error("Error updating food item:", err.message);
    res.status(500).send("Failed to update food item.");
  }
});

// Handle deletion
app.get("/food/delete/:id", async (req, res) => {
  try {
    await db.query(
      "DELETE FROM FoodItems WHERE item_id = ?",
      [req.params.id]
    );
    res.redirect("/dashboard");
  } catch (err) {
    console.error("Error deleting food item:", err.message);
    res.status(500).send("Failed to delete food item.");
  }
});

// Start server
app.listen(3000, () => {
  console.log("Server running at http://127.0.0.1:3000/");
});
