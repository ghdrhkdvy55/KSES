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
a.blueBtn, a.grayBtn {
	padding: 5px 12px;
	border-radius: 5px;
	font-size: 13px;
	margin-right: 5px;
}
</style>
<!-- //contents -->
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>고객 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">장기 예약 현황</li>
	</ol>
</div>
<h2 class="title">장기 예약 현황</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="whiteBox searchBox">
            <div class="top">     
            	<p>기간</p>
            	<input type="text" id="searchFrom" class="cal_icon hasDatepicker"> 
            	~
            	<input type="text" id="searchTo" class="cal_icon hasDatepicker"> 
                <p>검색어</p>
                <input type="text" id="searchKeyword" placeholder="검색어를 입력하세요." autocomplete="off">
            </div>
            <div class="inlineBtn">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
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
<div data-popup="rsv_longcustomrs" class="popup">
	<div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">장기 예매 상세</h2>
        <div class="pop_wrap">
        	<form>
        	<!-- <input type="hidden" name="mode" value="Ins"> -->
            <table class="detail_table">
	            <tbody>
	                <tr>
	                    <th>지점</th>
	                    <td id="centerNm"></td>
	                    <th>좌석 정보</th>
	                    <td id="seatNm"></td>
	                </tr>
	                <tr>
	                    <th>고객 아이디</th>
	                    <td id="userId"></td>
	                    <th>담당자 사번</th>
	                    <td id="empNo"></td>
	                </tr>
					<tr>
	                    <th>장기예약일자</th>
	                    <td>
	                    	<span id="longResvStartDt"></span>
	                    	~
	                    	<span id="longResvEndDt"></span>
	                    </td>
	                    <td colspan="3"></td>
	                </tr>
	            </tbody>
            </table>
            </form>
        </div>
        <div class="right_box">
        	<button type="button" class="grayBtn b-close">취소</button>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- 상세코드 추가 팝업 -->
<div data-popup="rsv_longcustomer_resvinfo" class="popup">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">장기 예약 상세 정보</h2>
        <div class="pop_wrap">
        	<form>
        	<input type="hidden" name="mode" value="Ins">
            <table class="detail_table">
				<tbody>
					<tr id="hideTr"> 
                    	<th>좌석 변경</th>
                    	<td name="rsvPopSeatChange">
                      		<a class="blueBtn">좌석변경</a>
                    	</td>
                    	<td colspan="3"></td>
                  	</tr>
                  	<tr>
                      <th>지점 </th>
                      <td id="rsvPopCenterNm"></td>
                      <th>좌석 정보 </th>
                      <td id="rsvPopAreaInfo"></td>
                  	</tr> 
                  	<tr>
						<th>예약 번호</th>
                    	<td id="rsvPopResvSeq"></td>
						<th>예약일자</th>
                    	<td id="rsvPopResvDate"></td>
                  	</tr>
                  	<tr>
                    	<th>이름 </th>
                    	<td id="rsvPopResvUserNm"></td>
                    	<th>전화번호</th>
                    	<td id="rsvPopResvUserPhone"></td>
                  	</tr>
                  	<tr>
						<th>아이디 </th>
                    	<td id="rsvPopUserId"></td>
						<th>결제 정보 </th>
                    	<td id="rsvPopResvPayDvsn"></td>
                  	</tr>
                  	<tr>
                    	<th>문진표</th>
						<td id="rsvPopResvUserAskYn">Y</td>
						<th>입장료</th>
                  		<td id="rsvPopResvEntryPayCost"></td>
                  	</tr>
                  	<tr>

                  		<th>좌석료</th>
                  		<td id="rsvPopResvSeatPayCost"></td>
						<th>발권 구분</th>
                    	<td id="rsvPopResvTicketDvsn"></td>                  			
                  	</tr>
              	</tbody>
            </table>
            <br>
			<p class="pop_tit">입/출입 내역 <span class="pBtn"><a href="javascript:$('#rsv_inout_add').bPopup();" class="blueBtn">입출입 수동 등록</a></span></p>
			<div id="inOutHis"> 
	          	<table id="inOutHisTable" class="main_table">
					
	          	</table>
				<div id="inOutHisPager" class="scroll" style="text-align:center;"></div>     
							
				<div id="paginate"></div>
			</div>
            </form>
        </div>
        <div class="right_box">
        	<button type="button" class="grayBtn b-close">취소</button>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->

<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		EgovJqGridApi.mainGrid([
            { label: '장기예약시퀀스', name:'long_resv_seq', align:'center', key: true, hidden:true },
			{ label: '지점', name:'center_nm', align: 'center'},
			{ label: '좌석 정보',  name:'seat_nm', align: 'center'},
			{ label: '장기예약시작일', name:'long_resv_start_dt', align:'center'},
			{ label: '장기예약종료일', name:'long_resv_end_dt', align:'center'},
			{ label: '고객아이디', name:'user_id', align:'center' },
            { label: '담당자사번', name:'emp_no', align:'center'},
            { label: '장기예약 전체취소', name:'long_resv_cancel', align:'center', formatter:fnLongResvInfoCancelButton},
            { label: '버튼상태', name:'all_cancel_btn_state', align:'center', hidden:true}
		], false, true, fnSearch);
		
		$("#searchFrom").datepicker(EgovCalendar);
		$("#searchTo").datepicker(EgovCalendar);
	});
	
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchFrom: $('#searchFrom').val(),
			searchTo: $('#searchTo').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/rsv/longCustomerListsAjax.do', params, fnSearch, fnSubGrid);
	}
	
  	function fnSubGrid(id, longResvSeq) {
		let subGridId = id + '_t';
		$('#'+id).empty().append('<table id="'+ subGridId + '" class="scroll"></table>');
		EgovJqGridApi.subGrid(subGridId, 
		[
			{label: '지점', name:'center_nm', align:'center'},
			{label: '좌석정보', name:'seat_nm', align:'center'},
			{label: '구역등급', name:'part_class', align:'center'},					
			{label: '예약번호', name:'resv_seq', align:'center', key: true},
			{label: '아이디', name:'user_id', align:'center'},
			{label: '이름', name:'user_nm', align:'center'},
			{label: '전화번호', name:'user_phone', align:'center'},
			{label: '금액', name: 'resv_pay_cost', align:'center'},
			{label: '신청일자', name:'resv_req_date', align:'center'},
			{label: '예약일자', name:'resv_end_dt', align:'center'},
			{label: '예약상태', name:'resv_state_text', align:'center'},
			{label: '결제상태', name:'resv_pay_dvsn_text', align:'center'},
			{label: '예약취소', name:'resv_cancel', align:'center', formatter:fnResvInfoCancelButton},
			{label: '예약상태', name:'resv_state', align:'center', hidden:true},
			{label: '결제상태', name:'resv_pay_dvsn', align:'center', hidden:true},
			{label: '입장료', name:'resv_entry_pay_cost', align:'center', hidden: true},
			{label: '좌석료', name:'resv_seat_pay_cost', align:'center', hidden: true},
			{label: '발권 구분', name:'resv_ticket_dvsn_text', align:'center', hidden: true},
		], 'GET', '/backoffice/rsv/longcustomerResvInfo.do', {
			longResvSeq: longResvSeq
		});
	}
	
	function fnLongcustomersInfo(id, rowData) {
		let $popup = $('[data-popup=rsv_longcustomrs]');
		let $form = $popup.find('form:first');
		$form.find('td#centerNm').html(rowData.center_nm);
		$form.find('td#seatNm').html(rowData.seat_nm);
		$form.find('span#longResvStartDt').html(rowData.long_resv_start_dt);
		$form.find('span#longResvEndDt').html(rowData.long_resv_end_dt);
		$form.find('td#userId').html(rowData.user_id);
		$form.find('td#empNo').html(rowData.emp_no);
		$popup.bPopup();
	}
	
	function fnLongcustomerResvInfo(id, rowData, gridId) {
		let $popup = $('[data-popup=rsv_longcustomer_resvinfo]');
		let $form = $popup.find('form:first');
		let rowId = $('#mainGrid').jqGrid('getGridParam', 'selrow');
		$form.find('tr#hideTr').hide();
		$form.find('td#rsvPopCenterNm').html(rowData.center_nm);
		$form.find('td#rsvPopAreaInfo').html(rowData.seat_nm);
		$form.find('td#rsvPopResvSeq').html(rowData.resv_seq);
		$form.find('td#rsvPopResvDate').html(rowData.resv_end_dt);
		$form.find('td#rsvPopResvUserNm').html(rowData.user_nm);
		$form.find('td#rsvPopResvUserPhone').html(rowData.user_phone);
		$form.find('td#rsvPopUserId').html(rowData.user_id);
		$form.find('td#rsvPopResvPayDvsn').html(rowData.resv_pay_dvsn_text);
		$form.find('td#rsvPopResvEntryPayCost').html(rowData.resv_entry_pay_cost);
		$form.find('td#rsvPopResvSeatPayCost').html(rowData.resv_seat_pay_cost);
		$form.find('td#rsvPopResvTicketDvsn').html(rowData.resv_ticket_dvsn_text);
		$form.find('p.pop_tit').hide();
		$form.find('div#inOutHis').hide();
		$popup.bPopup();
	}
	
	function fnResvInfoCancelButton(cellvalue, options, rowObject) {
		
		if(today_get() < rowObject.resv_end_dt){
			if (rowObject.resv_state == "RESV_STATE_4"){
				return '<a href="javascript:void(0);" class="grayBtn">취소 완료</a>';
			}else {
				return '<a href="javascript:fnResvInfoCancel(&#39;'+rowObject.resv_seq+'&#39;);" class="blueBtn">예약 취소</a>';
			}
		} else {
			return '<a href="javascript:void(0);" class="grayBtn">취소 불가</a>';
		}
	}
	
	function fnResvInfoCancel(resvSeq) {
		common_modelClose("confirmPage");
		var url = "/backoffice/rsv/resvInfoCancel.do";
		var params = {"resvSeq" : resvSeq};
		
		fn_Ajax
		(
			url,
			"GET",
			params,
			false,
			function(result) {
				if (result.status == "SUCCESS") {
					common_popup(result.message, "Y", "");
					fnSearch(1);
				} else if (result.status == "LOGIN FAIL") {
					common_popup("로그인 정보가 올바르지않습니다 다시 로그인해주세요", "Y", "");
				} else {
					common_popup(result.message, "Y", "");
				}
			},
			function(request) {
				common_popup("ERROR : " + request.status, "Y", "");	       						
			}    		
		);
	}
	function fnLongResvInfoCancelButton(cellvalue, options, rowObject) {
		if(rowObject.all_cancel_btn_state == "ON"){
			return '<a href="javascript:fnLongResvInfoCancel(&#39;'+rowObject.long_resv_seq+'&#39;);" class="blueBtn">예약 취소</a>';	
		} else {
			return '<a href="javascript:void(0);" class="grayBtn">취소 완료</a>';
		}
	}
	
	function fnLongResvInfoCancel(longResvSeq) {

		var url = "/backoffice/rsv/resvInfoCancelAll.do";
		var params = {"longResvSeq" : longResvSeq,
					  "mode" : "Long"
					 };
		
		fn_Ajax
		(
		    url,
		    "POST",
			params,
			false,
			function(result) {
				if (result.status == "SUCCESS") {
					if(result.allCount > 0) {
						result.message = 
							"전체 예약취소가 정상적으로 처리 되었습니다." + "<br><br>" +
							"취소 예약정보 : "  + result.allCount + "건" + "<br>" +
							"취소 성공 : "  + result.successCount + "건" + "<br>" + 
							"취소 실패 : "  + result.failCount + "건" + "<br>" +
							"무인발권기 예외 : "  + result.ticketCount + "건";
						common_popup(result.message, "Y", "");
						fnSearch(1);
					} else {
						common_popup("예약 일자를 확인해 주세요.", "Y", "");
					}
		    	} else if (result.status == "LOGIN FAIL") {
		    		common_popup("로그인 정보가 올바르지않습니다 다시 로그인해주세요", "N", "");
		    	} else {
		    		common_popup(result.message, "N", "");
		    	}
			},
			function(request) {
				common_popup("ERROR : " + request.status, "N", "");	       						
			}    		
		);
	}
	
</script>
<c:import url="/backoffice/inc/popup_common.do" />