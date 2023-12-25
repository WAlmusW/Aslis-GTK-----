using GLib;

namespace AslisGtk {
    public class Login {
        public bool checkCredentials (string username, string password) {
            File file = File.new_for_path ("src/database/accounts.csv");
            try {
                FileInputStream @is = file.read ();
                DataInputStream dis = new DataInputStream (@is);
                string line;

                while ((line = dis.read_line ()) != null) {
                    string[] fields = line.split (",");

                    // Assuming the CSV structure is: username,password
                    if (fields.length >= 2 && fields[0] == username && fields[1] == password) {
                        return true; // Credentials found
                    }
                }
            } catch (Error e) {
                print ("Error: %s\n", e.message);
            }

            return false; // Credentials not found
        }
    }
}