const mongoose = require("mongoose");
var donorSchema = new mongoose.Schema({
    donorid: {
        type: String,
        required: true,
        trim: true,
        ref: 'User'
    },
    bloodtype: {
        type: String,
        required: true
    },
})
module.exports = mongoose.model("Donor",donorSchema);