const db = require('../services/db');
const bcrypt = require("bcryptjs");

class User {
    id;
    email;
    businessName;
    forename;
    surname;
    contactNumber;

    constructor(email) {
        this.email = email;
    }

    async getIdFromEmail() {
        const sql = "SELECT id FROM Users WHERE email = ?";
        try {
            const result = await db.query(sql, [this.email]);
            if (result.length > 0) {
                this.id = result[0].id;
                return this.id;
            }
            return false;
        } catch (err) {
            console.error("Error in getIdFromEmail:", err);
            return false;
        }
    }

    async setUserPassword(password) {
        try {
            const pw = await bcrypt.hash(password, 10);
            const sql = "UPDATE Users SET password = ? WHERE id = ?";
            await db.query(sql, [pw, this.id]);
            return true;
        } catch (err) {
            console.error("Error setting user password:", err);
            return false;
        }
    }

    async addUser(password) {
        const pw = await bcrypt.hash(password, 10);
        const sql = "INSERT INTO Users (email, password, businessName, forename, surname, contactNumber) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            const result = await db.query(sql, [
                this.email,
                pw,
                this.businessName || null,
                this.forename || null,
                this.surname || null,
                this.contactNumber || null
            ]);
            this.id = result.insertId;
            return this.id;
        } catch (err) {
            console.error("Error in addUser:", err);
            return false;
        }
    }

    async authenticate(submittedPassword) {
        const sql = "SELECT password FROM Users WHERE id = ?";
        try {
            const result = await db.query(sql, [this.id]);
            if (result.length === 0) return false;
            const match = await bcrypt.compare(submittedPassword, result[0].password);
            return match;
        } catch (err) {
            console.error("Authentication error:", err);
            return false;
        }
    }
}

module.exports = {
    User
};
