package csrf;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID;
import java.util.Set;

public class CsrfFilter implements Filter {

    private static final Set<String> PROTECTED_METHODS = Set.of("POST", "PUT", "DELETE", "PATCH");

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(true);

        String csrfToken = (String) session.getAttribute("csrfToken");
        if (csrfToken == null) {
            csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
        }

        String method = request.getMethod().toUpperCase();
        if (PROTECTED_METHODS.contains(method)) {

            String formToken = request.getParameter("csrfToken");
            if (formToken == null) {
                formToken = request.getHeader("X-CSRF-Token"); // AJAX support
            }

            if (formToken == null || !formToken.equals(csrfToken)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return; // stop further processing
            }
        }

        chain.doFilter(request, response);
    }

//    @Override
//    public void init(FilterConfig filterConfig) {}
//    @Override
//    public void destroy() {}
}
