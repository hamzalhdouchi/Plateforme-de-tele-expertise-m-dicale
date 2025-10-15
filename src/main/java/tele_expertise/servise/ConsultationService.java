package tele_expertise.servise;


import tele_expertise.dao.ConsultationDAO;
import tele_expertise.entity.Consultation;
import tele_expertise.entity.Patient;

import java.util.List;

public class ConsultationService {
    private ConsultationDAO consultationDAO;

    public ConsultationService(ConsultationDAO consultationDAO) {
        this.consultationDAO = consultationDAO;
    }

    public Consultation save(Consultation consultation) {
        Consultation con =  consultationDAO.save(consultation);
        if (con != null) {
            return con;
        }
        return null;
    }

    public List<Consultation> getConsultationsRecentes(Long medecinId) {
        return consultationDAO.getConsultationsRecentes(medecinId);
    }

    public void updateConsultationForPatient(Consultation consultation) {
        List<Consultation> existingConsultations = consultationDAO.findByPatientId(
                consultation.getPatient().getId());

        if (!existingConsultations.isEmpty()) {
            // Prendre la première consultation trouvée pour ce patient
            Consultation existing = existingConsultations.get(0);

            existing.setMotif(consultation.getMotif());
            existing.setDiagnostic(consultation.getDiagnostic());
            existing.setTraitement(consultation.getTraitement());
            existing.setObservations(consultation.getObservations());
            existing.setStatut(consultation.getStatut());
            existing.setActesTechniques(consultation.getActesTechniques());
            existing.setCoutActesTechniques(consultation.getCoutActesTechniques());
            existing.setCoutConsultation(consultation.getCoutConsultation());
            existing.setDateCloture(consultation.getDateCloture());

            consultationDAO.update(existing);
        } else {
            consultationDAO.save(consultation);
        }
    }

    public List<Consultation> getAllConsultations() {
        return consultationDAO.getAll();
    }
    public List<Consultation> getAllConsultationsBymidsan(Long medecinId) {
        return consultationDAO.getAll().stream().filter(c -> c.getMedecinGeneraliste().getId().equals(medecinId)).toList();
    }

    public Consultation getConsultationByPatient(Patient patient) {
        return getAllConsultations().stream()
                .filter(c -> c.getPatient() != null && c.getPatient().getId() == patient.getId())
                .findFirst()
                .orElse(null);
    }

//    public void close() {
//        if (consultationDAO != null) {
//            consultationDAO.close();
//        }
//    }
}
