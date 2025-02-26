const User = require("../models/user");
const Hospital = require("../models/hospital");
const Feedback = require("../models/feedback");
const Complaint = require("../models/complaint");
const Donation = require("../models/donated_organs");
const Request = require("../models/requested_organs");
const MatchedOrgans = require("../models/matched_organs");
const nodemailer = require("nodemailer");

exports.sendRegistrationApprovalEmail = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ message: "Email is required" });
        }

        // Configure Nodemailer
        let transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "organbank2025@gmail.com", // Replace with your Gmail
                pass: "vhsb vvss vlyz fooj"  // Use an App Password instead of your actual password
            }
        });

        // Email Content
        let mailOptions = {
            from: "organbank2025@gmail.com",
            to: email,
            subject: "Registration Approval Notification",
            text: "Congratulations! Your registration has been approved. Thank you for your contribution."
        };

        // Send Email
        await transporter.sendMail(mailOptions);

        res.status(200).json({ message: "Approval email sent successfully" });

    } catch (error) {
        console.error("Error sending approval email:", error);
        res.status(500).json({ message: "Failed to send approval email", error });
    }
};

exports,this.sendRegistrationRejectionEmail = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ message: "Email is required" });
        }

        // Configure Nodemailer
        let transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "organbank2025@gmail.com", // Replace with your Gmail
                pass: "vhsb vvss vlyz fooj"  // Use an App Password instead of your actual password
            }
        });

        // Email Content
        let mailOptions = {
            from: "organbank2025@gmail.com",
            to: email,
            subject: "Registration Rejection Notification",
            text: "Sorry! Your registration has been rejected. Thank you for your contribution."
        };

        // Send Email
        await transporter.sendMail(mailOptions);

        res.status(200).json({ message: "Rejection email sent successfully" });

    } catch (error) {
        console.error("Error sending rejection email:", error);
        res.status(500).json({ message: "Failed to send rmejection email", error });
    }
};



exports.registerUser = (req, res) => {
    console.log(req.body);
    User.findOne({ email: req.body.email }).then((user) => {
        if (user) {
            return res.status(400).json({ message: "Email already exists" });
        }
        User.findOne({ phone: req.body.phone }).then((withphone) => {
            if (withphone) {
                return res.status(400).json({ message: "Phone already exists" });
            }
            const newUser = User(req.body);
            newUser.save().then((newuser) => {
                if (newuser) {
                    if (req.body.usertype == "Hospital") {
                        req.body.userid = newuser._id;
                        let newHospital = Hospital(req.body);
                        newHospital.save().then((hospital) => {
                            if (hospital) {
                                return res.status(200).json({ message: "User and Hospital created successfully", newuser, hospital });
                            } else {
                                return res.status(400).json({ message: "Failed to create hospital" });
                            }
                        })
                    } else {
                        return res.status(200).json({ message: "User created successfully", newuser });
                    }
                } else {
                    return res.status(400).json({ message: "Failed to create user" });
                }
            })
        })

    })
}

exports.getPendingDonor = (req, res) => {
    User.find({ status: "pending", usertype: "Donor" }, { password: 0 }).then((users) => {
        if (users) {
            return res.status(200).json(users);
        } else {
            return res.status(400).json({ message: "No pending users" });
        }
    })

}

exports.getPendingReceipient = (req, res) => {
    User.find({ status: "pending", usertype: "Receipient" }, { password: 0 }).then((users) => {
        if (users) {
            return res.status(200).json(users);
        } else {
            return res.status(400).json({ message: "No pending users" });
        }
    })
}

exports.getPendingHospital = async (req, res) => {
    User.find({ status: "pending", usertype: "Hospital" }, { password: 0 }).then((users) => {
        if (users) {
            return res.status(200).json(users);
        } else {
            return res.status(400).json({ message: "No pending users" });
        }
    })
}


exports.loginUser = (req, res) => {
    User.findOne({ email: req.body.email }).then((user) => {
        if (user) {
            if (user.password == req.body.password) {
                return res.status(200).json({ message: "Login successful", user });
            } else {
                return res.status(400).json({ message: "Invalid password" });
            }
        } else {
            return res.status(400).json({ message: "Invalid email" });
        }
    })
}

