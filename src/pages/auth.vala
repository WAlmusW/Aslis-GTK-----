// login.vala
using Gtk;
using GLib;

namespace AslisGtk {
    [GtkTemplate (ui = "/aslis/dpbo/id/pages/auth.ui")]
    public class AuthWindow : Gtk.ApplicationWindow {
        public string UserName;

        [GtkChild]
        private unowned Gtk.Stack pages;
        [GtkChild]
        private unowned Gtk.StackPage loginPage;
        [GtkChild]
        private unowned Gtk.StackPage registerPage;
        [GtkChild]
        private unowned Gtk.StackPage windowPage;
        [GtkChild]
        private unowned Gtk.Button login_button;
        [GtkChild]
        private unowned Gtk.Button register_button;
        [GtkChild]
        private unowned Gtk.Entry usernameEntry;
        [GtkChild]
        private unowned Gtk.Entry passwordEntry;
        [GtkChild]
        private unowned Gtk.Label resultLabel;
        [GtkChild]
        private unowned Gtk.Button loginButton;
        [GtkChild]
        private unowned Gtk.Entry usernameEntry_register;
        [GtkChild]
        private unowned Gtk.Entry passwordEntry_register;
        [GtkChild]
        private unowned Gtk.Label resultLabel_register;
        [GtkChild]
        private unowned Gtk.Button registerButton;

        public AuthWindow (Gtk.Application app) {
            var cssProvider = new Gtk.CssProvider ();
            cssProvider.load_from_resource ("/aslis/dpbo/id/style/auth.css");
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), cssProvider, 1);

            Object (application: app);

            registerPage.set_name("registerPage");
            loginPage.set_name("loginPage");
            windowPage.set_name("windowPage");

            // Connect button click event
            login_button.clicked.connect (() => {
                pages.set_visible_child_name("loginPage");
            });

            register_button.clicked.connect (() => {
                pages.set_visible_child_name("registerPage");
            });

            loginButton.clicked.connect (() => {
                checkLogin ();
            });

            registerButton.clicked.connect (() => {
                registerAccount ();
            });
        }

        private void checkLogin () {
            string username = usernameEntry.text;
            string password = passwordEntry.text;

            if ((username == null || username.length == 0) || (password == null || password.length == 0)) {
                resultLabel.set_label("Username and password are required!");
                return;
            }

            // Check login credentials
            if (checkCredentials (username, password)) {
                resultLabel.set_label("Login successful!");
                UserName = username;
                pages.set_visible_child_name("windowPage");
            } else {
                resultLabel.set_label("Login failed. Please check your credentials.");
            }
        }

        private bool checkCredentials (string username, string password) {
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

        private void registerAccount () {
            string username = usernameEntry_register.text;
            string password = passwordEntry_register.text;
    
            if ((username == null || username.length == 0) || (password == null || password.length == 0)) {
                resultLabel.set_label("Username and password are required!");
                return;
            }
    
            // Check if the account already exists
            if (accountExists(username)) {
                resultLabel.set_label("Account already exists. Choose a different username.");
                return;
            }
    
            // Add the account to the database
            if (addAccount(username, password)) {
                resultLabel_register.set_label("Registration successful!");
                UserName = username;
                pages.set_visible_child_name("windowPage");
            } else {
                resultLabel_register.set_label("Registration failed. Please try again.");
            }
        }

        private bool accountExists (string username) {
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

        private bool addAccount (string username, string password) {
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