#!/usr/bin/env python3

import sys
import signal

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")

from gi.repository import Gtk, GtkLayerShell


class Tooltip(Gtk.Window):

    def __init__(self, title, content, x):
        super().__init__(type=Gtk.WindowType.TOPLEVEL)

        self.title_text = title
        self.content_text = content
        self.x = x

        self.set_name("gtk-tooltip")
        self.set_decorated(False)
        self.set_resizable(False)
        self.set_keep_above(True)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)

        self.setup_layer_shell()
        self.load_css()
        self.build_ui()

        self.connect("button-press-event", self.close)
        self.connect("key-press-event", self.key_press)

    def setup_layer_shell(self):
        GtkLayerShell.init_for_window(self)

        GtkLayerShell.set_layer(
            self,
            GtkLayerShell.Layer.OVERLAY,
        )

        # Position below Waybar.
        GtkLayerShell.set_anchor(
            self,
            GtkLayerShell.Edge.TOP,
            True,
        )

        GtkLayerShell.set_margin(
            self,
            GtkLayerShell.Edge.TOP,
            36,
        )

        # Position horizontally.
        GtkLayerShell.set_anchor(
            self,
            GtkLayerShell.Edge.LEFT,
            True,
        )

        GtkLayerShell.set_margin(
            self,
            GtkLayerShell.Edge.LEFT,
            self.x,
        )

        # Do not reserve space.
        GtkLayerShell.set_exclusive_zone(
            self,
            -1,
        )

    def build_ui(self):
        box = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL,
            spacing=8,
        )

        box.set_margin_top(12)
        box.set_margin_bottom(12)
        box.set_margin_start(14)
        box.set_margin_end(14)

        title_label = Gtk.Label(
            label=self.title_text,
        )
        title_label.set_xalign(0)
        title_label.set_name("title")

        content_label = Gtk.Label(
            label=self.content_text,
        )
        content_label.set_xalign(0)
        content_label.set_selectable(True)
        content_label.set_name("content")

        box.pack_start(
            title_label,
            False,
            False,
            0,
        )

        box.pack_start(
            content_label,
            False,
            False,
            0,
        )

        self.add(box)

    def load_css(self):
        css = Gtk.CssProvider()

        css.load_from_data(
            b"""
            #gtk-tooltip {
                background-color: rgba(0, 0, 0, 1);
                border: 2px solid rgba(100, 114, 125, 1);
                border-radius: 4px;
            }

            #title {
                color: #ffffff;
                font-family: "DejaVu Sans";
                font-size: 14pt;
                font-weight: bold;
            }

            #content {
                color: #ffffff;
                font-family: "DejaVu Sans";
                font-size: 11pt;
            }

            #content selection {
                background-color: #64727d;
                color: #ffffff;
            }
            """,
        )

        Gtk.StyleContext.add_provider_for_screen(
            self.get_screen(),
            css,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
        )

    def close(self, *_):
        Gtk.main_quit()
        return True

    def key_press(self, _, event):
        if event.keyval == 65307:
            Gtk.main_quit()
            return True

        return False


def main():
    if len(sys.argv) < 4:
        print(
            f"Usage: {sys.argv[0]} TITLE CONTENT X",
            file=sys.stderr,
        )
        sys.exit(1)

    try:
        x = int(sys.argv[3])
    except ValueError:
        print(
            "X must be an integer",
            file=sys.stderr,
        )
        sys.exit(1)

    window = Tooltip(
        sys.argv[1],
        sys.argv[2],
        x,
    )

    window.show_all()

    signal.signal(
        signal.SIGTERM,
        lambda *_: Gtk.main_quit(),
    )

    signal.signal(
        signal.SIGINT,
        lambda *_: Gtk.main_quit(),
    )

    Gtk.main()


if __name__ == "__main__":
    main()
