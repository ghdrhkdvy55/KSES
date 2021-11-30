package com.kses.backoffice.bas.code.vo;

import java.io.Serializable;



import org.apache.commons.lang3.builder.ToStringBuilder;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CmmnCode implements Serializable {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 1L;
	private String codeId = "";
	private String codeIdNm = "";
	private String codeIdDc = "";
    private String useAt = "";
    private String frstRegisterId = "";
    private String lastUpdusrId   = "";
    private String mode = "";
	private String menuGubun;
	
	
    
    
}

