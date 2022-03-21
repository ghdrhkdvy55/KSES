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
    	<li>고객 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">고객 정보 관리</li>
	</ol>
</div>
<h2 class="title">고객 정보 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
      	<div class="whiteBox searchBox">
            <div class="sName">
              <h3>옵션 선택</h3>
            </div>
            <div class="top">
                <p>검색어</p>
                <select id="searchCondition" name="searchCondition">
                    <option value="ALL">전체</option>
					<option value="USER_ID">아이디</option>
					<option value="USER_NM">이름</option>
					<option value="USER_PHONE">전화번호</option>
                </select>
                <input type="text" name="searchKeyword" id="searchKeyword" placeholder="검색어를 입력하새요.">
            </div>
            <div class="inlineBtn ">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
          <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">	            	
        </div>
        <div class="clear"></div>
        <div class="whiteBox"></div>
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
<!-- //popup -->
<!-- 휴일 정보 팝업 -->
<div data-popup='rsv_user_add' class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">고객 정보 수정</h2>
    	<div class="pop_wrap">
    		<table class="detail_table">
           		<tbody>
               		<tr>
						<th>아이디</th>
	                    <td>
	                    	<span id="sp_userId"></span>
	                    </td>
	                    <th>이름</th>
			            <td>
		                    <span id="sp_userNm"></span>
						</td>
					</tr>
					<tr>
				        <th>전화번호</th>
			            <td>
		                    <span id="sp_userPhone"></span>
						</td>
						<th>메일</th>
			            <td>
		                    <span id="sp_userEmail"></span>
						</td>
					</tr>
					<tr>
						<th>성별</th>
			            <td>
		                    <span id="sp_userSexMf"></span>
						</td>
						<th>생년월일</th>
			            <td>
		                    <span id="sp_userBirthDy"></span>
						</td>
					</tr>
					<tr>
						<th>개인정보동의여부</th>
			            <td>
		                    <span id="sp_indvdlinfoAgreYn"></span>
						</td>
						<th>개인정보동의일자</th>
			            <td>
		                    <span id="sp_indvdlinfoAgreDt"></span>
						</td>
					</tr>
					<tr>
						<th>백신 차수</th>
						<td>
							<select name="vacntnRound" id="vacntnRound">
								<option value="">선택</option>
								<c:forEach items="${vacntnRound}" var="vacntnRound">
									<option value="${vacntnRound.code}"><c:out value='${vacntnRound.codenm}'/></option>
				               	</c:forEach>
							</select>
						</td>
						<th>백신 종류</th>
			            <td>
							<select id="vacntnDvsn" name="vacntnDvsn">
								<option value="">선택</option>
								<c:forEach items="${vacntnDvsn}" var="vacntnDvsn">
									<option value="${vacntnDvsn.code}"><c:out value='${vacntnDvsn.codenm}'/></option>
			               		</c:forEach>
							</select> 
						</td>
					</tr>
					<tr>     
						<th>접종 일자</th>
			            <td>
	                    	<input type="text" name="vacntnDt" id="vacntnDt" class="cal_icon" readonly>
						</td> 
					</tr>	
				</tbody>
			</table>
		</div>
	    <div class="right_box">
	    	<a href="javascript:fnUpdate();" id="btnUpdate" class="blueBtn">저장</a>
        	<a href="#" onClick="common_modelClose('rsv_user_add')" id="btnUpdate" class="grayBtn b-close">취소</a>
		</div>
		<div class="clear"></div>
	</div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {

		// 메인 목록 정의
		EgovJqGridApi.mainGrid([
			
			{ label:'아이디'		, name:'user_id'			, index:'user_id'			, align:'center', key:true},
			{ label:'이름'		, name:'user_nm'			, index:'user_nm'			, align:'center'},
			{ label:'전화번호'		, name:'user_phone'			, index:'user_phone'		, align:'center'},
			{ label:'백신 차수'	, name:'vacntn_round_text'	, index:'vacntn_round_text'	, align:'center'},
			{ label:'백신 종류'	, name:'vacntn_dvsn_text'	, index:'vacntn_dvsn_text'	, align:'center'},
			{ label:'접종 일자'	, name:'vacntn_dt'			, index:'vacntn_dt'			, align:'center'},
			{ label:'성별'		, name:'user_sex_mf'		, index:'user_sex_mf'		, align:'center'},
			{ label:'생년 월일'	, name:'user_birth_dy'		, index:'user_birth_dy'		, align:'center'},
			{ label: '수정'		, align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
				'<a href="javascript:fnUserInfo(\''+ row.user_id +'\');" class="edt_icon"></a>'
			}
		], false, false, fnSearch);

		
		var clareCalendar = {
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		weekHeader: 'Wk',
		dateFormat: 'yymmdd', //형식(20120303)
		autoSize: false, //오토리사이즈(body등 상위태그의 설정에 따른다)
		changeMonth: true, //월변경가능
		changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		buttonImageOnly: false, //이미지표시
		yearRange: '1970:2030' //1990년부터 2020년까지
        };	       
	    $("#vacntnDt").datepicker(clareCalendar);
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		$("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
		
 	});
   	
	// 메인 목록 검색
	function fnSearch(pageNo) {
	
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchCondition : $("#searchCondition").val(),
  			searchKeyword : $("#searchKeyword").val()
		};

		EgovJqGridApi.mainGridAjax('/backoffice/cus/userListInfoAjax.do', params, fnSearch);
		
	}

	// 고객 정보 상세 보기
	function fnUserInfo(userId) {

		let $popup = $('[data-popup=rsv_user_add]');

		$("#userId").val(userId);
		var params = {"userId" : userId};
		var url = "/backoffice/cus/selectUserListInfoDetail.do";

		EgovIndexApi.apiExecuteJson(
			"GET",
			url, 
			params, 
			null,
			function(result) {
				if (result.status == "LOGIN FAIL"){
					toastr.warning(result.message);
					location.href="/backoffice/login.do";
				} else if (result.status == "SUCCESS") {
					// 고객 정보 set
					var obj = result.regist;
					$("#sp_userId").html(obj.user_id);
					$("#sp_userNm").html(obj.user_nm);
					$("#sp_userPhone").html(obj.user_phone);
					$("#sp_userEmail").html(obj.user_email);								
					$("#sp_userSexMf").html(obj.user_sex_mf);								
					$("#sp_userBirthDy").html(obj.user_birth_dy);								
					$("#sp_indvdlinfoAgreYn").html(obj.indvdlinfo_agre_yn);
					if(obj.indvdlinfo_agre_dt != null){
						$("#sp_indvdlinfoAgreDt").html(obj.indvdlinfo_agre_dt);
					} else {
						$("#sp_indvdlinfoAgreDt").html('');
					}
					$("#vacntnRound").val(obj.vacntn_round);
					$("#vacntnDvsn").val(obj.vacntn_dvsn);
					$("#vacntnDt").val(obj.vacntn_dt);

					EgovJqGridApi.selection('mainGrid', userId);
					
					$popup.bPopup();

				}else {
					toastr.error(result.message);
				}
		
			},
			function(request){
				toastr.error("ERROR : " +request.status);
			}
		);
	}

	// 고객 정보 팝업 수정 버튼 클릭
	function fnUpdate() {
		
		let $popup = $('[data-popup=rsv_user_add]');

		bPopupConfirm('고객 정보', '수정 하시겠습니까?', function() {

			var params = 
			{
				'userId' : $("#sp_userId").html(),
				'vacntnRound' : $("#vacntnRound").val(),
				'vacntnDvsn' : $("#vacntnDvsn").val(),
				'vacntnDt' : $("#vacntnDt").val()
			};
			
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/cus/userListInfoUpdate.do',
				params,
				null,
				function(json) {
					if (json.status == "LOGIN FAIL"){
						toastr.warning(json.meesage);
	   					location.href="/backoffice/login.do";
	   				}else if (json.status == "SUCCESS"){
	   					//총 게시물 정리 하기'
	   					toastr.success(json.message);
	   					$popup.bPopup().close();
	   					fnSearch(1);

					}else if (json.status == "FAIL"){
						toastr.error("저장 도중 문제가 발생 하였습니다.");
						$popup.bPopup().close();
						fnSearch(1);
					}

				},
				function(json) {
					toastr.error(json.message);
				}
			);

		});
		
	}
	
</script>
<c:import url="/backoffice/inc/popup_common.do" />