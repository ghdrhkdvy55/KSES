package com.kses.backoffice.rsv.msg.vo;

import java.io.Serializable;

public class MessageInfo implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String msgSeq;
	private String msgGubun = "";
	private String msgTitle = "";
	private String msgSendtype = "";
	private String msgContent = "";
	private String msgRegId = "";
	private String msgRegDate;
	private String msgUpdateId = "";
	private String msgUpdateDate;
	private String mode;
	private String useYn = "";
	
	
	
	
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}
	public String getMsgSeq() {
		return msgSeq;
	}
	public void setMsgSeq(String msgSeq) {
		this.msgSeq = msgSeq;
	}
	public String getMsgGubun() {
		return msgGubun;
	}
	public void setMsgGubun(String msgGubun) {
		this.msgGubun = msgGubun;
	}
	public String getMsgTitle() {
		return msgTitle;
	}
	public void setMsgTitle(String msgTitle) {
		this.msgTitle = msgTitle;
	}
	
	public String getMsgSendtype() {
		return msgSendtype;
	}
	public void setMsgSendtype(String msgSendtype) {
		this.msgSendtype = msgSendtype;
	}
	public String getMsgContent() {
		return msgContent;
	}
	public void setMsgContent(String msgContent) {
		this.msgContent = msgContent;
	}
	public String getMsgRegId() {
		return msgRegId;
	}
	public void setMsgRegId(String msgRegId) {
		this.msgRegId = msgRegId;
	}
	public String getMsgRegDate() {
		return msgRegDate;
	}
	public void setMsgRegDate(String msgRegDate) {
		this.msgRegDate = msgRegDate;
	}
	public String getMsgUpdateId() {
		return msgUpdateId;
	}
	public void setMsgUpdateId(String msgUpdateId) {
		this.msgUpdateId = msgUpdateId;
	}
	public String getMsgUpdateDate() {
		return msgUpdateDate;
	}
	public void setMsgUpdateDate(String msgUpdateDate) {
		this.msgUpdateDate = msgUpdateDate;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	
	
}
