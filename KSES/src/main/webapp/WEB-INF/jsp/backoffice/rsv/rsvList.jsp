<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
</style>
<!-- //contents -->
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="resvSeq" name="resvSeq">
<input type="hidden" id="resvDate" name="resvDate">
<input type="hidden" id="authorCd" name="authorCd" value="${loginVO.authorCd}">
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
              		<p class="hideAuthor">지점</p>
              		<select id="searchCenterCd" class="hideAuthor">
						<option value="">지점 선택</option>
							<c:forEach items="${centerInfo}" var="centerInfo">
						<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
						</c:forEach>
              		</select>

	              	<p>기간</p>
	              	<!-- search //-->
	              	<label for="resvDate"><input type="radio" name="searchRsvDay" id="resvDate" value="resvDate" checked>예약일</label>
					<label for="resvReqDate"><input type="radio" name="searchRsvDay" id="resvReqDate" value="resvReqDate">신청일</label>
	              	<p>
						<input type="text" id="searchResvDateFrom" class="cal_icon" name="date_from" autocomplete=off><em>~</em>
	                	<input type="text" id="searchResvDateTo" class="cal_icon" name="date_to" autocomplete=off>
	              	</p>
	              	<p>예약 상태</p>
					<select id="searchResvState">
						<option value="">선택</option>
						<c:forEach items="${resvState}" var="resvState">
							<option value="${resvState.code}">${resvState.codenm}</option>
						</c:forEach>
	              	</select>
	              	<p>결재 상태</p>
	              	<select id="searchResvPayDvsn">
	              		<option value="">선택</option>
						<c:forEach items="${resvPayDvsn}" var="resvPayDvsn">
							<option value="${resvPayDvsn.code}">${resvPayDvsn.codenm}</option>
						</c:forEach>
	              	</select>
	              	<p>검색어</p>
	              	<select id="searchCondition">
						<option value="">선택</option>
						<option value="resvSeq">예약번호</option>
						<option value="resvName">이름</option>
						<option value="resvId">아이디</option>
	              	</select>
	              	<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
				</div>
			</div>
	
			<div class="inlineBtn">
				<a href="javascript:jqGridFunc.fn_search();"class="grayBtn">검색</a>
			</div>
		</div>
	
		<div class="right_box">
			<a href="javascript:jqGridFunc.fn_longSeatAdd();" class="blueBtn">장기 예매</a>
			<a href=""  class="blueBtn">엑셀 다운로드</a>
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
                      <th>지점 </th>
                      <td id="rsvPopCenterNm">장안지점</td>
                      <th>좌석 정보 </th>
                      <td id="rsvPopAreaInfo">1층 B-003</td>
                  	</tr> 
                  	<tr> 
                    	<th>좌석 변경</th>
                    	<td id="rsvPopSeatChange">
                      		<a class="blueBtn">좌석변경</a>
                    	</td>
                    	<th>예약 번호</th>
                    	<td id="rsvPopResvSeq">KSP7968</td>
                  	</tr>
                  	<tr>
                    	<th>회원 구분 </th>
                    	<td id="rsvPopResvUserDvsn">일반 회원</td>
                    	<th>아이디</th>
                    	<td id="rsvPopUserId">id5678</td>
                  	</tr>
                  	<tr>
                    	<th>이름 </th>
                    	<td id="rsvPopResvUserNm">홍길동</td>
                    	<th>전화번호</th>
                    	<td id="rsvPopResvUserPhone">010-1234-5678</td>
                  	</tr>
                  	<tr>
                    	<th>결제 정보 </th>
                    	<td>
							<label id="rsvPopResvPayDvsn"></label>
                      		<!-- <a href="#" class="blueBtn">영수증 출력 </a> -->
                    	</td>
                    	<th>문진표</th>
						<td id="rsvPopResvUserAskYn">Y</td>
                  	</tr>
                  	<tr>
                    	<th>블랙리스트</th>
                    	<td>대상 아님 <!-- <a href="" class="blueBtn left80">블랙리스트 등록</a></td> -->
                    	<th>발권 구분</th>
                    	<td>온라인</td>
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
      	</div>
      	<div class="right_box">
          	<a href="javascript:$('#rsv_detail').bPopup().close();" class="grayBtn">닫기</a>
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
			<a href="javascript:$('#long_seat_add').bPopup().close();" class="grayBtn">닫기</a>
      	</div>
      	<div class="clear"></div>
  	</div>
