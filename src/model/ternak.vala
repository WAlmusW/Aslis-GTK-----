using Gee;

public class Ternak {
    public int id;
    public string nama;
    public string umur;
    public float berat;
    public float gender;
    public string tempat_lahir;

    public Ternak (int id, string nama, string umur, float berat, float gender, string tempat_lahir) {
        this.nama = nama;
        this.umur = umur;
        this.berat = berat;
        this.gender = gender;
        this.tempat_lahir = tempat_lahir;
    }
}