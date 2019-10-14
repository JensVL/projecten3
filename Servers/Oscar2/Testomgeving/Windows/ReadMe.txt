
Installation Steps:

1. Create your db and db user
2. Open user.config.sample in a text editor and save as user.config
3. Set the correct connection string in user.config
4. Copy the contents of the  wwwroot folder to the root of your web site.
5. Make sure the /Data folder and /App_Data folder are completely writable by the web process user (the user that is the identity on the application pool is th euser who needs permission), set permissions on these folders if needed to make them wriable. No other folders need to be writable.
6. Visit yoursiteroot/Setup/Default.aspx to complete the installation, it will run all the needed db scripts and other configuration steps.

For more information:
http://www.mojoportal.com/installation.aspx

