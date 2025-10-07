package tele_expertise.util;

import java.util.regex.Pattern;

public class userValidPattern {


    private static final Pattern PATTERN_NOM = Pattern.compile("^[a-zA-ZÀ-ÿ\\s'-]{2,50}$");
    private static final Pattern PATTERN_PRENOM = Pattern.compile("^[a-zA-ZÀ-ÿ\\s'-]{2,50}$");
    private static final Pattern PATTERN_EMAIL = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PATTERN_TELEPHONE = Pattern.compile("^(\\+212|0)([5-7])[0-9]{8}$");
    private static final Pattern PATTERN_PASSWORD = Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!@#$%^&*()_+\\-]{6,}$");
    private static final Pattern PATTERN_ROLE = Pattern.compile("^(GENERALISTE|SPECIALISTE|INFIRMIER)$");

    // ==============================
    // 🔹 Validation : Nom
    // ==============================
    public static boolean estNomValide(String nom) {
        if (nom == null || nom.trim().isEmpty()) return false;
        return PATTERN_NOM.matcher(nom.trim()).matches();
    }

    // ==============================
    // 🔹 Validation : Prénom
    // ==============================
    public static boolean estPrenomValide(String prenom) {
        if (prenom == null || prenom.trim().isEmpty()) return false;
        return PATTERN_PRENOM.matcher(prenom.trim()).matches();
    }

    // ==============================
    // 🔹 Validation : Email
    // ==============================
    public static boolean estEmailValide(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        return PATTERN_EMAIL.matcher(email.trim()).matches();
    }

    // ==============================
    // 🔹 Validation : Téléphone
    // ==============================
    public static boolean estTelephoneValide(String telephone) {
        if (telephone == null || telephone.trim().isEmpty()) return false;
        return PATTERN_TELEPHONE.matcher(telephone.trim()).matches();
    }

    // ==============================
    // 🔹 Validation : Mot de passe
    // ==============================
    public static boolean estMotDePasseValide(String motDePasse) {
        if (motDePasse == null || motDePasse.trim().isEmpty()) return false;
        return PATTERN_PASSWORD.matcher(motDePasse.trim()).matches();
    }

    // ==============================
    // 🔹 Validation : Rôle utilisateur
    // ==============================
    public static boolean estRoleValide(String role) {
        if (role == null || role.trim().isEmpty()) return false;
        return PATTERN_ROLE.matcher(role.trim().toUpperCase()).matches();
    }

    // ==============================
    // 🔹 Validation complète
    // ==============================
    public static String validerUtilisateur(String nom, String prenom, String email, String telephone, String motDePasse, String role) {
        if (!estNomValide(nom)) return "Le nom est invalide (lettres uniquement, 2 à 50 caractères)";
        if (!estPrenomValide(prenom)) return "Le prénom est invalide (lettres uniquement, 2 à 50 caractères)";
        if (!estEmailValide(email)) return "L'email est invalide";
        if (!estTelephoneValide(telephone)) return "Le numéro de téléphone est invalide (format marocain attendu)";
        if (!estMotDePasseValide(motDePasse)) return "Le mot de passe doit contenir au moins 6 caractères, incluant lettres et chiffres";
        if (!estRoleValide(role)) return "Le rôle sélectionné est invalide";
        return null;
    }
}
