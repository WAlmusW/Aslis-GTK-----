// login.vala
using Gtk;
using GLib;

namespace AslisGtk {
    [GtkTemplate (ui = "/aslis/dpbo/id/pages/aslis_app.ui")]
    public class AslisApp : Gtk.ApplicationWindow {
        public string UserName;

        // Model Instances
        private Login LoginModel;
        private Register RegisterModel;

        // App Pages
        [GtkChild]
        private unowned Gtk.Stack pages;
        [GtkChild]
        private unowned Gtk.StackPage loginPage;
        [GtkChild]
        private unowned Gtk.StackPage registerPage;
        [GtkChild]
        private unowned Gtk.StackPage windowPage;

        // Login Page Widget
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

        // Register Page Widget
        [GtkChild]
        private unowned Gtk.Button login_button;
        [GtkChild]
        private unowned Gtk.Entry usernameEntry_register;
        [GtkChild]
        private unowned Gtk.Entry passwordEntry_register;
        [GtkChild]
        private unowned Gtk.Label resultLabel_register;
        [GtkChild]
        private unowned Gtk.Button registerButton;

        public AslisApp (Gtk.Application app) {
            var cssProvider = new Gtk.CssProvider ();
            cssProvider.load_from_resource ("/aslis/dpbo/id/style/aslis_app.css");
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), cssProvider, 1);

            Object (application: app);

            // Initialized Model
            LoginModel = new Login ();
            RegisterModel = new Register ();
            //  var WindowModel = new Window ();

            registerPage.set_name("registerPage");
            loginPage.set_name("loginPage");
            windowPage.set_name("windowPage");

            // Event Listener
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
            if (LoginModel.checkCredentials (username, password)) {
                resultLabel.set_label("Login successful!");
                UserName = username;
                pages.set_visible_child_name("windowPage");
            } else {
                resultLabel.set_label("Login failed. Please check your credentials.");
            }
        }

        private void registerAccount () {
            string username = usernameEntry_register.text;
            string password = passwordEntry_register.text;
    
            if ((username == null || username.length == 0) || (password == null || password.length == 0)) {
                resultLabel.set_label("Username and password are required!");
                return;
            }
    
            // Check if the account already exists
            if (RegisterModel.accountExists(username)) {
                resultLabel.set_label("Account already exists. Choose a different username.");
                return;
            }
    
            // Add the account to the database
            if (RegisterModel.addAccount(username, password)) {
                resultLabel_register.set_label("Registration successful!");
                UserName = username;
                pages.set_visible_child_name("windowPage");
            } else {
                resultLabel_register.set_label("Registration failed. Please try again.");
            }
        }
    }
}