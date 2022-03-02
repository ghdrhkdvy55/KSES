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
<input type="hidden" id="resvSeq" name="resvSeq">
<input type="hidden" id="resvDate" name="resvDate">
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
					<a href="javascript:jqGridFunc.fn_search();"class="grayBtn">검색</a>
				</div>
			</div>
		</div>
	
		<div class="right_box">
			<a href="javascript:common_modelOpen('all_cancel_pop');" class="blueBtn">전체 예약취소</a>
			<a href="javascript:jqGridFunc.fn_longSeatAdd();" class="blueBtn">장기 예매</a>
			<a id="export" onClick="jqGridFunc.fn_excelDown()" class="blueBtn">엑셀 다운로드</a>
		</div>
		<div class="clear"></div>
		
		<div class="whiteBox">
			<table id="mainGrid">    				
			</table>

			<div id="pager" class="scroll" style="text-align:center;"></div>     			
			<div id="paginate"></div>
		</div>
	</div>
</div>
<!-- contents//-->
<!-- //popup -->
<!-- // 예약 상세 정보 팝업 -->
<div id="rsv_detail" data-popup="rsv_detail" class="popup">
	<div class="pop_con">
      	<a class="button b-close">X</a>
      	<h2 class="pop_tit">예약 상세 정보</h2>
      	<div class="pop_wrap">
          	<table class="detail_table">
              	<tbody>
					<tr> 
                    	<th>좌석 변경</th>
                    	<td id="rsvPopSeatChange">
                      		<a class="blueBtn">좌석변경</a>
                    	</td>
						<th>상태 변경</th>
                    	<td id="rsvPopStateChange">
                      		<a href="javascript:common_modelOpen('state_change_pop');"class="blueBtn">상태변경</a>
                    	</td>                    	
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
						<th>회원 구분 </th>
                    	<td id="rsvPopResvUserDvsn"></td>
						<th>아이디 </th>
                    	<td id="rsvPopUserId"></td>
                  	</tr>
                  	<tr>
                    	<th>결제 정보 </th>
                    	<td>
							<label id="rsvPopResvPayDvsn"></label>
                    	</td>
						<th>결제 방식</th>
                    	<td id="rsvPopResvTicketDvsn"></td>
                  	</tr>
                  	<tr>
                  		<th>입장료</th>
                  		<td id="rsvPopResvEntryPayCost"></td>
                  		<th>좌석료</th>
                  		<td id="rsvPopResvSeatPayCost"></td>
                  	</tr>
                  	<tr>
						<th>예약상태</th>
						<td id="rsvPopResvState"></td>
						<th>예약취소</th>
                    	<td><a id="resvCancelBtn" class="blueBtn">예약취소</a></td>
                  	</tr>
                  	
              	</tbody>
          	</table>
			<br>
			<p class="pop_tit">입장 내역 <span class="pBtn"><a href="javascript:common_modelOpen('rsv_inout_add');" class="blueBtn">입장 수동 등록</a></span></p>
			<div id="inOutHis"> 
	          	<table id="inOutHisTable" class="main_table">
					
	          	</table>
				<div id="inOutHisPager" class="scroll" style="text-align:center;"></div>     
							
				<div id="paginate"></div>
			</div>
      	</div>
      	<div class="right_box">
          	<a href="javascript:common_modelClose('rsv_detail');" class="grayBtn">닫기</a>
      	</div>
      	<div class="clear"></div>
  	</div>
</div>
<!-- // 장기예매고객 팝업 -->
<div id="long_seat_add" data-popup="long_seat_add" class="popup">
  	<div class="pop_con">
		<a href="javascript:;" class="button b-close">X</a>
      	<h2 class="pop_tit">장기 예매 등록</h2>
      	<div class="pop_wrap">
			<table class="detail_table">
				<tbody>
                  	<tr>
                    	<th>좌석 정보</th>
                      	<td colspan="3">
							<input type="text" id="longResvSeatNm" readonly>
							<input type="hidden" id="longResvCenterCd">
							<input type="hidden" id="longResvFloorCd">
							<input type="hidden" id="longResvPartCd">
							<input type="hidden" id="longResvSeatCd">
							<input type="hidden" id="longResvPayCost">
							<a href="javascript:jqGridFunc.fn_resvSeatInfo('LONG')" class="blueBtn">좌석 조회</a>
                      	</td>
                  	</tr>
					<tr>
                    	<th>예약 일자 </th>
                    	<td colspan="3">                      
                      		<p>
								<input type="text" id="longResvDateFrom" readonly><em> ~ </em>
                        		<input type="text" id="longResvDateTo" readonly>
                      		</p>
                    	</td>
                    </tr>
                  	<tr>
                    	<th>회원 조회</th>
                    	<td>
                      		<select id="userSearchCondition">
                          		<option value="user_id">아이디</option>
                          		<option value="user_nm">이름</option>    
                          		<option value="user_phone">전화번호</option>             
                      		</select>
                      		<input type="text" id="userSearchKeyword">
                      		<a href="javascript:jqGridFunc.fn_searchResult('user')" class="blueBtn">조회</a>
                    	</td>
						<th>예약 회원(아이디)</th>
                    	<td>
                      		<input type="text" id="longResvUserId" readonly>
                      		<input type="hidden" id="longResvUserName">
                      		<input type="hidden" id="longResvUserPhone">
                    	</td>
                  	</tr>
                  	<tr>
						<th>담당자 조회</th>
                    	<td>
							<select id="empSearchCondition">
								<option value="b.EMP_NO">사번</option>
								<option value="b.EMP_NM">이름</option>    
	                      	</select>
	                    	<input type="text" id="empSearchKeyword">
	                    	<a href="javascript:jqGridFunc.fn_searchResult('emp')" class="blueBtn">조회</a>
                    	</td>
						<th>예약 담당자(사번)</th>
                    	<td>
                      		<input type="text" id="longResvEmpNo" readonly>
                    	</td>
                  	</tr>
					<tr>
                    	<td colspan="4"><textarea name="" rows="5" style="width: 100%;"></textarea></td>
                  	</tr>
              	</tbody>
			</table>
      	</div>
      	<div class="right_box">
      		<a href="javascript:jqGridFunc.fn_longSeatUpdate();" class="blueBtn">등록</a>
			<a href="javascript:common_modelClose('long_seat_add');" class="grayBtn">닫기</a>
      	</div>
      	<div class="clear"></div>
  	</div>
</div>

<!-- // 관리자 검색 팝업 -->
<div id="search_result" class="popup">
	<div class="pop_con">
		<a href="javascript:common_modalOpenAndClose('long_seat_add','search_result');" class="button bCloseT"></a>
		<h2 class="pop_tit">검색 결과</h2>
      	<div id="searchResultWrap" class="pop_wrap">
        	<table id="searchResultTable" class="whiteBox main_table">
        	
        	</table>
      	</div>
  	</div>
