const mongoose = require("mongoose");
var requestedorgansSchema = new mongoose.Schema({
    receipientid: {
        type: String,
        required: true,
        trim: true,
        ref: 'User'
    },
    organ: {
        type: String,
        required: true
    },
    hospitalid: {
        type: String,
        required: true,
        trim: true
    },
    requested_status: {
        type: String,
        required: true,
        default: "pending"
    },
})
module.exports = mongoose.model("requested_organs",requestedorgansSchema);