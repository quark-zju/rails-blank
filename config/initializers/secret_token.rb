# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
RailsApp::Application.config.secret_key_base = CONFIG[:secret_token] || '021b03de120420e3d5a27b969b375fb6279be3403c6e255180983df9a9530182cc016e4904183e9c5c1cd3f9b4f6362e4e5241152063f6f4dbb2695ac4995372'
