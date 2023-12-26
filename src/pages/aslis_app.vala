// aslis_app.vala
using Gtk;
using GLib;

namespace AslisGtk {
    [GtkTemplate (ui = "/aslis/dpbo/id/pages/aslis_app.ui")]
    public class AslisApp : Gtk.ApplicationWindow {
        public string UserName;

        // Model Instances
        private GridTernak GridTernakModel;

        // App Pages
        [GtkChild]
        private unowned Gtk.Stack pages;
        [GtkChild]
        private unowned Gtk.StackPage listTernakPageEmpty;
        //  [GtkChild]
        //  private unowned Gtk.StackPage tambahTernakPage;
        [GtkChild]
        private unowned Gtk.StackPage windowPage;

        // List Ternak Page Widget
        [GtkChild]
        private unowned Gtk.Button addButton;
        

        public AslisApp (Gtk.Application app) {
            var cssProvider = new Gtk.CssProvider ();
            cssProvider.load_from_resource ("/aslis/dpbo/id/style/aslis_app.css");
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), cssProvider, 1);

            Object (application: app);

            // Initialized Model
            //  GridTernakModel = new GridTernak ();
            //  var WindowModel = new Window ();

            // Set name for each pages
            listTernakPageEmpty.set_name("listTernakPageEmpty");
            //  tambahTernakPage.set_name("tambahTernakPage");
            windowPage.set_name("windowPage");

            Gtk.Box blank = new Gtk.Box(Gtk.Orientation.VERTICAL, 1);
            pages.add_named(blank, "blank");

            string path = "src/database/ternak.csv";
            if (file_exists(path)) {
                build_grid();
                refresh_handler();
            }

            addButton.clicked.connect (add_button_handler);
        }

        bool file_exists(string filePath) {
            File file = File.new_for_path(filePath);
            return file.query_exists();
        }

        public bool build_grid () {
            // Add GridView for List Ternak
            GridTernakModel = new GridTernak ();

            Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow ();
            swin.add_css_class("body");
            pages.add_named(swin, "listTernakPage");

            Gtk.Box box_main = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);
            box_main.add_css_class("main");

            Gtk.Box box_buttons = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
            box_buttons.set_hexpand(true);
            box_buttons.set_halign(Gtk.Align.FILL);
            box_buttons.add_css_class("buttons");

            Gtk.Box box_ternak = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);
            box_ternak.set_hexpand(true);
            box_ternak.set_halign(Gtk.Align.FILL);
            box_ternak.add_css_class("ternak");

            Gtk.Button refresh_button = new Gtk.Button.with_label("Refresh Tabel");
            refresh_button.add_css_class ("refresh");
            refresh_button.clicked.connect(refresh_handler);

            Gtk.Button delete_button = new Gtk.Button.with_label("Delete Tabel");
            delete_button.add_css_class ("delete_ternak");
            delete_button.clicked.connect(delete_button_handler);

            Gtk.Button add_button = new Gtk.Button.with_label("Tambah Ternak");
            delete_button.add_css_class ("tambah_ternak");
            add_button.clicked.connect(add_button_handler);

            GLib.ListStore? model = GridTernakModel.readTernak();
            if (model != null) {
                Gtk.GridView grid_ternak = new Gtk.GridView(new Gtk.NoSelection(model), new Gtk.BuilderListItemFactory.from_resource(null, "/aslis/dpbo/id/pages/grid.ui"));
                grid_ternak.set_min_columns(1);
                grid_ternak.set_max_columns(1);
    
                // Add the GridView to the window
                box_buttons.append(refresh_button);
                box_buttons.append(delete_button);
                box_buttons.append(add_button);
                box_main.append(box_buttons);
                box_ternak.append(grid_ternak);
                box_main.append(box_ternak);
                swin.set_child(box_main);
                
                return true;
            }
            return false;
        }

        private void delete_button_handler() {
            string path = "src/database/ternak.csv";
            File file = File.new_for_path(path);
            try {
                file.delete();
            } catch (Error e) {
                stderr.printf("Error deleting file: %s\n", e.message);
            }
            refresh_handler ();
        }

        private void add_button_handler() {
            var modalWin = new AslisGtk.AddTernakModal ( this);
            modalWin.set_modal(true);
            modalWin.set_resizable(false);
            modalWin.set_default_size(1000, 750);
            modalWin.present();

            modalWin.close_request.connect(() => {
                refresh_handler ();
                modalWin.destroy();
                return true;
            });
        }


        public void refresh_handler () {
            pages.set_visible_child_name("blank");
            if (pages.get_child_by_name ("listTernakPage") != null) {
                pages.remove(pages.get_child_by_name ("listTernakPage"));
            }
            if (this.build_grid()) {
                pages.set_visible_child_name("listTernakPage");
            } else {
                pages.set_visible_child_name("listTernakPageEmpty");
            }
        }
    }
}