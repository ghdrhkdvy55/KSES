package com.kses.backoffice.sym.log.vo;

import java.io.Serializable;

import org.apache.commons.lang.builder.ToStringBuilder;

public class SysLog implements Serializable {

	

		/**
		 * 에러횟수
		 */
		private int errorCo = 0;
		/**
		 * 에러코드
		 */
		private String errorCode = "";
		/**
		 * 에러코드 명
		 */
		private String errorCodeNm = "";		
		/**
		 * 에러구분
		 */
		private String errorSe = "";	
		/**
		 * 기관코드
		 */
		private String insttCode = "";
		/**
		 * 기관코드 명
		 */
		private String insttCodeNm = "";		
		/**
		 * 업무구분코드
		 */
		private String jobSeCode = "";

		/**
		 * 업무구분코드명
		 */
		private String jobSeCodeNm = "";	
		/**
		 * 메서드명
		 */
		private String methodNm = "";
		/**
		 * 발생일자
		 */
		private String occrrncDe = "";
		/**
		 * 처리횟수
		 */
		private int processCo = 0;
		/**
		 * 처리구분코드
		 */
		private String processSeCode = "";
		/**
		 * 처리구분코드명
		 */	
		private String processSeCodeNm = "";
		/**
		 * 처리시간
		 */
		private String processTime = "";
		/**
		 * 요청아이디
		 */
		private String requstId = "";
		/**
		 * 요청자아이디
		 */
		private String rqesterId = "";	
		/**
		 * 요청자 이름
		 */
		private String rqsterNm = "";
		/**
		 * 요청아이피
		 */
		private String rqesterIp = "";
		/**
		 * 응답코드
		 */
		private String rspnsCode = "";	
		/**
		 * 응답코드 명
		 */
		private String rspnsCodeNm = "";
		/**
		 * 서비스명
		 */
		private String srvcNm = "";
		/**
		 * 대상메뉴명
		 */
		private String trgetMenuNm = "";
		/**
		 * 검색시작일
		 */
		private String searchStartdday = "";//2011.09.14
		/**
		 * 검색종료일
		 */
		private String searchEndday = "";
		
		
		/**
		 * 검색단어
		 */
		private String searchKeyword = "";
		/**
		 * 정렬순서(DESC,ASC)
		 */
		private String sortOrdr = "";
		
		/** 검색사용여부 */
	    private String searchUseYn = "";
	    
	    private String searchCondition = "";
	    
	    /** 현재페이지 */
	    private int pageIndex = 1;
	    
	    /** 페이지갯수 */
	    private int pageUnit = 10;
	    
	    /** 페이지사이즈 */
	    private int pageSize = 10;

	    /** firstIndex */
	    private int firstIndex = 1;

	    /** lastIndex */
	    private int lastIndex = 1;

	    /** recordCountPerPage */
	    private int recordCountPerPage = 10;	
			
	    

		
		private String sqlid = "";
		private String sqlParam = "";
		private String sqlQuery = "";
		private String methodResult = "";
		private String searchProcessGubun = "";
		private String searchIp = "";
		private String searchId = "";
		
				
		

		public String getSearchIp() {
			return searchIp;
		}

		public void setSearchIp(String searchIp) {
			this.searchIp = searchIp;
		}

		public String getSearchId() {
			return searchId;
		}

		public void setSearchId(String searchId) {
			this.searchId = searchId;
		}

		public String getSearchProcessGubun() {
			return searchProcessGubun;
		}

		public void setSearchProcessGubun(String searchProcessGubun) {
			this.searchProcessGubun = searchProcessGubun;
		}

		public String getMethodResult() {
			return methodResult;
		}

		public void setMethodResult(String methodResult) {
			this.methodResult = methodResult;
		}

		public String getSqlid() {
			return sqlid;
		}

		public void setSqlid(String sqlid) {
			this.sqlid = sqlid;
		}

		public String getSqlParam() {
			return sqlParam;
		}

		public void setSqlParam(String sqlParam) {
			this.sqlParam = sqlParam;
		}

		public String getSqlQuery() {
			return sqlQuery;
		}

		public void setSqlQuery(String sqlQuery) {
			this.sqlQuery = sqlQuery;
		}

		public int getErrorCo() {
			return errorCo;
		}

		public void setErrorCo(int errorCo) {
			this.errorCo = errorCo;
		}

		public String getErrorCode() {
			return errorCode;
		}

		public void setErrorCode(String errorCode) {
			this.errorCode = errorCode;
		}

		public String getErrorCodeNm() {
			return errorCodeNm;
		}

		public void setErrorCodeNm(String errorCodeNm) {
			this.errorCodeNm = errorCodeNm;
		}