</div>
<!-- // 환불처리 팝업 -->
<div data-popup="view_refund" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">환불 처리</h2>
      	<div class="pop_wrap">
			<table class="detail_table">
				<tbody>
					<tr>
						<th>지점 </th>
                      	<td>장안지점</td>
                      	<th>구역 정보 </th>
                      	<td>B001</td>
                  	</tr>
                  	<tr>
                    	<th>좌석 정보</th>
                    	<td>023</td>
                    	<th>예약 번호</th>
                    	<td>KSP7968</td>
                  	</tr>
                  	<tr>
                    	<th>회원 구분 </th>
                    	<td>일반 회원</td>
                    	<th>아이디</th>
                    	<td>id5678</td>
                  	</tr>
                  	<tr>
                    	<th>이름 </th>
                    	<td>홍길동</td>
                    	<th>전화번호</th>
                    	<td>010-1234-5678</td>
                  	</tr>
                  	<tr>
                    	<th>환불 코드 </th>
                    	<td colspan="3">
	                      	<select name="" id="">
                        		<option value="">선택</option>
                      		</select>
                    	</td>
					</tr>
					<tr>
                    	<th>환불 상세 내역 </th>
                    	<td colspan="3">
                      		<textarea name="" id="" rows="3"></textarea>
                    	</td>
                  	</tr>
              	</tbody>
			</table>
		</div>
		<div class="right_box">
          	<a href="" class="blueBtn">환불 처리 </a>
      	</div>
      	<div class="clear"></div>
  	</div>
</div>

<!-- // 관리자 검색 팝업 -->
<div id="search_result" class="popup">
	<div class="pop_con">
		<a href="javascript:$('#long_seat_add').bPopup(); $('#search_result').bPopup().close();" class="button bCloseT"></a>
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
                            	<option value="OUT">퇴장</option>
                            </select>
                        </td>
                    </tr>
            </table>
        </div>
        <div class="center_box">
        	<a href="javascript:attendService.fn_setInoutHistory();" id="inOutUpdateBtn" class="blueBtn">저장</a>
            <a href="javascript:$('#rsv_inout_add').bPopup().close();" class="grayBtn">취소</a>
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
							<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
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

<!--1214 QR출력 팝업-->
<div data-popup="qr_print" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">QR 출력</h2>
      	<div class="pop_wrap">
      		<div class="pint_a">
      			<a href="">출력<img src="/resources/img/print_black_24dp.svg" alt="출력"></a>
      		</div>
      		<!--QR 영역-->
      		<p class="qrPrint">
      			<img src="/resources/img/qrcode.png" alt="">
      		</p>
			<!--QR 영역//-->

			<table class="detail_table">
				<tbody>
					<tr>
						<th>지점 </th>
                      	<td>장안지점</td>
                      	<th>구역 정보 </th>
                      	<td>B001</td>
                  	</tr>
                  	<tr>
                    	<th>좌석 정보</th>
                    	<td>023</td>
                    	<th>예약 번호</th>
                    	<td>KSP7968</td>
                  	</tr>
                  	<tr>
                    	<th>회원 구분 </th>
                    	<td>일반 회원</td>
                    	<th>아이디</th>
                    	<td>id5678</td>
                  	</tr>
                  	<tr>
                    	<th>이름 </th>
                    	<td>홍길동</td>
                    	<th>전화번호</th>
                    	<td>010-1234-5678</td>
                  	</tr>
              	</tbody>
			</table>
		</div>
      	<div class="clear"></div>
  	</div>
</div>

