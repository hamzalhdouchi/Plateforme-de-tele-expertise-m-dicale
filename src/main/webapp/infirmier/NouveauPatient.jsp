<%@ page import="tele_expertise.enums.RoleUtilisateur" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
    <title>Nouveau Patient - Digital Clinic</title>
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
</head>
<body class="bg-background text-foreground font-sans antialiased">
<div class="min-h-screen">
    <div class="container mx-auto px-4 py-6 max-w-4xl">
        <!-- En-tête -->
        <header class="mb-8">
            <div class="flex justify-between items-center mb-4">
                <div class="flex items-center space-x-3">
                    <svg class="w-8 h-8 text-primary" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <div>
                        <h1 class="text-2xl font-bold">Digital Clinic</h1>
                        <p class="text-sm text-muted-foreground">Enregistrement d'un Nouveau Patient</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/Home-Infirmier"
                   class="bg-primary text-primary-foreground px-4 py-2 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all">
                    ← Retour
                </a>
            </div>
        </header>

        <!-- Messages d'alerte -->
        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-sm text-red-800">
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg text-sm text-green-800">
                    ${message}
            </div>
        </c:if>

        <%
            String csrfToken = (String) session.getAttribute("csrfToken");
        %>

        <!-- Formulaire -->
        <form action="${pageContext.request.contextPath}/NouveauPatient" method="POST" class="space-y-6">
            <input type="hidden" name="csrfToken" value="<%= csrfToken%>">

            <!-- Informations Personnelles -->
            <div class="bg-white rounded-lg shadow-sm border border-border p-6">
                <h2 class="text-lg font-bold mb-4 pb-2 border-b border-border">Informations Personnelles</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="nom" class="block text-sm font-medium mb-2">Nom *</label>
                        <input
                                type="text"
                                id="nom"
                                name="nom"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                placeholder="Entrez le nom"
                        >
                    </div>

                    <div>
                        <label for="prenom" class="block text-sm font-medium mb-2">Prénom *</label>
                        <input
                                type="text"
                                id="prenom"
                                name="prenom"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                placeholder="Entrez le prénom"
                        >
                    </div>

                    <div>
                        <label for="dateNaissance" class="block text-sm font-medium mb-2">Date de naissance *</label>
                        <input
                                type="date"
                                id="dateNaissance"
                                name="dateNaissance"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="numeroSecuriteSociale" class="block text-sm font-medium mb-2">N° Sécurité Sociale *</label>
                        <input
                                type="text"
                                id="numeroSecuriteSociale"
                                name="numeroSecuriteSociale"
                                placeholder="1234567890123"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="telephone" class="block text-sm font-medium mb-2">Téléphone</label>
                        <input
                                type="tel"
                                id="telephone"
                                name="telephone"
                                placeholder="0612345678"
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="adresse" class="block text-sm font-medium mb-2">Adresse</label>
                        <input
                                type="text"
                                id="adresse"
                                name="adresse"
                                placeholder="123 Rue de la Santé"
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>
                </div>
            </div>

            <!-- Signes Vitaux -->
            <div class="bg-white rounded-lg shadow-sm border border-border p-6">
                <h2 class="text-lg font-bold mb-4 pb-2 border-b border-border">Signes Vitaux *</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="temperature" class="block text-sm font-medium mb-2">Température (°C) *</label>
                        <input
                                type="number"
                                id="temperature"
                                name="temperature"
                                step="0.1"
                                min="35"
                                max="42"
                                placeholder="37.0"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="frequenceCardiaque" class="block text-sm font-medium mb-2">Fréquence Cardiaque (bpm) *</label>
                        <input
                                type="number"
                                id="frequence"
                                name="frequenceCardiaque"
                                min="40"
                                max="200"
                                placeholder="75"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="tensionSystolique" class="block text-sm font-medium mb-2">Tension Systolique (mmHg) *</label>
                        <input
                                type="number"
                                id="tensionSystolique"
                                name="tensionSystolique"
                                min="70"
                                max="250"
                                placeholder="120"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="tensionDiastolique" class="block text-sm font-medium mb-2">Tension Diastolique (mmHg) *</label>
                        <input
                                type="number"
                                id="tensionDiastolique"
                                name="tensionDiastolique"
                                min="40"
                                max="150"
                                placeholder="80"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="frequenceRespiratoire" class="block text-sm font-medium mb-2">Fréquence Respiratoire (rpm) *</label>
                        <input
                                type="number"
                                id="frequenceRespiratoire"
                                name="frequenceRespiratoire"
                                min="10"
                                max="40"
                                placeholder="16"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>

                    <div>
                        <label for="saturationOxygene" class="block text-sm font-medium mb-2">Saturation O₂ (%) *</label>
                        <input
                                type="number"
                                id="saturationOxygene"
                                name="saturationOxygene"
                                step="1"
                                min="70"
                                max="100"
                                placeholder="98"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        >
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex justify-end space-x-4 pt-4">
                <a href="${pageContext.request.contextPath}/Home-Infirmier"
                   class="bg-secondary text-primary-foreground px-6 py-3 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-secondary focus:ring-offset-2 transition-all">
                    Annuler
                </a>
                <button
                        type="submit"
                        class="bg-primary text-primary-foreground px-6 py-3 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all"
                >
                    Enregistrer et Ajouter à la File
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>