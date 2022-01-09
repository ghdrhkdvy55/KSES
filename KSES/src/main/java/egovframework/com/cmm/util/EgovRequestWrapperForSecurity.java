package egovframework.com.cmm.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class EgovRequestWrapperForSecurity extends HttpServletRequestWrapper {

	private String username = null;
	private String password = null;
	private String clientIp = null;

	public EgovRequestWrapperForSecurity(HttpServletRequest request, String username, String password, String ip) {
		super(request);
		this.username = username;
		this.password = password;
		this.clientIp = ip;
	}
	
	@Override
	public String getServletPath() {		
		return ((HttpServletRequest) super.getRequest()).getContextPath() + "/egov_security_login";
	}

	@Override
	public String getRequestURI() {		
		return ((HttpServletRequest) super.getRequest()).getContextPath() + "/egov_security_login";
	}

	@Override
	public String getParameter(String name) {
		if (name.equals("egov_security_username")) {
			return username;
		}

		if (name.equals("egov_security_password")) {
			return password;
		}

		return super.getParameter(name);
	}
	
	public String getUsername() {
		return this.username;
	}

	public String getPassword() {
		return this.password;
	}
	
	public String getClientIp() {
		return this.clientIp;
	}
}
