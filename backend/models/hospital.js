const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;
var hospitalSchema = new mongoose.Schema({

    userid:{
        type:ObjectId,
        required:true,
        ref:"User"
    },
    otherphno:{
        type:Number,
        required:true,
        unique:true
    },
    location:{
        type:String,
        required:true,
        trim:true
    }
})
module.exports = mongoose.model("Hospital",hospitalSchema);