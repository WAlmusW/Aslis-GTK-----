using GLib;

namespace AslisGtk {
    public class GridTernak {
        public GLib.ListStore model;

        public GridTernak() {
            model = new GLib.ListStore(GLib.Type.OBJECT);
        }

        public GLib.ListStore? readTernak () {
            string path = "src/database/ternak.csv";
            File file = File.new_for_path (path);
            try {
                FileInputStream @is = file.read ();
                DataInputStream dis = new DataInputStream (@is);
                string line;

                while ((line = dis.read_line ()) != null) {
                    if (line == "{id},{nama},{umur},{berat},{gender},{tempat_lahir}") {
                        continue;
                    }
                    string[] fields = line.split (",");
                    this.populateModel (fields);
                }
                return this.model;

            } catch (Error e) {
                print ("Error: %s\n", e.message);
                return null;
            }
        }

        public void populateModel (string[] fields) {
            message (@"%s - %s".printf(fields[0], fields[1]));
            string title = "ID %s - %s".printf(fields[0], fields[1]);
            string detail = "- Umur %s Tahun\n- Berat %s kg\n- Kelamin %s\n- Tempat Lahir %s".printf(fields[2], fields[3], fields[4], fields[5]);

            Gtk.Label labelTitle = new Gtk.Label(title);
            Gtk.Label labelDetail = new Gtk.Label(detail);

            labelTitle.add_css_class ("grid_item_title");
            labelDetail.add_css_class ("grid_item_detail");

            this.model.append(labelTitle);
            this.model.append(labelDetail);
        }
    }
}