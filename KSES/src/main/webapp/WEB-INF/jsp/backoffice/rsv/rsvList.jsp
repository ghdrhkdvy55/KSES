<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/css/paragraph_new.css">
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<script src="/resources/js/front/qrcode.js"></script>
<script src="/resources/js/jQuery.print.js"></script>
<style type="text/css">
	.ui-jqgrid .ui-jqgrid-htable th div {
		outline-style: none;
		height: 30px;
	}
	.ui-jqgrid tr.jqgrow {
		outline-style: none;
		height: 30px;
	}
</style>
<!-- Xlsx -->
<script type="text/javascript" src="/resources/js/xlsx.js"></script>
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- FileSaver -->
<script type="text/javascript" src="/resources/js/FileSaver.min.js"></script>
<!-- jszip -->
<script type="text/javascript" src="/resources/js/jszip.min.js"></script>
<!-- //contents -->
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="resvEntryPayCost" name="resvEntryPayCost">
<input type="hidden" id="seasonCd" name="seasonCd">
<jsp:useBean id="toDay" class="java.util.Date" />
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>고객 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">예약 현황</li>
	</ol>
</div>
<h2 class="title">예약 현황</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
		<div class="whiteBox searchBox">
      		<div class="sName">
        		<h3>검색 옵션</h3>
      		</div>
      		<div class="top">
      			<!--// Date Picker -->
				<div>
              		<p>지점</p>
              		<select id="searchCenterCd">
						<option value="">지점 선택</option>
						<c:forEach items="${centerInfo}" var="centerInfo">
							<option value="${centerInfo.center_cd}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
              		</select>
	              	<p>기간</p>
	              	<!-- search //-->
	              	<label for="resvDate"><input type="radio" name="searchRsvDay" id="resvDate" value="resvDate" checked>예약일</label>
					<label for="resvReqDate"><input type="radio" name="searchRsvDay" id="resvReqDate" value="resvReqDate">신청일</label>
	              	<p>
						<input type="text" id="searchResvDateFrom" class="cal_icon" name="date_from" value=<fmt:formatDate value="${toDay}" pattern="yyyyMMdd" /> autocomplete=off style="width:110px;"><em>~</em>
	                	<input type="text" id="searchResvDateTo" class="cal_icon" name="date_to" value=<fmt:formatDate value="${toDay}" pattern="yyyyMMdd" /> autocomplete=off style="width:110px;">
	              	</p>
					<p>회원 구분</p>
					<select id="searchResvUserDvsn">
						<option value="">선택</option>
						<c:forEach items="${resvUserDvsn}" var="resvUserDvsn">
							<option value="${resvUserDvsn.code}"><c:out value='${resvUserDvsn.codenm}'/></option>
						</c:forEach>
	              	</select>
	              	<p>예약 상태</p>
					<select id="searchResvState">
						<option value="">선택</option>
						<c:forEach items="${resvState}" var="resvState">
							<option value="${resvState.code}"><c:out value='${resvState.codenm}'/></option>
						</c:forEach>
	              	</select>
	              	<p>결제 상태</p>
	              	<select id="searchResvPayDvsn">
	              		<option value="">선택</option>
						<c:forEach items="${resvPayDvsn}" var="resvPayDvsn">
							<option value="${resvPayDvsn.code}"><c:out value='${resvPayDvsn.codenm}'/></option>
						</c:forEach>
	              	</select>
					<p>결제 구분</p>
	              	<select id="searchResvTicketDvsn">
	              		<option value="">선택</option>
						<c:forEach items="${resvTicketDvsn}" var="resvTicketDvsn">
							<option value="${resvTicketDvsn.code}"><c:out value='${resvTicketDvsn.codenm}'/></option>
						</c:forEach>
	              	</select>
					<p>현금영수증 발행</p>
	              	<select id="searchResvRcptYn">
	              		<option value="">선택</option>
						<option value="Y">발행</option>
						<option value="N">미발행</option>
	              	</select>
				</div>
			</div>
		</div>
		<div class="whiteBox searchBox">
			<div class="top">
				<p>검색어</p>
				<select id="searchCondition">
					<option value="">선택</option>
					<option value="resvSeq">예약번호</option>
					<option value="resvId">아이디</option>
					<option value="resvName">이름</option>
					<option value="resvPhone">전화번호</option>
				</select>
				<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
				<div class="inlineBtn">
					<a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
				</div>
			</div>
		</div>
		<div class="right_box">
			<!-- <a href="javascript:$('[data-popup=rsv_all_cancel]').bPopup();" class="blueBtn">전체 예약취소</a> -->
			<a id="export" onClick="fnExcelDown();" class="blueBtn">엑셀 다운로드</a>
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
<!-- // 예약 상세 정보 팝업 -->
<div data-popup="rsv_rsv_detail" class="popup">
	<div class="pop_con">
      	<a class="button b-close">X</a>
      	<h2 class="pop_tit">예약 상세 정보</h2>
      	<div class="pop_wrap">
      		<form>
          	<table class="detail_table">
              	<tbody>
					<tr> 
                    	<th>좌석 변경</th>
                    	<td>
                      		<a href="javascript:fnResvSeatInfo();" id="rsvSeatChangeBtn" class="blueBtn">좌석변경</a>
                    	</td>
						<th>상태 변경</th>
                    	<td>
                      		<a id="rsvStateChange" class="blueBtn">상태변경</a>
                    	</td>                    	
                  	</tr>
                  	<tr>
                      <th>지점</th>
                      <td id="rsvCenterNm"></td>
                      <th>좌석 정보 </th>
                      <td id="rsvAreaInfo"></td>
                  	</tr> 
                  	<tr>
						<th>예약 번호</th>
                    	<td id="rsvResvSeq"></td>
						<th>예약일자</th>
                    	<td id="rsvResvDate"></td>
                  	</tr>
                  	<tr>
                    	<th>이름</th>
                    	<td id="rsvResvUserNm"></td>
                    	<th>전화번호</th>
                    	<td id="rsvResvUserPhone"></td>
                  	</tr>
                  	<tr>
						<th>회원 구분 </th>
                    	<td id="rsvResvUserDvsn"></td>
						<th>아이디 </th>
                    	<td id="rsvUserId"></td>
                  	</tr>
                  	<tr>
                    	<th>결제 정보 </th>
                    	<td id="rsvResvPayDvsn"></td>
						<th>결제 방식</th>
                    	<td id="rsvResvTicketDvsn"></td>
                  	</tr>
                  	<tr>
                  		<th>입장료</th>
                  		<td id="rsvResvEntryPayCost"></td>
                  		<th>좌석료</th>
                  		<td id="rsvResvSeatPayCost"></td>
                  	</tr>
                  	<tr>
						<th>예약상태</th>
						<td id="rsvResvState"></td>
						<th>예약취소</th>
                    	<td><a href="javascript:fnResvInfoCancel();" id="resvCancelBtn" class="blueBtn">예약취소</a></td>
                  	</tr>
              	</tbody>
          	</table>
          	</form>
			<br>
			<p class="pop_tit">입장 내역 <span class="pBtn"><a href="javascript:$('[data-popup=rsv_inout_add]').bPopup();" id="enterRegistBtn" class="blueBtn">입장 수동 등록</a></span></p>
			<div style="width:650px;"> 
	          	<table id="attendGrid"></table>
				<div id="attendPager"></div>     
			</div>
      	</div>
		<popup-right-button/>
  	</div>
