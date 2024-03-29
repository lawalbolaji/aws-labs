const { EC2Client, DescribeImagesCommand } = require("@aws-sdk/client-ec2");

const client = new EC2Client({ region: "us-east-1" });

(async () => {
    try {
        const results = await client.send(
            new DescribeImagesCommand({
                Filters: [
                    {
                        Name: "description",
                        Values: ["Amazon Linux AMI*"],
                    },
                ],
            })
        );

        console.log(
            results.Images.map((image) => ({ amiId: image.ImageId, description: image.Description })).slice(0, 5)
        );
    } catch (error) {
        console.log(error);
    }
})();
