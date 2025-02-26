require("dotenv").config();
const mongoose = require("mongoose");
const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const cors = require("cors");
const userRoutes = require("./routes/user-routes");

//DB Connection 
mongoose
    .connect(process.env.DATABASE)
    .then(() => {
        console.log("DB CONNECTED");
    })
    .catch((error) => {
        console.error("DB connection error:", error);
    });

//Middlewares 
app.use(bodyParser.json());
app.use(cookieParser());
app.use(cors());
app.use("/api", userRoutes);

const port = process.env.PORT || 8000;

//Starting a server 
app.listen(port, () => {
    console.log(`app is running at ${port}`);
});
