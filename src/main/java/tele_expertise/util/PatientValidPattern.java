package tele_expertise.util;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;

public class PatientValidPattern {

    // ==============================
    // 🔹 Définition des Patterns
    // ==============================
    private static final Pattern PATTERN_NOM = Pattern.compile("^[a-zA-ZÀ-ÿ\\s'-]{2,50}$");
    private static final Pattern PATTERN_PRENOM = Pattern.compile("^[a-zA-ZÀ-ÿ\\s'-]{2,50}$");
    private static final Pattern PATTERN_NUM_SECU = Pattern.compile("^\\d{13}$");
    private static final Pattern PATTERN_TELEPHONE = Pattern.compile("^(\\+212|0)([5-7])[0-9]{8}$");
    private static final Pattern PATTERN_ADRESSE = Pattern.compile("^[A-Za-z0-9À-ÿ\\s,'-]{5,100}$");

    // ==============================
    // 🔹 Nom
    // ==============================
    public static boolean estNomValide(String nom) {
        if (nom == null || nom.trim().isEmpty()) return false;
        return PATTERN_NOM.matcher(nom.trim()).matches();
    }

    // 🔹 Prénom
    public static boolean estPrenomValide(String prenom) {
        if (prenom == null || prenom.trim().isEmpty()) return false;
        return PATTERN_PRENOM.matcher(prenom.trim()).matches();
    }

    // 🔹 Date de naissance
    public static boolean estDateNaissanceValide(String dateNaissance) {
        if (dateNaissance == null || dateNaissance.trim().isEmpty()) return false;
        try {
            LocalDate date = LocalDate.parse(dateNaissance);
            return !date.isAfter(LocalDate.now());
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    // 🔹 Numéro de sécurité sociale
    public static boolean estNumeroSecuriteSocialeValide(String numero) {
        if (numero == null || numero.trim().isEmpty()) return false;
        return PATTERN_NUM_SECU.matcher(numero.trim()).matches();
    }

    // 🔹 Téléphone
    public static boolean estTelephoneValide(String telephone) {
        if (telephone == null || telephone.trim().isEmpty()) return true; // facultatif
        return PATTERN_TELEPHONE.matcher(telephone.trim()).matches();
    }

    // 🔹 Adresse
    public static boolean estAdresseValide(String adresse) {
        if (adresse == null || adresse.trim().isEmpty()) return true; // facultatif
        return PATTERN_ADRESSE.matcher(adresse.trim()).matches();
    }

    // ==============================
    // 🔹 Température
    // ==============================
    public static boolean estTemperatureValide(double temperature) {
        try {
            double t = temperature;
            return t >= 35 && t <= 42;
        } catch (Exception e) {
            return false;
        }
    }

    // 🔹 Fréquence cardiaque
    public static boolean estFrequenceCardiaqueValide(int frequence) {
        try {
            int f = frequence;
            return f >= 40 && f <= 200;
        } catch (Exception e) {
            return false;
        }
    }

    // 🔹 Tension systolique
    public static boolean estTensionSystoliqueValide(double tension) {
        try {
            double t = tension;
            return t >= 70 && t <= 250;
        } catch (Exception e) {
            return false;
        }
    }

    // 🔹 Tension diastolique
    public static boolean estTensionDiastoliqueValide(double tension) {
        try {
            double t = tension;
            return t >= 40 && t <= 150;
        } catch (Exception e) {
            return false;
        }
    }

    // 🔹 Fréquence respiratoire
    public static boolean estFrequenceRespiratoireValide(int frequence) {
        try {
            int f = frequence;
            return f >= 10 && f <= 40;
        } catch (Exception e) {
            return false;
        }
    }

    // 🔹 Saturation en oxygène
    public static boolean estSaturationOxygeneValide(int saturation) {
        try {
            int s = saturation;
            return s >= 70 && s <= 100;
        } catch (Exception e) {
            return false;
        }
    }

    // ==============================
    // 🔹 Validation complète du patient
    // ==============================
    public static String validerPatient(
            String nom,
            String prenom,
            String dateNaissance,
            String numeroSecuriteSociale,
            String telephone,
            String adresse,
            double temperature,
            int frequenceRespiratoire,
            double tensionSystolique,
            double tensionDiastolique,
            int saturationOxygene
    ) {

        if (!estNomValide(nom)) return "Le nom est invalide (lettres uniquement, 2 à 50 caractères).";
        if (!estPrenomValide(prenom)) return "Le prénom est invalide (lettres uniquement, 2 à 50 caractères).";
        if (!estDateNaissanceValide(dateNaissance)) return "La date de naissance est invalide.";
        if (!estNumeroSecuriteSocialeValide(numeroSecuriteSociale)) return "Le numéro de sécurité sociale doit contenir exactement 13 chiffres.";
        if (!estTelephoneValide(telephone)) return "Le numéro de téléphone est invalide (format marocain attendu).";
        if (!estAdresseValide(adresse)) return "L’adresse doit comporter entre 5 et 100 caractères valides.";

        if (!estTemperatureValide(temperature)) return "La température doit être comprise entre 35°C et 42°C.";
        if (!estTensionSystoliqueValide(tensionSystolique)) return "La tension systolique doit être entre 70 et 250 mmHg.";
        if (!estTensionDiastoliqueValide(tensionDiastolique)) return "La tension diastolique doit être entre 40 et 150 mmHg.";
        if (!estFrequenceRespiratoireValide(frequenceRespiratoire)) return "La fréquence respiratoire doit être entre 10 et 40 rpm.";
        if (!estSaturationOxygeneValide(saturationOxygene)) return "La saturation O₂ doit être comprise entre 70% et 100%.";

        return null;
    }
    public static String validerPatientVital(
            double temperature,
            int frequenceRespiratoire,
            double tensionSystolique,
            double tensionDiastolique,
            int saturationOxygene
    ) {

        if (!estTemperatureValide(temperature)) return "La température doit être comprise entre 35°C et 42°C.";
        if (!estTensionSystoliqueValide(tensionSystolique)) return "La tension systolique doit être entre 70 et 250 mmHg.";
        if (!estTensionDiastoliqueValide(tensionDiastolique)) return "La tension diastolique doit être entre 40 et 150 mmHg.";
        if (!estFrequenceRespiratoireValide(frequenceRespiratoire)) return "La fréquence respiratoire doit être entre 10 et 40 rpm.";
        if (!estSaturationOxygeneValide(saturationOxygene)) return "La saturation O₂ doit être comprise entre 70% et 100%.";

        return null;
    }
}
