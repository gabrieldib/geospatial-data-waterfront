import express, { Express, Request, Response } from 'express';
import cors from 'cors';
const corsOptions = {
  origin: ['http://localhost:5173'],
}

const app: Express = express();
const port = 3000;

app.use(cors(corsOptions))

app.get('/', (req: Request, res: Response) => {
  res.send('Hello from /');
});

app.get("/api/v1/hello", (req, res) => {
  res.send("hello vite, from yours truly, backend server.")
});

app.listen(port, () => {
  console.log(`Server started at http://localhost:${port}`);
});