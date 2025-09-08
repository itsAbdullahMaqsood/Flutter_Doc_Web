import dotenv from "dotenv";
dotenv.config();
import express from "express";
import jwt from "jsonwebtoken";
import { auth } from "../middleware/auth.js";
import User from "../models/user.js";
// import { DB } from "..";

const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;
    let user = await User.findOne({ email: email });
    if (!user) {
      user = new User({
        email: email,
        profilePic: profilePic,
        name: name,
      });
      user = await user.save();
    }
    console.log("JWT_SECRET:", process.env.JWT_SECRET);
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

    res.status(200).json({ user, token });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  const userObj = user.toObject();
  delete userObj.__v;
  res.json({ user: userObj, token: req.token });
});

export { authRouter };