</div>
<!-- 관리자 검색 팝업 // -->

<!-- 입출입 추가 팝업 -->
<div id="rsv_inout_add" class="popup s_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit" style="min-width:300px;">입출입 수동 등록</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th style="width: 120px;">입출입 구분</th>
                        <td>
                            <select id="inoutDvsn">
                            	<option value="IN">입장</option>
                            </select>
                        </td>
                    </tr>
				</tbody>
            </table>
        </div>
        <div class="center_box">
        	<a href="javascript:attendService.fn_setInoutHistory();" id="inOutUpdateBtn" class="blueBtn">저장</a>
            <a href="javascript:common_modelClose('rsv_inout_add');" class="grayBtn">취소</a>
        </div>
        <div class="clear"></div>
    </div>
</div>

<!-- 구역 생성 팝업 // -->
<!-- // 사용자 좌석 변경 팝업 -->
<div id="seat_change" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">사용자 좌석 변경</h2>
      	<div class="pop_wrap pop_seat_change">
        	<div class="searchBox left_box">
          		<p>지점
            		<select id="resvCenterCd" onChange="jqGridFunc.fn_centerChange()">
            			<option value="">선택</option>
						<c:forEach items="${centerInfo}" var="centerInfo">
							<option value="${centerInfo.center_cd}" data-entrypaycost="${centerInfo.center_entry_pay_cost}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
            		</select>
          		</p>
          		<p>층
            		<select id="resvFloorCd" onChange="jqGridFunc.fn_floorChange()">
              			<option value="">선택</option>
            		</select>
          		</p>
          		<p>구역
            		<select id="resvPartCd">
              			<option value="">선택</option>
            		</select>
          		</p>
          		<p>날짜 
            		<input type="text" id="resvDateFrom" class="cal_icon"> ~
            		<input type="text" id="resvDateTo" class="cal_icon">
          		</p>
          		<a href="javascript:jqGridFunc.fn_resvSeatSearch('LONG');" class="grayBtn left_box">검색</a>
        	</div>
        	<a href="javascript:jqGridFunc.fn_resvSeatUpdate('CHANGE')" class="blueBtn right_box">저장</a>
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
<div id='all_cancel_pop' class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">전체 예약 취소</h2>
    	<div class="pop_wrap">
    		<table class="detail_table">
           		<tbody>
					<tr>
						<th>지점</th>
	                    <td>
            				<select id="cancelResvCenterCd">
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
	                    	<input type="text" name="cancelResvDate" id="cancelResvDate" class="cal_icon">
	                    </td>
					</tr>
				</tbody>
			</table>
		</div>
	    <div class="right_box">
	    	<a href="javascript:jqGridFunc.fn_resvInfoCancelAll();" id="btnUpdate" class="blueBtn">예약취소</a>
        	<a href="#" onClick="common_modelClose('all_cancel_pop')" id="btnUpdate" class="grayBtn b-close">취소</a>
		</div>
		<div class="clear"></div>
	</div>
</div>
<!-- 전체 취소 팝업 -->

<!-- 상태 변경 팝업 -->
<div id='state_change_pop' class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">예약정보 상태변경</h2>
    	<div class="pop_wrap">
    		<table class="detail_table">
           		<tbody>
					<tr>
						<th>예약 상태</th>
	                    <td>
            				<select id="changeResvState">
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
            				<select id="changeResvPayDvsn">
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
	    <div class="right_box">
	    	<a href="#" id="btnUpdate" class="blueBtn">변경</a>
        	<a href="#" onClick="common_modelClose('state_change_pop')" id="btnUpdate" class="grayBtn b-close">취소</a>
		</div>
		<div class="clear"></div>
	</div>
</div>
<!-- 상태 변경 팝업 -->

<!--1214 QR출력 팝업-->
<div id="qr_print" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">QR 출력</h2>
      	<div id="qrWrap" class="pop_wrap">
      		<!--QR 영역-->
      		<div id="qrPrint" class="qrPrint">
      			<!-- <img src="/resources/img/qrcode.png" alt=""> -->
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
			<a href="javascript:jqGridFunc.fn_qrPrint();">출력<img src="/resources/img/print_black_24dp.svg" alt="출력"></a>
		</div>
      	<div class="clear"></div>
  	</div>
</div>

<!--현금영수증 임시 팝업-->
<div id="bill_state_pop" class="popup">
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
<div id="pay_number" class="popup">
	<div class="pop_con rsv_popup noti_pw">
		<a class="button b-close">X</a>
		<div class="pop_wrap">
			<h4>결제 비밀번호를 입력해주세요.</h4>
			<ul class="cost_list noti_pwBtn">
				<li>
					<ul class="pay_passWord">
                        <li>결제</li>
                        <li><input type="password" id="cardPw" placeholder="결제 비밀번호를 입력하세요."></li>
                	</ul>
            	</li>
        	</ul>
			<ul class="cost_btn ">
				<li class="okBtn ok_pwBtn"><a href="javascript:jqGridFunc.fn_resvSeatUpdate();">확인</a></li>
			</ul>
		</div>
	</div>
</div>

