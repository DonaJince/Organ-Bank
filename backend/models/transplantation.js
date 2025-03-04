const mongoose = require("mongoose");
var transplantationSchema = new mongoose.Schema({

    matchid:{
        type:String,
        required:true,
        maxlength:32,
        trim:true
    },
    donorid:{
        type:String,
        required:true,
        maxlength:32,
        trim:true
    },
    receipientid:{
        type:String,
        required:true,
        maxlength:32,
        trim:true
    },
    hospitalid:{
        type:String,
        required:true,
        maxlength:32,
        trim:true        
    },
    organ:{
        type:String,
        required:true,
        maxlength:32,
        trim:true  
    },
    status:{
        type:String,
        required:true,
        maxlength:32,
        trim:true,  
        default:"success"
    },
    createdAt:{
        type:Date,
        default:Date.now
    }
})
module.exports = mongoose.model("Transplantation",transplantationSchema);