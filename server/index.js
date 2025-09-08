import dotenv from "dotenv";
dotenv.config();
import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import { authRouter } from "./routes/auth.js";

const PORT = process.env.PORT || 3001;

const app = express();

app.use(cors());
app.use(express.json());
app.use(authRouter);

export const DB = process.env.DB_URI;

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successful!");
  })
  .catch((error) => {
    console.log(error);
  });

app.listen(process.env.PORT, "0.0.0.0", () => {
  console.log(`connected at port ${process.env.PORT}`);
  console.log(`check check`);
});
