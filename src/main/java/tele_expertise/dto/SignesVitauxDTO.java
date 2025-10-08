package tele_expertise.dto;

public class SignesVitauxDTO {

    private int id;
    private double temperature;
    private double tensionSystolique;
    private int frequenceRespiratoire;
    private double tensionDiastolique;
    private double saturation;

    public SignesVitauxDTO() {}

    public SignesVitauxDTO(int id, double temperature, double tensionSystolique,
                           int frequenceRespiratoire, double tensionDiastolique, double saturation) {
        this.id = id;
        this.temperature = temperature;
        this.tensionSystolique = tensionSystolique;
        this.frequenceRespiratoire = frequenceRespiratoire;
        this.tensionDiastolique = tensionDiastolique;
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

    public double getTensionSystolique() {
        return tensionSystolique;
    }

    public void setTensionSystolique(double tensionSystolique) {
        this.tensionSystolique = tensionSystolique;
    }

    public int getFrequenceRespiratoire() {
        return frequenceRespiratoire;
    }

    public void setFrequenceRespiratoire(int frequenceRespiratoire) {
        this.frequenceRespiratoire = frequenceRespiratoire;
    }

    public double getTensionDiastolique() {
        return tensionDiastolique;
    }

    public void setTensionDiastolique(double tensionDiastolique) {
        this.tensionDiastolique = tensionDiastolique;
    }

    public double getSaturation() {
        return saturation;
    }

    public void setSaturation(double saturation) {
        this.saturation = saturation;
    }
}
