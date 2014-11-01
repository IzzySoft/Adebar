# Adebar GUI
You might have noticed, there is no fancy user-friendly GUI to Adebar,
everything is working via config files and command-line stuff. Sorry for that.

Second sorry for not promising there will be one – soon or at all. I lack the
time to deal with that – and rather concentrate on adding new features, if I get
some more ideas :)

Still, that doesn't necessarily mean there will be no GUI. ***You*** might
provide one, for example: *Adebar* is open-source, and the code is [available
at Github][1]. So you can fork the project, play with it, add a GUI, and
send a pull-request "upstream" (to me, that is).

## Suggestion for implementing a GUI
Browsing the code, you might have seen the main script is not simply called
`adebar`, but `adebar-cli`. That was done incidentally, with a GUI pendant in
mind – which should be named `adebar-gui`.

Interfacing with the CLI script shouldn't be a big deal. My "basic ideas" on
how the GUI could work are:

* Using a nice form, it asks the user for settings. It could provide means
  to read defaults from files and save them there (see the `hints.md`
  document on *Configuration*)
* When the "Run" button is pressed, it writes a temporary config file
  into the `config/` directory, and passes its name to `adebar-cli`.
  When not using one of the user's explicitly stored configs (i.e. when using
  a "temporary file"), additionally to the options described the GUI defines
  the `OUTDIR` variable with what the user wanted it to be. So when "sourcing"
  the config file, `adebar-cli` would be updated accordingly.
* After `adebar-cli` is done, the "temporary config" (if any) should be removed.

The GUI could capture STDOUT and STDERR from the CLI script to provide the user
with feedback.

I possibly missed something here. If you find it, feel free to contact me: Of
course I'm open to make adjustments, when needed, to help the GUI.


[1]: https://github.com/IzzySoft/Adebar "Adebar at Github"
