<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Digital Clinic</title>
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
<div class="min-h-screen flex">
    <div class="hidden lg:flex lg:w-1/2 bg-primary items-center justify-center p-12">
        <div class="max-w-md text-primary-foreground">
            <div class="mb-8">
                <svg class="w-12 h-12 mb-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <h1 class="text-4xl font-bold mb-2">Digital Clinic</h1>
                <p class="text-lg opacity-90">Healthcare Management System</p>
            </div>
            <p class="text-base leading-relaxed opacity-80">
                Secure access to patient records, appointments, and medical data.
                Streamline your healthcare practice with our comprehensive digital solution.
            </p>
        </div>
    </div>
    <div class="flex-1 flex items-center justify-center p-8">
        <div class="w-full max-w-md">
            Mobile Logo
            <div class="lg:hidden mb-8 text-center">
                <h1 class="text-2xl font-bold text-primary">Digital Clinic</h1>
                <p class="text-sm text-muted-foreground">Healthcare Management System</p>
            </div>

            <div class="mb-8">
                <h2 class="text-3xl font-bold mb-2">Welcome back</h2>
                <p class="text-muted-foreground">Enter your credentials to access your account</p>
            </div>

            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-sm text-red-800">
                    ${error}
                </div>
            </c:if>


            <%
                String csrfToken = (String) session.getAttribute("csrfToken");
            %>

            <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-6">
                <input type="hidden" name="csrfToken" value="<%= csrfToken%>">
                <div>
                    <label for="email" class="block text-sm font-medium mb-2">
                        Email address
                    </label>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            required
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="doctor@clinic.com"
                            value="${param.email}"
                    />
                </div>

                <div>
                    <div class="flex items-center justify-between mb-2">
                        <label for="password" class="block text-sm font-medium">
                            Password
                        </label>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="text-sm text-primary hover:underline">
                            Forgot password?
                        </a>
                    </div>
                    <input
                            type="password"
                            id="password"
                            name="password"
                            required
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="••••••••"
                    />
                </div>

                <button
                        type="submit"
                        class="w-full bg-primary text-primary-foreground py-3 px-4 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all"
                >
                    Sign in
                </button>
            </form>

            <div class="mt-6 text-center">
                <p class="text-sm text-muted-foreground">
                    Don't have an account?
                    <a href="${pageContext.request.contextPath}/register.jsp" class="text-primary font-medium hover:underline">
                        Register here
                    </a>
                </p>
            </div>

<%--            <div class="mt-8 pt-6 border-t border-border">--%>
<%--                <p class="text-xs text-center text-muted-foreground">--%>
<%--                    By signing in, you agree to our Terms of Service and Privacy Policy--%>
<%--                </p>--%>
<%--            </div>--%>
        </div>
    </div>
</div>
</body>
</html>