<!-- popup// -->
<script type="text/javascript" src="/resources/js/temporary.js"></script>
<script type="text/javascript">
	var seatSearchInfo = {};

	$(document).ready(function() { 
		if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
			$(".top > div > p").eq(0).hide();
			$(".top > div > select").eq(0).hide();
		}
		
		jqGridFunc.setGrid("mainGrid");
		var clareCalendar = {
			monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
			weekHeader: 'Wk',
			dateFormat: 'yymmdd', //형식(20120303)
			autoSize: false, //오토리사이즈(body등 상위태그의 설정에 따른다)
			changeMonth: true, //월변경가능
			changeYear: true, //년변경가능
			showMonthAfterYear: true, //년 뒤에 월 표시
			buttonImageOnly: false, 
			yearRange: '1970:2030', //1990년부터 2020년까지
			currentText: "Today"
		};	       
		
		var datePickerObject = ["#searchResvDateFrom","#searchResvDateTo","#resvDateFrom","#resvDateTo","#cancelResvDate"];
		$.each(datePickerObject, function (index, item) {
			$(item).datepicker(clareCalendar);
		});
	   
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		$("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
		
    	$("body").keydown(function (key) {
        	if(key.keyCode == 13){
        		jqGridFunc.fn_search();
        	}
    	});
	});

	var jqGridFunc = {
		setGrid : function(gridOption) {
			var grid = $('#'+gridOption);
			
			//ajax 관련 내용 정리 하기 
			var postData = {
				"pageIndex": "1", 
				"searchDayCondition" : $('input[name=searchRsvDay]:checked').val(), 
				"searchFrom" : $("#searchResvDateFrom").val(), 
				"searchTo" : $("#searchResvDateTo").val()
			};
			
			grid.jqGrid({
				url : '/backoffice/rsv/rsvListAjax.do',
				mtype : 'POST',
				datatype : 'json',
				pager: $('#pager'),  
				ajaxGridOptions: {contentType: "application/json; charset=UTF-8"},
				ajaxRowOptions: {contentType: "application/json; charset=UTF-8", async: true},
				ajaxSelectOptions: {contentType: "application/json; charset=UTF-8", dataType: "JSON"}, 
				postData : JSON.stringify(postData),
				jsonReader : {
					root : 'resultlist',
					"page":"paginationInfo.currentPageNo",
					"total":"paginationInfo.totalPageCount",
					"records":"paginationInfo.totalRecordCount",
					repeatitems:false
				},
				//상단면
				colModel :  
				[
					{label: 'resv_seq', key: true, name:'resv_seq', index:'resv_seq', align:'center', hidden:true},
					{label: 'NO', name:'rnum', index:'rnum', align:'center', width : "50px"},
					{label: '예약일자', name:'resv_end_dt', index:'resv_end_dt', align:'center', formatter:jqGridFunc.formSetting},
					{label: '예약번호', name:'resv_seq', index:'resv_seq', align:'center'},
					{label: '지점', name:'center_nm', index:'center_nm', align:'center'},
					{label: '좌석등급', name:'part_class', index:'part_class', align:'center'},
					{label: '좌석정보', name:'seat_nm', index:'seat_nm', align:'center'},
					{label: '이름', name:'user_nm', index:'user_nm', align:'center'},
					{label: '전화번호', name:'user_phone', index:'user_phone', align:'center'},
					{label: '금액', name: 'resv_pay_cost', index:'resv_pay_cost', align:'center', formatter:jqGridFunc.formSetting},
					{label: '예약상태', name:'resv_state_text', index:'resv_state_text', align:'center'},
					{label: '결제상태', name:'resv_pay_dvsn_text', index:'resv_pay_dvsn_text', align:'center'},
					{label: '결제구분', name: 'resv_ticket_dvsn_text',  index:'resv_ticket_dvsn_text', align:'center'},
					{label: 'QR출력', name:'resv_qr_print', index:'resv_qr_print', align:'center', sortable : false, formatter:jqGridFunc.formSetting},
					{label: '현금영수증', name:'resv_rcpt_print', index:'resv_rcpt_print', align:'center', sortable : false, formatter:jqGridFunc.formSetting}
				], 
				rowNum : 10,  //레코드 수
				rowList : [10,20,30,40,50,100],  // 페이징 수
				pager : pager,
				refresh : true,
			    multiselect : false, // 좌측 체크박스 생성
				rownumbers : false, // 리스트 순번
				viewrecord : true,  // 하단 레코드 수 표기 유무
				//loadonce : false, // true 데이터 한번만 받아옴 
				loadui : "enable",
				loadtext:'데이터를 가져오는 중...',
				emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
				height : "100%",
				autowidth:true,
				shrinkToFit : true,
				refresh : true,
				loadComplete : function (data) {
					$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
			        var patchWidth = $("[aria-labelledby='gbox_"+$(this).prop("id")+"']").css("width");
			        var patchTarget = $(this).parent();
			        $(patchTarget).css("width", patchWidth);
				},
				loadError:function(xhr, status, error) {
					alert(error); 
				}, 
				onPaging: function(pgButton) {
					var gridPage = grid.getGridParam('page'); //get current  page
					var lastPage = grid.getGridParam("lastpage"); //get last page 
					var totalPage = grid.getGridParam("total");
    		              
					if (pgButton == "next") {
						if (gridPage < lastPage ){
							gridPage += 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "prev") {
						if (gridPage > 1 ){
							gridPage -= 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "first") {
						gridPage = 1;
                    } else if (pgButton == "last") {
						gridPage = lastPage;
					} else if (pgButton == "user") {
						var nowPage = Number($("#pager .ui-pg-input").val());
						
						if (totalPage >= nowPage && nowPage > 0 ) {
							gridPage = nowPage;
						} else {
							$("#pager .ui-pg-input").val(nowPage);
							gridPage = nowPage;
						}
					} else if (pgButton == "records") {
						gridPage = 1;
					}
					
					grid.setGridParam({
						page : gridPage,
						rowNum : $('#pager .ui-pg-selbox option:selected').val(),
						postData : JSON.stringify({
							"pageIndex": gridPage,
							"pageUnit":$('#pager .ui-pg-selbox option:selected').val(),
							"searchCenterCd" : $("#searchCenterCd").val(),
							"searchDayCondition" : $('input[name=searchRsvDay]:checked').val(),
							"searchFrom" : $("#searchResvDateFrom").val(),
							"searchTo" : $("#searchResvDateTo").val(),
							"searchResvUserDvsn" : $("#searchResvUserDvsn").val(),
							"searchResvState" : $("#searchResvState").val(),
							"searchResvPayDvsn" : $("#searchResvPayDvsn").val(),
							"searchResvTicketDvsn" : $("#searchResvTicketDvsn").val(),
							"searchResvRcptYn" : $("#searchResvRcptYn").val(),
							"searchKeyword" : $("#searchKeyword").val(),
							"searchCondition" : $("#searchCondition").val()
						})
					}).trigger("reloadGrid");
				},
				onSelectRow : function(rowId) {
					// 체크 할떄
					if(rowId != null) {
						
					}
				},
				ondblClickRow : function(rowid, iRow, iCol, e) {
					grid.jqGrid('editRow', rowid, {keys: true});
				},
				onCellSelect : function (rowid, index, contents, action){
					var cm = $(this).jqGrid('getGridParam', 'colModel');
					
					if (cm[index].name !='btn'){
						jqGridFunc.fn_resvInfo("Edt", $(this).jqGrid('getCell', rowid, 'resv_seq'));
					}
				},
					//체크박스 선택시에만 체크박스 체크 적용
				beforeSelectRow: function (rowid, e) { 
					var $myGrid = $(this), i = $.jgrid.getCellIndex($(e.target).closest('td')[0]), 
					cm = $myGrid.jqGrid('getGridParam', 'colModel'); 
					return (cm[i].name === 'cb'); 
				}
			});
		}, 
    	useYn : function(cellvalue, options, rowObject) {
			return (rowObject.use_yn ==  "Y") ? "사용" : "사용안함";
		},
		formSetting : function (cellvalue, options, rowObject) {
			var index = options.colModel.index;
			var item = rowObject;
			var form = "";
			
			item.resv_pay_dvsn = item.center_pilot_yn == "N" ? "RESV_PAY_DVSN_2" : item.resv_pay_dvsn;
			if(index == 'resv_qr_print' && item.resv_pay_dvsn == 'RESV_PAY_DVSN_2' && (item.resv_state == 'RESV_STATE_1' || item.resv_state == 'RESV_STATE_2')) {
				form = '<a href="javascript:jqGridFunc.fn_qrInfo(&#39;' + item.resv_seq + '&#39;);" class="blueBtn">QR출력</a>';	
			} else if(index == 'resv_end_dt') {
				form = fn_resvDateFormat(item.resv_end_dt); 	
			} else if(index == 'resv_pay_cost') {
				form = item.resv_pay_cost + "원";
			} else if(index == 'resv_rcpt_print') {
				if(item.resv_rcpt_yn == 'Y' && item.resv_pay_dvsn == "RESV_PAY_DVSN_2") {
					var rcptState = "발행";
					if(item.resv_rcpt_state == "" || item.resv_rcpt_state == "RESV_RCPT_STATE_1") {
						form =  '<a href="javascript:jqGridFunc.fn_billPrint(&#39;' + item.resv_seq + '&#39;);" class="blueBtn" style="padding: 5px 12px;">취소</a>';
						form += '<a href="javascript:jqGridFunc.fn_billState(&#39;' + item.resv_seq + '&#39;);" class="blueBtn" style="padding: 5px 12px;">조회</a>';
					} else {
						form =  '<a href="javascript:jqGridFunc.fn_billPrint(&#39;' + item.resv_seq + '&#39;);" class="blueBtn" style="padding: 5px 12px;">발행</a>';
						form += '<a href="javascript:void(0);" class="blueBtn" style="padding: 5px 12px;">조회</a>';
					}
				}
			}
			
			return form;
		},			
		refreshGrid : function(){
			$('#mainGrid').jqGrid().trigger("reloadGrid");
		},
		clearGrid : function() {
			$("#mainGrid").clearGridData();
		},
		fn_search: function(){
			$("#mainGrid").setGridParam({
				datatype : "json",
				postData : JSON.stringify({
					"pageIndex": $("#pager .ui-pg-input").val(),
					"searchCenterCd" : $("#searchCenterCd").val(),
					"searchDayCondition" : $('input[name=searchRsvDay]:checked').val(),
					"searchFrom" : $("#searchResvDateFrom").val(),
					"searchTo" : $("#searchResvDateTo").val(),
					"searchResvUserDvsn" : $("#searchResvUserDvsn").val(),
					"searchResvState" : $("#searchResvState").val(),
					"searchResvPayDvsn" : $("#searchResvPayDvsn").val(),
					"searchResvTicketDvsn" : $("#searchResvTicketDvsn").val(),
					"searchResvRcptYn" : $("#searchResvRcptYn").val(),
					"searchCondition" : $("#searchCondition").val(),
					"searchKeyword" : $("#searchKeyword").val(),
					"pageUnit":$('#pager .ui-pg-selbox option:selected').val()
				}),
				loadComplete : function(data) {
					$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
				}
			}).trigger("reloadGrid");
 		}, 
		fn_resvInfo : function (mode, resvSeq) {
			$("#mode").val(mode);
			$("#resvSeq").val(resvSeq);
   
			var url = "/backoffice/rsv/rsvInfoDetail.do";
			var param = {"resvSeq" : resvSeq};
			fn_Ajax
			(
				url, 
				"GET",
				param,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "Y","");
						location.href="/backoffice/login.do";
			    	} else if (result.status == "SUCCESS") {
						var obj = result.regist;
						$("#rsvPopCenterNm").html(obj.center_nm);
						$("#rsvPopAreaInfo").html(obj.seat_nm);
						$("#rsvPopResvSeq").html(obj.resv_seq);
						$("#rsvPopResvDate").html(fn_resvDateFormat(obj.resv_end_dt));
						$("#rsvPopResvUserDvsn").html(obj.resv_user_dvsn_text);
						$("#rsvPopUserId").html(obj.user_id);
						$("#rsvPopResvUserNm").html(obj.user_nm);
						$("#rsvPopResvUserPhone").html(obj.user_phone);
						$("#rsvPopResvPayDvsn").html(obj.resv_pay_dvsn_text);
						$("#rsvPopResvSeatPayCost").html(obj.resv_seat_pay_cost + "원");
						$("#rsvPopResvEntryPayCost").html(obj.resv_entry_pay_cost + "원");
						$("#rsvPopResvTicketDvsn").html(obj.resv_ticket_dvsn_text);
						$("#rsvPopResvState").html(obj.resv_state_text);
						
						$("#state_change_pop .right_box a:eq(0)").off().on("click", function() {
							jqGridFunc.fn_resvStateChange(obj.resv_seq);
						});
						
						$("#rsvPopStateChange").off().on("click", function() {
							$("#changeResvState").val(obj.resv_state);
							$("#changeResvPayDvsn").val(obj.resv_pay_dvsn);			
						});
						
						//좌석변경 버튼표출 -> 스피드온 결제상태 + 예약 또는 이용중 상태
						if(obj.resv_ticket_dvsn == "RESV_TICKET_DVSN_1" && (obj.resv_state == "RESV_STATE_1" || obj.resv_state == "RESV_STATE_2")) {
							$("#rsvPopSeatChange a").show().off().on('click',function () {
								jqGridFunc.fn_resvSeatInfo("CHANGE",obj);
							});
						} else {
							$("#rsvPopSeatChange a").hide();
						}
						
						//예약취소버튼 표출 -> 예약 또는 이용중 상태일 경우
						if(obj.resv_state == "RESV_STATE_1" || obj.resv_state == "RESV_STATE_2") {
							$("#resvCancelBtn").show().off().on('click', function () {
				        		$("#id_ConfirmInfo").off().on('click',function () {
				        			jqGridFunc.fn_resvInfoCancel(obj.resv_seq);
								});
				        		fn_ConfirmPop("해당 예약정보를 취소 하시겠습니까?");
							});							
						} else {
							$("#resvCancelBtn").hide();
						}
						
						//입퇴장 이력
						attendService.fn_attendInfo(resvSeq);
					}
				},
				function(request){
					common_popup("ERROR : " + request.status, "");
				}    		
			);
		},
		fn_resvStateChange : function(resvSeq) {
			var url = "/backoffice/rsv/rsvStateChange.do";
			var params = {
				"resvSeq" : resvSeq,
				"resvState" : $("#changeResvState").val(),
				"resvPayDvsn" : $("#changeResvPayDvsn").val()
			};
			
			fn_Ajax
			(
			    url,
			    "POST",
				params,
				false,
				function(result) {
					if (result.status == "SUCCESS") {
						common_modelClose('state_change_pop');
						common_popup("예약정보가 정상적으로 변경되었습니다.", "Y", "");
						jqGridFunc.fn_resvInfo("Edt", resvSeq);
						jqGridFunc.fn_search();
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
		},
		fn_resvInfoCancel : function(resvSeq) {
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
						jqGridFunc.fn_resvInfo("Edt", resvSeq);
						jqGridFunc.fn_search();
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
		},
		fn_excelDown : function (){
			if ($("#mainGrid").getGridParam("reccount") === 0) {
				alert('다운받으실 데이터가 없습니다.');
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
						alert('해당 조회 건수가 1000건이 넘습니다. 엑셀 다운로드 시 1000건에 대한 데이터만 저장됩니다.');
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
					alert(json.message);
				}
			);
		},
		fn_resvInfoCancelAll : function() {
			if(!$("#cancelResvCenterCd").val()) {
				common_popup("지점을 선택하세요.", "N", "");
				return;
			} else if(!$("#cancelResvDate").val()) {
				common_popup("예약 취소일을 선택하세요.", "N", "");
				return;
			} else if(!yesterDayConfirm($("#cancelResvDate").val())){
				common_popup("예약 취소일을 이전일자로 지정하실수 없습니다.", "N", "");
				return;					
			}

			var url = "/backoffice/rsv/resvInfoCancelAll.do";
			var params = {
				"centerCd" : $("#cancelResvCenterCd").val(),
				"resvDate" : $("#cancelResvDate").val()
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
							jqGridFunc.fn_search();
						} else {
							common_popup("지정한 날짜에 취소할 예약정보가 존재하지 않습니다.", "Y", "");
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
			
			common_modelClose('all_cancel_pop');
		},
		fn_qrInfo : function(resvSeq) {
			var url = "/backoffice/rsv/qrSend.do";
			var params = {
				"resvSeq" : resvSeq,
				"tickPlace" : "PAPER"
			}
			
			fn_Ajax
			(
			    url,
			    "GET",
				params,
				false,
				function(result) {
			    	if (result.status == "SUCCESS") {
			    		$("#qrPrint > img").remove();
						var qrcode = new QRCode("qrPrint", {
						    text: result.QRCODE,
						    width: 256,
						    height: 256,
						    colorDark : "#000000",
						    colorLight : "#ffffff",
						    correctLevel : QRCode.CorrectLevel.M
						});
						
						$("#qrPrint > img").css("margin", "auto");
						
						$("#qrResvSeq").html(result.resvInfo.resv_seq);
						$("#qrResvDate").html(result.resvInfo.resv_end_dt);
						$("#qrCenter").html(result.resvInfo.center_nm);
						$("#qrSeat").html(result.resvInfo.seat_nm);
						$("#qrName").html(result.resvInfo.user_nm);
						$("#qrPhone").html(result.resvInfo.user_phone);
					} else {
						common_popup(result.message, "Y", "");
					}
				},
				function(request) {
					alert("ERROR : " + request.status);	       						
				}    		
			);	
			
			common_modelOpen("qr_print");
		},
		fn_qrPrint : function() {
			$("#qrWrap").print();
		},
		fn_billPrint : function(resvSeq) {
			var url = "/backoffice/rsv/billPrint.do"
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
						jqGridFunc.fn_search();
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
		},
		fn_billState : function(resvSeq) {
			var url = "/backoffice/rsv/billState.do"
			var params = {
				"resvSeq" : resvSeq
			};
			
			fn_Ajax
			(
			    url,
			    "GET",
				params,
				false,
				function(result) {
					if (result.status == "SUCCESS") {
						var cashBillInfo = result.cashBillInfo;
						$("#confirmNum").html(cashBillInfo.confirmNum);
						$("#issueDT").html(cashBillInfo.issueDT);
						$("#mgtKey").html(cashBillInfo.mgtKey);
						$("#tradeType").html(cashBillInfo.tradeType);
						$("#tradeUsage").html(cashBillInfo.tradeUsage);
						$("#tradeOpt").html(cashBillInfo.tradeOpt);
						$("#taxationType").html(cashBillInfo.taxationType);
						$("#identityNum").html(cashBillInfo.identityNum);
						$("#tradeDate").html(cashBillInfo.tradeDate);
						$("#totalAmount").html(cashBillInfo.totalAmount + "원");
						$("#itemName").html(cashBillInfo.itemName);
						$("#customerName").html(cashBillInfo.customerName);
						 
						common_modelOpen('bill_state_pop');
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
		},
		fn_centerChange : function() {
	 		var url = "/backoffice/bld/floorComboInfo.do";
	 		var params = {
	 			"centerCd" : $("#resvCenterCd").val()
	 		};
	 		
	 		//입장료
	 		$("#resvEntryPayCost").val($("#resvCenterCd").find("option:selected").data("entrypaycost"));
	 		var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
	 		fn_comboListJson("resvFloorCd", returnVal, "jqGridFunc.fn_floorChange", "100px;", "");
		},
		fn_floorChange : function() {
			var url = "/backoffice/bld/partInfoComboList.do";
		    var params = {
				"floorCd" : $("#resvFloorCd").val()
			};
		 	var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
			fn_comboListJson("resvPartCd", returnVal, "", "100px;", "");
		},
		fn_resvSeatInfo : function(division,resvInfo) {
			if(division == "CHANGE") {
				$("#resvSeq").val(resvInfo.resv_seq);
				$("#resvDate").val(resvInfo.resv_end_dt);
				$("#resvCenterCd").val(resvInfo.center_cd).trigger("change").show();
 				$("#resvFloorCd").val(resvInfo.floor_cd).trigger("change");
				$("#resvPartCd").val(resvInfo.part_cd);
				$("#seat_change p:eq(3)").hide();
				$("#seat_change a:eq(1)").attr("href","javascript:jqGridFunc.fn_resvSeatSearch('CHANGE');");
				$("#seat_change a:eq(2)").html("변경").attr("href","javascript:common_modelOpen('pay_number');").click(function () {
					$("#cardPw").val("");
				});
				jqGridFunc.fn_resvSeatSearch("CHANGE");
			} else if(division = "LONG") {				
				if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
					$("#resvCenterCd").val($("#loginCenterCd").val()).trigger("change").closest("p").hide();
				} else {
					$("#resvCenterCd").val("");
					$("#resvFloorCd").children("option:not(:first)").remove();
				}
				
				$("#resvPartCd").children("option:not(:first)").remove();
 				$("#resvSeq").val("");
				$("#resvDate").val("");
				$("#resvDateFrom").val("");
				$("#resvDateTo").val("");
				$("#seat_change p:eq(3)").show();
				$("#seat_change a:eq(1)").attr("href","javascript:jqGridFunc.fn_resvSeatSearch('LONG');");
				$("#seat_change a:eq(2)").html("좌석선택").attr("href","javascript:jqGridFunc.fn_setLongSeatInfo()");
				$("#seat_change .pop_tit").html("사용자 좌석 선택");
				$(".pop_mapArea").css("background","");
				$(".pop_seat").html("");
			}
			
			seatSearchInfo = {};
			$("#seasonCd").val("");
			common_modelOpen("seat_change");
		},
		fn_resvSeatSearch : function(division) {
			var url = "/front/rsvSeatListAjax.do";
			var params = {};
			
			if($("#resvCenterCd").val() == "") { common_popup("지점을 선택하세요.", "N", ""); return; }
			if($("#resvFloorCd").val() == "") { common_popup("층을 선택하세요.", "N", ""); return; }
			if($("#resvPartCd").val() == "") { common_popup("구역을 선택하세요.", "N", ""); return; }
			
			
			if(division == "CHANGE") {
				params = {
					"searchCondition" : division,
					"resvSeq" : $("#resvSeq").val(),
					"resvDate" : $("#resvDate").val(),
					"centerCd" : $("#resvCenterCd").val(),
					"partCd" : $("#resvPartCd").val()
				};
			} else {
				if(!$("#resvDateFrom").val() || !$("#resvDateTo").val()){
					common_popup("예약일자를 입력하세요.", "N", "");
					return;
				} else if(!yesterDayConfirm($("#resvDateFrom").val())){
					common_popup("예약시작일을 이전일자로 지정하실수 없습니다.", "N", "");
					return;					
				} else if(!dateIntervalCheckTemp($("#resvDateFrom").val(), $("#resvDateTo").val())){
					common_popup("종료일자가 시작일자보다 빠를수 없습니다.", "N", "");
					return;
				}
				
				params = {
					"searchCondition" : division,
					"resvDateFrom" : $("#resvDateFrom").val(),
					"resvDateTo" : $("#resvDateTo").val(),
					"centerCd" : $("#resvCenterCd").val(),
					"partCd" : $("#resvPartCd").val()
				};
			}
			
			//마지막 검색결과 보유
			seatSearchInfo.centerCd = $("#resvCenterCd").val();
			seatSearchInfo.floorCd = $("#resvFloorCd").val();
			seatSearchInfo.partCd = $("#resvPartCd").val();
			seatSearchInfo.resvDateFrom = $("#resvDateFrom").val();
			seatSearchInfo.resvDateTo = $("#resvDateTo").val();
			
			fn_Ajax
			(
			    url,
			    "POST",
			    params,
				false,
				function(result) {
			    	if (result.status == "SUCCESS") {
			    		result.seasonCd != null ? $("#seasonCd").val(result.seasonCd) : $("#seasonCd").val("");
			    		
			    		if (result.seatMapInfo != null) {
			    		    var img = result.seatMapInfo.part_map1;
			    		    $('.pop_mapArea').css({
			    		        "background": "#fff url(/upload/" + img + ")"
			    		    });
			    		} else {
			    		    $('.part_mapArea').css({
			    		        "background": "#fff url()"
			    		    });
			    		}
							
						if (result.resultlist.length > 0) {
			    		    var shtml = "";
			    		    var obj = result.resultlist;
			    		    for (var i in result.resultlist) {
			    		    	switch(obj[i].status){
			    		    		case "1" : addClass = "usable"; break;
			    		    		case "2" : addClass = "disable"; break;
			    		    		default : addClass = "selected"; break;
			    		    	}

			    		        shtml += '<li id="' + fn_NVL(obj[i].seat_cd) + '" class="' + addClass + '" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_nm + '" >' + obj[i].seat_number + '</li>';
			    		    }

			    		    $(".pop_seat").html(shtml);
			    		    
			    		    for (var i in result.resultlist) {
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
			    	}
				},
				function(request) {	 
					common_popup("ERROR : " + request.status, "N", "");
				}    		
			);	
		},
		fn_resvSeatUpdate : function(division) {
			if($(".pop_seat li.usable").length <= 0) {
				common_popup("변경할 좌석을 선택하세요.", "N", "");
				return;	
			} else if($("#cardPw").val() == "") {
				common_popup("결제 비밀번호를 입력하세요.", "N", "");
				return;				
			}
			
			common_modelClose('pay_number');
			
			var params = {
				"resvSeq" : $("#resvSeq").val(),
				"inResvDate" : $("#resvDate").val(),
				"seasonCd" : $("#seasonCd").val(),
				"centerCd" : $("#resvCenterCd").val(),
				"floorCd" : $("#resvFloorCd").val(),
				"partCd" : $("#resvPartCd").val(),
				"seatCd" : $(".pop_seat li.usable").attr("id"),
				"resvEntryPayCost" : $("#resvEntryPayCost").val(),
				"resvSeatPayCost" : $(".pop_seat li.usable").data("seat_paycost"),
				"cardPw" : $("#cardPw").val(),
				"checkDvsn" : division
			}
			
			var validResult = jqGridFunc.fn_resvVaildCheck(params);
			
			if(validResult != null) {
				var url = "/backoffice/rsv/rsvSeatChange.do"; 
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
				    	if(result.status == "SUCCESS") {
				    		common_modelClose("seat_change");
				    		common_popup(result.message, "Y", "");
				    		jqGridFunc.fn_resvInfo("Edt", result.resvSeq);
							jqGridFunc.fn_search();
				    	} else if (result.status == "LOGIN FAIL") {
				    		common_popup("로그인 정보가 올바르지않습니다 다시 로그인해주세요", "Y", "");
				    	} else {
				    		common_modelClose("seat_change");
				    		jqGridFunc.fn_search();
				    		jqGridFunc.fn_resvInfo("Edt", result.resvSeq);
				    		common_popup(result.step + "<br>" + result.message, "Y", "");
				    	}
					},
					function(request) {
						common_popup("ERROR : " + request.status, "N", "");	       						
					}    		
				);	
			}		
		},
		fn_resvVaildCheck : function(params) {
			var url = "/backoffice/rsv/resvValidCheck.do";
			var validResult;
			
			fn_Ajax
			(
			    url,
			    "POST",
				params,
				false,
				function(result) {
					if (result.status == "SUCCESS") {
						if(result.validResult.resultCode != "SUCCESS") {
							common_popup(result.validResult.resultMessage, "N", "long_seat_add");
							return;
						} else {
							validResult = result.validResult;
						}
					} else if (result.status == "LOGIN FAIL") {
						location.href = "/backoffice/login.do";
					}
				},
				function(request) {
					common_popup("ERROR : " + request.status, "N", "long_seat_add");	       						
				}    		
			);
			
			return validResult;
		},
		fn_longSeatAdd : function() {
			$("#seasonCd").val("");
			$("#resvEntryPayCost").val("");
			$("#longResvCenterCd").val("");
			$("#longResvFloorCd ").val("");
			$("#longResvPartCd").val("");
			$("#longResvSeatNm").val("");
			$("#longResvSeatCd").val("");
 			$("#longResvDateFrom").val("");
			$("#longResvDateTo").val("");

			$("#userSearchCondition option:eq(0)").prop("selected",true);
			$("#userSearchKeyword").val("");
			$("#longResvUserId").val("");
			
			$("#empSearchCondition  option:eq(0)").prop("selected",true);
			$("#empSearchKeyword").val("");
			$("#longResvEmpNo").val("");
			
			common_modelOpen("long_seat_add");
		},
		fn_setLongSeatInfo : function() {
			if($(".pop_seat li.usable").length <= 0) {
				common_popup("좌석을 선택하세요.", "N", "");
				return;	
			}

			$("#longResvCenterCd").val(seatSearchInfo.centerCd);
			$("#longResvFloorCd").val(seatSearchInfo.floorCd);
			$("#longResvPartCd").val(seatSearchInfo.partCd);
			$("#longResvSeatCd").val($(".pop_seat li.usable").attr("id"));
			$("#longResvSeatNm").val(
				$("#resvCenterCd option:checked").text() + " " +
				$("#resvFloorCd option:checked").text() + " " +
				$("#resvPartCd option:checked").text() + "구역 " +
				$(".pop_seat li.usable").data("seat_name")
			);
			
			$("#longResvPayCost").val($(".pop_seat li.usable").data("seat_paycost")); 
			$("#longResvDateFrom").val($("#resvDateFrom").val());
			$("#longResvDateTo").val($("#resvDateTo").val());
			common_modelClose("seat_change");
		},
		fn_longSeatUpdate : function() {
			if (any_empt_line_span("long_seat_add", "longResvSeatCd", "예약할 좌석을 선택하세요","sp_message", "savePage") == false) return;
			if (any_empt_line_span("long_seat_add", "longResvUserId", "에약 회원을 선택하세요","sp_message", "savePage") == false) return;
			if (any_empt_line_span("long_seat_add", "longResvEmpNo", "예약 담당자를 선택하세요","sp_message", "savePage") == false) return;
			
			var params = {
				"mode" : "Ins",
				"checkDvsn" : "LONG",
				"resvDateFrom" : $("#longResvDateFrom").val(),
				"resvDateTo" : $("#longResvDateTo").val(),
				"seasonCd" : $("#seasonCd").val(),
				"centerCd" : $("#longResvCenterCd").val(),
				"floorCd" : $("#longResvFloorCd").val(),
				"partCd" : $("#longResvPartCd").val(),
				"seatCd" : $("#longResvSeatCd").val(),
				"userId" : $("#longResvUserId").val(),
				"resvEntryPayCost" : $("#resvEntryPayCost").val(),
				"resvSeatPayCost" : $("#longResvPayCost").val(),
				"resvUserNm" : $("#longResvUserName").val(),
				"longResvEmpNo" : $("#longResvEmpNo").val(),
				"resvUserClphn" : $("#longResvUserPhone").val(),
			}
			
			var validResult = jqGridFunc.fn_resvVaildCheck(params);
			
			if(validResult != null) {
				var url = "/backoffice/rsv/longResvInfoUpdate.do"; 
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
				    	if(result.status == "SUCCESS") {
							common_modelCloseM("장기 예약 정보가 정상적으로 등록되었습니다.", "long_seat_add");
							jqGridFunc.fn_search();
				    	} else if (result.status == "LOGIN FAIL") {
				    		alert("로그인 정보가 올바르지 않습니다 다시 로그인 해주세요");
				    		location.href = "/backoffice/login.do";
				    	} else {
				    		common_popup("처리중 오류가 발생하였습니다.", "Y", "");
				    	}
					},
					function(request) {
						common_popup("ERROR : " + request.status, "N", "");	       						
					}    		
				);
			}
		},
		fn_searchResult : function (searchDvsn) {
			var setHtml = "<table id='searchResultTable' class='whiteBox main_table'>";
			$("#searchResultWrap").empty();
			$("#searchResultWrap").append(setHtml);
			
			var checkTag = "";
			var colModel = "";
			var gridEmp = $("#searchResultTable");
			var postData = "";
			var url = "";
			gridEmp.jqGrid('clearGridData',true);
			
			if(searchDvsn == "user") {
				url ="/backoffice/cus/userListInfoAjax.do";
				checkTag = "userSearchKeyword";
				if (any_empt_line_span("long_seat_add", checkTag, "검색어를 입력해 주세요.","sp_message", "savePage") == false) return;	
				colModel =
				[
					{ label: '아이디', name:'user_id', index:'user_id', align:'left', width:'150px'},
					{ label: '이름',  name:'user_nm', index:'user_nm', align:'left', width:'150px'},
					{ label: '전화번호', name:'user_phone', index:'user_phone', align:'left', width:'150px'},
				];
				postData = {"pageIndex": "1", "mode": "", "searchCondition" : $("#userSearchCondition").val(), "searchKeyword" : $("#userSearchKeyword").val()};
			} else {
				url = "/backoffice/mng/empListAjax.do";
				checkTag = "empSearchKeyword";
				if (any_empt_line_span("long_seat_add", checkTag, "검색어를 입력해 주세요.","sp_message", "savePage") == false) return;	
				colModel =
				[
					{ label: '부서', name:'dept_nm', index:'dept_nm', align:'left', width:'150px'},
					{ label: '사번', name:'emp_no', index:'emp_no', align:'left', width:'150px'},
					{ label: '이름', name:'emp_nm', index:'emp_nm', align:'left', width:'150px'},
					{ label: '전화번호', name:'emp_clphn', index:'emp_clphn', align:'left', width:'0px', hidden:true},
					{ label: '이메일', name:'emp_email', index:'emp_email', align:'left', width:'0px', hidden:true}
				];
				postData = {"pageIndex": "1", "mode": "search", "searchCondition" : $("#empSearchCondition").val(), "searchKeyword" : $("#empSearchKeyword").val()};
			}

			common_modelOpen("search_result");
			
			gridEmp.jqGrid({
				url : url,
				mtype :  'POST',
				datatype :'json',
				ajaxGridOptions: { contentType: "application/json; charset=UTF-8"},
				ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true} ,
				ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON"}, 
				postData : JSON.stringify(postData),
				jsonReader : {
					root : 'resultlist',
					"page":"paginationInfo.currentPageNo",
					"total":"paginationInfo.totalPageCount",
					"records":"paginationInfo.totalRecordCount",
					repeatitems:false
				},
				colModel : colModel,  //상단면 
				rowNum : 1000,  //레코드 수
				refresh : false,
				rownumbers : false, // 리스트 순번
				viewrecord : true,    // 하단 레코드 수 표기 유무
			    loadui : "enable",
			    loadtext:'데이터를 가져오는 중...',
			    emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
			    height : "100%",
			    autowidth:false,
			    frozen:true, 
			    shrinkToFit : false,
			    refresh : true,
			    multiselect:false,
			    loadonce : true,
			    loadComplete : function (data){
			    	//완료 표시 
			    }, 
			    loadError:function(xhr, status, error) {
			    	loadtext:'시스템 장애...'
			    }, 
				onSelectRow: function(rowId){
					if(rowId != null) {  }// 체크 할떄
				}, 
				onCellSelect : function (rowid, index, contents, action){
					var cm = $('#searchResultTable').jqGrid('getGridParam', 'colModel');
					if (cm[index].name !='btn' ){
						var id = searchDvsn == "user" ? "user_id" : "emp_no";
						var name = searchDvsn == "user" ? "user_nm" : "";
						var phone = searchDvsn == "user" ? "user_phone" : "";
						
						jqGridFunc.fn_inSearchInfo(
							searchDvsn, 
							$(this).jqGrid('getCell', rowid, id), 
							$(this).jqGrid('getCell', rowid, name), 
							$(this).jqGrid('getCell', rowid, phone)
						);
					}
				},
			});
			//추후 변경 예정 
			$("#searchResultTable").setGridParam({
				datatype : "json",
				postData : JSON.stringify(postData),
				loadComplete : function(data) {}
			}).trigger("reloadGrid");
		},
		fn_inSearchInfo : function(searchDvsn, id, name, phone) {
			if(searchDvsn == "user") {
				$("#longResvUserId").val(id);
				$("#longResvUserName").val(name);
				$("#longResvUserPhone").val(phone);
			} else {
				$("#longResvEmpNo").val(id);
			}
			
			common_modalOpenAndClose('long_seat_add','search_result');
		}
	}
	
	var isAttendGridInit = false;
	
	var attendService = {
		fn_attendInfo : function(resvSeq) {
			$("#resvSeq").val(resvSeq);
			common_modelOpen("rsv_detail");
			
			var grid = $("#inOutHisTable");
			var postData = {"pageIndex": "1", "searchCondition" : "RES_SEQ", "searchKeyword" : resvSeq};
			var pager = $("#inOutHisPager");
			
			if(isAttendGridInit) {
				grid.setGridParam({
					datatype : "json",
					postData : JSON.stringify(postData),
					loadComplete : function(data) {
						/* $("#sp_totcnt").text(data.paginationInfo.totalRecordCount); */
					}
				}).trigger("reloadGrid");
			} else {
				//ajax 관련 내용 정리 하기 
				grid.jqGrid({
					url : '/backoffice/rsv/attendListAjax.do',
					mtype : 'POST',
					datatype : 'json',
					pager: pager,  
					ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
					ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
					ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
					
					postData : JSON.stringify(postData),
					
					jsonReader : {
						root : 'resultlist',
						"page":"paginationInfo.currentPageNo",
						"total":"paginationInfo.totalPageCount",
						"records":"paginationInfo.totalRecordCount",
						repeatitems:false
					},
					//상단면
					colModel :  
					[     
						{label: 'qr_check_seq', key: true, name:'qr_check_seq', index:'qr_check_seq', align:'center', hidden:true},
						{label: 'NO', name:'rnum', index:'rnum', align:'center', width : "50px"},
						{label: '체크 구분', name:'inout_dvsn_text', index:'inout_dvsn_text', align:'center'},
						{label: '체크인 시간', name:'qr_check_tm', index:'qr_check_tm', align:'center'},
						{label: '통신시간 ', name:'rcv_dt', index:'rcv_dt', align:'center'},
						{label: '통신결과', name:'rcv_cd', index:'rcv_cd', align:'center'}
					], 
					rowNum : 5,  //레코드 수
					rowList : [5,10,20,30,40,50],  // 페이징 수
					pager : pager,
					refresh : true,
				    multiselect : false, // 좌측 체크박스 생성
					rownumbers : false, // 리스트 순번
					viewrecord : true,  // 하단 레코드 수 표기 유무
					loadonce : true, 
					loadui : "enable",
					loadtext:'데이터를 가져오는 중...',
					emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
					height : "100%",
					autowidth: true,
					shrinkToFit : true,
					refresh : true,
					loadComplete : function (data) {
						/* $("#sp_totcnt").text(data.paginationInfo.totalRecordCount); */
					},
					loadError:function(xhr, status, error) {
						alert(error); 
					}, 
					onPaging: function(pgButton) {
						var gridPage = grid.getGridParam('page'); //get current  page
						var lastPage = grid.getGridParam("lastpage"); //get last page 
						var totalPage = grid.getGridParam("total");
	    		              
						if (pgButton == "next"){
							if (gridPage < lastPage ){
								gridPage += 1;
							} else {
								gridPage = gridPage;
							}
						} else if (pgButton == "prev") {
							if (gridPage > 1 ){
								gridPage -= 1;
							} else {
								gridPage = gridPage;
							}
						} else if (pgButton == "first") {
							gridPage = 1;
	                    } else if (pgButton == "last") {
							gridPage = lastPage;
						} else if (pgButton == "user") {
							var nowPage = Number($("#inOutHisPager .ui-pg-input").val());
							
							if (totalPage >= nowPage && nowPage > 0 ) {
								gridPage = nowPage;
							} else {
								$("#inOutHisPager .ui-pg-input").val(nowPage);
								gridPage = nowPage;
							}
						} else if (pgButton == "records") {
							gridPage = 1;
						}
						
						grid.setGridParam({
							page : gridPage,
							rowNum : $('#inOutHisPager .ui-pg-selbox option:selected').val(),
							postData : JSON.stringify({
								"pageIndex": gridPage,
								"pageUnit":$('#inOutHisPager .ui-pg-selbox option:selected').val()
							})
						}).trigger("reloadGrid");
					},
					onSelectRow : function(rowId) {
						// 체크 할떄
						if(rowId != null) {  
							
						}
					},
					ondblClickRow : function(rowid, iRow, iCol, e) {
						grid.jqGrid('editRow', rowid, {keys: true});
					},
				});
				
				//추후 변경 예정 
				$("#inOutHisTable").setGridParam({
					datatype : "json",
					postData : JSON.stringify(postData),
					loadComplete : function(data) {}
				}).trigger("reloadGrid");
				
				isAttendGridInit = true;
			}
		},
		fn_setInoutHistory : function() {
			var url = "/backoffice/rsv/attendInfoUpdate.do";
			var params = {
				"mode" : "Manual",
				"resvSeq" : $("#resvSeq").val(),
				"inoutDvsn" : $("#inoutDvsn").val()
			}
			
			fn_Ajax
			(
			    url,
			    "POST",
				params,
				false,
				function(result) {
					if(result.status == "SUCCESS") {
						common_modelCloseM("입출입 정보가 정상적으로 등록되었습니다.", "rsv_inout_add");
					} else {
						common_modelCloseM("에러가 발생하였습니다.", "rsv_inout_add");
					}
					
					attendService.fn_attendInfo($("#resvSeq").val());
				},
				function(request) {
					common_popup("ERROR : " + request.status, "N", "");	       						
				}    		
			);	
		}
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />