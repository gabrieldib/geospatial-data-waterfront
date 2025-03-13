import express, { Express, Request, Response } from 'express';
import cors from 'cors';
const corsOptions = {
  origin: ['http://localhost:5173'],
}

const app: Express = express();
const port = 3000;

app.use(express.json()); // Add this line to parse JSON request bodies
app.use(cors(corsOptions))

app.get('/', (req: Request, res: Response) => {
  res.send('Hello from / root');
});

app.get("/api/v1/hello", (req, res) => {
  res.send("hello vite, from yours truly, backend server.")
});

app.post("/", (req, res) => {
  console.log("Received:", req.body)
  res.send(`we received the address: ${req.body.address}`)
});

app.listen(port, () => {
  console.log(`Server started at http://localhost:${port}`);
});