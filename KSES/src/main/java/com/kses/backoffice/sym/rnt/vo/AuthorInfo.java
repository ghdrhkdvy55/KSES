package com.kses.backoffice.sym.rnt.vo;

import java.io.Serializable;

public class AuthorInfo implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String authorCode;
	private String authorNm;
	private String authorDc;
	private String authorCreateDe;
	
	
	
	public String getAuthorCode() {
		return authorCode;
	}
	public void setAuthorCode(String authorCode) {
		this.authorCode = authorCode;
	}
	public String getAuthorNm() {
		return authorNm;
	}
	public void setAuthorNm(String authorNm) {
		this.authorNm = authorNm;
	}
	public String getAuthorDc() {
		return authorDc;
	}
	public void setAuthorDc(String authorDc) {
		this.authorDc = authorDc;
	}
	public String getAuthorCreateDe() {
		return authorCreateDe;
	}
	public void setAuthorCreateDe(String authorCreateDe) {
		this.authorCreateDe = authorCreateDe;
	}
	
	
	
	
	
	
}
