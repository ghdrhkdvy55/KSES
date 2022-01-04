package com.kses.backoffice.bas.menu.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MenuInfo {

	private String menuNo = "";
	private String menuNm = ""; 
	private String progrmFileNm  = "";
	private String progrmKoreannm = ""; 
	private String upperMenuNo  = "";
	private String upperMenuNm  = "";
	private String menuOrdr  = "";
	private String menuDc  = "";
	private String relateImagePath = ""; 
	private String relateImageNm = "";
 	private String mode;
 	private int cnt = 0;
 	
}