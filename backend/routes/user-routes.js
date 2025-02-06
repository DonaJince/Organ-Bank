const express = require("express");
var routes = express.Router();
const userController = require("../controllers/user-controller");

routes.post("/register",userController.registerUser);
routes.get("/pendingDonor",userController.getPendingDonor);
routes.get("/pendingReceipient",userController.getPendingReceipient);
routes.get("/pendingHospital",userController.getPendingHospital);
routes.post("/login",userController.loginUser);
module.exports = routes;