		public String getErrorSe() {
			return errorSe;
		}

		public void setErrorSe(String errorSe) {
			this.errorSe = errorSe;
		}

		public String getInsttCode() {
			return insttCode;
		}

		public void setInsttCode(String insttCode) {
			this.insttCode = insttCode;
		}

		public String getInsttCodeNm() {
			return insttCodeNm;
		}

		public void setInsttCodeNm(String insttCodeNm) {
			this.insttCodeNm = insttCodeNm;
		}

		public String getJobSeCode() {
			return jobSeCode;
		}

		public void setJobSeCode(String jobSeCode) {
			this.jobSeCode = jobSeCode;
		}

		public String getJobSeCodeNm() {
			return jobSeCodeNm;
		}

		public void setJobSeCodeNm(String jobSeCodeNm) {
			this.jobSeCodeNm = jobSeCodeNm;
		}

		public String getMethodNm() {
			return methodNm;
		}

		public void setMethodNm(String methodNm) {
			this.methodNm = methodNm;
		}

		public String getOccrrncDe() {
			return occrrncDe;
		}

		public void setOccrrncDe(String occrrncDe) {
			this.occrrncDe = occrrncDe;
		}

		public int getProcessCo() {
			return processCo;
		}

		public void setProcessCo(int processCo) {
			this.processCo = processCo;
		}

		public String getProcessSeCode() {
			return processSeCode;
		}

		public void setProcessSeCode(String processSeCode) {
			this.processSeCode = processSeCode;
		}

		public String getProcessSeCodeNm() {
			return processSeCodeNm;
		}

		public void setProcessSeCodeNm(String processSeCodeNm) {
			this.processSeCodeNm = processSeCodeNm;
		}

		public String getProcessTime() {
			return processTime;
		}

		public void setProcessTime(String processTime) {
			this.processTime = processTime;
		}

		public String getRequstId() {
			return requstId;
		}

		public void setRequstId(String requstId) {
			this.requstId = requstId;
		}

		public String getRqesterId() {
			return rqesterId;
		}

		public void setRqesterId(String rqesterId) {
			this.rqesterId = rqesterId;
		}

		public String getRqsterNm() {
			return rqsterNm;
		}

		public void setRqsterNm(String rqsterNm) {
			this.rqsterNm = rqsterNm;
		}

		public String getRqesterIp() {
			return rqesterIp;
		}

		public void setRqesterIp(String rqesterIp) {
			this.rqesterIp = rqesterIp;
		}

		public String getRspnsCode() {
			return rspnsCode;
		}

		public void setRspnsCode(String rspnsCode) {
			this.rspnsCode = rspnsCode;
		}

		public String getRspnsCodeNm() {
			return rspnsCodeNm;
		}

		public void setRspnsCodeNm(String rspnsCodeNm) {
			this.rspnsCodeNm = rspnsCodeNm;
		}

		public String getSrvcNm() {
			return srvcNm;
		}

		public void setSrvcNm(String srvcNm) {
			this.srvcNm = srvcNm;
		}

		public String getTrgetMenuNm() {
			return trgetMenuNm;
		}

		public void setTrgetMenuNm(String trgetMenuNm) {
			this.trgetMenuNm = trgetMenuNm;
		}		
				
		public String getSortOrdr() {
			return sortOrdr;
		}

		public void setSortOrdr(String sortOrdr) {
			this.sortOrdr = sortOrdr;
		}

		public String getSearchUseYn() {
			return searchUseYn;
		}

		public void setSearchUseYn(String searchUseYn) {
			this.searchUseYn = searchUseYn;
		}

		public int getPageIndex() {
			return pageIndex;
		}

		public void setPageIndex(int pageIndex) {
			this.pageIndex = pageIndex;
		}

		public int getPageUnit() {
			return pageUnit;
		}

		public void setPageUnit(int pageUnit) {
			this.pageUnit = pageUnit;
		}

		public int getPageSize() {
			return pageSize;
		}

		public void setPageSize(int pageSize) {
			this.pageSize = pageSize;
		}

		public int getFirstIndex() {
			return firstIndex;
		}

		public void setFirstIndex(int firstIndex) {
			this.firstIndex = firstIndex;
		}

		public int getLastIndex() {
			return lastIndex;
		}

		public void setLastIndex(int lastIndex) {
			this.lastIndex = lastIndex;
		}

		public int getRecordCountPerPage() {
			return recordCountPerPage;
		}

		public void setRecordCountPerPage(int recordCountPerPage) {
			this.recordCountPerPage = recordCountPerPage;
		}
		

		public String getSearchCondition() {
			return searchCondition;
		}

		public void setSearchCondition(String searchCondition) {
			this.searchCondition = searchCondition;
		}

