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
            string item = @"%s %s\n%s Tahun - %s kg - %s - %s".printf(fields[0], fields[1], fields[2], fields[3], fields[4], fields[5]);
            this.model.append(new Gtk.Label(item));
        }
    }
}