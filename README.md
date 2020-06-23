# p6-GStreamer

## Installation

Make a directory to contain the p6-Gtk-based projects. Once made, then set the P6_GTK_HOME environment variable to that directory:

```
$ export P6_GTK_HOME=/path/to/projects
```

Switch to that directory and clone both p6-GLib and p6-GStreamer

```
$ git clone https://github.com/Xliff/p6-GLib.git
$ git clone https://github.com/Xliff/p6-GStreamer.git
```

[Optional] - You can also check out p6-Pango and p6-GtkPlus for those examples that need them.

```
$ git clone https://github.com/Xliff/p6-Pango.git
$ git clone https://github.com/Xliff/p6-GtkPlus.git
```

Install dependencies
```
$ cd p6-GLib
$ zef install --deps-only .
```

[Optional] To build all of GStreamer and its required modules, you can change to the p6-GStreamer directory and do:

```
./build.sh
```

If you just want to run the examples, you can do:

```
./p6gtkexec t/<name of example>
```

Unfortunately, compile times are very long for this project, but I hope you will find it interesting!
