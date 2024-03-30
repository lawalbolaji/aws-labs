import { ListObjectsCommand, PutObjectCommand, S3Client } from "@aws-sdk/client-s3";
import express from "express";
import { createServer } from "node:http";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import multer from "multer";

const app = express();
const server = createServer(app);
const port = 7962;
const bucket = process.env.BucketUri;

const viewUrl = join(dirname(fileURLToPath(import.meta.url)), "views");
const publicDir = join(dirname(fileURLToPath(import.meta.url)), "public");

if (!bucket) {
    console.log("Missing S3 bucket. Server will exit");
    process.exit(1);
}

const s3 = new S3Client({ region: "us-east-1" });

const storage = multer.memoryStorage();
const upload = multer({ storage });

app.set("view engine", "ejs");
app.set("views", viewUrl);
app.use(express.static(publicDir));
app.use(express.json());
app.get("/", async (req, res) => {
    const s3Images = [];
    const command = new ListObjectsCommand({ Bucket: bucket, MaxKeys: 10 });

    try {
        let truncated = true;
        while (truncated) {
            const { Contents, NextMarker, IsTruncated } = await s3.send(command);

            Contents.forEach(({ Key }) => {
                s3Images.push({ DocumentKey: Key });
            });

            truncated = IsTruncated;
            command.input.NextMarker = NextMarker;
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send("error loading page");
    }

    return res.render("index", { s3Images, BucketName: bucket });
});

/* 'multipart/form-data */
app.post("/upload", upload.single("picture"), async (req, res) => {
    const putObjectCommand = new PutObjectCommand({
        Bucket: bucket,
        Key: `images/${req.file.originalname}` /* take care of name collision in prod */,
        Body: req.file.buffer,
        ContentType: req.file.mimetype,
    });

    /* alternatively, setup streaming pipeline for image processing */
    try {
        /* use sharp to resize image before uploading */
        await s3.send(putObjectCommand);
    } catch (error) {
        console.log(error);
        res.status(500).send("error uploading file");
    }

    return res.redirect("/");
});

export default server.listen(port, () => {
    console.log("server is now listening on http://localhost:%s", port);
});
