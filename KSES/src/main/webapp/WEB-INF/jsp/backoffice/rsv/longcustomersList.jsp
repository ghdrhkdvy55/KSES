<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/css/paragraph_new.css">
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
            	<input type="text" name="searchFrom" id="searchFrom" class="cal_icon" readonly>
            	~
            	<input type="text" id="searchTo" class="cal_icon" readonly>
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
        	<a href="javascript:fnLongSeatAdd();" class="blueBtn">장기 예매</a>
        </div>
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager"></div>  
        </div>
    </div>
</div>
<!-- contents//-->
<!-- // 장기예매고객 팝업 -->
<div data-popup="long_seat_add" class="popup">
  	<div class="pop_con">
		<a href="javascript:;" class="button b-close">X</a>
      	<h2 class="pop_tit">장기 예매 등록</h2>
      	<div class="pop_wrap">
      		<form>
			<table class="detail_table">
				<tbody>
                  	<tr>
                    	<th>좌석 정보</th>
                      	<td colspan="3">
							<input type="text" name="longResvSeatNm" readonly>
							<input type="hidden" name="longResvCenterCd">
							<input type="hidden" name="longResvFloorCd">
							<input type="hidden" name="longResvPartCd">
							<input type="hidden" name="longResvSeatCd">
							<input type="hidden" name="longResvPayCost">
							<input type="hidden" name="resvEntryPayCost">
							<input type="hidden" name="seasonCd">
							<a href="javascript:fnResvSeatInfo()" class="blueBtn">좌석 조회</a>
                      	</td>
                  	</tr>
					<tr>
                    	<th>예약 일자 </th>
                    	<td colspan="3">                      
                      		<p>
								<input type="text" name="longResvDateFrom" readonly><em> ~ </em>
                        		<input type="text" name="longResvDateTo" readonly>
                      		</p>
                    	</td>
                    </tr>
                  	<tr>
                    	<th>회원 조회</th>
                    	<td>
                      		<select name="userSearchCondition">
                          		<option value="user_id">아이디</option>
                          		<option value="user_nm">이름</option>    
                          		<option value="user_phone">전화번호</option>             
                      		</select>
                      		<input type="text" name="userSearchKeyword">
                      		<a href="javascript:fnUserInfoPopup();" class="blueBtn">조회</a>
                    	</td>
						<th>예약 회원(아이디)</th>
                    	<td>
                      		<input type="text" name="longResvUserId" readonly>
                      		<input type="hidden" name="longResvUserName">
                      		<input type="hidden" name="longResvUserPhone">
                    	</td>
                  	</tr>
                  	<tr>
						<th>담당자 조회</th>
                    	<td>
							<select name="empSearchCondition" style="width:100px;">
								<option value="emp_no">사번</option>
								<option value="emp_nm">이름</option>
							</select>
	                    	<input type="text" name="empSearchKeyword">
	                    	<a href="javascript:fnEmpInfoPopup();" class="blueBtn">조회</a>
                    	</td>
						<th>예약 담당자(사번)</th>
                    	<td>
                      		<input type="text" name="longResvEmpNo" readonly>
                    	</td>
                  	</tr>
					<tr>
                    	<td colspan="4"><textarea name="" rows="5" style="width: 100%;"></textarea></td>
                  	</tr>
              	</tbody>
			</table>
			</form>
      	</div>
      	<div class="right_box">
			<button type="button" class="blueBtn">저장</button>
	    	<button type="button" class="grayBtn b-close">취소</button>
      	</div>
      	<div class="clear"></div>
  	</div>
</div>
<!-- // 사용자 좌석 변경 팝업 -->
<div data-popup="seat_change" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">사용자 좌석 변경</h2>
      	<form>
      	<div class="pop_wrap pop_seat_change">
        	<div class="searchBox left_box">
          		<p>지점
            		<select id="resvCenterCd" name="resvCenterCd" onChange="javascript:fnCenterChange()">
            			<option value="">선택</option>
						<c:forEach items="${centerInfo}" var="centerInfo">
							<option value="${centerInfo.center_cd}" data-entrypaycost="${centerInfo.center_entry_pay_cost}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
            		</select>
          		</p>
          		<p>층
            		<select id="resvFloorCd" name="resvFloorCd" onChange="javascript:fnFloorChange()">
              			<option value="">선택</option>
            		</select>
          		</p>
          		<p>구역
            		<select id="resvPartCd" name="resvPartCd">
              			<option value="">선택</option>
            		</select>
          		</p>
          		<p>날짜 
            		<input type="text" name="resvDateFrom" class="cal_icon"> ~
            		<input type="text" name="resvDateTo" class="cal_icon">
          		</p>
          		<a href="javascript:fnResvSeatSearch();" class="grayBtn left_box">검색</a>
        	</div>
        	<a href="javascript:void(0)" class="blueBtn right_box">저장</a>
			<div class="clear"></div>
        	<div class="pop_mapArea" style="background: url(/resources/img/area_bg.png) no-repeat center;">
          		<div class="pop_seat_label left_box">
            		<ul>
              			<li class="disable"><i></i>신청불가</li>
              			<li class="usable"><i></i>신청가능</li>
              			<li class="selected"><i></i>선택좌석</li>
            		</ul>
          		</div>
          		<ul class="pop_seat">
          		</ul>
        	</div>
      	</div>
      	</form>
  	</div>
