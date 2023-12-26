// aslis_app.vala
using Gtk;
using GLib;

namespace AslisGtk {
    [GtkTemplate (ui = "/aslis/dpbo/id/pages/aslis_app.ui")]
    public class AslisApp : Gtk.ApplicationWindow {
        public string UserName;

        // Model Instances
        private Login LoginModel;
        private Register RegisterModel;
        private GridTernak GridTernakModel;

        // App Pages
        [GtkChild]
        private unowned Gtk.Stack pages;
        [GtkChild]
        private unowned Gtk.StackPage loginPage;
        [GtkChild]
        private unowned Gtk.StackPage registerPage;
        [GtkChild]
        private unowned Gtk.StackPage homePage;
        [GtkChild]
        private unowned Gtk.StackPage listTernakPageEmpty;
        //  [GtkChild]
        //  private unowned Gtk.StackPage tambahTernakPage;
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

        // List Ternak Page Widget
        [GtkChild]
        private unowned Gtk.Button addButton;

        public AslisApp (Gtk.Application app) {
            var cssProvider = new Gtk.CssProvider ();
            cssProvider.load_from_resource ("/aslis/dpbo/id/style/aslis_app.css");
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), cssProvider, 1);

            Object (application: app);

            // Initialized Model
            LoginModel = new Login ();
            RegisterModel = new Register ();
            GridTernakModel = new GridTernak ();
            //  var WindowModel = new Window ();

            // Set name for each pages
            registerPage.set_name("registerPage");
            loginPage.set_name("loginPage");
            homePage.set_name("homePage");
            listTernakPageEmpty.set_name("listTernakPageEmpty");
            //  tambahTernakPage.set_name("tambahTernakPage");
            windowPage.set_name("windowPage");

            // Event Listener
            login_button.clicked.connect (() => {
                pages.set_visible_child_name("loginPage");
            });

            register_button.clicked.connect (() => {
                pages.set_visible_child_name("registerPage");
            });

            loginButton.clicked.connect (() => {
                if (checkLogin ()) {
                    if (this.build_grid()) {
                        pages.set_visible_child_name("listTernakPage");
                    } else {
                        pages.set_visible_child_name("listTernakPageEmpty");
                    }
                }
            });

            registerButton.clicked.connect (() => {
                if (registerAccount ()) {
                    if (this.build_grid()) {
                        pages.set_visible_child_name("listTernakPage");
                    } else {
                        pages.set_visible_child_name("listTernakPageEmpty");
                    }
                }
            });

            addButton.clicked.connect (add_button_handler);
        }

        public bool build_grid () {
            // Add GridView for List Ternak
            Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow ();
            pages.add_named(swin, "listTernakPage");
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 3);
            Gtk.Button back_btn = new Gtk.Button.with_label("Back");
            back_btn.clicked.connect(back_btn_handler);
            Gtk.Button add_button = new Gtk.Button.with_label("Tambah Ternak");
            add_button.clicked.connect(add_button_handler);

            GLib.ListStore? model = GridTernakModel.readTernak(UserName);
            if (model != null) {
                Gtk.GridView grid_ternak = new Gtk.GridView(new Gtk.NoSelection(model), new Gtk.BuilderListItemFactory.from_resource(null, "/aslis/dpbo/id/pages/grid.ui"));
                grid_ternak.set_min_columns(1);
                grid_ternak.set_max_columns(1);
    
                // Add the GridView to the window
                box.append(back_btn);
                box.append(add_button);
                box.append(grid_ternak);
                swin.set_child(box);
                
                return true;
            }
            return false;
        }

        private void back_btn_handler() {
            pages.set_visible_child_name("");
            pages.set_visible_child_name("listTernakPage");
        }

        private void add_button_handler() {
            var modalWin = new AslisGtk.AddTernakModal (UserName, this);
            modalWin.set_modal(true);
            modalWin.set_resizable(false);
            modalWin.set_default_size(1000, 750);
            modalWin.present();
        }

        private bool checkLogin () {
            string username = usernameEntry.text;
            string password = passwordEntry.text;

            if ((username == null || username.length == 0) || (password == null || password.length == 0)) {
                resultLabel.set_label("Username and password are required!");
                return false;
            }

            // Check login credentials
            if (LoginModel.checkCredentials (username, password)) {
                resultLabel.set_label("Login successful!");
                UserName = username;
                return true;
            } else {
                resultLabel.set_label("Login failed. Please check your credentials.");
                return false;
            }
        }

        private bool registerAccount () {
            string username = usernameEntry_register.text;
            string password = passwordEntry_register.text;
    
            if ((username == null || username.length == 0) || (password == null || password.length == 0)) {
                resultLabel_register.set_label("Username and password are required!");
                return false;
            }
    
            // Check if the account already exists
            if (RegisterModel.accountExists(username)) {
                resultLabel_register.set_label("Account already exists. Choose a different username.");
                return false;
            }
    
            // Add the account to the database
            if (RegisterModel.addAccount(username, password)) {
                resultLabel_register.set_label("Registration successful!");
                UserName = username;
                return true;
            } else {
                resultLabel_register.set_label("Registration failed. Please try again.");
                return false;
            }
        }
    }
}