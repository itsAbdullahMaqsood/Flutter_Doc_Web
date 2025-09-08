import dotenv from "dotenv";
dotenv.config();
import jwt from "jsonwebtoken";

export const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) return res.status(401).json({ msg: "No auth token" });
    console.log("JWT_SECRET:", process.env.JWT_SECRET);
    const verified = jwt.verify(token, process.env.JWT_SECRET);

    if (!verified)
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied!" });

    req.user = verified.id;
    req.token = token;
    next();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
