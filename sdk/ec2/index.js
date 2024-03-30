import { EC2Client, DescribeImagesCommand } from "@aws-sdk/client-ec2";

const client = new EC2Client({ region: "us-east-1" });

export default async function () {
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

        return results.Images.map((image) => ({ amiId: image.ImageId, description: image.Description })).slice(0, 5);
    } catch (error) {
        console.log(error);
    }
}
