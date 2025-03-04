const mongoose = require("mongoose");
var matchedorganSchema = new mongoose.Schema({

    donorid:{
       type: mongoose.Schema.Types.ObjectId,
               ref: "User",
               required: true
    },
    receipientid:{
        type: mongoose.Schema.Types.ObjectId,
                ref: "User",
                required: true
    },
    hospitalid:{
        type: mongoose.Schema.Types.ObjectId,
                ref: "User",
                required: true     
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