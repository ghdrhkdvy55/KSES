<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<div class="breadcrumb">
  	<ol class="breadcrumb-item">
    	<li>시스템 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">인터페이스 현황</li>
  	</ol>
</div>
<h2 class="title">인터페이스 현황</h2>
<div class="clear"></div>
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
                <input type="text" id="searchKeyword"  placeholder="검색어를 입력하새요." autocomplete="off">
            </div>
            <div class="inlineBtn ">
                <a href="javascript:fnSearch(1)" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>     
        </div>
    </div>
</div>
<!-- contents//-->
<!-- //popup -->
<div data-popup="sys_interfaceinfo" id=bas_interfaceinfo class="popup">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">전문 상세 내역</h2>
        <div class="pop_wrap">
        	<form>
				<table class="detail_table">
				    <tbody>
				        <tr>
				            <th>전문ID</th>
				            <td><span id="spReqId"></span></td>
				            <th>송수신구분</th>
				            <td><span id="spTrsmrcv"></span></td>
				        </tr>
				        <tr>
				            <th>요청기간</th>
				            <td><span id="spReqInsttId"></span></td>
				            <th>제공기관</th>
				            <td><span id="spProInsttId"></span></td>
				        </tr>
				        <tr>
				            <th>송신시간</th>
				            <td><span id="spReqTrnTm"></span></td>
				            <th>수신시간</th>
				            <td><span id="spRspTrnTm"></span></td>
				        </tr>
				        <tr>
				            <th>결과값</th>
				            <td colspan="3">
				            <span id="spResultCode"></span>
				            <br/>  
				            <span id="spSendtMessage"></span>
				            <br/>  
				            <span id="spResultMessage"></span>
				            </td>
				        </tr>
				    </tbody>
				</table>
			</form>
        </div>
        <div class="right_box">
            <button class="grayBtn b-close">취소</button>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		EgovJqGridApi.mainGrid([
			{ label: '인터페이스 아이디', key: true, name: 'requst_id', align: 'left', hidden:true},
			{ label: '일자', name: 'occrrnc_de', align: 'left', width: '10%'},
			{ label: '송수신구분', name: 'trsmrcv_se_code', align: 'left', width: '10%'},
			{ label: '연계ID', name: 'integ_id', align: 'center', width: '12%'},
			{ label: '제공기관', name: 'provd_instt_id', align: 'center', width: '12%'},
			{ label: '요청기간', name: 'requst_instt_id', align: 'center', width: '12%'},
			{ label: '송신시간', name: 'requst_trnsmit_tm', align: 'center', width: '12%'},
			{ label: '수신시간', name: 'rspns_recptn_tm', align:'center', width:'12%'},
			{ label: '결과코드', name: 'result_code', align:'center', width:'12%'},
			{ label: '결과메세지', name: 'result_message', align:'center', hidden:true},
			{ label: '송신메세지', name: 'send_message', align:'center', hidden:true},
			{ label: '발생일자', name: 'frst_regist_pnttm', align: 'center', width: '8%', 
			sortable: 'date',formatter: "date", formatoptions: { newformat: "Y-m-d H:i:s"}}	
		], false, false, fnSearch);	
		
		$("#searchFrom").datepicker(EgovCalendar);
		$("#searchTo").datepicker(EgovCalendar);
	});
	
	function fnSearch(pageNo) {
		let params = {
				pageIndex : pageNo,
				pageUnit : $('.ui-pg-selbox option:selected').val(),
				searchKeyword : $("#searchKeyword").val(),
				searchFrom : $("#searchFrom").val(),
				searchTo : $("#searchTo").val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/sys/selectInterfaceListAjax.do', params, fnSearch);
		EgovJqGridApi.mainGridDetail(fnInterfaceInfo);
	}
	
	function fnInterfaceInfo(id, rowData) {
		let $popup = $('[data-popup=sys_interfaceinfo]');
		let $form = $popup.find('form:first');
		$form.find('span#spReqId').html(rowData.requst_id);
		$form.find('span#spTrsmrcv').html(rowData.trsmrcv_se_code);
		$form.find('span#spReqInsttId').html(rowData.requst_instt_id);
		$form.find('span#spProInsttId').html(rowData.provd_instt_id);
		$form.find('span#spReqTrnTm').html(rowData.requst_trnsmit_tm);
		$form.find('span#spRspTrnTm').html(rowData.rspns_trnsmit_tm);
		$form.find('span#spResultCode').html(rowData.result_code);
		$form.find('span#spResultMessage').html(rowData.result_message);
		$form.find('span#spSendtMessage').html(rowData.send_message);
		$popup.bPopup();
	}
	
	
/* 		result : function(cellvalue, options, rowObject){
			var resultTxt = "";
			switch (rowObject.result){
				case "O" :
					resultTxt = "즉시전송";
					break;
				case "R" :
					resultTxt = "예약전송";
					break;
				case "Y" :
					resultTxt = "정상발송";
					break;
				default :
				resultTxt = "애러";
			}
			return resultTxt;
		}, */
</script>
