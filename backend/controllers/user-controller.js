const User = require("../models/user");
const Hospital = require("../models/hospital");


exports.registerUser = (req,res)=>{
console.log(req.body);
    User.findOne({email:req.body.email}).then((user)=>{
        if(user){
            return res.status(400).json({message:"Email already exists"});
        }
        User.findOne({phone:req.body.phone}).then((withphone)=>{
            if(withphone){
                return res.status(400).json({message:"Phone already exists"});
            }
            const newUser =  User(req.body);
            newUser.save().then((newuser)=>{
                if(newuser){
                    if(req.body.usertype=="Hospital"){
                        req.body.userid = newuser._id;
                        let newHospital = Hospital(req.body);
                        newHospital.save().then((hospital)=>{
                            if(hospital){
                                return res.status(200).json({message:"User and Hospital created successfully",newuser,hospital});
                            }
                            else{
                                return res.status(400).json({message:"Failed to create hospital"});
                            }
                        })
                    }
                    else{
                    return res.status(200).json({message:"User created successfully",newuser});
                    }
                }
                else{
                    return res.status(400).json({message:"Failed to create user"});
                }
            })
        })

    })
}

exports.getPendingDonor = (req,res)=>{
    User.find({status:"pending",usertype:"Donor"},{password:0}).then((users)=>{
        if(users){
            return res.status(200).json(users);
        }
        else{
            return res.status(400).json({message:"No pending users"});
        }
    })

}

exports.getPendingReceipient = (req,res)=>{
    User.find({status:"pending",usertype:"Receipient"},{password:0}).then((users)=>{
        if(users){
            return res.status(200).json(users);
        }
        else{
            return res.status(400).json({message:"No pending users"});
        }
    })
}

exports.getPendingHospital = async (req,res)=>{
    console.log(req.body)
    try {
        const hospitals = await Hospital.find().populate({
            path: "userid",
            match: { usertype: "Hospital" }, // Filter users with usertype "Hospital"
            select: "-password" // Exclude the password field
        });

        // Remove entries where userid is null (if no matching user found)
        const filteredHospitals = hospitals.filter(hospital => hospital.userid);

        console.log(filteredHospitals);
        return res.status(200).json(filteredHospitals);
    } catch (error) {
        console.error("Error fetching hospitals:", error);
    }
}

exports.loginUser = (req,res)=>{
 User.findOne({email:req.body.email}).then((user)=>{    
    if(user){
        if(user.password==req.body.password){
            return res.status(200).json({message:"Login successful",user});
        }
        else{
            return res.status(400).json({message:"Invalid password"});
        }
    }
    else{
        return res.status(400).json({message:"Invalid email"});
    }
})
}