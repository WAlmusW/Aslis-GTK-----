using GLib;

namespace AslisGtk {
    public class Register {
        public bool accountExists (string username) {
            File file = File.new_for_path ("src/database/accounts.csv");
            try {
                FileInputStream @is = file.read ();
                DataInputStream dis = new DataInputStream (@is);
                string line;

                while ((line = dis.read_line ()) != null) {
                    string[] fields = line.split (",");

                    // Assuming the CSV structure is: username,password
                    if (fields.length >= 1 && fields[0] == username) {
                        return true; // Account already exists
                    }
                }
            } catch (Error e) {
                print ("Error: %s\n", e.message);
            }

            return false; // Account not found
        }

        public bool addAccount (string username, string password) {
            File file = File.new_for_path ("src/database/accounts.csv");
            try {
                // Open the file in append mode
                GLib.FileOutputStream os = file.append_to (GLib.FileCreateFlags.NONE);

                // Create a new line with username and password
                string accountLine = "%s,%s\n".printf(username, password);
                uint8[] dataBytes = accountLine.data;

                // Write the new line to the file
                os.write (dataBytes, null);
                return true; // Registration successful
            } catch (Error e) {
                print ("Error: %s\n", e.message);
            }

            return false; // Registration failed
        }
    }
}