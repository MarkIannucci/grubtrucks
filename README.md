## Estee Lauder Assessment Challenge (grubtrucks)

## Summary

Not being a true developer and mainly dabbling in it from a hobbyist perspective, I looked at this challange as an educational opportunity.
I chose to tackle this using Javascript for all of the dynamic requirements as the API did not require any authentication, so there was no security concerns regarding the call.
Furthermore, this reduced the compute requirements from the server side, minimizing costs. The dataset received by the API call was quite small which also supported the edge compute decision.

This was also my first attempt at using GitHub actions for deployment.
We are primarily a GitLab shop, so I had to familiarize myself with the syntax differences.

## Code

### JavaScript/Stylesheet References

I put the required JavaScript and StyleSheet files in their respective subdirectories (js/css).
Typically, I would put these files in an internal managed package and include them. 
This provides the development operations team more granular control of change within the application versus 
referencing the packages from their external source or using static copies which go stale.

### UI

For the UI I grabbed a free BootStrap template to make the site a bit presentable. 
I made the following minor modifications to the template
* Removed user profile components
* Removed static table elements as I planned to populate them with the JavaScript function
* Modified the DataTable.js to remove the check for an empty table element during page load. I would have preferred to avoid modifying this file as it will complicate updates. However I did not have the time to investigate further.

### JavaScript Code

I created a JavaScript function ./src/js/grubtrucks.js that includes all of that I wrote to pull and display data from the Open API.

## Infrastructure

## Deployment

### Requirements

* AWS Account
    * IAM User Account with programmatic access for the access key secrets below
        * User Policy
        ````JSON
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "VisualEditor0",
                    "Effect": "Allow",
                    "Action": [
                        "sts:AssumeRole",
                        "sts:TagSession"
                    ],
                    "Resource": [
                        "arn:aws:iam::489312212545:role/psbtestrole"
                    ]
                }
            ]
        }
        ````
    * IAM Role with required priviledges to deploy resources to the AWS Account

* Secrets:
    * AWS_ACCESS_KEY_ID
    * AWS_SECRET_ACCESS_KEY
    * AWS_ROLE_TO_ASSUME