</div>
<!-- 고객 조회 팝업 -->
<div data-popup="bld_user_search" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">회원 조회</h2>
		<div class="pop_wrap">
			<form>
			<fieldset class="whiteBox searchBox">
				<div class="top" style="padding:0;border-bottom:none;">
					<select id="userInfoSearchCondition">
						<option value="user_id">아이디</option>
						<option value="user_nm">이름</option>    
						<option value="user_phone">전화번호</option>             
					</select>
					<input type="text" id="userInfoSearchKeyword" placeholder="검색어를 입력하세요.">
					<a href="javascript:fnUserSearchInfo(1);" class="grayBtn">검색</a>
				</div>
			</fieldset>
			<div style="width:570px;">
				<table id="popGridUser"></table>
				<div id="popPagerUser"></div>
			</div>
			</form>
		</div>
		<popup-right-button okText="선택" clickFunc="fnUserSearchSelect();" />
	</div>
</div>
<!-- 담당자 조회 팝업 -->
<div data-popup="bld_emp_search" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">담당자 조회</h2>
		<div class="pop_wrap">
			<form>
			<fieldset class="whiteBox searchBox">
				<div class="top" style="padding:0;border-bottom:none;">
					<select id="empInfoSearchCondition" style="width:100px;">
						<option value="">선택</option>
						<option value="emp_no">사번</option>
						<option value="emp_nm">이름</option>
					</select>
					<input type="text" id="empInfoSearchKeyword" placeholder="검색어를 입력하세요.">
					<a href="javascript:fnUserSearchInfo(1);" class="grayBtn">검색</a>
				</div>
			</fieldset>
			<div style="width:570px;">
				<table id="popGridEmp"></table>
				<div id="popPagerEmp"></div>
			</div>
			</form>
		</div>
		<popup-right-button okText="선택" clickFunc="fnEmpSearchSelect();" />
	</div>
