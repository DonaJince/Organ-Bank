const User = require("../models/user");
const Hospital = require("../models/hospital");
const Feedback = require("../models/feedback");
const Complaint = require("../models/complaint");
const Donation = require("../models/donated_organs");
const Request = require("../models/requested_organs");
const MatchedOrgans = require("../models/matched_organs");
const Transplantation = require("../models/transplantation");
const Donor = require("../models/donor");
const Receipient = require("../models/receipient");
const Admin = require("../models/admin");
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
            text: "Congratulations! Your registration has been approved. Your username will be your email and password will be the password you entered at the time of registration.Thank you for your contribution."
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




exports.registerUser = async (req, res) => {
    try {
        console.log(req.body);
        
        // Check if email already exists
        const existingUser = await User.findOne({ email: req.body.email });
        if (existingUser) {
            return res.status(400).json({ message: "Email already exists" });
        }


        // Create new User
        const newUser = new User(req.body);
        const savedUser = await newUser.save();

        if (!savedUser) {
            return res.status(400).json({ message: "Failed to create user" });
        }

        // If user is a Hospital, save hospital details
        if (req.body.usertype === "Hospital") {
            req.body.userid = savedUser._id;
            const newHospital = new Hospital(req.body);
            const savedHospital = await newHospital.save();
            
            if (!savedHospital) {
                return res.status(400).json({ message: "Failed to create hospital" });
            }

            return res.status(200).json({
                message: "User and Hospital created successfully",
                newUser: savedUser,
                hospital: savedHospital
            });
        }

        // If user is a Donor, save in Donor collection
        if (req.body.usertype === "Donor") {
            const newDonor = new Donor({
                donorid: savedUser._id,
                bloodtype: req.body.bloodtype
            });
            await newDonor.save();
        }

        // If user is a Receipient, save in Receipient collection
        if (req.body.usertype === "Receipient") {
            const newReceipient = new Receipient({
                receipientid: savedUser._id,
                bloodtype: req.body.bloodtype
            });
            await newReceipient.save();
        }

        return res.status(200).json({
            message: "User created successfully",
            newUser: savedUser
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Server error", error: error.message });
    }
};


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

exports.getFeedback = async (req, res) => {
    try {
        console.log("Fetching all feedback details");

        // Find all feedbacks and populate user details
        const feedbacks = await Feedback.find().populate({
            path: 'userId',
            model: 'User',
            select: 'name email'
        });

        const formattedFeedbacks = feedbacks.map(feedback => ({
            ...feedback.toObject(),
            userName: feedback.userId.name,
            userEmail: feedback.userId.email
        }));

        return res.status(200).json({ feedbacks: formattedFeedbacks });
    } catch (error) {
        console.error("Error fetching feedback:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.getComplaint = async (req, res) => {
    try {
        console.log("Fetching all complaint details");

        // Find all complaints and populate user details
        const complaints = await Complaint.find().populate({
            path: 'userId',
            model: 'User',
            select: 'name email'
        });

        const formattedComplaints = complaints.map(complaint => ({
            ...complaint.toObject(),
            userName: complaint.userId.name,
            userEmail: complaint.userId.email
        }));

        return res.status(200).json({ complaints: formattedComplaints });
    } catch (error) {
        console.error("Error fetching complaints:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
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

exports.updateHospitalProfile = async (req, res) => {
    const Id = req.params.id; // Get ID from URL

    try {
        // Update the User collection
        const updatedUser = await User.findByIdAndUpdate(
            Id,
            { $set: { name: req.body.name, phone: req.body.phone } },
            { new: true, runValidators: true }
        );

        if (!updatedUser) {
            return res.status(404).json({ message: "User not found" });
        }

        // Update the Hospital collection
        const updatedHospital = await Hospital.findOneAndUpdate(
            { userid: Id },
            { $set: { location: req.body.location, otherphno: req.body.otherphno } },
            { new: true, runValidators: true }
        );

        if (!updatedHospital) {
            return res.status(404).json({ message: "Hospital not found" });
        }

        return res.status(200).json({
            message: "Hospital profile updated successfully",
            user: updatedUser,
            hospital: updatedHospital
        });
    } catch (error) {
        console.error("Error updating Hospital profile:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};


exports.submitFeedback = async (req, res) => {
    try {
        const { userId, feedback } = req.body;

        if (!userId || !feedback) {
            return res.status(400).json({ status: "error", message: "userid and feedback are required" });
        }

        const newFeedback = new Feedback({ userId, feedback });
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
        const { userId, complaint } = req.body;

        if (!userId || !complaint) {
            return res.status(400).json({ status: "error", message: "userid and complaint are required" });
        }

        const newComplaint = new Complaint({ userId, complaint });
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

exports.getHospitalDetailsByid = async (req, res) => {
    try {
        const hospital = await Hospital.findOne({ userid: req.params.id })
            .populate({
                path: 'userid',
                select: 'name email phone'
            });

        if (!hospital) {
            return res.status(400).json({ message: 'Hospital not found' });
        }

        const hospitalDetails = {
            name: hospital.userid.name,
            email: hospital.userid.email,
            phone: hospital.userid.phone,
            location: hospital.location,
            otherphno: hospital.otherphno
        };

        return res.status(200).json(hospitalDetails);
    } catch (error) {
        console.error('Error fetching hospital details:', error);
        return res.status(500).json({ message: 'Internal server error' });
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



exports.getBloodType = async (req, res) => {
    try {
        const { userid } = req.params;

        if (!userid) {
            return res.status(400).json({ message: "User ID is required" });
        }

        const user = await User.findById(userid, { bloodtype: 1 });

        if (!user) {

            return res.status(400).json({ message: "User not found" });
        }

        return res.status(200).json({ bloodtype: user.bloodtype });

    } catch (error) {
        console.error("Error fetching blood type:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};


exports.fetchMatchedDonor = async (req, res) => {
    try {
        const { receipientid, hospitalid, bloodtype, organ } = req.body;

        if (!receipientid || !hospitalid || !bloodtype || !organ) {
            return res.status(400).json({ message: "Receipient ID, Hospital ID, Blood type, and Organ are required" });
        }

        console.log("Request received with:", req.body);

        // Find donors with matching blood type and usertype as 'Donor'
        const donors = await User.find({
            bloodtype: bloodtype,
            usertype: "Donor"
        });

        console.log("Donors with matching blood type found:", donors);

        if (!donors || donors.length === 0) {
            return res.status(400).json({ message: "No donors with matching blood type found" });
        }

        // Find donations that match the organ and belong to the donors found
        const matchedDonations = await Donation.find({
            organ: organ,
            donation_status: "pending",
            donorid: { $in: donors.map(donor => donor._id) }
        }).populate("donorid");

        console.log("Matching donations found:", matchedDonations);

        if (!matchedDonations || matchedDonations.length === 0) {
            return res.status(200).json({ 
                message: "No matching donations found for the given blood type and organ", 
                matchedDonations: [] 
            });
        }
        

        // Store the matching details in MatchedOrgans collection
        const matchedOrganPromises = matchedDonations.map(donation => {
            const matchedOrgan = new MatchedOrgans({
                receipientid,
                donorid: donation.donorid._id,
                hospitalid,
                organ,
                matchedDonorId: donation.donorid._id // Store matched donor ID
            });
            return matchedOrgan.save();
        });

        const savedMatchedOrgans = await Promise.all(matchedOrganPromises);

        console.log("Matched organs saved:", savedMatchedOrgans);

        return res.status(200).json({ message: "Matching donors found and stored successfully", matchedOrgans: savedMatchedOrgans });
    } catch (error) {
        console.error("Error fetching matched donor:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};


exports.fetchMatchedReceipient = async (req, res) => {
    try {
        const { donorid, bloodtype, organ } = req.body;

        if (!donorid || !bloodtype || !organ) {
            return res.status(400).json({ message: "Donor ID, Blood type, and Organ are required" });
        }

        console.log("Request received with:", req.body);

        // Find recipients with matching blood type and usertype as 'Receipient'
        const recipients = await User.find({
            bloodtype: bloodtype,
            usertype: "Receipient"
        });

        console.log("Recipients with matching blood type found:", recipients);

        if (!recipients || recipients.length === 0) {
            return res.status(400).json({ message: "No recipients with matching blood type found" });
        }

        // Find requests that match the organ and belong to the recipients found
        const matchedRequests = await Request.find({
            organ: organ,
            requested_status: "pending",
            receipientid: { $in: recipients.map(rec => rec._id) }
        });

        console.log("Matching organ requests found:", matchedRequests);

        if (!matchedRequests || matchedRequests.length === 0) {
            console.log("No matching organ requests found for the given blood type and organ.");
            return res.status(200).json({ message: "No matching organ requests found", matchedOrgans: [] });
        }

        // Store the matching details in MatchedOrgans collection
        const matchedOrganPromises = matchedRequests.map(request => {
            const matchedOrgan = new MatchedOrgans({
                receipientid: request.receipientid,
                donorid,
                hospitalid: request.hospitalid,
                organ,
                matchedDonorId: donorid // Store matched donor ID
            });
            return matchedOrgan.save();
        });

        const savedMatchedOrgans = await Promise.all(matchedOrganPromises);

        console.log("Matched organs saved:", savedMatchedOrgans);

        return res.status(200).json({ message: "Matching recipients found and stored successfully", matchedOrgans: savedMatchedOrgans });
    } catch (error) {
        console.error("Error fetching matched recipient:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.getPendingMatches = async (req, res) => {
    try {
        // Find all pending matches
        const pendingMatches = await MatchedOrgans.find({ status: "pending" });

        if (!pendingMatches || pendingMatches.length === 0) {
            return res.status(400).json({ message: "No pending matches found" });
        }

        // Filter matches based on availability status in Donations
        const validPendingMatches = [];
        for (const match of pendingMatches) {
            const donation = await Donation.findOne({
                donorid: match.donorid,
                organ: match.organ,
                availability_status: "available"
            });

            if (donation) {
                validPendingMatches.push(match);
            }
        }

        if (validPendingMatches.length === 0) {
            return res.status(400).json({ message: "No valid pending matches found" });
        }

        // Populate the donor, recipient, and hospital details
        const populatedMatches = await MatchedOrgans.populate(validPendingMatches, [
            { path: 'donorid', model: 'User', select: 'name' },
            { path: 'receipientid', model: 'User', select: 'name' },
            { path: 'hospitalid', model: 'User', select: 'name' }
        ]);

        const formattedMatches = populatedMatches.map(match => ({
            ...match.toObject(),
            donorName: match.donorid.name,
            receipientName: match.receipientid.name,
            hospitalName: match.hospitalid.name
        }));

        return res.status(200).json({ pendingMatches: formattedMatches });
    } catch (error) {
        console.error("Error fetching pending matches:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.getDonatedOrgans = async (req, res) => {    
    try {
        const { id } = req.params;
        const donatedOrgans = await Donation.find({ donorid: id }); // Corrected the query syntax

        if (!donatedOrgans || donatedOrgans.length === 0) {
            return res.status(400).json({ message: "No donated organs found" });
        }   
        return res.status(200).json({ organs: donatedOrgans.map(donation => donation.organ) });

    } catch (error) {
        console.error("Error fetching donated organs:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.getRequestedOrgans = async (req, res) => {
    try {
        const { id } = req.params;
        const requestedOrgans = await Request.find({ receipientid: id }); // Corrected the query syntax

        if (!requestedOrgans || requestedOrgans.length === 0) {
            return res.status(400).json({ message: "No requested organs found" });
        }

        return res.status(200).json({ organs: requestedOrgans.map(request => request.organ) });

    } catch (error) {
        console.error("Error fetching requested organs:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
}

exports.getDonations = async (req, res) => {
    try {
        const { donorId } = req.params;
        console.log("Fetching donations for donorId:", donorId);
        
        const donations = await Donation.find({ donorid: donorId });

        if (!donations) {
            console.log("Donations is null, returning an empty array.");
            return res.status(200).json([]);  // Ensures response is always an array
        }

        console.log("Donations found:", donations);
        return res.status(200).json(donations);
    } catch (error) {
        console.error("Error fetching donations:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.updateDonationStatus = async (req, res) => {
    const { donationId } = req.params;
    const { status } = req.body;

    try {
        const donation = await Donation.findByIdAndUpdate(
            donationId,
            { availability_status: status },
            { new: true, runValidators: true }
        );

        if (!donation) {
            return res.status(404).json({ message: "Donation not found" });
        }

        return res.status(200).json({ message: "Donation status updated successfully", donation });
    } catch (error) {
        console.error("Error updating donation status:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.approveMatch = async (req, res) => {
    const { matchid } = req.body;

    try {
        // Find the match in MatchedOrgans
        const match = await MatchedOrgans.findById(matchid);

        if (!match) {
            return res.status(404).json({ message: "Match not found" });
        }

        console.log("Match found:", match);

        // Update the status in MatchedOrgans
        match.status = "approved";
        await match.save();
        console.log("Match status updated:", match);

        // Update the status in Request
        const requestUpdate = await Request.findOneAndUpdate(
            { receipientid: match.receipientid, organ: match.organ },
            { requested_status: "approved" },
            { new: true, runValidators: true }
        );

        if (!requestUpdate) {
            return res.status(404).json({ message: "Request not found" });
        }

        console.log("Request status updated:", requestUpdate);

        // Update the status in Donation
        const donationUpdate = await Donation.findOneAndUpdate(
            { donorid: match.donorid, organ: match.organ },
            { donation_status: "approved" },
            { new: true, runValidators: true }
        );

        if (!donationUpdate) {
            return res.status(404).json({ message: "Donation not found" });
        }

        console.log("Donation status updated:", donationUpdate);

        // Find the hospital email
        const hospital = await User.findById(match.hospitalid);
        if (!hospital) {
            return res.status(404).json({ message: "Hospital not found" });
        }

        console.log("Hospital found:", hospital);

        // Configure Nodemailer
        let transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "organbank2025@gmail.com", // Replace with your Gmail
                pass: "vhsb vvss vlyz fooj"  // Use an App Password instead of your actual password
            }
        });

        // Send email to the hospital
        let mailOptions = {
            from: "organbank2025@gmail.com",
            to: hospital.email,
            subject: "Organ Match Found",
            text: `A match has been found for the recipient with ID ${match.receipientid} for the organ ${match.organ}.`
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email:", error);
            } else {
                console.log("Email sent:", info.response);
            }
        });

        return res.status(200).json({
            message: "Match approved successfully and email sent to the hospital",
            match,
            request: requestUpdate,
            donation: donationUpdate
        });
    } catch (error) {
        console.error("Error approving match:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};


    exports.getRequests = async (req, res) => {
        try {
            const { receipientId } = req.params;
            console.log("Fetching requests for receipientId:", receipientId);
    
            const requests = await Request.find({ receipientid: receipientId });
    
            if (!requests || requests.length === 0) {
                console.log("Requests is null or empty, returning an empty array.");
                return res.status(200).json([]);  // Ensures response is always an array
            }
    
            console.log("Requests found:", requests);
            return res.status(200).json(requests);
        } catch (error) {
            console.error("Error fetching requests:", error);
            return res.status(500).json({ message: "Internal server error" });
        }


};

exports.approvedMatches = async (req, res) => {
    try {
        const { hospitalId } = req.params;
        console.log("Fetching approved matches for hospitalId:", hospitalId);

        const approvedMatches = await MatchedOrgans.find({ hospitalid: hospitalId, status: "approved" })
            .populate({ path: 'donorid', model: 'User', select: 'name email' })
            .populate({ path: 'receipientid', model: 'User', select: 'name email' })
            .populate({ path: 'hospitalid', model: 'User', select: 'name email' })
            .lean();

        if (!approvedMatches || approvedMatches.length === 0) {
            console.log("No approved matches found, returning an empty array.");
            return res.status(200).json([]); // Ensures response is always an array
        }

        // Format the matches to include the names and emails
        const formattedMatches = approvedMatches.map(match => ({
            ...match,
            _id: match._id.toString(),
            donorName: match.donorid.name,
            donorEmail: match.donorid.email,
            receipientName: match.receipientid.name,
            receipientEmail: match.receipientid.email,
            hospitalName: match.hospitalid.name,
            hospitalEmail: match.hospitalid.email
        }));

        console.log("Approved matches found:", formattedMatches);
        return res.status(200).json(formattedMatches);
    } catch (error) {
        console.error("Error fetching approved matches:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};



exports.sendTestScheduleEmail = async (req, res) => {
    const { matchId, emailBody } = req.body;

    try {
        // Find the match in MatchedOrgans
        const match = await MatchedOrgans.findById(matchId);

        if (!match) {
            return res.status(404).json({ message: "Match not found" });
        }

        console.log("Match found:", match);

        // Update the status in MatchedOrgans to 'testscheduled'
        match.status = "testscheduled";
        await match.save();
        console.log("Match status updated to 'testscheduled':", match);

                // Update the status in Request to 'testscheduled'
                const requestUpdate = await Request.findOneAndUpdate(
                    { receipientid: match.receipientid, organ: match.organ },
                    { requested_status: "testscheduled" },
                    { new: true, runValidators: true }
                );
        
                if (!requestUpdate) {
                    return res.status(404).json({ message: "Request not found" });
                }
        
                console.log("Request status updated to 'testscheduled':", requestUpdate);
        
                // Update the status in Donation to 'testscheduled'
                const donationUpdate = await Donation.findOneAndUpdate(
                    { donorid: match.donorid, organ: match.organ },
                    { donation_status: "testscheduled" },
                    { new: true, runValidators: true }
                );
        
                if (!donationUpdate) {
                    return res.status(404).json({ message: "Donation not found" });
                }
        
                console.log("Donation status updated to 'testscheduled':", donationUpdate);
        

        // Find the hospital email
        const hospital = await User.findById(match.hospitalid);
        if (!hospital) {
            return res.status(404).json({ message: "Hospital not found" });
        }

        console.log("Hospital found:", hospital);

        // Find the donor email
        const donor = await User.findById(match.donorid);
        if (!donor) {
            return res.status(404).json({ message: "Donor not found" });
        }

        console.log("Donor found:", donor);

        // Find the recipient email
        const recipient = await User.findById(match.receipientid);
        if (!recipient) {
            return res.status(404).json({ message: "Recipient not found" });
        }

        console.log("Recipient found:", recipient);

        // Configure Nodemailer
        let transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "organbank2025@gmail.com", // Replace with your Gmail
                pass: "vhsb vvss vlyz fooj"  // Use an App Password instead of your actual password
            }
        });

        // Send email to the donor
        let donorMailOptions = {
            from: hospital.email,
            to: donor.email,
            replyTo: hospital.email,
            subject: "Test Schedule Notification",
            text: `Dear ${donor.name},\n\nA match has been found for your donated organ (${match.organ}). Thank you for your generous donation.\n\nTest Schedule Details\n\n${emailBody}\n\nBest regards,\nOrgan Bank`
        };

        transporter.sendMail(donorMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to donor:", error);
            } else {
                console.log("Email sent to donor:", info.response);
            }
        });

        // Send email to the recipient
        let recipientMailOptions = {
            from: hospital.email,
            to: recipient.email,
            replyTo: hospital.email,
            subject: "Test Schedule Notification",
            text: `Dear ${recipient.name},\n\nA match has been found for your requested organ (${match.organ}). Please contact the hospital for further details.\n\nTest Schedule Details\n\n${emailBody}\n\nBest regards,\nOrgan Bank`
        };

        transporter.sendMail(recipientMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to recipient:", error);
            } else {
                console.log("Email sent to recipient:", info.response);
            }
        });

        return res.status(200).json({
            message: "Test schedule emails sent successfully to donor and recipient",
            match
        });
    } catch (error) {
        console.error("Error sending test schedule email:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.testScheduledMatches = async (req, res) => {
    try {
        const { hospitalId } = req.params;
        console.log("Fetching test scheduled matches for hospitalId:", hospitalId);

        const testScheduledMatches = await MatchedOrgans.find({ hospitalid: hospitalId, status: "testscheduled" })
            .populate({ path: 'donorid', model: 'User', select: 'name email' })
            .populate({ path: 'receipientid', model: 'User', select: 'name email' })
            .populate({ path: 'hospitalid', model: 'User', select: 'name email' })
            .lean();

        if (!testScheduledMatches || testScheduledMatches.length === 0) {
            console.log("No test scheduled matches found, returning an empty array.");
            return res.status(200).json([]); // Ensures response is always an array
        }

        // Format the matches to include the names and emails
        const formattedMatches = testScheduledMatches.map(match => ({
            ...match,
            _id: match._id.toString(),
            donorName: match.donorid.name,
            donorEmail: match.donorid.email,
            receipientName: match.receipientid.name,
            receipientEmail: match.receipientid.email,
            hospitalName: match.hospitalid.name,
            hospitalEmail: match.hospitalid.email
        }));

        console.log("Test scheduled matches found:", formattedMatches);
        return res.status(200).json(formattedMatches);
    } catch (error) {
        console.error("Error fetching test scheduled matches:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};



exports.updateTestResult = async (req, res) => {
    const { matchId } = req.params;
    const { status } = req.body;

    console.log("Updating test result for matchId:", matchId, "with status:", status);

    try {
        // Update the status in MatchedOrgans
        const match = await MatchedOrgans.findByIdAndUpdate(
            matchId,
            { status },
            { new: true, runValidators: true }
        );

        if (!match) {
            return res.status(404).json({ message: "Match not found" });
        }

        console.log("Match status updated:", match);

        // Determine the new status for Donation and Request
        const newStatus = status === "failure" ? "pending" : "matched";

        // Update the status in Request
        const requestUpdate = await Request.findOneAndUpdate(
            { receipientid: match.receipientid, organ: match.organ },
            { requested_status: newStatus },
            { new: true, runValidators: true }
        );

        if (!requestUpdate) {
            return res.status(404).json({ message: "Request not found" });
        }

        console.log("Request status updated:", requestUpdate);

        // Update the status in Donation
        const donationUpdate = await Donation.findOneAndUpdate(
            { donorid: match.donorid, organ: match.organ },
            { donation_status: newStatus },
            { new: true, runValidators: true }
        );

        if (!donationUpdate) {
            return res.status(404).json({ message: "Donation not found" });
        }

        console.log("Donation status updated:", donationUpdate);

        // Find the hospital email
        const hospital = await User.findById(match.hospitalid);
        if (!hospital) {
            return res.status(404).json({ message: "Hospital not found" });
        }

        console.log("Hospital found:", hospital);

        // Find the donor email
        const donor = await User.findById(match.donorid);
        if (!donor) {
            return res.status(404).json({ message: "Donor not found" });
        }

        console.log("Donor found:", donor);

        // Find the recipient email
        const recipient = await User.findById(match.receipientid);
        if (!recipient) {
            return res.status(404).json({ message: "Recipient not found" });
        }

        console.log("Recipient found:", recipient);

        // Configure Nodemailer
        let transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "organbank2025@gmail.com", // Replace with your Gmail
                pass: "vhsb vvss vlyz fooj"  // Use an App Password instead of your actual password
            }
        });

        // Email content based on the status
        const emailSubject = status === "failure" ? "Test Result: Failure" : "Test Result: Success";
        const emailBodyDonor = status === "failure"
            ? `Dear ${donor.name},\n\nUnfortunately, the test for your donated organ (${match.organ}) has failed. Please contact the hospital for further details.\n\nBest regards,\nOrgan Bank`
            : `Dear ${donor.name},\n\nThe test for your donated organ (${match.organ}) has been successful. Thank you for your generous donation.\n\nBest regards,\nOrgan Bank`;

        const emailBodyRecipient = status === "failure"
            ? `Dear ${recipient.name},\n\nUnfortunately, the test for the organ (${match.organ}) you requested has failed. Please contact the hospital for further details.\n\nBest regards,\nOrgan Bank`
            : `Dear ${recipient.name},\n\nThe test for the organ (${match.organ}) you requested has been successful. Please contact the hospital for further details.\n\nBest regards,\nOrgan Bank`;

        // Send email to the donor
        let donorMailOptions = {
            from: "organbank2025@gmail.com",
            to: donor.email,
            replyTo: hospital.email,
            subject: emailSubject,
            text: emailBodyDonor
        };

        transporter.sendMail(donorMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to donor:", error);
            } else {
                console.log("Email sent to donor:", info.response);
            }
        });

        // Send email to the recipient
        let recipientMailOptions = {
            from: "organbank2025@gmail.com",
            to: recipient.email,
            replyTo: hospital.email,
            subject: emailSubject,
            text: emailBodyRecipient
        };

        transporter.sendMail(recipientMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to recipient:", error);
            } else {
                console.log("Email sent to recipient:", info.response);
            }
        });

        return res.status(200).json({
            message: "Test result updated successfully and emails sent to donor and recipient",
            match,
            request: requestUpdate,
            donation: donationUpdate
        });
    } catch (error) {
        console.error("Error updating test result:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.successMatches = async (req, res) => {
    try {
        const { hospitalId } = req.params;
        console.log("Fetching success matches for hospitalId:", hospitalId);

        const successMatches = await MatchedOrgans.find({ hospitalid: hospitalId, status: "success" })
            .populate({ path: 'donorid', model: 'User', select: 'name email' })
            .populate({ path: 'receipientid', model: 'User', select: 'name email' })
            .populate({ path: 'hospitalid', model: 'User', select: 'name email' })
            .lean();

        if (!successMatches || successMatches.length === 0) {
            console.log("No success matches found, returning an empty array.");
            return res.status(200).json([]); // Ensures response is always an array
        }

        // Format the matches to include the names and emails
        const formattedMatches = successMatches.map(match => ({
            ...match,
            _id: match._id.toString(),
            donorName: match.donorid.name,
            donorEmail: match.donorid.email,
            receipientName: match.receipientid.name,
            receipientEmail: match.receipientid.email,
            hospitalName: match.hospitalid.name,
            hospitalEmail: match.hospitalid.email
        }));

        console.log("Success matches found:", formattedMatches);
        return res.status(200).json(formattedMatches);
    } catch (error) {
        console.error("Error fetching success matches:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
exports.sendTransplantationScheduleEmail = async (req, res) => {
    const { matchId, emailBody } = req.body;

    try {
        // Find the match in MatchedOrgans
        const match = await MatchedOrgans.findById(matchId);

        if (!match) {
            return res.status(404).json({ message: "Match not found" });
        }

        console.log("Match found:", match);

        // Update the status in MatchedOrgans to 'transplantationscheduled'
        match.status = "transplantationscheduled";
        await match.save();
        console.log("Match status updated to 'transplantationscheduled':", match);

        // Update the status in Request to 'transplantationscheduled'
        const requestUpdate = await Request.findOneAndUpdate(
            { receipientid: match.receipientid, organ: match.organ },
            { requested_status: "transplantationscheduled" },
            { new: true, runValidators: true }
        );

        if (!requestUpdate) {
            return res.status(404).json({ message: "Request not found" });
        }

        console.log("Request status updated to 'transplantationscheduled':", requestUpdate);

        // Update the status in Donation to 'transplantationscheduled'
        const donationUpdate = await Donation.findOneAndUpdate(
            { donorid: match.donorid, organ: match.organ },
            { donation_status: "transplantationscheduled" },
            { new: true, runValidators: true }
        );

        if (!donationUpdate) {
            return res.status(404).json({ message: "Donation not found" });
        }

        console.log("Donation status updated to 'transplantationscheduled':", donationUpdate);

        // Find the hospital email
        const hospital = await User.findById(match.hospitalid);
        if (!hospital) {
            return res.status(404).json({ message: "Hospital not found" });
        }

        console.log("Hospital found:", hospital);

        // Find the donor email
        const donor = await User.findById(match.donorid);
        if (!donor) {
            return res.status(404).json({ message: "Donor not found" });
        }

        console.log("Donor found:", donor);

        // Find the recipient email
        const recipient = await User.findById(match.receipientid);
        if (!recipient) {
            return res.status(404).json({ message: "Recipient not found" });
        }

        console.log("Recipient found:", recipient);

        // Configure Nodemailer
        let transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "organbank2025@gmail.com", // Replace with your Gmail
                pass: "vhsb vvss vlyz fooj"  // Use an App Password instead of your actual password
            }
        });

        // Send email to the donor
        let donorMailOptions = {
            from: "organbank2025@gmail.com",
            to: donor.email,
            replyTo: hospital.email,
            subject: "Transplantation Schedule Notification",
            text: `Dear ${donor.name},\n\nA match has been found for your donated organ (${match.organ}). Thank you for your generous donation.\n\nTransplantation Schedule Details\n\n${emailBody}\n\nBest regards,\nOrgan Bank`
        };

        transporter.sendMail(donorMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to donor:", error);
            } else {
                console.log("Email sent to donor:", info.response);
            }
        });

        // Send email to the recipient
        let recipientMailOptions = {
            from: "organbank2025@gmail.com",
            to: recipient.email,
            replyTo: hospital.email,
            subject: "Transplantation Schedule Notification",
            text: `Dear ${recipient.name},\n\nA match has been found for your requested organ (${match.organ}). Please contact the hospital for further details.\n\nTransplantation Schedule Details\n\n${emailBody}\n\nBest regards,\nOrgan Bank`
        };

        transporter.sendMail(recipientMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to recipient:", error);
            } else {
                console.log("Email sent to recipient:", info.response);
            }
        });

        return res.status(200).json({
            message: "Transplantation schedule emails sent successfully to donor and recipient, and status updated to 'transplantationscheduled'",
            match,
            request: requestUpdate,
            donation: donationUpdate
        });
    } catch (error) {
        console.error("Error sending transplantation schedule email:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.transplantationScheduledMatches = async (req, res) => {
    try {
        const { hospitalId } = req.params;
        console.log("Fetching transplantation scheduled matches for hospitalId:", hospitalId);

        const transplantationScheduledMatches = await MatchedOrgans.find({ hospitalid: hospitalId, status: "transplantationscheduled" })
            .populate({ path: 'donorid', model: 'User', select: 'name email' })
            .populate({ path: 'receipientid', model: 'User', select: 'name email' })
            .populate({ path: 'hospitalid', model: 'User', select: 'name email' })
            .lean();

        if (!transplantationScheduledMatches || transplantationScheduledMatches.length === 0) {
            console.log("No transplantation scheduled matches found, returning an empty array.");
            return res.status(200).json([]); // Ensures response is always an array
        }

        // Format the matches to include the names and emails
        const formattedMatches = transplantationScheduledMatches.map(match => ({
            ...match,
            _id: match._id.toString(),
            donorName: match.donorid.name,
            donorEmail: match.donorid.email,
            receipientName: match.receipientid.name,
            receipientEmail: match.receipientid.email,
            hospitalName: match.hospitalid.name,
            hospitalEmail: match.hospitalid.email
        }));

        console.log("Transplantation scheduled matches found:", formattedMatches);
        return res.status(200).json(formattedMatches);
    } catch (error) {
        console.error("Error fetching transplantation scheduled matches:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.updateTransplantationResult = async (req, res) => {
    const { matchId } = req.params;
    const { status } = req.body;

    console.log("Updating transplantation result for matchId:", matchId, "with status:", status);

    try {
        // Update the status in MatchedOrgans
        const match = await MatchedOrgans.findByIdAndUpdate(
            matchId,
            { status: status === "success" ? "transplantationsuccess" : "transplantationfailed" },
            { new: true, runValidators: true }
        );

        if (!match) {
            return res.status(404).json({ message: "Match not found" });
        }

        console.log("Match status updated:", match);

        // Update the status in Request to 'completed'
        const requestUpdate = await Request.findOneAndUpdate(
            { receipientid: match.receipientid, organ: match.organ },
            { requested_status: "completed" },
            { new: true, runValidators: true }
        );

        if (!requestUpdate) {
            return res.status(404).json({ message: "Request not found" });
        }

        console.log("Request status updated to 'completed':", requestUpdate);

        // Update the status in Donation to 'completed'
        const donationUpdate = await Donation.findOneAndUpdate(
            { donorid: match.donorid, organ: match.organ },
            { donation_status: "completed" },
            { new: true, runValidators: true }
        );

        if (!donationUpdate) {
            return res.status(404).json({ message: "Donation not found" });
        }

        console.log("Donation status updated to 'completed':", donationUpdate);

        // Store the transplantation details in the Transplantation collection
        const newTransplantation = new Transplantation({
            matchid: match._id,
            donorid: match.donorid,
            receipientid: match.receipientid,
            hospitalid: match.hospitalid,
            organ: match.organ,
            status: status === "success" ? "transplantationsuccess" : "transplantationfailed",
            date: new Date()
        });

        await newTransplantation.save();
        console.log("Transplantation details saved:", newTransplantation);

        // Find the hospital email
        const hospital = await User.findById(match.hospitalid);
        if (!hospital) {
            return res.status(404).json({ message: "Hospital not found" });
        }

        console.log("Hospital found:", hospital);

        // Find the donor email
        const donor = await User.findById(match.donorid);
        if (!donor) {
            return res.status(404).json({ message: "Donor not found" });
        }

        console.log("Donor found:", donor);

        // Find the recipient email
        const recipient = await User.findById(match.receipientid);
        if (!recipient) {
            return res.status(404).json({ message: "Recipient not found" });
        }

        console.log("Recipient found:", recipient);

        // Configure Nodemailer
        let transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "organbank2025@gmail.com", // Replace with your Gmail
                pass: "vhsb vvss vlyz fooj"  // Use an App Password instead of your actual password
            }
        });

        // Email content based on the status
        const emailSubject = status === "failure" ? "Transplantation Result: Failure" : "Transplantation Result: Success";
        const emailBodyDonor = status === "failure"
            ? `Dear ${donor.name},\n\nUnfortunately, the transplantation for your donated organ (${match.organ}) has failed. Please contact the hospital for further details.\n\nBest regards,\nOrgan Bank`
            : `Dear ${donor.name},\n\nThe transplantation for your donated organ (${match.organ}) has been successful. Thank you for your generous donation.\n\nBest regards,\nOrgan Bank`;

        const emailBodyRecipient = status === "failure"
            ? `Dear ${recipient.name},\n\nUnfortunately, the transplantation for the organ (${match.organ}) you received has failed. Please contact the hospital for further details.\n\nBest regards,\nOrgan Bank`
            : `Dear ${recipient.name},\n\nThe transplantation for the organ (${match.organ}) you received has been successful. Please contact the hospital for further details.\n\nBest regards,\nOrgan Bank`;

        // Send email to the donor
        let donorMailOptions = {
            from: "organbank2025@gmail.com",
            to: donor.email,
            replyTo: hospital.email,
            subject: emailSubject,
            text: emailBodyDonor
        };

        transporter.sendMail(donorMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to donor:", error);
            } else {
                console.log("Email sent to donor:", info.response);
            }
        });

        // Send email to the recipient
        let recipientMailOptions = {
            from: "organbank2025@gmail.com",
            to: recipient.email,
            replyTo: hospital.email,
            subject: emailSubject,
            text: emailBodyRecipient
        };

        transporter.sendMail(recipientMailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email to recipient:", error);
            } else {
                console.log("Email sent to recipient:", info.response);
            }
        });

        return res.status(200).json({
            message: "Transplantation result updated successfully and emails sent to donor and recipient",
            match,
            request: requestUpdate,
            donation: donationUpdate
        });
    } catch (error) {
        console.error("Error updating transplantation result:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

exports.getTransplantations = async (req, res) => {
    try {
        console.log("Fetching all transplantations");

        const transplantations = await Transplantation.find()
            .populate({ path: 'donorid', model: 'User', select: 'name email' })
            .populate({ path: 'receipientid', model: 'User', select: 'name email' })
            .populate({ path: 'hospitalid', model: 'User', select: 'name email' })
            .lean();

        if (!transplantations || transplantations.length === 0) {
            console.log("No transplantations found, returning an empty array.");
            return res.status(200).json([]); // Ensures response is always an array
        }

        // Format the transplantations to include the names and emails
        const formattedTransplantations = transplantations.map(transplantation => ({
            ...transplantation,
            _id: transplantation._id.toString(),
            donorName: transplantation.donorid.name,
            donorEmail: transplantation.donorid.email,
            receipientName: transplantation.receipientid.name,
            receipientEmail: transplantation.receipientid.email,
            hospitalName: transplantation.hospitalid.name,
            hospitalEmail: transplantation.hospitalid.email
        }));

        console.log("Transplantations found:", formattedTransplantations);
        return res.status(200).json(formattedTransplantations);
    } catch (error) {
        console.error("Error fetching transplantations:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};


exports.getTodayTransplantationData = async (req, res) => {
    try {
        
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const tomorrow = new Date(today);
        tomorrow.setDate(today.getDate() + 1);

        const transplantations = await Transplantation.find({
            createdAt: { $gte: today, $lt: tomorrow }
        })
            .populate({ path: 'donorid', model: 'User', select: 'name email' })
            .populate({ path: 'receipientid', model: 'User', select: 'name email' })
            .populate({ path: 'hospitalid', model: 'User', select: 'name email' })
            .lean();

        const formattedTransplantations = transplantations.map(transplantation => ({
            ...transplantation,
            _id: transplantation._id.toString(),
            donorName: transplantation.donorid?.name || "N/A",
            donorEmail: transplantation.donorid?.email || "N/A",
            receipientName: transplantation.receipientid?.name || "N/A",
            receipientEmail: transplantation.receipientid?.email || "N/A",
            hospitalName: transplantation.hospitalid?.name || "N/A",
            hospitalEmail: transplantation.hospitalid?.email || "N/A"
        }));

        console.log("Today's transplantations:", formattedTransplantations);

        return res.status(200).json({
            transplantations: formattedTransplantations
        });
    } catch (error) {
        console.error("Error fetching  transplantation data:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
};