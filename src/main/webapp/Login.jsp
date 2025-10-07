<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Digital Clinic</title>
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
    Left Side - Branding
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
            <div class="space-y-4">
                <div class="flex items-start gap-3">
                    <svg class="w-6 h-6 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    <div>
                        <h3 class="font-semibold mb-1">Secure & Compliant</h3>
                        <p class="text-sm opacity-80">HIPAA-compliant platform ensuring patient data security</p>
                    </div>
                </div>
                <div class="flex items-start gap-3">
                    <svg class="w-6 h-6 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    <div>
                        <h3 class="font-semibold mb-1">Streamlined Workflow</h3>
                        <p class="text-sm opacity-80">Manage appointments, records, and billing in one place</p>
                    </div>
                </div>
                <div class="flex items-start gap-3">
                    <svg class="w-6 h-6 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    <div>
                        <h3 class="font-semibold mb-1">24/7 Support</h3>
                        <p class="text-sm opacity-80">Dedicated support team available around the clock</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    Right Side - Register Form
    <div class="flex-1 flex items-center justify-center p-8">
        <div class="w-full max-w-md">
            Mobile Logo
            <div class="lg:hidden mb-8 text-center">
                <h1 class="text-2xl font-bold text-primary">Digital Clinic</h1>
                <p class="text-sm text-muted-foreground">Healthcare Management System</p>
            </div>

            <div class="mb-8">
                <h2 class="text-3xl font-bold mb-2">Create an account</h2>
                <p class="text-muted-foreground">Join our healthcare platform today</p>
            </div>

            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                    <p class="text-sm text-red-800">${error}</p>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="space-y-5">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label for="firstName" class="block text-sm font-medium mb-2">
                            First name
                        </label>
                        <input
                                type="text"
                                id="firstName"
                                name="firstName"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                placeholder="John"
                                value="${param.firstName}"
                        />
                    </div>
                    <div>
                        <label for="lastName" class="block text-sm font-medium mb-2">
                            Last name
                        </label>
                        <input
                                type="text"
                                id="lastName"
                                name="lastName"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                placeholder="Doe"
                                value="${param.lastName}"
                        />
                    </div>
                </div>

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
                    <label for="role" class="block text-sm font-medium mb-2">
                        Role
                    </label>
                    <select
                            id="role"
                            name="role"
                            required
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                    >
                        <option value="">Select your role</option>
                        <option value="doctor" ${param.role == 'doctor' ? 'selected' : ''}>Doctor</option>
                        <option value="nurse" ${param.role == 'nurse' ? 'selected' : ''}>Nurse</option>
                        <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Administrator</option>
                        <option value="receptionist" ${param.role == 'receptionist' ? 'selected' : ''}>Receptionist</option>
                    </select>
                </div>

                <div>
                    <label for="licenseNumber" class="block text-sm font-medium mb-2">
                        License Number
                    </label>
                    <input
                            type="text"
                            id="licenseNumber"
                            name="licenseNumber"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="Optional for non-medical staff"
                            value="${param.licenseNumber}"
                    />
                </div>

                <div>
                    <label for="password" class="block text-sm font-medium mb-2">
                        Password
                    </label>
                    <input
                            type="password"
                            id="password"
                            name="password"
                            required
                            minlength="8"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="••••••••"
                    />
                    <p class="mt-1 text-xs text-muted-foreground">Must be at least 8 characters</p>
                </div>

                <div>
                    <label for="confirmPassword" class="block text-sm font-medium mb-2">
                        Confirm password
                    </label>
                    <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            required
                            minlength="8"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="••••••••"
                    />
                </div>

                <div class="flex items-start">
                    <input
                            type="checkbox"
                            id="terms"
                            name="terms"
                            required
                            class="w-4 h-4 mt-1 text-primary border-border rounded focus:ring-2 focus:ring-primary"
                    />
                    <label for="terms" class="ml-2 text-sm text-muted-foreground leading-relaxed">
                        I agree to the <a href="#" class="text-primary hover:underline">Terms of Service</a> and
                        <a href="#" class="text-primary hover:underline">Privacy Policy</a>
                    </label>
                </div>

                <button
                        type="submit"
                        class="w-full bg-primary text-primary-foreground py-3 px-4 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all"
                >
                    Create account
                </button>
            </form>

            <div class="mt-6 text-center">
                <p class="text-sm text-muted-foreground">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary font-medium hover:underline">
                        Sign in
                    </a>
                </p>
            </div>
        </div>
    </div>
</div>
</body>
</html>