</div>
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 장기 예약 조회 jqGrid 정의
		EgovJqGridApi.mainGrid([
            { label: '장기예약시퀀스', name:'long_resv_seq', align:'center', key: true, hidden:true },
			{ label: '지점', name:'center_nm', align: 'center', fixed: true},
			{ label: '좌석 정보',  name:'seat_nm', align: 'center'},
			{ label: '시작일', name:'long_resv_start_dt', align:'center', fixed: true},
			{ label: '종료일', name:'long_resv_end_dt', align:'center', fixed: true},
			{ label: '고객아이디', name:'user_id', align:'center' },
            { label: '담당자사번', name:'emp_no', align:'center'},
            { label: '전체취소', width: 100, fixed: true, align:'center', formatter:fnLongResvInfoCancelButton},
            { label: '예약수', name:'child_cnt', hidden: true },
            { label: '버튼상태', name:'all_cancel_btn_state', align:'center', hidden:true}
		], false, true, fnSearch).jqGrid('setGridParam', {
			isHasSubgrid: function(rowId) {
				let rowData = EgovJqgridApi.getMainGridRowData(rowId);
				if (rowData.child_cnt === '0') {
					return false;
				}
				return true;
			}
		});
		// 회원 조회 검색 JqGrid 정의
		EgovJqGridApi.pagingGrid('popGridUser', [
			{ label: '아이디', name: 'user_id', align: 'center', sortable: false, key: true },
			{ label: '이름', name: 'user_nm', align: 'center', sortable: false },
			{ label: '전화번호', name: 'user_phone', align: 'center', sortable: false }
		], 'popPagerUser', false, false, 5);
		// 담당자 조회 검색 JqGrid 정의
		EgovJqGridApi.pagingGrid('popGridEmp', [
			{ label: '사번', name: 'emp_no', align: 'center', sortable: false, key: true },
			{ label: '이름', name: 'emp_nm', align: 'center', sortable: false },
			{ label: '부서', name: 'dept_nm', align: 'center', sortable: false },
			{ label: '전화번호', name: 'emp_clphn', hidden: true },
			{ label: '이메일', name: 'emp_email', hidden: true }
		], 'popPagerEmp', false, false, 5);
		
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
	// 장기 예약 SubGrid 정의
  	function fnSubGrid(parentId, rowId) {
		EgovJqGridApi.subGrid(parentId, 
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
			longResvSeq: rowId
		});
	}
	// 장기 예약 단건 취소 버튼 호출
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
	//장기 예약 단건 취소 기능
	function fnResvInfoCancel(resvSeq) {
		var url = "/backoffice/rsv/resvInfoCancel.do";
		var params = {resvSeq: resvSeq};
		bPopupConfirm('장기 예약 단건 취소', '예약을 취소 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'GET',
				url,
				params,
				null,
				function(json) {
					toastr.info(json.message);
					fnSearch(1);
				},
				function(json) {
					toastr.warning(json.message);
				}
			);
		});
	}
	//장기 예약 전체 취소 버튼 호출
	function fnLongResvInfoCancelButton(cellvalue, options, rowObject) {
		if(rowObject.all_cancel_btn_state == "ON"){
			return '<a href="javascript:fnLongResvInfoCancel(&#39;'+rowObject.long_resv_seq+'&#39;);" class="blueBtn">예약 취소</a>';	
		} else {
			return '<a href="javascript:void(0);" class="grayBtn">취소 완료</a>';
		}
	}
	//장기 예약 전체 취소 기능
	function fnLongResvInfoCancel(longResvSeq) {
		let url = '/backoffice/rsv/resvInfoCancelAll.do';
		let params = {
			longResvSeq: longResvSeq,
			mode: 'Long'
		};
		bPopupConfirm('장기 예약 전체 취소', '예약을 모두 취소 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				url,
				params,
				null,
				function(json) {
					if(json.allCount > 0) {
						json.message = 
							"취소 예약정보 : "  + json.allCount + "건" + "<br>" +
							"취소 성공 : "  + json.successCount + "건" + "<br>" + 
							"취소 실패 : "  + json.failCount + "건" + "<br>";
						toastr.info(json.message,'전체 예약취소가 정상 처리 되었습니다.',{timeOut: 50000});
						fnSearch(1);
					} else {
						toastr.warning("예약 일자를 확인해 주세요.");
					}
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 장기 예약 팝업 호출
	function fnLongSeatAdd() {
		let $popup = $('[data-popup=long_seat_add]');
		let $form = $popup.find('form:first');
		$popup.find('button.blueBtn').off('click').click(fnLongSeatUpdate);
		$form.find(':hidden[name=seasonCd]').val('');
		$form.find(':hidden[name=resvEntryPayCost]').val('');
		$form.find(':hidden[name=longResvCenterCd]').val('');
		$form.find(':hidden[name=longResvFloorCd]').val('');
		$form.find(':hidden[name=longResvPartCd]').val('');
		$form.find(':hidden[name=longResvSeatNm]').val('');
		$form.find(':hidden[name=longResvSeatCd]').val('');
		$form.find(':hidden[name=longResvDateFrom]').val('');
		$form.find(':hidden[name=longResvDateTo]').val('');
		$form.find('select[name=userSearchCondition]option:eq(0)').prop("selected",true);
		$form.find(':text[name=userSearchKeyword]').val('');
		$form.find(':text[name=longResvUserId]').val('');
		$form.find('select[name=empSearchCondition]option:eq(0)').prop("selected",true);
		$form.find(':text[name=empSearchKeyword]').val('');
		$form.find(':text[name=longResvEmpNo]').val('');
		
		$popup.bPopup();
	}
	//장기 예약 좌석 조회 팝업 호출
	function fnResvSeatInfo() {
		let $popup = $('[data-popup=seat_change]');
		let $form = $popup.find('form:first');
		$popup.find('p:eq(3)').show();
		$popup.find('a:eq(1)').attr("href","javascript:fnResvSeatSearch();");
		$popup.find('.pop_tit').html('사용자 좌석 선택');
		$popup.find('.pop_mapArea').css('background','');
		$popup.find('.pop_seat').html('');
		if($('#loginAuthorCd').val() != 'ROLE_ADMIN' && $('#loginAuthorCd').val() != 'ROLE_SYSTEM') {
			$form.find('select[name=resvCenterCd]').val($('#loginCenterCd').val()).trigger('change').closest('p').hide();
		} else {
			$form.find('select[name=resvCenterCd]').val('');
			$form.find('select[name=resvFloorCd]').children('option:not(:first)').remove();
		}
		$form.find('select[name=resvPartCd]').children('option:not(:first)').remove();
		$form.find(':text[name=resvDateFrom]').val('');
		$form.find(':text[name=resvDateTo]').val('');
		$popup.find('a:eq(2)').html('좌석선택').attr('href', 'javascript:fnSetLongSeatInfo()');
		seatSearchInfo = {};
		$('[data-popup=long_seat_add] :hidden[name=seasonCd]').val('');
		$popup.bPopup();
	}
	// 장기 예약 좌석 및 정보 선택
	function fnSetLongSeatInfo() {
		let $popup = $('[data-popup=long_seat_add]');
		let $form = $popup.find('form:first');
		if($(".pop_seat li.usable").length <= 0) {
			toastr.warning("좌석을 선택하세요.");
			return;	
		}
		$form.find(':hidden[name=longResvCenterCd]').val(seatSearchInfo.centerCd);
		$form.find(':hidden[name=longResvFloorCd]').val(seatSearchInfo.floorCd);
		$form.find(':hidden[name=longResvPartCd]').val(seatSearchInfo.partCd);
		$form.find(':hidden[name=longResvSeatCd]').val($(".pop_seat li.usable").attr("id"));
		$form.find(':text[name=longResvSeatNm]').val(
			$('select[name=resvCenterCd] option:checked').text() + ' ' +
			$('select[name=resvFloorCd] option:checked').text() + ' ' +
			$('select[name=resvPartCd] option:checked').text() + '구역 ' +
			$(".pop_seat li.usable").data("seat_name")
		);
		$form.find(':hidden[name=longResvPayCost]').val($(".pop_seat li.usable").data("seat_paycost"));
		$form.find(':text[name=longResvDateFrom]').val($(':text[name=resvDateFrom]').val());
		$form.find(':text[name=longResvDateTo]').val($(':text[name=resvDateTo]').val());
		$('[data-popup=seat_change]').bPopup().close();
	}
	// 회원 조회 팝업 호출
	function fnUserInfoPopup() {
		$('#userInfoSearchKeyword').val(
			$('[data-popup=long_seat_add] :text[name=userSearchKeyword]').val()
		);
		$('#userInfoSearchCondition').val(
			$('[data-popup=long_seat_add] select[name=userSearchCondition]').val()
		);
		fnUserSearchInfo(1);
		setTimeout(function() {
			$('[data-popup=bld_user_search]').bPopup();	
		}, 100);
	}
	// 담당자 조회 팝업 호출
	function fnEmpInfoPopup() {
		$('#empInfoSearchKeyword').val(
			$('[data-popup=long_seat_add] :text[name=empSearchKeyword]').val()
		);
		$('#empInfoSearchCondition').val(
			$('[data-popup=long_seat_add] select[name=empSearchCondition]').val()
		);
		fnEmpSearchInfo(1);
		setTimeout(function() {
			$('[data-popup=bld_emp_search]').bPopup();	
		}, 100);
	}
	// 회원 조회
	function fnUserSearchInfo(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: '5',
			searchKeyword: $('#userInfoSearchKeyword').val(),
			searchCondition: $('#userInfoSearchCondition').val()
		};
		EgovJqGridApi.pagingGridAjax('popGridUser', '/backoffice/cus/userListInfoAjax.do', params, fnUserSearchInfo);
	}
	
	// 담당자 조회
	function fnEmpSearchInfo(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: '5',
			searchKeyword: $('#empInfoSearchKeyword').val(),
			searchCondition: $('#empInfoSearchCondition').val(),
			mode: 'list'
		};
		EgovJqGridApi.pagingGridAjax('popGridEmp', '/backoffice/mng/empListAjax.do', params, fnEmpSearchInfo);
	}
	// 회원 조회 결과 선택
	function fnUserSearchSelect() {
		let $popup = $('[data-popup=bld_user_search]');
		let rowId = EgovJqGridApi.getGridSelectionId('popGridUser');
		if (rowId === null) {
			toastr.warning('목록을 선택해주세요.');
			return;
		}
		let rowData = EgovJqGridApi.getGridRowData('popGridUser', rowId);
		$('[data-popup=long_seat_add] :text[name=userSearchKeyword]').val(rowId);
		$('[data-popup=long_seat_add] :text[name=longResvUserId]').val(rowData.user_id);
		$('[data-popup=long_seat_add] :hidden[name=longResvUserName]').val(rowData.user_nm);
		$('[data-popup=long_seat_add] :hidden[name=longResvUserPhone]').val(rowData.user_phone);
		$popup.bPopup().close();
	}
	// 담당자 조회 결과 선택
	function fnEmpSearchSelect() {
		let $popup = $('[data-popup=bld_emp_search]');
		let rowId = EgovJqGridApi.getGridSelectionId('popGridEmp');
		if (rowId === null) {
			toastr.warning('목록을 선택해주세요.');
			return;
		}
		let rowData = EgovJqGridApi.getGridRowData('popGridEmp', rowId);
		$('[data-popup=long_seat_add] :text[name=empSearchKeyword]').val(rowId);
		$('[data-popup=long_seat_add] :text[name=longResvEmpNo]').val(rowId);
		$popup.bPopup().close();
	}
	// 좌석 선택 기능
	function fnResvSeatSearch() {
		let $popup = $('[data-popup=seat_change]');
		let $form = $popup.find('form:first');
		var url = "/front/rsvSeatListAjax.do";
		var params = {};
		if($form.find('select[name=resvCenterCd]').val() == "") { toastr.warning("지점을 선택하세요."); return; }
		if($form.find('select[name=resvFloorCd]').val() == "") { toastr.warning("층을 선택하세요."); return; }
		if($form.find('select[name=resvPartCd]').val() == "") { toastr.warning("구역을 선택하세요."); return; }
		if(!$form.find(':text[name=resvDateFrom]').val() || !$form.find(':text[name=resvDateTo]').val()){
			toastr.warning("예약일자를 입력하세요.");
			return;
		} else if(!yesterDayConfirm($form.find(':text[name=resvDateFrom]').val())){
			toastr.warning("예약시작일을 이전일자로 지정하실수 없습니다.");
			return;					
		} else if(!dateIntervalCheckTemp($form.find(':text[name=resvDateFrom]').val(), $form.find(':text[name=resvDateTo]').val())){
			toastr.warning("종료일자가 시작일자보다 빠를수 없습니다.");
			return;
		}
		params = {
			searchCondition: 'LONG',
			resvDateFrom: $form.find(':text[name=resvDateFrom]').val(),
			resvDateTo: $form.find(':text[name=resvDateTo]').val(),
			centerCd: $form.find('select[name=resvCenterCd]').val(),
			partCd: $form.find('select[name=resvPartCd]').val()
		};
		//마지막 검색결과 보유
		seatSearchInfo.centerCd = $form.find('select[name=resvCenterCd]').val();
		seatSearchInfo.floorCd = $form.find('select[name=resvFloorCd]').val();
		seatSearchInfo.partCd = $form.find('select[name=resvPartCd]').val();
		seatSearchInfo.resvDateFrom = $form.find(':text[name=resvDateFrom]').val();
		seatSearchInfo.resvDateTo = $form.find(':text[name=resvDateTo]').val();
		EgovIndexApi.apiExecuteJson(
			'POST',
			url,
			params,
			null,
			function(json) {
				json.seasonCd != null ? $('[data-popup=long_seat_add] :hidden[name=seasonCd]').val(json.seasonCd)
					: $('[data-popup=long_seat_add] :hidden[name=seasonCd]').val('');
	    		if (json.seatMapInfo != null) {
	    		    var img = json.seatMapInfo.part_map1;
	    		    $('.pop_mapArea').css({
	    		        "background": "#fff url(/upload/" + img + ")"
	    		    });
	    		} else {
	    		    $('.part_mapArea').css({
	    		        "background": "#fff url()"
	    		    });
	    		}
				if (json.resultlist.length > 0) {
	    		    var shtml = "";
	    		    var obj = json.resultlist;
	    		    for (var i in json.resultlist) {
	    		    	switch(obj[i].status){
	    		    		case "1" : addClass = "usable"; break;
	    		    		case "2" : addClass = "disable"; break;
	    		    		default : addClass = "selected"; break;
	    		    	}
	    		        shtml += '<li id="' + fn_NVL(obj[i].seat_cd) + '" class="' + addClass + '" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_nm + '" >' + obj[i].seat_number + '</li>';
	    		    }
	    		    $(".pop_seat").html(shtml);
	    		    for (var i in json.resultlist) {
	    		        $("#" + fn_NVL(obj[i].seat_cd)).css({
	    		            "top": fn_NVL(obj[i].seat_top) + "px",
	    		            "left": fn_NVL(obj[i].seat_left) + "px"
	    		        });
	    		        $("#" + fn_NVL(obj[i].seat_cd)).data("seat_paycost", obj[i].pay_cost);
	    		        $("#" + fn_NVL(obj[i].seat_cd)).data("seat_name", obj[i].seat_nm);
	    		    }
					var seatList = $(".pop_seat li");
	    		    $(seatList).click(function() {
	    		    	if(!$(this).hasClass("disable")) {
	    		    		var oldSel = $(".pop_seat li.usable");
	    		    		oldSel.removeClass("usable").addClass("selected");
	    		    		$(this).removeClass("selected").addClass("usable");
	    		    	}
					});
	    		}					
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
	// 장기 예매 등록 기능
	function fnLongSeatUpdate() {
		let $popup = $('[data-popup=long_seat_add]');
		let $form = $popup.find('form:first');
		if($form.find(':hidden[name=longResvSeatCd]').val() == "") { toastr.warning("예약할 좌석을 선택하세요."); return; }
		if($form.find(':text[name=longResvUserId]').val() == "") { toastr.warning("예약 회원을 선택하세요."); return; }
		if($form.find(':text[name=longResvEmpNo]').val() == "") { toastr.warning("예약 담당자를 선택하세요."); return; }
		let params = {
			mode : 'Ins',
			checkDvsn : 'LONG',
			seasonCd : $form.find(':text[name=seasonCd]').val(),
			resvEntryPayCost : $form.find(':text[name=resvEntryPayCost]').val(),
			resvDateFrom : $form.find(':text[name=longResvDateFrom]').val(),
			resvDateTo : $form.find(':text[name=longResvDateTo]').val(),
			centerCd : $form.find(':hidden[name=longResvCenterCd]').val(),
			floorCd : $form.find(':hidden[name=longResvFloorCd]').val(),
			partCd : $form.find(':hidden[name=longResvPartCd]').val(),
			seatCd : $form.find(':hidden[name=longResvSeatCd]').val(),
			userId : $form.find(':text[name=longResvUserId]').val(),
			resvSeatPayCost : $form.find(':hidden[name=longResvPayCost]').val(),
			resvUserNm : $form.find(':hidden[name=longResvUserName]').val(),
			longResvEmpNo : $form.find(':text[name=longResvEmpNo]').val(),
			resvUserClphn : $form.find(':hidden[name=longResvUserPhone]').val()
		}
		// 유효성 검사
		fnResvVaildCheck(params, function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/rsv/longResvInfoUpdate.do',
				params,
				null,
				function(json) {
					toastr.success('장기 예약 정보가 정상적으로 등록되었습니다.');
					fnSearch(1);
					$popup.bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 좌석 예약정보 유효성 검사
	function fnResvVaildCheck(params, callback) {
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/rsv/resvValidCheck.do',
			params,
			null,
			function(json) {
				if(json.result.resultCode !== 'SUCCESS') {
					toastr.error(json.result.resultMessage);
				} else {
					callback();
				}
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
	// 지점 셀렉트 박스 선택 시 지점 층 정보 호출 
	function fnCenterChange() {
		let $popup = $('[data-popup=seat_change]');
		let $form = $popup.find('form:first');
 		var url = "/backoffice/bld/floorComboInfo.do";
 		var params = {
 			centerCd: $form.find('select[name=resvCenterCd]').val()
 		};
 		//입장료
 		$("#resvEntryPayCost").val($form.find('select[name=resvCenterCd] option:selected').data("entrypaycost"));
 		var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
 		fn_comboListJson("resvFloorCd", returnVal, "fnFloorChange", "100px;", "");
	}
	// 층정보 셀렉트 박스 선택 시 층 구역 정보 호출 
	function fnFloorChange() {
		let $popup = $('[data-popup=seat_change]');
		let $form = $popup.find('form:first');
		var url = "/backoffice/bld/partInfoComboList.do";
	    var params = {
			floorCd: $form.find('select[name=resvFloorCd]').val()
		};
	 	var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
		fn_comboListJson("resvPartCd", returnVal, "", "100px;", "");
	}
</script>