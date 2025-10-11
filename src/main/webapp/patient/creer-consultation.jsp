<%@ page import="tele_expertise.enums.RoleUtilisateur" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%

    if (session == null || session.getAttribute("loggedUser") == null || session.getAttribute("role") != RoleUtilisateur.INFIRMIER) {
        request.setAttribute("error", "Session expired");
        request.getRequestDispatcher("Login.jsp").forward(request, response);

    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer Consultation - Système Médical</title>
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
    </style>
</head>
<body class="bg-background">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-primary to-primary shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
                   class="text-primary-foreground hover:text-muted-foreground mr-4">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                </a>
                <h1 class="text-xl font-bold text-primary-foreground">Créer une Consultation</h1>
            </div>
            <div class="flex items-center space-x-4">
                    <span class="text-primary-foreground">
                        <svg class="inline h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                      Hamza Lhadouchi
                    </span>
                <a href="${pageContext.request.contextPath}/Login"
                   class="bg-primary-foreground text-primary px-4 py-2 rounded-lg hover:bg-muted transition font-semibold">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Informations du patient -->
    <div class="bg-primary-foreground rounded-xl shadow-lg p-6 mb-6">
        <h2 class="text-xl font-bold text-foreground mb-4 flex items-center">
            <svg class="h-6 w-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            Informations du patient
        </h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <p class="text-sm text-muted-foreground">Nom complet</p>
                <p class="font-semibold text-lg">${patient.nom} ${patient.prenom}</p>
            </div>
            <div>
                <p class="text-sm text-muted-foreground">Date de naissance</p>
                <p class="font-semibold">${patient.dateDeNaissance}</p>
            </div>
            <div>
                <p class="text-sm text-muted-foreground">N° Sécurité Sociale</p>
                <p class="font-semibold">${patient.NSecuriteSociale}</p>
            </div>
        </div>

        <!-- Signes vitaux récents -->
        <c:if test="${not empty patient.signesVitaux}">
            <div class="mt-4 pt-4 border-t border-border">
                <h3 class="text-sm font-semibold text-muted-foreground mb-2">Signes vitaux récents</h3>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                    <c:if test="${not empty patient.signesVitaux.tensiondiastolique}">
                        <div class="bg-blue-50 rounded-lg p-3">
                            <p class="text-xs text-blue-600">Tension artérielle</p>
                            <p class="font-semibold">${patient.signesVitaux.tensiondiastolique}</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty patient.signesVitaux.frequencerespiratoire}">
                        <div class="bg-red-50 rounded-lg p-3">
                            <p class="text-xs text-red-600">Fréquence cardiaque</p>
                            <p class="font-semibold">${patient.signesVitaux.frequencerespiratoire} bpm</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty patient.signesVitaux.temperature}">
                        <div class="bg-orange-50 rounded-lg p-3">
                            <p class="text-xs text-orange-600">Température</p>
                            <p class="font-semibold">${patient.signesVitaux.temperature}°C</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty patient.signesVitaux.saturation}">
                        <div class="bg-green-50 rounded-lg p-3">
                            <p class="text-xs text-green-600">Saturation</p>
                            <p class="font-semibold">${patient.signesVitaux.saturation}/min</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>


        <!-- Antécédents et allergies --></div>
    <%
        String csrf =(String) session.getAttribute("csrfToken");
    %>
    <!-- Formulaire de sélection du médecin -->
    <form action="${pageContext.request.contextPath}/infirmier/creer-consultation" method="post">
        <input type="hidden" name="patientId" value="${patient.id}"/>
        <input type="hidden" name="csrfToken" value="<%= csrf%>">
        <div class="bg-primary-foreground rounded-xl shadow-lg p-6 mb-6">
            <h2 class="text-xl font-bold text-foreground mb-4 flex items-center">
                <svg class="h-6 w-6 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                </svg>
                Assigner un médecin généraliste
            </h2>
            <c:choose>
                <c:when test="${not empty generalistes}">
                    <div class="grid grid-cols-1 gap-3">
                        <c:forEach items="${generalistes}" var="generaliste">
                            <label class="relative flex items-center p-4 border-2 border-border rounded-xl hover:border-primary cursor-pointer transition">
                                <input type="radio"
                                       name="generalisteId"
                                       value="${generaliste.id}"
                                       required
                                       class="h-5 w-5 text-primary focus:ring-primary">
                                <div class="ml-4 flex-1">
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <p class="font-bold text-foreground text-lg">
                                                Dr. ${generaliste.nom}
                                            </p>
                                            <p class="text-sm text-muted-foreground mt-1">Médecin Généraliste</p>
                                        </div>
                                        <div class="flex items-center">
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                    <svg class="h-3 w-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                    Disponible
                                </span>
                                        </div>
                                    </div>
                                </div>
                            </label>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-8 bg-muted rounded-lg border-2 border-dashed border-border">
                        <svg class="mx-auto h-12 w-12 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                        </svg>
                        <h3 class="mt-2 text-sm font-medium text-foreground">Aucun médecin généraliste disponible</h3>
                        <p class="mt-1 text-sm text-muted-foreground">Contactez l'administrateur pour ajouter un médecin généraliste.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Actions -->
            <div class="flex justify-end space-x-4 pt-4 border-t border-border">
                <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
                   class="bg-muted text-muted-foreground px-6 py-3 rounded-xl font-semibold hover:bg-border transition">
                    Annuler
                </a>
                <button type="submit"
                        class="bg-primary text-primary-foreground px-6 py-3 rounded-xl font-semibold hover:bg-secondary transition inline-flex items-center"
                ${empty generalistes ? 'disabled' : ''}>
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                    Créer la consultation
                </button>
            </div>
        </div>
    </form>
</div>

</body>
</html>