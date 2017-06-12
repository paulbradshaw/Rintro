# Getting a key for the Spotify API

In May 2017 Spotify [changed their API](https://developer.spotify.com/migration-guide-for-unauthenticated-web-api-calls/) so that *all* calls required authentication. This meant that you need to generate a key - and it's quite a complex process.

There are 4 steps to creating and using a key on Spotify:

1. Create an application on Spotify: this will give you a client ID and secret key
2. Convert the client ID and key to Base 64
3. Use command line to request an access token
4. You then need to know how to include this token in a request to the API

I'll go through each in turn.

## 1. Create an application to get a client ID and key

Log in to Spotify and [go to the My Applications section](https://developer.spotify.com/my-applications/): click **Create an app** and give it a name and description.

Once saved this will generate two codes: *Client ID* and *Client Secret*. You'll need to combine these to get a key to use with the API.

## 2. Convert the client ID and key to Base 64

The [Web API authorisation guide provides some guidance on how to get a key](https://developer.spotify.com/web-api/authorization-guide/#client-credentials-flow), but it's not hugely clear. One part explains that you will need a:

> Base 64 encoded string that contains the client ID and client secret key. The field must have the format: Authorization: Basic <base64 encoded client_id:client_secret>

To create a Base 64 encoded string go to [Base64](https://www.base64encode.org/):

1. First, paste the Client ID from your application page
2. Then, type a colon: `:` (don't add any spaces)
3. Next, and again without adding any space, paste the Client Secret from your application page
4. Now click the **ENCODE** button to generate the Base 64 encoded string that you'll need. It appears in the box below. Copy this for the next step.

## 3. Use command line to request an access token

The example in the [Web API authorisation guide](https://developer.spotify.com/web-api/authorization-guide/#client-credentials-flow) is:

`curl -H "Authorization: Basic ZjM4ZjAw...WY0MzE=" -d grant_type=client_credentials https://accounts.spotify.com/api/token`

`curl` indicates that this is something you need to do using command line. If you haven't used command line you can [find more about command line in my repo here](https://github.com/paulbradshaw/commandline).

Open your command line tool - Terminal (Mac) or PowerShell (Windows). Type:

`curl -H "Authorization: Basic ` followed by the Base64 string you generated and copied in the last step. Then complete the command with `" -d grant_type=client_credentials https://accounts.spotify.com/api/token`

You should get a response like this:

`{"access_token":"BLAHBLAHBLAHCOPYTHIS","token_type":"Bearer","expires_in":3600}`

You can copy this text into a text editor so it's easier to cut the token (in quotation marks after `{"access_token":`) out.

## 4. You then need to know how to include this token in a request to the API

You can now use that token with requests that previously didn't need one, by adding `&access_token=` at the end of the URL, followed by your token, like this:

`https://api.spotify.com/v1/artists/7MhMgCo0Bl0Kukl93PZbYS/top-tracks?country=GB&access_token=BLAHBLAHBLAHPASTETHIS`