exports.getDonorDetailsById = (req, res) => {
    console.log("Request Body:", req.body); // Debugging
    User.findOne({ _id: req.body._id }, { password: 0 }).then((user) => {
        if (user) {
            return res.status(200).json(user);
        } else {
            return res.status(400).json({ message: "Donor not found" });
        }
    }).catch((error) => {
        console.error("Error fetching Donor details:", error);
        return res.status(500).json({ message: "Internal server error" });
    });
};


exports.approveDonor = (req, res) => {
    User.findByIdAndUpdate(req.body._id, { status: "approved" }, { new: true })
        .then((user) => {
            if (user) {
                return res.status(200).json({ message: "Donor approved", user });
            } else {
                return res.status(400).json({ message: "Donor not found" });
            }
        })
        .catch((err) => res.status(500).json({ message: "Error updating donor", error: err }));
};

exports.rejectDonor = (req, res) => {
    User.findByIdAndUpdate(req.body._id, { status: "rejected" }, { new: true })
        .then((user) => {
            if (user) {
                return res.status(200).json({ message: "Donor rejected", user });
            } else {
                return res.status(400).json({ message: "Donor not found" });
            }
        })
        .catch((err) => res.status(500).json({ message: "Error updating donor", error: err }));
};



exports.getReceipientDetailsById = (req, res) => {
    console.log("Request Body:", req.body); // Debugging
    User.findOne({ _id: req.body._id }, { password: 0 }).then((user) => {
        if (user) {
            return res.status(200).json(user);
        } else {
            return res.status(400).json({ message: "Receipient not found" });
        }
    }).catch((error) => {
        console.error("Error fetching receipient details:", error);
        return res.status(500).json({ message: "Internal server error" });
    });
};



exports.approveReceipient = (req, res) => {
    User.findByIdAndUpdate(req.body._id, { status: "approved" }, { new: true })
        .then((user) => {
            if (user) {
                return res.status(200).json({ message: "Receipient approved", user });
            } else {
                return res.status(400).json({ message: "Receipient not found" });
            }
        })
        .catch((err) => res.status(500).json({ message: "Error updating Receipient", error: err }));
};

exports.rejectReceipient = (req, res) => {
    User.findByIdAndUpdate(req.body._id, { status: "rejected" }, { new: true })
        .then((user) => {
            if (user) {
                return res.status(200).json({ message: "Receipient rejected", user });
            } else {
                return res.status(400).json({ message: "Receipient not found" });
            }
        })
        .catch((err) => res.status(500).json({ message: "Error updating Receipient", error: err }));
};

exports.getHospitalDetailsById = async (req, res) => {
    try {
        const hospital = await Hospital.findOne({ userid: req.body._id })
            .populate({
                path: "userid",
                select: "name email phone status createdAt"
            });

        if (!hospital) {
            return res.status(400).json({ message: "Hospital not found" });
        }

        return res.status(200).json(hospital);
    } catch (error) {
        console.error("Error fetching hospital details:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.approveHospital = (req, res) => {
    User.findByIdAndUpdate(req.body._id, { status: "approved" }, { new: true })
        .then((user) => {
            if (user) {
                return res.status(200).json({ message: "Hospital approved", user });
            } else {
                return res.status(400).json({ message: "Hospital not found" });
            }
        })
        .catch((err) => res.status(500).json({ message: "Error updating hospital", error: err }));
};

exports.rejectHospital = (req, res) => {
    User.findByIdAndUpdate(req.body._id, { status: "rejected" }, { new: true })
        .then((user) => {
            if (user) {
                return res.status(200).json({ message: "Hospital rejected", user });
            } else {
                return res.status(400).json({ message: "Hospital not found" });
            }
        })
        .catch((err) => res.status(500).json({ message: "Error updating hospital", error: err }));
};


exports.getUserDetailsById = (req, res) => {
    console.log("Fetching details for User ID:", req.params.id); // Debugging

    if (!req.params.id) {
        return res.status(400).json({ message: "User ID is required" });
    }

    User.findById(req.params.id, { password: 0 }) // Exclude password
        .then((user) => {
            if (user) {
                return res.status(200).json(user);
            } else {
                return res.status(404).json({ message: "User not found" });
            }
        })
        .catch((error) => {
            console.error("Error fetching user details:", error);
            return res.status(500).json({ message: "Internal server error" });
        });
};



exports.updateUserProfile = (req, res) => {
    const Id = req.params.id; // Get ID from URL

    User.findOneAndUpdate(
        { _id: Id },
        { $set: req.body },
        { new: true, runValidators: true }
    ).then((user) => {
        if (user) {
            return res.status(200).json({ message: "User profile updated successfully", user });
        } else {
            return res.status(404).json({ message: "User not found" });
        }
    }).catch((error) => {
        console.error("Error updating User profile:", error);
        return res.status(500).json({ message: "Internal server error" });
    });
};

exports.submitFeedback = async (req, res) => {
    try {
        const { email, feedback } = req.body;

        if (!email || !feedback) {
            return res.status(400).json({ status: "error", message: "Email and feedback are required" });
        }

        const newFeedback = new Feedback({ email, feedback });
        await newFeedback.save();

        console.log("Feedback saved successfully");
        return res.status(200).json({
            status: "success", // ✅ Add this line
            message: "Feedback submitted successfully",
            feedback: newFeedback
        });
    } catch (error) {
        console.error("Error submitting feedback:", error);
        return res.status(500).json({ status: "error", message: "Internal server error" });
    }
};

exports.submitComplaint = async (req, res) => {
    try {
        const { email, complaint } = req.body;

        if (!email || !complaint) {
            return res.status(400).json({ status: "error", message: "Email and complaint are required" });
        }

        const newComplaint = new Complaint({ email, complaint });
        await newComplaint.save();

        console.log("Complaint saved successfully");
        return res.status(200).json({
            status: "success", // ✅ Add this line
            message: "Complaint submitted successfully",
            complaint: newComplaint
        });
    } catch (error) {
        console.error("Error submitting complaint:", error);
        return res.status(500).json({ status: "error", message: "Internal server error" });
    }
};

exports.submitDonation = async (req, res) => {
    try {
        const { donorid, organs } = req.body;

        if (!donorid || !organs || !Array.isArray(organs)) {
            return res.status(400).json({ status: "error", message: "Donor ID and a list of organs are required" });
        }

        const donations = organs.map(organ => ({ donorid, organ }));
        const newDonations = await Donation.insertMany(donations);

        console.log("Donations saved successfully");
        return res.status(200).json({
            status: "success",
            message: "Donations submitted successfully",
            donations: newDonations
        });
    } catch (error) {
        console.error("Error submitting donations:", error);
        return res.status(500).json({ status: "error", message: "Internal server error" });
    }
};

exports.getApprovedHospitals = async (req, res) => {
    try {
        const hospitals = await User.find(
            { status: 'approved', usertype: 'Hospital' }, // Add usertype condition
            'name' // Only fetch the name field
        );

        res.json({ success: true, data: hospitals });
    } catch (error) {
        console.error("Error fetching hospitals:", error);
        res.status(500).json({ success: false, message: 'Error fetching hospitals', error });
    }
};


exports.submitRequest = async (req, res) => {
    try {
      const { receipientid, organs, hospitalid } = req.body;
      
      if (!hospitalid) {
        return res.status(400).json({ success: false, message: "hospitalid is required" });
      }
  
      const newRequest = new Request({
        receipientid,
        organ: organs[0], 
        hospitalid 
      });
  
      await newRequest.save();
      res.status(200).json({ success: true, message: "Request submitted successfully" });
    } catch (error) {
      console.error("🔥 Server Error:", error);
      res.status(500).json({ success: false, message: error.message });
    }
  };
  


exports.getApprovedDonor = async (req, res) => {
    try {
        // Fetch approved donors
        const users = await User.find(
            { status: "approved", usertype: "Donor" },
            { _id: 1, bloodtype: 1 } // Fetch only required fields
        );

        if (!users || users.length === 0) {
            return res.status(400).json({ message: "No approved donors found" });
        }

        // Fetch only available & pending donated organs for each donor
        const donorsWithOrgans = await Promise.all(
            users.map(async (user) => {
                const donatedOrgans = await Donation.find(
                    {
                        donorid: user._id,
                        availability_status: "available",
                        donation_status: "pending"
                    },
                    { _id: 1, organ: 1, availability_status: 1, donation_status: 1 }
                );

                return donatedOrgans.length > 0
                    ? {
                        donorid: user._id,
                        bloodtype: user.bloodtype,
                        donatedOrgans: donatedOrgans
                    }
                    : null;
            })
        );

        // Remove donors with no matching donated organs
        const filteredDonors = donorsWithOrgans.filter(donor => donor !== null);

        if (filteredDonors.length === 0) {
            return res.status(400).json({ message: "No available organs found for approved donors" });
        }

        return res.status(200).json(filteredDonors);
    } catch (error) {
        console.error("Error fetching approved donors:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};



exports.getApprovedReceipient = async (req, res) => {
    try {
        // Fetch approved recipients with only required fields
        const users = await User.find(
            { status: "approved", usertype: "Receipient" },
            { _id: 1, bloodtype: 1 } // Fetch only _id and bloodtype
        );

        if (!users || users.length === 0) {
            return res.status(400).json({ message: "No approved recipients found" });
        }

        // Fetch pending requests for each recipient
        const recipientsWithRequests = await Promise.all(
            users.map(async (user) => {
                const requestedOrgans = await Request.find(
                    {
                        receipientid: user._id,
                        requested_status: "pending"
                    },
                    { _id: 1, organ: 1, hospitalid: 1, requested_status: 1 } // Fetch hospital ID too
                );

                return requestedOrgans.length > 0
                    ? {
                        receipientid: user._id,
                        bloodtype: user.bloodtype,
                        requestedOrgans: requestedOrgans
                    }
                    : null;
            })
        );

        // Remove recipients with no pending organ requests
        const filteredRecipients = recipientsWithRequests.filter(recipient => recipient !== null);

        if (filteredRecipients.length === 0) {
            return res.status(400).json({ message: "No pending organ requests found for approved recipients" });
        }

        return res.status(200).json(filteredRecipients);
    } catch (error) {
        console.error("Error fetching approved recipients:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
exports.matchOrgan = async (req, res) => {
    try {
        const { organ, bloodtype } = req.body;

        if (!organ || !bloodtype) {
            return res.status(400).json({ message: "Organ and blood type are required" });
        }

        // Find matching donated organs
        const donatedOrgans = await Donation.find({
            organ: organ,
            availability_status: "available",
            donation_status: "pending"
        }).populate("donorid");

        console.log("Donated organs:", donatedOrgans);



        if (!donatedOrgans || donatedOrgans.length === 0) {
            return res.status(400).json({ message: "No matching donated organs found" });
        }

        // Find matching requested organs
        const requestedOrgans = await Request.find({
            organ: organ,
            requested_status: "pending"
        });

        if (!requestedOrgans || requestedOrgans.length === 0) {
            return res.status(400).json({ message: "No matching requested organs found" });
        }

        // Find users with matching blood type
        const users = await User.find({
            bloodtype: bloodtype,
            _id: { $in: requestedOrgans.map(req => req.receipientid) }
        });

        console.log("Users with matching blood type:", users);

        if (!users || users.length === 0) {
            return res.status(400).json({ message: "No users with matching blood type found" });
        }

        // Filter requested organs by matching blood type
        const matchedRequests = requestedOrgans.filter(req => 
            users.some(user => user._id.equals(req.receipientid))
        );

        const hospital = await User.findById(matchedRequests[0].hospitalid);

        console.log("Matched requests:", matchedRequests);

        if (matchedRequests.length === 0) {
            return res.status(400).json({ message: "No matching requests found for the given blood type" });
        }

        requested = await User.find({
            _id: { $in: matchedRequests.map(req => req.receipientid) }
            
        });

       


        //const requested = await User.findById(matchedRequests[0].receipientid);
        //const donor = await User.findById(donatedOrgans[0].donorid);
         

        return res.status(200).json({ message: "Matching organs found", matchedRequests, donatedOrgans , requested, hospital});
    } catch (error) {
        console.error("Error matching organs:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};