<!-- popup// -->
<script type="text/javascript">
	var seatSearchInfo = {};

	$(document).ready(function() { 
		if($("#authorCd").val() != "ROLE_ADMIN" && $("#authorCd").val() != "ROLE_SYSTEM") {
			/* $(".hideAuthor").hide(); */
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
		
		var datePickerObject = ["#searchResvDateFrom","#searchResvDateTo","#resvDateFrom","#resvDateTo"];
		$.each(datePickerObject, function (index, item) {
			$(item).datepicker(clareCalendar);
		});
	   
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		$("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
	});
	
	var jqGridFunc = {
		setGrid : function(gridOption) {
			var grid = $('#'+gridOption);
			
			//ajax 관련 내용 정리 하기 
			var postData = {"pageIndex": "1"};
			
			grid.jqGrid({
				url : '/backoffice/rsv/rsvListAjax.do',
				mtype : 'POST',
				datatype : 'json',
				pager: $('#pager'),  
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
					{label: 'resv_seq', key: true, name:'resv_seq', index:'resv_seq', align:'center', hidden:true},
					{label: 'NO', name:'rnum', index:'rnum', align:'center', width : "50px"},
					{label: '지점', name:'center_nm', index:'center_nm', align:'center'},
					{label: '좌석정보', name:'seat_nm', index:'seat_nm', align:'center'},
					{label: '예약번호', name:'resv_seq', index:'resv_seq', align:'center'},
					{label: '아이디', name:'user_id', index:'user_id', align:'center'},
					{label: '이름', name:'user_nm', index:'user_nm', align:'center'},
					{label: '전화번호', name:'user_phone', index:'user_phone', align:'center'},
					/* {label: '발권구분', name: 'resv_ticket_dvsn',  index:'resv_ticket_dvsn', align:'center'}, */
					{label: '금액', name: 'resv_pay_cost', index:'resv_pay_cost', align:'center'},
					{label: '신청일자', name:'resv_req_date', index:'resv_req_date', align:'center'},
					{label: '예약일자', name:'resv_end_dt', index:'resv_end_dt', align:'center'},
					{label: '예약상태', name:'resv_state', index:'resv_state', align:'center'},
					{label: '문진', name:'resv_user_ask_yn', index:'resv_user_ask_yn', align:'center', width : "50px"},
					{label: '결재상태', name:'resv_pay_dvsn', index:'resv_pay_dvsn', align:'center'},
					{label: 'QR출력', name:'resv_qr_print', index:'resv_qr_print', align:'center', sortable : false, formatter:jqGridFunc.buttonSetting},
					{label: '현금영수증출력', name:'cash_receipts_print', index:'cash_receipts_print', align:'center', sortable : false, formatter:jqGridFunc.buttonSetting},
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
							"searchKeyword" : $("#searchKeyword").val(),
							"searchCenterCd" : $("#searchCenterCd").val(),
							"searchDayCondition" : $('input[name=searchRsvDay]:checked').val(),
							"searchFrom" : $("#searchResvDateFrom").val(),
							"searchTo" : $("#searchResvDateTo").val(),
							"searchResvState" : $("#searchResvState").val(),
							"searchResvPayDvsn" : $("#searchResvPayDvsn").val(),
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
		buttonSetting : function (cellvalue, options, rowObject) {
			return '<a href="javascript:jqGridFunc.fn_resvInfo(&#39;list&#39;,&#39;'+rowObject.center_cd+'&#39;);" class="detailBtn">설정</a>';
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
					"searchResvState" : $("#searchResvState").val(),
					"searchResvPayDvsn" : $("#searchResvPayDvsn").val(),
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
						$("#rsvPopResvUserDvsn").html(obj.resv_user_dvsn_text);
						$("#rsvPopUserId").html(obj.user_id);
						$("#rsvPopResvUserNm").html(obj.user_nm);
						$("#rsvPopResvUserPhone").html(obj.user_phone);
						$("#rsvPopResvPayDvsn").html(obj.resv_pay_dvsn_text);
						obj.resv_user_ask_yn = obj.resv_user_ask_yn == "Y" ? "동의" : "미동의"; 
						$("#rsvPopResvUserAskYn").html(obj.resv_user_ask_yn);
						
						if(obj.seat_nm != "입석" && obj.resv_state == "RESV_STATE_1") { 
							$("#rsvPopSeatChange a").show().click(function (e) {
								jqGridFunc.fn_resvSeatInfo("CHANGE",obj);
							});		
						} else {
							$("#rsvPopSeatChange a").hide();
						}
						
						//입퇴장 이력
						attendService.fn_attendInfo(resvSeq);
					}
				},
				function(request){
					common_popup("Error:" + request.status,"");
				}    		
			);
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
				$("#seat_change a:eq(2)").html("변경").attr("href","javascript:jqGridFunc.fn_resvSeatUpdate('CHANGE')");;
				jqGridFunc.fn_resvSeatSearch("CHANGE");
			} else if(division = "LONG") {
				if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
					$("#resvCenterCd").val($("#loginCenterCd").val()).trigger("change").closest("p").hide();
				} else {
					$("#resvCenterCd").val("");
				}
				$("#resvFloorCd").children("option:not(:first)").remove();
				$("#resvPartCd").children("option:not(:first)").remove();
 				$("#resvSeq").val("");
				$("#resvDate").val("");
				$("#resvDateFrom").val("");
				$("#resvDateTo").val("");
				$("#seat_change p:eq(3)").show();
				$("#seat_change a:eq(1)").attr("href","javascript:jqGridFunc.fn_resvSeatSearch('LONG');");
				$("#seat_change a:eq(2)").html("좌석선택").attr("href","javascript:jqGridFunc.fn_setLongSeatInfo()");
				/* $("#seat_change a:eq(2)").html("좌석선택").attr("href","javascript:jqGridFunc.fn_resvSeatUpdate('LONG')"); */
				$("#seat_change .pop_tit").html("사용자 좌석 선택");
				$(".pop_mapArea").css("background","");
				$(".pop_seat").html("");
			}
			
			seatSearchInfo = {};
			$("#seat_change").bPopup();
		},
		fn_resvSeatSearch : function(division) {
			var url = "/front/rsvSeatListAjax.do";
			var params = {};
			if($("#resvPartCd").val() == "") {
				common_popup("구역을 선택하세요.", "N", "");
				return;
			}
			
			if(division == "CHANGE") {
				params = {
					"searchCondition" : division,
					"resvSeq" : $("#resvSeq").val(),
					"resvDate" : $("#resvDate").val(),
					"partCd" : $("#resvPartCd").val()
				};
			} else {
				if(!$("#resvDateFrom").val() || !$("#resvDateTo").val()){
					common_popup("예약일자를 입력하세요.", "N", "");
					return;
				} else if(!dateIntervalCheckTemp($("#resvDateFrom").val(), $("#resvDateTo").val())){
					common_popup("종료일자가 시작일자보다 빠를수 없습니다.", "N", "");
					return;
				}
				
				params = {
					"searchCondition" : division,
					"resvDateFrom" : $("#resvDateFrom").val(),
					"resvDateTo" : $("#resvDateTo").val(),
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

			    		        shtml += '<li id="' + fn_NVL(obj[i].seat_cd) + '" class="' + addClass + '" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_nm + '" >' + obj[i].seat_order + '</li>';
			    		    }

			    		    $(".pop_seat").html(shtml);
			    		    
			    		    for (var i in result.resultlist) {
			    		        $("#" + fn_NVL(obj[i].seat_cd)).css({
			    		            "top": fn_NVL(obj[i].seat_top) + "px",
			    		            "left": fn_NVL(obj[i].seat_left) + "px"
			    		        });
			    		        
			    		        $("#" + fn_NVL(obj[i].seat_cd)).data("seat-name", obj[i].seat_nm);
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
					alert("ERROR : " +request.status);	       						
				}    		
			);	
		},
		fn_resvSeatUpdate : function(division) {
			if($(".pop_seat li.usable").length <= 0) {
				common_popup("변경할 좌석을 선택하세요.", "N", "");
				return;	
			}
			
			var params = {
				"resvSeq" : $("#resvSeq").val(),
				"inResvDate" : $("#resvDate").val(),
				"centerCd" : $("#resvCenterCd").val(),
				"floorCd" : $("#resvFloorCd").val(),
				"partCd" : $("#resvPartCd").val(),
				"seatCd" : $(".pop_seat li.usable").attr("id"),
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
							common_popup("좌석이 정상적으로 변경되었습니다.", "Y", "");
							jqGridFunc.fn_resvInfo("Edt", $("#resvSeq").val());
							$("#seat_change").bPopup().close();
				    	} else if (result.status == "LOGIN FAIL") {
				    		common_popup("로그인 정보가 올바르지않습니다 다시 로그인해주세요", "Y", "");
				    	} else {
				    		common_popup("처리중 오류가 발생하였습니다.", "Y", "");
				    	}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	
			}		
		},
		fn_resvVaildCheck : function(params) {
			var url = "/front/resvValidCheck.do";
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
							common_popup(result.validResult.resultMessage, "N", "");
							return;
						} else {
							validResult = result.validResult;
						}
					} else if (result.status == "LOGIN FAIL"){
						common_popup("로그인 정보가 올바르지 않습니다.", "N", "");
					}
				},
				function(request) {
					common_popup("ERROR : " + request.status, "N", "");	       						
				}    		
			);
			
			return validResult;
		},
		fn_centerChange : function() {
	 		var url = "/backoffice/bld/floorComboInfo.do"
	 		var params = {"centerCd" : $("#resvCenterCd").val()}
	 		var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
	 		fn_comboListJson("resvFloorCd", returnVal, "jqGridFunc.fn_floorChange", "100px;", "");
		},
		fn_floorChange : function() {
			var url = "/backoffice/bld/partInfoComboList.do"
		    var params = {"floorCd" : $("#resvFloorCd").val()}
		 	var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
			fn_comboListJson("resvPartCd", returnVal, "", "100px;", "");
		},
		fn_longSeatAdd : function() {
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
			
			$("#long_seat_add").bPopup();
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
				$(".pop_seat li.usable").data("seat-name")
			);
					
			$("#longResvDateFrom").val($("#resvDateFrom").val());
			$("#longResvDateTo").val($("#resvDateTo").val());
			$("#seat_change").bPopup().close();
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
				"resvUserDvsn" : "USER_DVSN_1",
				"resvEntryDvsn" : "ENTRY_DVSN_2",
				"centerCd" : $("#longResvCenterCd").val(),
				"floorCd" : $("#longResvFloorCd").val(),
				"partCd" : $("#longResvPartCd").val(),
				"seatCd" : $("#longResvSeatCd").val(),
				"userId" : $("#longResvUserId").val(),
				"resvUserNm" : $("#longResvUserName").val(),
				"resvUserClphn" : $("#longResvUserPhone").val(),
				"resvUserAskYn" : "Y",
				"resvIndvdlinfoAgreYn" : "Y"
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
		fn_searchResult : function (searchDvsn){
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
				url ="/backoffice/cus/userListAjax.do";
				checkTag = "userSearchKeyword";
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

			if (any_empt_line_span("long_seat_add", checkTag, "검색어를 입력해 주세요.","sp_message", "savePage") == false) return;	

			$("#search_result").bPopup();
			
			gridEmp.jqGrid({
				url : url,
				mtype :  'POST',
				datatype :'json',
				ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
				ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
				ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
				postData : JSON.stringify( postData ),
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
			    	loadtext:'시스템 장애... '
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
				}
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
			
			$("#search_result").bPopup().close();
			$("#long_seat_add").bPopup();
		}
	}
	
	var isAttendGridInit = false;
	
	var attendService = {
		fn_attendInfo : function(resvSeq) {
			$("#resvSeq").val(resvSeq);
			$("#rsv_detail").bPopup();
			
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
						/* {label: '현금영수증출력', name:'cash_receipts_print', index:'cash_receipts_print', align:'center', sortable : false, formatter:jqGridFunc.buttonSetting}, */
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
					if (result.status == "SUCCESS") {
						common_modelCloseM("입출입 정보가 정상적으로 등록되었습니다.", "rsv_inout_add");
					} else {
						common_modelCloseM("에러가 발생하였습니다.", "rsv_inout_add");
					}
					
					attendService.fn_attendInfo($("#resvSeq").val());
				},
				function(request) {
					alert("ERROR : " + request.status);	       						
				}    		
			);	
		}
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />