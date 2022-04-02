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
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll"></div>     
        </div>
    </div>
</div>
<!-- contents//-->
<!-- //popup -->
<!--권한분류 추가 팝업-->
<div data-popup="bas_interfaceinfo" class="popup">
	<div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">전문 상세 내역</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>전문ID</th>
                        <td><span id="sp_reqId"></span></td>
                        <th>송수신구분</th>
                        <td><span id="sp_trsmrcv"></span></td>
                    </tr>
                    <tr>
                        <th>요청기간</th>
                        <td><span id="sp_reqInsttId"></span></td>
                        <th>제공기관</th>
                        <td><span id="sp_proInsttId"></span></td>
                    </tr>
                    <tr>
                        <th>송신시간</th>
                        <td><span id="sp_reqTrnTm"></span></td>
                        <th>수신시간</th>
                        <td><span id="sp_recpTnTm"></span></td>
                    </tr>
                    <tr>
                        <th>결과값</th>
                        <td colspan="3">
                        <span id="sp_resultCode"></span>
                        <br/>  
                        <span id="sp_sendMessage"></span>
                        <br/>  
                        <span id="sp_resultMessage"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
		<div class="right_box">
        	<button type="button" class="grayBtn b-close">닫기</button>
        </div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 인터페이스 로그 현황 메인 그리드 정의
		EgovJqGridApi.mainGrid([
			{ label: '인터페이스 아이디',	name:'requst_id',    	  	hidden:true, 	key: true},
			{ label: '일자',  		 	name:'occrrnc_de', 		  	align:'center'},
			{ label: '송수신구분',      	name:'trsmrcv_se_code',   	align:'center'},
			{ label: '연계ID',        	name:'integ_id', 		  	align:'center'},
			{ label: '제공기관',       	name:'provd_instt_id', 	  	align:'center'},
			{ label: '요청기관', 			name:'requst_instt_id',   	align:'center'},
			{ label: '송신시간', 			name:'requst_trnsmit_tm', 	align:'center'},
			{ label: '수신시간', 			name:'rspns_recptn_tm',   	align:'center'},
			{ label: '결과코드', 			name:'result_code',       	align:'center'},
			{ label: '발생일자', 			name:'frst_regist_pnttm', 	align:'center', formatter: 'date'},
			{ label: '전송메시지',     	name:'send_message', 	    hidden:true},
			{ label: '결과메시지',         name:'result_message', 		hidden:true}
		],false, false, fnSearch);
		
		// 메인 그리드 상세조회 이벤트 바인딩
		EgovJqGridApi.mainGridDetail(fnInterfaceInfo);
		
		// 검색일자 세팅
		let today = new Date();
		$('#searchFrom').val($.datepicker.formatDate('yymmdd', today))
		$("#searchTo").val($.datepicker.formatDate('yymmdd', today))
	});
	
	// 인터페이스 로그 목록 조회
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchFrom: $('#searchFrom').val(),
			searchTo: $('#searchTo').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/sys/selectInterfaceListAjax.do', params, fnSearch);
	}
	
	// 인터페이스 로그 상세정보 팝업
	function fnInterfaceInfo(rowId, rowData) {
		let $popup = $('[data-popup=bas_interfaceinfo]');

		$popup.find('span').text('');
		$popup.find('span#sp_reqId').text(rowData.requst_id);
		$popup.find('span#sp_trsmrcv').text(rowData.occrrnc_de);
		$popup.find('span#sp_reqInsttId').text(rowData.requst_instt_id);
		$popup.find('span#sp_proInsttId').text(rowData.provd_instt_id);
		$popup.find('span#sp_reqTrnTm').text(rowData.requst_trnsmit_tm);
		$popup.find('span#sp_recpTnTm').text(rowData.rspns_recptn_tm);
		$popup.find('span#sp_resultCode').text(rowData.result_code);
		$popup.find('span#sp_sendtMessage').text(rowData.send_message);
		$popup.find('span#sp_resultMessage').text(rowData.result_message);
		
		$popup.bPopup();
	}
</script>