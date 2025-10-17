<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session == null || session.getAttribute("user") == null ||
            !"SPECIALISTE".equals(session.getAttribute("role").toString())) {
        response.sendRedirect(request.getContextPath() + "/Login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Répondre à l'Expertise - Digital Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: 'oklch(0.55 0.15 240)',
                        'primary-foreground': 'oklch(0.99 0 0)',
                        secondary: 'oklch(0.65 0.12 200)',
                        background: 'oklch(0.99 0.005 240)',
                        foreground: 'oklch(0.25 0.015 240)',
                        muted: 'oklch(0.96 0.01 240)',
                        'muted-foreground': 'oklch(0.55 0.015 240)',
                        border: 'oklch(0.90 0.01 240)',
                        input: 'oklch(0.95 0.01 240)',
                    }
                }
            }
        }
    </script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        * { font-family: 'Inter', sans-serif; }
        .input-field { transition: all 0.3s ease; }
        .input-field:focus { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(85, 81, 255, 0.15); }
        .info-card { background: oklch(0.98 0.005 240); }
    </style>
</head>
<body class="bg-background text-foreground">

<!-- Navbar -->
<nav class="bg-primary border-b border-border">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/specialiste/dashboard-specialiste"
                   class="text-primary-foreground hover:opacity-80 mr-4 transition">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                </a>
                <h1 class="text-xl font-semibold text-primary-foreground">Répondre à la Demande d'Expertise</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-primary-foreground text-sm">Dr. ${sessionScope.user}</span>
                <a href="${pageContext.request.contextPath}/logout"
                   class="bg-primary-foreground text-primary px-4 py-2 rounded-lg hover:opacity-90 transition text-sm font-medium">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Messages -->
    <c:if test="${not empty sessionScope.error}">
        <div class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg mb-6 flex items-center">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
                ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Patient & Consultation Info -->
    <div class="bg-white rounded-xl border border-border p-6 mb-6">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-semibold text-foreground flex items-center">
                <svg class="w-6 h-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Informations sur la Consultation
            </h2>
            <c:choose>
                <c:when test="${demande.priorite eq 'URGENTE'}">
                    <span class="inline-flex items-center px-4 py-2 text-sm font-medium text-red-800 bg-red-100 rounded-full">
                        🔴 URGENTE
                    </span>
                </c:when>
                <c:when test="${demande.priorite eq 'NORMALE'}">
                    <span class="inline-flex items-center px-4 py-2 text-sm font-medium text-primary bg-primary/10 rounded-full">
                        🔵 NORMALE
                    </span>
                </c:when>
                <c:otherwise>
                    <span class="inline-flex items-center px-4 py-2 text-sm font-medium text-muted-foreground bg-muted rounded-full">
                        ⚪ NON URGENTE
                    </span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="info-card rounded-lg p-4 border border-border">
                <p class="text-sm text-muted-foreground mb-1">Patient</p>
                <p class="text-lg font-semibold text-foreground">Patient #${demande.consultation.patient.id}</p>
            </div>

            <div class="info-card rounded-lg p-4 border border-border">
                <p class="text-sm text-muted-foreground mb-1">Date de demande</p>
                <p class="text-lg font-semibold text-foreground">
                    ${not empty demande.dateDemande ? demande.dateDemande : '-'}
                </p>
            </div>

            <div class="info-card rounded-lg p-4 border border-border">
                <p class="text-sm text-muted-foreground mb-1">Motif de consultation</p>
                <p class="text-lg font-semibold text-foreground">${demande.consultation.motif}</p>
            </div>

            <div class="info-card rounded-lg p-4 border border-border">
                <p class="text-sm text-muted-foreground mb-1">Créneau réservé</p>
                <p class="text-lg font-semibold text-foreground">
                    ${not empty demande.creneau and not empty demande.creneau.dateHeure ? demande.creneau.dateHeure : '-'}
                </p>
            </div>
        </div>

        <c:if test="${not empty demande.consultation.observations}">
            <div class="mt-6 p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                <p class="text-sm font-medium text-blue-900 mb-2">Observations du Généraliste</p>
                <p class="text-foreground">${demande.consultation.observations}</p>
            </div>
        </c:if>
    </div>

    <!-- Question from Generaliste -->
    <div class="bg-white rounded-xl border border-border p-6 mb-6">
        <h2 class="text-xl font-semibold text-foreground mb-4 flex items-center">
            <svg class="w-6 h-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Question du Médecin Généraliste
        </h2>
        <div class="bg-amber-50 rounded-lg p-6 border-l-4 border-amber-500">
            <p class="text-foreground text-lg leading-relaxed">${demande.question}</p>
        </div>
    </div>

    <!-- Additional Data & Analyses -->
    <c:if test="${not empty demande.donneesAnalyses}">
        <div class="bg-white rounded-xl border border-border p-6 mb-6">
            <h2 class="text-xl font-semibold text-foreground mb-4 flex items-center">
                <svg class="w-6 h-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Données et Analyses Complémentaires
            </h2>
            <div class="bg-muted rounded-lg p-6 border border-border">
                <p class="text-foreground whitespace-pre-wrap">${demande.donneesAnalyses}</p>
            </div>
        </div>
    </c:if>

    <!-- Response Form -->
    <form method="post" action="${pageContext.request.contextPath}/specialiste/repondre-expertise">
        <input type="hidden" name="demandeId" value="${demande.id}"/>

        <div class="bg-white rounded-xl border border-border p-6 mb-6">
            <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                <svg class="w-6 h-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                </svg>
                Votre Avis d'Expert
            </h2>

            <div class="space-y-6">
                <!-- Medical Opinion -->
                <div>
                    <label for="avisMedical" class="block text-sm font-medium text-foreground mb-2">
                        Avis Médical <span class="text-red-500">*</span>
                    </label>
                    <textarea
                            id="avisMedical"
                            name="avisMedical"
                            required
                            rows="8"
                            class="input-field w-full px-4 py-3 bg-input border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-foreground"
                            placeholder="Votre diagnostic, analyse et opinion médicale détaillée sur le cas présenté..."></textarea>
                    <p class="text-xs text-muted-foreground mt-2 flex items-center">
                        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        Soyez aussi détaillé et précis que possible dans votre analyse
                    </p>
                </div>

                <!-- Recommendations -->
                <div>
                    <label for="recommandations" class="block text-sm font-medium text-foreground mb-2">
                        Recommandations et Conduite à Tenir
                    </label>
                    <textarea
                            id="recommandations"
                            name="recommandations"
                            rows="6"
                            class="input-field w-full px-4 py-3 bg-input border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-foreground"
                            placeholder="Recommandations thérapeutiques, examens complémentaires à prescrire, suivi à mettre en place..."></textarea>
                    <p class="text-xs text-muted-foreground mt-2 flex items-center">
                        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                        </svg>
                        Incluez les recommandations de traitement, suivi et orientation si nécessaire
                    </p>
                </div>

                <!-- Information Box -->
                <div class="bg-primary/10 border-l-4 border-primary p-4 rounded">
                    <div class="flex">
                        <svg class="h-5 w-5 text-primary mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <div>
                            <h3 class="text-sm font-medium text-foreground">Important</h3>
                            <p class="text-sm text-muted-foreground mt-1">
                                Votre avis sera transmis au médecin généraliste et intégré au dossier médical du patient.
                                Assurez-vous que toutes les informations fournies sont précises et conformes aux bonnes pratiques médicales.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Cost Summary -->
                <div class="bg-primary/5 rounded-xl p-6 border-2 border-primary/20">
                    <h3 class="text-lg font-semibold text-foreground mb-4 flex items-center">
                        <svg class="w-5 h-5 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        Honoraires
                    </h3>
                    <div class="flex justify-between items-center text-xl">
                        <span class="font-medium text-foreground">Votre tarif pour cette expertise</span>
                        <span class="font-semibold text-primary">
                            <c:choose>
                                <c:when test="${not empty specialiste.tarif}">
                                    ${specialiste.tarif} DH
                                </c:when>
                                <c:otherwise>
                                    0.00 DH
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex justify-end space-x-4 pt-4">
                    <a href="${pageContext.request.contextPath}/specialiste/dashboard-specialiste"
                       class="bg-muted text-muted-foreground px-6 py-3 rounded-xl font-medium hover:opacity-90 transition">
                        <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                        </svg>
                        Annuler
                    </a>
                    <button type="submit"
                            class="bg-primary text-primary-foreground px-8 py-3 rounded-xl font-medium hover:opacity-90 transition">
                        <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                        </svg>
                        Envoyer l'Avis Médical
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    // Confirmation before submission
    document.querySelector('form').addEventListener('submit', function(e) {
        const avisMedical = document.getElementById('avisMedical').value.trim();

        if (!avisMedical) {
            e.preventDefault();
            alert('⚠️ L\'avis médical est obligatoire');
            return false;
        }

        if (avisMedical.length < 50) {
            if (!confirm('⚠️ Votre avis médical semble court (moins de 50 caractères). Êtes-vous sûr de vouloir continuer ?')) {
                e.preventDefault();
                return false;
            }
        }

        return confirm('✅ Confirmer l\'envoi de votre avis médical ?\n\nCette action est irréversible et l\'avis sera transmis au médecin généraliste.');
    });
</script>

</body>
</html>