		public String getSearchStartdday() {
			return searchStartdday;
		}

		public void setSearchStartdday(String searchStartdday) {
			this.searchStartdday = searchStartdday;
		}

		public String getSearchEndday() {
			return searchEndday;
		}

		public void setSearchEndday(String searchEndday) {
			this.searchEndday = searchEndday;
		}

		public String getSearchKeyword() {
			return searchKeyword;
		}

		public void setSearchKeyword(String searchKeyword) {
			this.searchKeyword = searchKeyword;
		}
		@Override
		public String toString() {
			return "SysLog [errorCo=" + errorCo + ", errorCode=" + errorCode
					+ ", errorCodeNm=" + errorCodeNm + ", errorSe=" + errorSe
					+ ", insttCode=" + insttCode + ", insttCodeNm="
					+ insttCodeNm + ", jobSeCode=" + jobSeCode
					+ ", jobSeCodeNm=" + jobSeCodeNm + ", methodNm=" + methodNm
					+ ", occrrncDe=" + occrrncDe + ", processCo=" + processCo
					+ ", processSeCode=" + processSeCode + ", processSeCodeNm="
					+ processSeCodeNm + ", processTime=" + processTime
					+ ", requstId=" + requstId + ", rqesterId=" + rqesterId
					+ ", rqsterNm=" + rqsterNm + ", rqesterIp=" + rqesterIp
					+ ", rspnsCode=" + rspnsCode + ", rspnsCodeNm="
					+ rspnsCodeNm + ", srvcNm=" + srvcNm + ", trgetMenuNm="
					+ trgetMenuNm + ", searchStartdday=" + searchStartdday
					+ ", searchEndday=" + searchEndday + ", searchKeyword="
					+ searchKeyword + ", sortOrdr=" + sortOrdr
					+ ", searchUseYn=" + searchUseYn + ", searchCondition="
					+ searchCondition + ", pageIndex=" + pageIndex
					+ ", pageUnit=" + pageUnit + ", pageSize=" + pageSize
					+ ", firstIndex=" + firstIndex + ", lastIndex=" + lastIndex
					+ ", recordCountPerPage=" + recordCountPerPage + ", sqlid="
					+ sqlid + ", sqlParam=" + sqlParam + ", sqlQuery="
					+ sqlQuery + ", methodResult=" + methodResult
					+ ", getMethodResult()=" + getMethodResult()
					+ ", getSqlid()=" + getSqlid() + ", getSqlParam()="
					+ getSqlParam() + ", getSqlQuery()=" + getSqlQuery()
					+ ", getErrorCo()=" + getErrorCo() + ", getErrorCode()="
					+ getErrorCode() + ", getErrorCodeNm()=" + getErrorCodeNm()
					+ ", getErrorSe()=" + getErrorSe() + ", getInsttCode()="
					+ getInsttCode() + ", getInsttCodeNm()=" + getInsttCodeNm()
					+ ", getJobSeCode()=" + getJobSeCode()
					+ ", getJobSeCodeNm()=" + getJobSeCodeNm()
					+ ", getMethodNm()=" + getMethodNm() + ", getOccrrncDe()="
					+ getOccrrncDe() + ", getProcessCo()=" + getProcessCo()
					+ ", getProcessSeCode()=" + getProcessSeCode()
					+ ", getProcessSeCodeNm()=" + getProcessSeCodeNm()
					+ ", getProcessTime()=" + getProcessTime()
					+ ", getRequstId()=" + getRequstId() + ", getRqesterId()="
					+ getRqesterId() + ", getRqsterNm()=" + getRqsterNm()
					+ ", getRqesterIp()=" + getRqesterIp()
					+ ", getRspnsCode()=" + getRspnsCode()
					+ ", getRspnsCodeNm()=" + getRspnsCodeNm()
					+ ", getSrvcNm()=" + getSrvcNm() + ", getTrgetMenuNm()="
					+ getTrgetMenuNm() + ", getSortOrdr()=" + getSortOrdr()
					+ ", getSearchUseYn()=" + getSearchUseYn()
					+ ", getPageIndex()=" + getPageIndex() + ", getPageUnit()="
					+ getPageUnit() + ", getPageSize()=" + getPageSize()
					+ ", getFirstIndex()=" + getFirstIndex()
					+ ", getLastIndex()=" + getLastIndex()
					+ ", getRecordCountPerPage()=" + getRecordCountPerPage()
					+ ", getSearchCondition()=" + getSearchCondition()
					+ ", getSearchStartdday()=" + getSearchStartdday()
					+ ", getSearchEndday()=" + getSearchEndday()
					+ ", getSearchKeyword()=" + getSearchKeyword() + "]";
		}

		
		
		
		
}
