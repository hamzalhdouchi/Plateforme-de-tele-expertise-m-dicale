<%@ page import="tele_expertise.enums.RoleUtilisateur" %>
<%@ page contentType="text/html;charset=UTF-8" %>
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
    <title>Mettre à jour Signes Vitaux - Digital Clinic</title>
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
<div class="min-h-screen flex items-center justify-center p-8">
    <div class="w-full max-w-md">
        <div class="mb-8 text-center">
            <svg class="w-12 h-12 mx-auto mb-4 text-primary" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <h1 class="text-2xl font-bold text-primary">Digital Clinic</h1>
            <p class="text-sm text-muted-foreground">Mise à jour des signes vitaux</p>
        </div>
        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-sm text-red-800">
                    ${error}
            </div>
        </c:if>

        <div class="mb-8">
            <h2 class="text-3xl font-bold mb-2">Signes vitaux</h2>
            <p class="text-muted-foreground">Mettez à jour les données médicales du patient</p>
        </div>

        <%
            String csrfToken = (String) session.getAttribute("csrfToken");
        %>

        <form method="post" action="${pageContext.request.contextPath}/update-vitals" class="space-y-6">
            <input type="hidden" name="patientId" value="${patientId}" />
            <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

            <!-- Température -->
            <div>
                <label for="temperature" class="block text-sm font-medium mb-2">
                    Température (°C)
                </label>
                <input
                        type="number"
                        step="0.1"
                        id="temperature"
                        name="temperature"
                        value="${signesVitaux.temperature}"
                        min="35.0"
                        max="42.0"
                        placeholder="37.0"
                        class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        required
                />
            </div>

            <!-- Tension artérielle -->
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label for="tensionSystolique" class="block text-sm font-medium mb-2">
                        Tension systolique (mmHg)
                    </label>
                    <input
                            type="number"
                            id="tensionSystolique"
                            name="tensionSystolique"
                            value="${signesVitaux.tensionsystolique}"
                            min="70"
                            max="200"
                            placeholder="120"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required
                    />
                </div>
                <div>
                    <label for="tensionDiastolique" class="block text-sm font-medium mb-2">
                        Tension diastolique (mmHg)
                    </label>
                    <input
                            type="number"
                            id="tensionDiastolique"
                            name="tensionDiastolique"
                            value="${signesVitaux.tensiondiastolique}"
                            min="40"
                            max="120"
                            placeholder="80"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required
                    />
                </div>
            </div>

            <!-- Fréquence respiratoire -->
            <div>
                <label for="frequenceRespiratoire" class="block text-sm font-medium mb-2">
                    Fréquence respiratoire (resp/min)
                </label>
                <input
                        type="number"
                        id="frequenceRespiratoire"
                        name="frequenceRespiratoire"
                        value="${signesVitaux.frequencerespiratoire}"
                        min="12"
                        max="40"
                        placeholder="16"
                        class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        required
                />
            </div>

            <!-- Saturation -->
            <div>
                <label for="saturation" class="block text-sm font-medium mb-2">
                    Saturation en O₂ (%)
                </label>
                <input
                        type="number"
                        id="saturation"
                        name="saturation"
                        value="${signesVitaux.saturation}"
                        min="70"
                        max="100"
                        placeholder="98"
                        class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                        required
                />
            </div>

            <div class="space-y-4">
                <button
                        type="submit"
                        class="w-full bg-primary text-primary-foreground py-3 px-4 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all"
                >
                    Enregistrer
                </button>

                <a href="${pageContext.request.contextPath}/RecherchePatient"
                   class="w-full block text-center bg-secondary text-primary-foreground py-3 px-4 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-secondary focus:ring-offset-2 transition-all">
                    Retour
                </a>
            </div>
        </form>
    </div>
</div>
</body>
</html>