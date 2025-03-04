const mongoose = require("mongoose");
var complaintSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    complaint: {
        type: String,
        required: true
    }
})
module.exports = mongoose.model("Complaint",complaintSchema);