</div>

<!-- 입출입 추가 팝업 -->
<div data-popup="rsv_inout_add" class="popup s_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit" style="min-width:300px;">입출입 수동 등록</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th style="width: 120px;">입출입 구분</th>
                        <td>
                            <select name="inoutDvsn">
                            	<option value="IN">입장</option>
                            </select>
                        </td>
                    </tr>
				</tbody>
            </table>
        </div>
        <popup-right-button okText="저장" clickFunc="fnAttendInsert();" />
    </div>
</div>

<!-- 구역 생성 팝업 // -->
<!-- // 사용자 좌석 변경 팝업 -->
<div data-popup="rsv_seat_change" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<input type="hidden" name="resvSeq">
		<input type="hidden" name="resvDate">
		<input type="hidden" name="seasonCd">
		<input type="hidden" name="seatCd">
		<input type="hidden" name="resvEntryPayCost">
		<input type="hidden" name="resvSeatPayCost">
      	<h2 class="pop_tit">사용자 좌석 변경</h2>
      	<div class="pop_wrap pop_seat_change">
        	<div class="searchBox left_box">
          		<p>지점
            		<select id="resvCenterCd" name="centerCd" onChange="fnFloorComboList();">
            			<option value="">선택</option>
						<c:forEach items="${centerInfo}" var="centerInfo">
							<option value="${centerInfo.center_cd}" data-entrypaycost="${centerInfo.center_entry_pay_cost}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
            		</select>
          		</p>
          		<p>층
            		<select id="resvFloorCd" name="floorCd" onChange="fnPartComboList();">
              			<option value="">선택</option>
            		</select>
          		</p>
          		<p>구역
            		<select id="resvPartCd" name="partCd">
              			<option value="">선택</option>
            		</select>
          		</p>
          		<a href="javascript:fnResvSeatSearch();" class="grayBtn left_box">검색</a>
        	</div>
        	<a href="javascript:$('[data-popup=rsv_pay_number]').bPopup();" class="blueBtn right_box">변경</a>
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
  	</div>
