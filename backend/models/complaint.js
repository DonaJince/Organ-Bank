const mongoose = require("mongoose");
var complaintSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        trim: true
    },
    complaint: {
        type: String,
        required: true
    }
})
module.exports = mongoose.model("Complaint",complaintSchema);