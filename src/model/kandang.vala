// Kandang.vala
namespace AslisGtk {
    public class Kandang {
        public Gee.ArrayList<Ternak> list_ternak;

        public Kandang () {
            list_ternak = new Gee.ArrayList<Ternak>();
        }

        public void add (int id, string nama, string umur, double berat, double gender, string tempat_lahir) {
            Ternak ternak = new Ternak(id, nama, umur, berat, gender, tempat_lahir);
            list_ternak.add(ternak);
        }

        public void delete (string nama) {
            for (int i = 0; i < list_ternak.size; i++) {
                if (list_ternak[i].nama == nama) {
                    list_ternak.remove_at(i);
                    break;
                }
            }
        }

        public int count () {
            return list_ternak.size;
        }
    }
}