</div>

<!-- 전체 취소 팝업 -->
<div data-popup="rsv_all_cancel" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">전체 예약 취소</h2>
    	<div class="pop_wrap">
    		<table class="detail_table">
           		<tbody>
					<tr>
						<th>지점</th>
	                    <td>
							<select name="centerCd">
            					<option value="">선택</option>
								<c:forEach items="${centerInfo}" var="centerInfo">
									<option value="${centerInfo.center_cd}"><c:out value='${centerInfo.center_nm}'/></option>
								</c:forEach>
            				</select>
	                    </td>
					</tr>
               		<tr>
						<th>취소일</th>
	                    <td>
	                    	<input type="text" name="resvDate" class="cal_icon">
	                    </td>
					</tr>
				</tbody>
			</table>
		</div>
		<popup-right-button okText="예약취소" clickFunc="fnResvInfoCancelAll();" />
	</div>
</div>
<!-- 전체 취소 팝업 -->

<!-- 상태 변경 팝업 -->
<div data-popup="rsv_state_change" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">예약정보 상태변경</h2>
    	<div class="pop_wrap">
    		<table class="detail_table">
           		<tbody>
					<tr>
						<th>예약 상태</th>
	                    <td>
            				<select name="resvState">
								<option value="">선택</option>
								<c:forEach items="${resvState}" var="resvState">
									<option value="${resvState.code}"><c:out value='${resvState.codenm}'/></option>
								</c:forEach>
            				</select>
	                    </td>
					</tr>
               		<tr>
						<th>결제 상태</th>
	                    <td>
            				<select name="resvPayDvsn">
			              		<option value="">선택</option>
								<c:forEach items="${resvPayDvsn}" var="resvPayDvsn">
									<option value="${resvPayDvsn.code}"><c:out value='${resvPayDvsn.codenm}'/></option>
								</c:forEach>
            				</select>
	                    </td>
					</tr>
				</tbody>
			</table>
		</div>
		<popup-right-button okText="변경" clickFunc="fnResvStateChange();" />
	</div>
</div>
<!-- 상태 변경 팝업 -->

<!--1214 QR출력 팝업-->
<div data-popup="rsv_qr_print" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">QR 출력</h2>
      	<div id="qrWrap" class="pop_wrap">
      		<!--QR 영역-->
      		<div id="qrPrint" class="qrPrint">
      			
      		</div>
			<!--QR 영역//-->
                            			
			<table class="detail_table">
				<tbody>
					<tr>
						<th>예약 번호</th>
                    	<td id="qrResvSeq"></td>
                      	<th>예약일 </th>
                      	<td id="qrResvDate">B001</td>
                  	</tr>
                  	<tr>
						<th>지점 </th>
                      	<td id="qrCenter"></td>
                    	<th>좌석 정보</th>
                    	<td id="qrSeat"></td>
                  	</tr>
                  	<tr>
                    	<th>이름 </th>
                    	<td id="qrName"></td>
                    	<th>전화번호</th>
                    	<td id="qrPhone"></td>
                  	</tr>
              	</tbody>
			</table>
		</div>
		
		<div class="pint_a">
			<a href="javascript:fnQrPrint();">출력<img src="/resources/img/print_black_24dp.svg" alt="출력"></a>
		</div>
      	<div class="clear"></div>
  	</div>
</div>

<!--현금영수증 팝업-->
<div data-popup="rsv_bill_info" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">현금영수증 발행 정보</h2>
      	<div id="bill_state_pop" class="pop_wrap">
			<table class="detail_table">
				<tbody>
					<tr>
						<th>국세청 승인번호</th>
                    	<td id="confirmNum"></td>
						<th>발행일시</th>
                    	<td id="issueDT"></td>
                  	</tr>
                  	<tr>
						<th>문서번호</th>
                      	<td id="mgtKey"></td>
						<th>문서형태</th>
                      	<td id="tradeType"></td>
                  	</tr>
                  	<tr>
						<th>거래구분</th>
                    	<td id="tradeUsage"></td>
                    	<th>거래유형</th>
                    	<td id="tradeOpt"></td>
                  	</tr>
					<tr>
						<th>과세형태</th>
                    	<td id="taxationType"></td>
						<th>식별번호</th>
                      	<td id="identityNum"></td>
                  	</tr>
                  	<tr>
                  		<th>거래일자</th>
                    	<td id="tradeDate"></td>
						<th>거래금액</th>
                      	<td id="totalAmount"></td>
                  	</tr>
                  	<tr>
						<th>주문상품명</th>
                    	<td id="itemName"></td>
                    	<th>고객성명</th>
                    	<td id="customerName"></td>
                  	</tr>
              	</tbody>
			</table>
		</div>
      	<div class="clear"></div>
  	</div>
