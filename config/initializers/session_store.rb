# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dayday3_session',
  :secret      => '7fae527ca4f8939a6b968f37a815a17b8fd36e311107284f0e207bf837b988db304f885405382fbcaed8f4b4eccbe797b0037474c28017451438ad646d10cbd9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
