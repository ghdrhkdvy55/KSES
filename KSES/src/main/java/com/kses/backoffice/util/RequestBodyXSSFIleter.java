package com.kses.backoffice.util;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kses.backoffice.util.service.impl.fileServiceImpl;


public class RequestBodyXSSFIleter implements Filter {
	private static final Logger LOGGER = LoggerFactory.getLogger(fileServiceImpl.class);
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest)req;
 		HttpServletResponse response = (HttpServletResponse)res;
 		RequestWrapper requestWrapper = null;
 		try{
 			requestWrapper = new RequestWrapper(request);
 		} catch(Exception e) {
 			LOGGER.error("RequestBodyXSSFilter Exception ERROR : " + e.toString());
 		}
 		chain.doFilter(requestWrapper, response);
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {}

	@Override
	public void destroy() {}

}
