<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div{
	outline-style: none;
	height: 30px;
}
.ui-jqgrid tr.jqgrow {
	outline-style: none;
	height: 30px;
}
</style>
<!-- //contents -->
<input type="hidden" name="mode" id="mode" >
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>시스템 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">사용자 로그인 현황</li>
	</ol>
</div>
<h2 class="title">사용자 로그인 현황</h2>
<div class="clear">
	<div class="dashboard">
		<div class="boardlist">
	      	<div class="whiteBox searchBox">
	            <div class="sName">
	              <h3>검색 옵션</h3>
	            </div>
	            <div class="top">
	                <p>기간</p>
		            <input type="text" id="searchFrom" class="cal_icon"> ~
		            <input type="text" id="searchTo" class="cal_icon">
	                <p>검색어</p>
	                <input type="text" name="searchKeyword" id="searchKeyword"  placeholder="검색어를 입력하새요.">
	            </div>
	            <div class="inlineBtn ">
	                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
	            </div>
	        </div>
	        <div class="left_box mng_countInfo">
	          <p>총 : <span id="sp_totcnt"></span>건</p>
	        </div>
	       
	        <div class="clear"></div>
	        <div class="whiteBox"></div>
		</div>
	</div>
</div>
<div class="Swrap tableArea">
	<table id="mainGrid">
	</table>
	<div id="pager" class="scroll" style="text-align:center;"></div>     
	<br />
	<div id="paginate"></div>   
</div>
<!-- contents// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 메인 목록 정의
		EgovJqGridApi.mainGrid([
			{ label:'로그인 아이디'	, name:'log_id'		, align:'left'	},
			{ label:'아이디'		, name:'conect_id'	, align:'left'	},
			{ label:'이름'		, name:'login_nm'	, align:'left'	},
			{ label:'구분'		, name:'conect_mthd', align:'center', formatter: (c, o, row) =>
				$.trim(row.conect_mthd) == 'I' ? '로그인' : '로그아웃'
			},
			{ label:'IP'		, name:'conect_ip'	, align:'center'},
			{ label:'발생일자'		, name: 'creat_dt', align:'center', formatter: 'datetime' }
		], false, false, fnSearch);
		let today = new Date();
		$('#searchFrom').val($.datepicker.formatDate('yymmdd', today))
		$("#searchTo").val($.datepicker.formatDate('yymmdd', today))
	 });

	// 메인 목록 검색
	function fnSearch(pageNo){
		let params = {
			pageIndex	  : pageNo,
			pageUnit	  : $('.ui-pg-selbox option:selected').val(),
			searchFrom	  : $("#searchFrom").val(),
    		searchTo 	  : $("#searchTo").val(),
			searchKeyword : $("#searchKeyword").val(),
		};
		EgovJqGridApi.mainGridAjax('/backoffice/sys/selectLoginLogListAjax.do', params, fnSearch);
	}

</script>
