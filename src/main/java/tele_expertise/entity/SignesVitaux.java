package tele_expertise.entity;
import jakarta.persistence.*;

@Entity
@Table(name = "signesvitaux")
public class SignesVitaux {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private double temperature;


    @Column(nullable = false)
    private double tensionsystolique ;

    @Column(nullable = false)
    private int frequencerespiratoire;



    @Column(nullable = false)
    private double tensiondiastolique;

    @Column(nullable = false)
    private double saturation;

    public SignesVitaux() {}
    public SignesVitaux(int id, double temperature, double tensionsystolique, int frequencerespiratoire, double tensiondiastolique, double saturation) {
        this.id = id;
        this.temperature = temperature;
        this.tensionsystolique = tensionsystolique;
        this.frequencerespiratoire = frequencerespiratoire;
        this.tensiondiastolique = tensiondiastolique;
        this.saturation = saturation;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getTemperature() {
        return temperature;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }

    public double getTensionsystolique() {
        return tensionsystolique;
    }

    public void setTensionsystolique(double tensionsystolique) {
        this.tensionsystolique = tensionsystolique;
    }

    public int getFrequencerespiratoire() {
        return frequencerespiratoire;
    }

    public void setFrequencerespiratoire(int frequencerespiratoire) {
        this.frequencerespiratoire = frequencerespiratoire;
    }

    public double getTensiondiastolique() {
        return tensiondiastolique;
    }

    public void setTensiondiastolique(double tensiondiastolique) {
        this.tensiondiastolique = tensiondiastolique;
    }

    public double getSaturation() {
        return saturation;
    }

    public void setSaturation(double saturation) {
        this.saturation = saturation;
    }
}
