package tele_expertise.servise;


import tele_expertise.dao.ConsultationDAO;
import tele_expertise.entity.Consultation;

public class ConsultationService {
    private ConsultationDAO consultationDAO;

    public ConsultationService() {
        this.consultationDAO = new ConsultationDAO();
    }

    public Consultation save(Consultation consultation) {
        return consultationDAO.save(consultation);
    }

    public void close() {
        if (consultationDAO != null) {
            consultationDAO.close();
        }
    }
}
