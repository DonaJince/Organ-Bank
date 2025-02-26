const mongoose = require("mongoose");
var matchedorganSchema = new mongoose.Schema({
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
        default:"pending"
    }
})
module.exports = mongoose.model("MatchedOrgans",matchedorganSchema);