</div>

<!-- 좌석변경 대상 고객 결제 비밀빈호 -->
<div data-popup="rsv_pay_number" class="popup">
	<div class="pop_con rsv_popup noti_pw">
		<a class="button b-close">X</a>
		<div class="pop_wrap">
			<h4>결제 비밀번호를 입력해주세요.</h4>
			<ul class="cost_list noti_pwBtn">
				<li>
					<ul class="pay_passWord">
                        <li>결제</li>
                        <li><input type="password" name="cardPw" placeholder="결제 비밀번호를 입력하세요."></li>
                	</ul>
            	</li>
        	</ul>
			<ul class="cost_btn">
				<li class="okBtn ok_pwBtn"><a href="javascript:fnResvSeatUpdate();">확인</a></li>
			</ul>
		</div>
	</div>
</div>

<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	let searchStorage;

	$(document).ready(function() { 
		// 메인 JqGrid 정의
		EgovJqGridApi.mainGrid([
			{ label: '예약번호', 	name: 'resv_seq',  				align:'center',	fixed: true, key:true },
			{ label: '예약일자', 	name: 'resv_end_dt', 			align:'center', fixed: true, formatter: fnFormSetting },
			{ label: '지점', 	name: 'center_nm', 				align:'center', fixed: true },
			{ label: '좌석등급', 	name: 'resv_seat_class_text',   align:'center', fixed: true },
			{ label: '좌석정보', 	name: 'seat_nm', 				align:'center', fixed: true },
			{ label: '이름', 	name: 'user_nm', 				align:'center', fixed: true },
			{ label: '전화번호', 	name: 'user_phone', 	 		align:'center', fixed: true },
			{ label: '금액', 	name: 'resv_pay_cost', 		    align:'center', fixed: true, formatter: fnFormSetting },
			{ label: '예약상태', 	name: 'resv_state_text',    	align:'center', fixed: true },
			{ label: '결제상태', 	name: 'resv_pay_dvsn_text', 	align:'center', fixed: true },
			{ label: '결제구분', 	name: 'resv_ticket_dvsn_text',  align:'center', fixed: true },
			{ label: 'QR출력', 	name: 'resv_qr_print', 			align:'center', fixed: true, formatter: fnFormSetting },			
			{ name : 'season_cd', hidden : true }, { name : 'center_cd', hidden : true },     { name : 'floor_cd', hidden : true }, 
			{ name : 'part_cd', hidden : true },   { name : 'seat_cd', hidden : true },       { name : 'user_id', hidden : true }, 
			{ name : 'resv_state', hidden : true },{ name : 'resv_pay_dvsn', hidden : true }, { name : 'resv_ticket_dvsn', hidden : true }, 
			{ name : 'resv_seat_pay_cost', hidden : true }, { name : 'resv_entry_pay_cost', hidden : true }, 
			{ name : 'resv_user_dvsn_text', hidden : true }
		], false, false, fnSearch);
		
    	// 메인 그리드 더블 클릭 시 이벤트 발생.
    	EgovJqGridApi.mainGridDetail(fnResvInfo);
		
		// 출입 정보 JqGrid 정의
		EgovJqGridApi.pagingGrid('attendGrid', [
			{label: '출입번호', 	name:'qr_check_seq', 	align:'center', sortable: false, key: true, hidden:true},
			{label: '체크 구분',	name:'inout_dvsn_text', align:'center'},
			{label: '출입시간', 	name:'qr_check_tm',		align:'center', sortable: false},
			{label: '통신시간', 	name:'rcv_dt',			align:'center', sortable: false},
			{label: '통신결과', 	name:'rcv_cd', 			align:'center', sortable: false}
		], 'attendPager', false, false, 5);
		
		$("#searchResvDateFrom","#searchResvDateTo","#resvDateFrom","#resvDateTo","#cancelResvDate").datepicker(EgovCalendar);
		
		if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
			$(".top > div > p").eq(0).hide();
			$(".top > div > select").eq(0).hide();
		}
		
    	$("body").keydown(function (key) {
        	if(key.keyCode == 13){
        		fnSearch(1);
        	}
    	});
	});
	
	// 변경예정
	function fnFormSetting(c, o, row) {
		var index = o.colModel.index;
		var form = "";
		
		row.resv_pay_dvsn = row.center_pilot_yn === "N" ? "RESV_PAY_DVSN_2" : row.resv_pay_dvsn;
		if(index === 'resv_qr_print' && row.resv_pay_dvsn === 'RESV_PAY_DVSN_2' && (row.resv_state === 'RESV_STATE_1' || row.resv_state === 'RESV_STATE_2')) {
			form = '<a href="javascript:fnQrInfo(&#39;' + row.resv_seq + '&#39;);" class="blueBtn">QR출력</a>';
		} else if(index === 'resv_end_dt') {
			form = fn_resvDateFormat(row.resv_end_dt); 	
		} else if(index === 'resv_pay_cost') {
			form = row.resv_pay_cost + "원";
		} else if(index === 'resv_rcpt_print') {
			if(row.resv_rcpt_yn === 'Y' && row.resv_pay_dvsn === "RESV_PAY_DVSN_2") {
				var rcptState = "발행";
				if(row.resv_rcpt_state === "" || row.resv_rcpt_state === "RESV_RCPT_STATE_1") {
					form =  '<a href="javascript:fnBillStateChange(&#39;' + row.resv_seq + '&#39;);" class="blueBtn" style="padding: 5px 12px;">취소</a>';
					form += '<a href="javascript:fnBillInfo(&#39;' + row.resv_seq + '&#39;);" class="blueBtn" style="padding: 5px 12px;">조회</a>';
				} else {
					form =  '<a href="javascript:fnBillStateChange(&#39;' + row.resv_seq + '&#39;);" class="blueBtn" style="padding: 5px 12px;">발행</a>';
					form += '<a href="javascript:void(0);" class="blueBtn" style="padding: 5px 12px;">조회</a>';
				}
			}
		}
		
		return form;
	}
	
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit : $('#pager .ui-pg-selbox option:selected').val(),
			searchCenterCd : $('#searchCenterCd').val(),
			searchDayCondition : $('input[name=searchRsvDay]:checked').val(),
			searchFrom : $('#searchResvDateFrom').val(),
			searchTo : $('#searchResvDateTo').val(),
			searchResvUserDvsn : $('#searchResvUserDvsn').val(),
			searchResvState : $('#searchResvState').val(),
			searchResvPayDvsn : $('#searchResvPayDvsn').val(),
			searchResvTicketDvsn : $('#searchResvTicketDvsn').val(),
			searchResvRcptYn : $('searchResvRcptYn').val(),
			searchCondition : $('#searchCondition').val(),
			searchKeyword : $('#searchKeyword').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/rsv/rsvListAjax.do', params, fnSearch);

        var patchWidth = $("[aria-labelledby='gbox_"+$(this).prop("id")+"']").css("width");
        var patchTarget = $(this).parent();
        $(patchTarget).css("width", patchWidth);
	}
	
	// 메인 상세 팝업 정의
	function fnResvInfo(rowId) {
		let $popup = $('[data-popup=rsv_rsv_detail]');
		let rowData = EgovJqGridApi.getMainGridRowData(rowId);
		
		$popup.find('td#rsvCenterNm').html(rowData.center_nm);
		$popup.find('td#rsvAreaInfo').html(rowData.seat_nm);
		$popup.find('td#rsvResvSeq').html(rowData.resv_seq);
		$popup.find('td#rsvResvDate').html(fn_resvDateFormat(rowData.resv_end_dt));
		$popup.find('td#rsvResvUserDvsn').html(rowData.resv_user_dvsn_text);
		$popup.find('td#rsvUserId').html(rowData.user_id);
		$popup.find('td#rsvResvUserNm').html(rowData.user_nm);
		$popup.find('td#rsvResvUserPhone').html(rowData.user_phone);
		$popup.find('td#rsvResvPayDvsn').html(rowData.resv_pay_dvsn_text);
		$popup.find('td#rsvResvSeatPayCost').html(rowData.resv_seat_pay_cost + '원');
		$popup.find('td#rsvResvEntryPayCost').html(rowData.resv_entry_pay_cost + '원');
		$popup.find('td#rsvResvTicketDvsn').html(rowData.resv_state_text);
		$popup.find('td#rsvResvPayDvsn').html(rowData.resv_pay_dvsn_text);
		$popup.find('td#rsvResvState').html(rowData.resv_state_text);
		$popup.find('popup-right-button button').eq(0).hide();
		
		// 좌석 상태변경 버튼
		$popup.find('a#rsvStateChange').off().click(function() {
			let $sPopup = $('[data-popup=rsv_state_change]');
			$sPopup.find('select[name=resvState]').val(rowData.resv_state);
			$sPopup.find('select[name=resvPayDvsn]').val(rowData.resv_pay_dvsn);
			$sPopup.bPopup();
		});
		
		// 예약취소/좌석변경 버튼
		$popup.find('a#rsvSeatChangeBtn,a#resvCancelBtn,a#enterRegistBtn').hide();
		if(rowData.resv_state === 'RESV_STATE_1' || rowData.resv_state === 'RESV_STATE_2') {
			$popup.find('a#resvCancelBtn').show();
			if(fn_resvDateFormat(today_get())  === rowData.resv_end_dt){
				$popup.find('a#enterRegistBtn').show();
			}
			if(rowData.resv_ticket_dvsn === 'RESV_TICKET_DVSN_1') {
				$popup.find('a#rsvSeatChangeBtn').show();
			}
		}
	
		fnAttendSearch(1);
		$popup.bPopup();
	}
	
	// 예약정보 상태변경
	function fnResvStateChange() {
		let $popup = $('[data-popup=rsv_state_change]');
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		bPopupConfirm('예약상태변경', '예약상태를 변경 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/rsv/rsvStateChange.do', 
				{
					resvSeq : rowId,
					resvState : $popup.find('select[name=resvState]').val(),
					resvPayDvsn : $popup.find('select[name=resvPayDvsn]').val()
				},
				null,
				function(json) {
					toastr.success("예약상태가 정상적으로 변경되었습니다.");
					$popup.bPopup().close();
					fnSearch(1);
					$('[data-popup=rsv_rsv_detail]').bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	// 예약정보 취소
	function fnResvInfoCancel() {
		let $popup = $('[data-popup=rsv_rsv_detail]');
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		bPopupConfirm('예약취소', '<b>' + rowId + '번</b>' + ' 예약정보를 취소 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'GET',
				'/backoffice/rsv/resvInfoCancel.do', {
					resvSeq : rowId,
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
					$popup.bPopup().close()
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
		
	// QR코드 정보 조회
	function fnQrInfo(resvSeq) {
		let $popup = $('[data-popup=rsv_qr_print]');
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/rsv/qrSend.do', {
				resvSeq : resvSeq,
				tickPlace : "PAPER"
			},
			null,
			function(json) {
				let data = json.resvInfo;
	    		
				$('#qrPrint > img').remove();
	    		let qrcode = new QRCode("qrPrint", {
				    text: json.QRCODE,
				    width: 256,
				    height: 256,
				    colorDark : "#000000",
				    colorLight : "#ffffff",
				    correctLevel : QRCode.CorrectLevel.M
				});
				
				$('#qrPrint > img').css('margin', 'auto');
				$('#qrResvSeq').html(data.resv_seq);
				$('#qrResvDate').html(data.resv_end_dt);
				$('#qrCenter').html(data.center_nm);
				$('#qrSeat').html(data.seat_nm);
				$('#qrName').html(data.user_nm);
				$('#qrPhone').html(data.user_phone);
			},
			function(json) {
				toastr.error(json.message);
			}
		);
		$popup.bPopup();
	}

	// QR코드 프린트	
	function fnQrPrint() {
		$("#qrWrap").print();
	}
	
	// 예약 현금영수증 발행/취소
	function fnBillStateChange(resvSeq) {
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/rsv/billPrint.do', {
				resvSeq : resvSeq,
			},
			null,
			function(json) {
				toastr.success(json.message);
				fnSearch(1);
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
	
	// 예약 현금영수증 발행정보 조회
	function fnBillInfo(resvSeq) {
		let $popup = $('[data-popup=rsv_bill_info]');
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/rsv/billState.do', {
				resvSeq : resvSeq,
			},
			null,
			function(json) {
				let data = json.result;
				$('#confirmNum').html(data.confirmNum);
				$('#issueDT').html(data.issueDT);
				$('#mgtKey').html(data.mgtKey);
				$('#tradeType').html(data.tradeType);
				$('#tradeUsage').html(data.tradeUsage);
				$('#tradeOpt').html(data.tradeOpt);
				$('#taxationType').html(data.taxationType);
				$('#identityNum').html(data.identityNum);
				$('#tradeDate').html(data.tradeDate);
				$('#totalAmount').html(data.totalAmount + '원');
				$('#itemName').html(data.itemName);
				$('#customerName').html(data.customerName);
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
	
	// 출입정보 목록 검색
	function fnAttendSearch(pageNo) {
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		let params = {
			pageIndex: pageNo,
			pageUnit: '5',
			searchCondition : "RES_SEQ",
			searchKeyword : rowId
		};
		EgovJqGridApi.pagingGridAjax('attendGrid', '/backoffice/rsv/attendListAjax.do', params, fnAttendSearch);
	}
	
	// 출입정보 수동 등록
	function fnAttendInsert() {
		let $popup = $('[data-popup=rsv_inout_add]');
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		bPopupConfirm('출입정보등록', '<b>' + rowId + '번</b>' + ' 출입정보를 등록 하시겠습니까??', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/rsv/attendInfoUpdate.do', {
					mode : "Manual",
					resvSeq : rowId,
					inoutDvsn : $popup.find('select[name=inoutDvsn]').val()
				},
				null,
				function(json) {
					toastr.success("입출입 정보가 정상적으로 등록되었습니다.");
					$popup.bPopup().close();
					fnSearch(1);
					$('[data-popup=rsv_rsv_detail]').bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	// 예약정보 좌석변경 팝업 세팅
	function fnResvSeatInfo() {
		let $popup = $('[data-popup=rsv_seat_change]');
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		let rowData = EgovJqGridApi.getMainGridRowData(rowId);

		$popup.find(':hidden[name=resvSeq]').val(rowData.resv_seq);
		$popup.find(':hidden[name=resvDate]').val(rowData.resv_end_dt.replaceAll('-',''));
		$popup.find(':hidden[name=seatCd]').val('');
		$popup.find(':hidden[name=resvSeatPayCost]').val('');
		$popup.find(':hidden[name=resvEntryPayCost]').val('');
		$popup.find('select[name=centerCd]').val(rowData.center_cd).trigger("change").show();
		$popup.find('select[name=floorCd]').val(rowData.floor_cd).trigger("change");
		$popup.find('select[name=partCd]').val(rowData.part_cd);

		fnResvSeatSearch();
		$popup.bPopup();
	}
	
	// 좌석변경 팝업 좌석 검색
	function fnResvSeatSearch() {
		let $popup = $('[data-popup=rsv_seat_change]');
		
        if ($popup.find('select[name=centerCd]').val() === '') {
            toastr.warning('지점을 선택해 주세요.');
            return;
        }
        if ($popup.find('select[name=floorCd]').val() === '') {
            toastr.warning('층을 입력해 주세요.');
            return;
        }
        if ($popup.find('select[name=partCd]').val() === '') {
            toastr.warning('구역명을 입력해 주세요.');
            return;
        }
		
        $popup.find(':hidden[name=resvEntryPayCost]').val(
			$popup.find('select[name=centerCd]').find("option:selected").data("entrypaycost")
        );
        
        searchStorage = {
			searchCondition : 'SEAT',
			resvSeq : $popup.find(':hidden[name=resvSeq]').val(),
			resvDate : $popup.find(':hidden[name=resvDate]').val(),
        	centerCd : $popup.find('select[name=centerCd]').val(),
        	floorCd : $popup.find('select[name=floorCd]').val(),
        	partCd : $popup.find('select[name=partCd]').val()
        };
		
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/front/rsvSeatListAjax.do',
			searchStorage,
			null,
			function(json) {
				let img = json.seatMapInfo !== null ? '/upload/' + json.seatMapInfo.part_map1 : '';
				
				$popup.find(':hidden[name=seasonCd]').val(json.seasonCd);
				$popup.find('.pop_mapArea').css({'background': '#fff url(' + img + ')'});
				$popup.find('.pop_seat').empty();
				
				let list = json.resultlist;
    		    for (let i in list) {
    		    	let addClass = "";
					switch(list[i].status){
						case "1" : addClass = "usable"; break;
						case "2" : addClass = "disable"; break;
						default : addClass = "selected"; break;
					}
					
					let $li = $('<li></li>').attr({
						'id' : list[i].seat_cd,
						'class' : addClass,
					})
					.data('seat_paycost',list[i].pay_cost)
					.css({
    		            "top": list[i].seat_top + "px",
    		            "left": list[i].seat_left + "px"
					}).html(list[i].seat_number).appendTo('.pop_seat');
				}

				let seatList = $popup.find(".pop_seat li");
				$(seatList).click(function() {
					if(!$(this).hasClass('disable')) {
						let oldSel = $('.pop_seat li.usable');
						oldSel.removeClass('usable').addClass('selected');
						$(this).removeClass('selected').addClass('usable');
						$popup.find(':hidden[name=resvSeatPayCost]').val($(this).data('seat_paycost'));
						$popup.find(':hidden[name=seatCd]').val($(this).attr('id'));
					}
				});
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}

	// 예약정보 좌석변경
	function fnResvSeatUpdate() {
		let $sPopup = $('[data-popup=rsv_seat_change]');
		let $pPopup = $('[data-popup=rsv_pay_number]');
		
		if($sPopup.find(":hidden[name=seatCd]").val() === '') {
			toastr.warning('변경할 좌석을 선택해주세요.');
			return;	
		}
		if($pPopup.find(':password[name=cardPw]').val() === '') {
			toastr.warning('결제 비밀번호를 입력해주세요.');
			return;			
		}
		
		let params = Object.assign({
			checkDvsn : 'CHANGE',
			resvSeq : $sPopup.find(':hidden[name=resvSeq]').val(),
			inResvDate : $sPopup.find(':hidden[name=resvDate]').val(),
			seasonCd : $sPopup.find(':hidden[name=seasonCd]').val(),
			seatCd : $sPopup.find(':hidden[name=seatCd]').val(),
			resvEntryPayCost : $sPopup.find(':hidden[name=resvEntryPayCost]').val(),
			resvSeatPayCost : $sPopup.find(':hidden[name=resvSeatPayCost]').val(),
			cardPw : $pPopup.find(':password[name=cardPw]').val()
		},searchStorage);
		
		// 유효성 검사
		fnResvVaildCheck(params, function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/rsv/rsvSeatChange.do',
				params,
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
					$sPopup.bPopup().close();
				},
				function(json) {
					toastr.error(json.message, json.step);
				}
			);
		});
		$pPopup.find(':password[name=cardPw]').val('');
		$pPopup.bPopup().close();
		$('[data-popup=rsv_rsv_detail]').bPopup().close();
	}

	// 좌석변경 예약정보 유효성 검사
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
	
	function fnFloorComboList() {
 		let params = {centerCd : $('#resvCenterCd').val()};
 		let returnVal = uniAjaxReturn('/backoffice/bld/floorComboInfo.do', 'GET', false, params, 'lst');
 		fn_comboListJson('resvFloorCd', returnVal, 'fnPartComboList', '100px;', '');
	}
	
	// 좌석변경팝업 구역 콤보박스 목록 검색(변경예정)
	function fnPartComboList() {
	    let params = {floorCd : $('#resvFloorCd').val()};
	 	let returnVal = uniAjaxReturn('/backoffice/bld/partInfoComboList.do', 'GET', false, params, 'lst');
		fn_comboListJson('resvPartCd', returnVal, '', '100px;', '');
	}
	
	// 예약정보 엑셀다운로드
	function fnExcelDown() {
		if ($("#mainGrid").getGridParam("reccount") === 0) {
			toastr.warning('다운받으실 데이터가 없습니다.');
			return;
		}
		let params = {
			pageIndex: '1',
			pageUnit: '1000',
			searchCondition : $("#searchCondition").val(),
			searchKeyword: $('#searchKeyword').val(),
			searchCenterCd : $("#searchCenterCd").val(),
			searchDayCondition : $('input[name=searchRsvDay]:checked').val(),
			searchFrom : $("#searchResvDateFrom").val(),
			searchTo : $("#searchResvDateTo").val(),
			searchResvUserDvsn : $("searchResvUserDvsn").val(),
			searchResvState : $("#searchResvState").val(),
			searchResvPayDvsn : $("#searchResvPayDvsn").val(),
			searchResvRcptYn : $("#searchResvRcptYn").val(),
			searchResvTicketDvsn : $("#searchResvTicketDvsn").val()
		};
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/rsv/rsvListAjax.do', 
			params,
			null,
			function(json) {
				let ret = json.resultlist;
				if (ret.length <= 0) {
					return;
				}
				if (ret.length >= 1000) {
					toastr.info('해당 조회 건수가 1000건이 넘습니다. 엑셀 다운로드 시 1000건에 대한 데이터만 저장됩니다.');
				}
				let excelData = new Array();
				excelData.push(['NO', '예약일자', '예약번호', '지점', '좌석등급', '좌석정보', '이름', '전화번호', '금액', '예약상태', '결제상태', '결제구분']);
				for (let idx in ret) {
					let arr = new Array();
					arr.push(Number(idx)+1);
					arr.push(ret[idx].resv_end_dt);
					arr.push(ret[idx].resv_seq);
					arr.push(ret[idx].center_nm);
					arr.push(ret[idx].part_class);
					arr.push(ret[idx].seat_nm);
					arr.push(ret[idx].user_nm);
					arr.push(ret[idx].user_phone);
					arr.push(ret[idx].resv_pay_cost);
					arr.push(ret[idx].resv_state_text);
					arr.push(ret[idx].resv_pay_dvsn_text);
					arr.push(ret[idx].resv_ticket_dvsn_text);
					excelData.push(arr);
				}
				let wb = XLSX.utils.book_new();
				XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(excelData), 'sheet1');
				var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });
				saveAs(new Blob([EgovIndexApi.s2ab(wbout)],{ type: 'application/octet-stream' }), '예약 현황.xlsx');
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
</script>