package tele_expertise.servise;

import jakarta.persistence.EntityManagerFactory;
import tele_expertise.dao.UtilisateurDaoImpl;
import tele_expertise.dao.SpecialiteDaoImpl;
import tele_expertise.entity.Specialite;
import java.util.List;

public class SpecialiteServiceImpl {

    private final SpecialiteDaoImpl specialiteDao;

    public SpecialiteServiceImpl(SpecialiteDaoImpl specialiteDao) {
        this.specialiteDao = specialiteDao;
    }

    public List<Specialite> getAllSpecialites() {
        return specialiteDao.getAllSpecialites();
    }

    public Specialite getSpecialiteById(Long id) {
        return specialiteDao.getSpecialiteById(id);
    }

    public Specialite getSpecialiteByNom(String nom) {
        return specialiteDao.getSpecialiteByNom(nom);
    }

    public boolean createSpecialite(Specialite specialite) {
        try {
            if (!isValidSpecialite(specialite) || specialiteExists(specialite.getNom())) {
                return false;
            }
            specialite.setNom(specialite.getNom().trim().toUpperCase());
            specialiteDao.saveSpecialite(specialite);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSpecialite(Specialite specialite) {
        try {
            if (specialite.getId() == null || !isValidSpecialite(specialite)) {
                return false;
            }
            Specialite existing = getSpecialiteById(specialite.getId());
            if (existing == null) return false;

            specialite.setNom(specialite.getNom().trim().toUpperCase());
            Specialite updated = specialiteDao.updateSpecialite(specialite);
            return updated != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSpecialite(Long id) {
        return specialiteDao.deleteSpecialite(id);
    }

    public boolean specialiteExists(String nom) {
        return specialiteDao.specialiteExists(nom);
    }

    public List<Specialite> getTopSpecialites(int limit) {
        return specialiteDao.getTopSpecialites(limit);
    }

    private boolean isValidSpecialite(Specialite s) {
        if (s == null || s.getNom() == null || s.getNom().trim().length() < 2) return false;
        return s.getNom().trim().length() <= 50;
    }
}