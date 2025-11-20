import express from "express";
import cors from "cors";
const app = express();

app.use(cors())
const port = process.env.PORT || 3000;

//  '/' route p request bhji h bs or in response me "hello from service-a" return krdi h
app.get("/", (req, res) => res.send("hello from service-a"));

// lgataar ye project ko listen kr rha h changes k lye 
app.listen(port, () => console.log(`service-a http://localhost:${port}`));
