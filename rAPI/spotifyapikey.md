# Getting a key for the Spotify API

In May 2017 Spotify changed their API so that *all* calls required authentication. This meant that you need to generate a key - and it's quite a complex process.

There are 4 steps to creating and using a key on Spotify:

1. Create an application on Spotify: this will give you a client ID and secret key
2. Convert the client ID and key to Base 64
3. Use command line to request an access token
4. You then need to know how to include this token in a request to the API

I'll go through each in turn.

## Create an application to get a client ID and key

