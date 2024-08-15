<h1>Spotify Library Random Album Generator</h1>

<p>
  This is a pretty simple app! Lives here: https://spotify-random-liked-albums-cde946bf36b7.herokuapp.com/ (but as of now Spotify hasn't approved my app on their side, so only select users can use the API -- AKA make my app work for them. Let me know if you would like access!)
</p>

<p>
  I have a bad habit of saving all albums that seem interesting to me, with the mentality that if I save it I'll listen to it eventually... how wrong I always am.
  I got to a point where I had 3000+ albums saved (or "liked" technically), and I have probably listened to about half of that.
</p>

<p>
  That being said, my music taste started to get a bit stagnant recently, and I realized why... 
</p>

<p>
  Everytime I opened my Spotify with the mentality of "lemme go pick out something I've never listened to", I would quickly get overwhelmed by how many choices I had, and ended up just going to listen to an album I already knew I loved.
</p>

<p>
  That's where this app comes in! The sheer volume of my library is what intimidated me, so I wanted to build something that gave me limited choices, and that way I could quickly choose what felt like my vibe at the time
</p>

<img width="680" alt="image" src="https://github.com/user-attachments/assets/09f2b27b-e01b-464a-8f24-08d43f74e32e">
<p>
  This is a Ruby on Rails app that uses vanilla JavaScript on the front end. Using Spotify's API and Oauth flow, users are able to connect their Spotify account to the app, in which I store all of their liked albums and all the necessary profile information into a PostgreSQL database for easy updating, deleting, and creating of records. We then give them the ability to grab 5 random albums from their library for easy choosing of their next album to listen to.
</p>
