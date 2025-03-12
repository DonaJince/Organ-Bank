const mongoose = require("mongoose");
var receipientSchema = new mongoose.Schema({
    receipientid: {
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
module.exports = mongoose.model("Receipient",receipientSchema);