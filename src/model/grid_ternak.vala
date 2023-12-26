using GLib;

namespace AslisGtk {
    public class GridTernak {
        public GLib.ListStore model;

        public GridTernak() {
            model = new GLib.ListStore(GLib.Type.OBJECT);
        }

        public GLib.ListStore? readTernak (string username) {
            string path = "src/database/%s_ternak.csv".printf(username);
            File file = File.new_for_path (path);
            try {
                FileInputStream @is = file.read ();
                DataInputStream dis = new DataInputStream (@is);
                string line;

                int count = 1;
                while ((line = dis.read_line ()) != null) {
                    if (line == "{id},{nama},{umur},{berat},{gender},{tempat_lahir}") {
                        continue;
                    }
                    string[] fields = line.split (",");
                    this.populateModel (fields, count);
                    count++;
                }
                return this.model;

            } catch (Error e) {
                print ("Error: %s\n", e.message);
                return null;
            }
        }

        public void populateModel (string[] fields, int count) {
            message (@"%s - %s".printf(fields[0], fields[1]));
            string item = @"%d %s\n%s Tahun - %s kg - %s - %s".printf(count, fields[1], fields[2], fields[3], fields[4], fields[5]);
            this.model.append(new Gtk.Label(item));
        }
    }
}