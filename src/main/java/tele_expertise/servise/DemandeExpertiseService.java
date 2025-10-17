package tele_expertise.servise;

import tele_expertise.dao.DemandeExpertiseDAO;
import tele_expertise.entity.DemandeExpertise;

import java.util.List;

public class DemandeExpertiseService {
    private DemandeExpertiseDAO dao;

    public DemandeExpertiseService(DemandeExpertiseDAO dao) {
        this.dao = dao;
    }

    public DemandeExpertise findById(Long id) {
        return dao.findById(id);
    }

    public List<DemandeExpertise> findBySpecialisteId(Long specialisteId) {
        return dao.findBySpecialisteId(specialisteId);
    }

    public List<DemandeExpertise> findBySpecialisteIdAndStatut(Long specialisteId, String statut) {
        return dao.findBySpecialisteIdAndStatut(specialisteId, statut);
    }

    public List<DemandeExpertise> findByConsultationId(Long consultationId) {
        return dao.findByConsultationId(consultationId);
    }

    public List<DemandeExpertise> findAll() {
        return dao.findAll();
    }

    public void save(DemandeExpertise demande) {
        dao.save(demande);
    }

    public void update(DemandeExpertise demande) {
        dao.update(demande);
    }

    public void delete(Long id) {
        dao.delete(id);
    }

    public long countBySpecialisteId(Long specialisteId) {
        return dao.countBySpecialisteId(specialisteId);
    }

    public long countBySpecialisteIdAndStatut(Long specialisteId, String statut) {
        return dao.countBySpecialisteIdAndStatut(specialisteId, statut);
    }

    public void close() {
        if (dao != null) {
            dao.close();
        }
    }
}