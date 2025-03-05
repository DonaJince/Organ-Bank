const mongoose = require("mongoose");
var donatedorgansSchema = new mongoose.Schema({
    donorid: {
        type: String,
        required: true,
        trim: true,
        ref: 'User'
    },
    organ: {
        type: String,
        required: true
    },
    availability_status: {
        type: String,
        required: true,
        default: "available"
    },
    donation_status: {
        type: String,
        required: true,
        default: "pending"
    },

    createdAt: {
        type: Date,
        default: Date.now
    }
})
module.exports = mongoose.model("donated_organs",donatedorgansSchema);