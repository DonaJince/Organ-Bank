const mongoose = require("mongoose");
var feedbackSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        trim: true
    },
    feedback: {
        type: String,
        required: true
    }
})
module.exports = mongoose.model("Feedback",feedbackSchema);