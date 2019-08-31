# p6-GStreamer

## Installation

Make a directory to contain the p6-Gtk-based projects. Once made, then set the P6_GTK_HOME environment variable to that directory:

```
$ export P6_GTK_HOME=/path/to/projects
```

Switch to that directory and clone both p6-GtkPlus and p6-GStreamer

```
$ git clone https://github.com/Xliff/p6-GtkPlus.git
$ git clone https://github.com/Xliff/p6-GStreamer.git
$ cd p6-GtkPlus
$ zef install --deps-only .
```

[Optional] To build all of GStreamer and the required GTK modules, you can change to the p6-GStreamer directory and do:

```
zef install --deps-only .
./build.sh
```

If you just want to run the examples, you can do:

```
./p6gtkexec t/<name of example>
```

Unfortunately, compile times are very long for this project, but I hope you find it interesting!
