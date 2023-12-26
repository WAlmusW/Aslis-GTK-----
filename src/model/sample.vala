// sample.vala
namespace AslisGtk {
    public class SampleData {
        public static Kandang createSampleKandang () {
            var kandang = new Kandang();
            kandang.add(1, "Kambing Macho", "5", 20.0, "Male", "Penangkaran Asi");
            kandang.add(2, "Kambing Machan", "6", 10.0, "Female", "Penangkaran Asi");
            // Add more sample Ternak as needed
            return kandang;
        }
    }
}
