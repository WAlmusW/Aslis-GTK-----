// Ternak.vala
namespace AslisGtk {
    public class Ternak {
        public int id;
        public string nama;
        public string umur;
        public double berat;
        public double gender;
        public string tempat_lahir;

        public Ternak (int id, string nama, string umur, double berat, double gender, string tempat_lahir) {
            this.id = id;
            this.nama = nama;
            this.umur = umur;
            this.berat = berat;
            this.gender = gender;
            this.tempat_lahir = tempat_lahir;
        }
    }
}