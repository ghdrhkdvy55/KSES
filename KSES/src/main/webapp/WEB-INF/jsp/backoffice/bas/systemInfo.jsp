<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- timepicker -->
<script src="/resources/js/jquery.timepicker.js"></script>
<link rel="stylesheet" href="/resources/css/jquery.timepicker.css">
<!-- //contents -->
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">환경 설정</li>
	</ol>
</div>
<h2 class="title">환경 설정</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
   		<div class="whiteBox">
        	<table class="main_table">
				<tbody class="setTxt">
					<tr>
                        <th>사이트 명</th>
                        <td><input type="text" id="comTitle" name="comTitle" value="${regist.comTitle}"></td>
						<td colspan="2"></td>
                    </tr>
                	<tr>
                    	<th>전일 오픈 시간(회원)</th>
                    	<td><input 
                    			type="text" 
                    			id="userEveDayOptm" 
                    			name="userEveDayOptm"
                    			value="${fn:substring(regist.userEveDayOptm, 0,2)}:${fn:substring(regist.userEveDayOptm, 2,4)}"
                    			onkeypress="only_num();"
								class="timepicker"
								readonly
                    		>
                    	</td>
                    	<th>전일 오픈 시간(비회원)</th>
                    	<td><input 
                    			type="text" 
                    			id="nonUserEveDayOptm" 
                    			name="nonUserEveDayOptm"
                    			value="${fn:substring(regist.nonUserEveDayOptm, 0,2)}:${fn:substring(regist.nonUserEveDayOptm, 2,4)}"  
                    			onkeypress="only_num();"
								class="timepicker"
								readonly
                    		>
                    	</td>
                	</tr>
                    <tr>
                        <th>지점 자동취소 오전시간</th>
                        <td><input 
                        		type="text"
                        		id="centerAutoCancleAmtm"
                        		name="centerAutoCancleAmtm"
                        		value="${fn:substring(regist.centerAutoCancleAmtm, 0,2)}:${fn:substring(regist.centerAutoCancleAmtm, 2,4)}" 
                        		onkeypress="only_num();"
								class="timepicker"
								readonly
                        	>
                        </td>
                        <th>지점 자동취소 오후시간</th>
                        <td><input 
                        		type="text" 
                        		id="centerAutoCanclePmtm" 
                        		name="centerAutoCanclePmtm"
                        		value="${fn:substring(regist.centerAutoCanclePmtm, 0,2)}:${fn:substring(regist.centerAutoCanclePmtm, 2,4)}"  
                        		onkeypress="only_num();"
                        		class="timepicker"
                        		readonly
                        	>
                        </td>
                    </tr>
                    <tr>
                        <th>지점 자동취소 종일시간</th>
                        <td><input 
                        		type="text" 
                        		id="centerAutoCancleAlltm" 
                        		name="centerAutoCancleAlltm"
                        		value="${fn:substring(regist.centerAutoCancleAlltm, 0,2)}:${fn:substring(regist.centerAutoCancleAlltm, 2,4)}"  
                        		onkeypress="only_num();"
								class="timepicker"
								readonly
                        	>
                        </td>
						<th>블랙리스트 해제일</th>
                        <td><input type="number" id="blklstRlsdt" name="blklstRlsdt" value="${regist.blklstRlsdt}"></td>
                    </tr>
                    <tr>
						<th>비회원 예약 여부</th>
	                  	<td>
                    		<label for="guestResvPossibleYn_Y">
                    			<input 
                    				id="guestResvPossibleYn_Y" 
                    				type="radio" 
                    				name="guestResvPossibleYnYn" 
                    				value="Y" 
                    				<c:if test="${regist.guestResvPossibleYn == 'Y' }"> checked </c:if>
                    			>Y
                    		</label>
                    		<label for="guestResvPossibleYn_N">
                    			<input 
                    				id="guestResvPossibleYn_N" 
                    				type="radio" 
                    				name="guestResvPossibleYnYn" 
                    				value="N" <c:if test="${regist.guestResvPossibleYn == 'N' }"> checked </c:if>
                    			>N
                    		</label>
                    		<td colspan="2"></td>
                  		</td>
                    </tr>
            	</tbody>
        	</table>
    	</div>
    	<div class="center_box">
        	<a href="javascript:fn_Checkform();" class="blueBtn">저장</a> 
    	</div>
	</div>
</div>
<!-- contents//-->
<script type="text/javascript">
	$(document).ready(function () {
		timepicker();
    });

	function fn_Checkform(){
		
		if (any_empt_line_span_noPop("comTitle", "사이트명을 입력해주세요.","sp_message", "btn_Message") == false) return;
		if (any_empt_line_span_noPop("userEveDayOptm", "회원 전일 오픈 시간을 입력해주세요.","sp_message", "btn_Message") == false) return;
		if (any_empt_line_span_noPop("nonUserEveDayOptm", "비회원 전일 오픈 시간을 입력해주세요.","sp_message", "btn_Message") == false) return;
		if (any_empt_line_span_noPop("centerAutoCancleAmtm", "지점 자동취소 오전시간을 입력해주세요.","sp_message", "btn_Message") == false) return;
		if (any_empt_line_span_noPop("centerAutoCanclePmtm", "지점 자동취소 오후시간을 입력해주세요.","sp_message", "btn_Message") == false) return;
		if (any_empt_line_span_noPop("centerAutoCancleAlltm", "지점 자동취소 종일시간을 입력해주세요.","sp_message", "btn_Message") == false) return;
		if (any_empt_line_span_noPop("blklstRlsdt", "블랙리스트 해제일을 입력해주세요.","sp_message", "btn_Message") == false) return;
		
		var url = "/backoffice/bas/systemInfoUpdate.do";
    	var params = 
    	{   
			'comTitle' : $.trim($("#comTitle").val()),
			'userEveDayOptm' : $.trim($("#userEveDayOptm").val()).replace(":",""),
			'nonUserEveDayOptm' : $.trim($("#nonUserEveDayOptm").val()).replace(":",""),
			'centerAutoCancleAmtm' : $.trim($("#centerAutoCancleAmtm").val()).replace(":",""),
			'centerAutoCanclePmtm' : $.trim($("#centerAutoCanclePmtm").val()).replace(":",""),
			'centerAutoCancleAlltm' :  $.trim($("#centerAutoCancleAlltm").val()).replace(":",""),
			'guestResvPossibleYn' : $('input[name=guestResvPossibleYn]:checked').val(),
			'blklstRlsdt' :  $.trim($("#blklstRlsdt").val())
		}; 
    	
    	fn_Ajax
    	(
			url, 
			"POST",
			params,
			false,
			function(result) {
				if (result.status == "LOGIN FAIL") {
					common_popup(result.message, "N","");
					
					location.href="/backoffice/login.do";
				} else if (result.status == "SUCCESS") {
					common_popup(result.message, "Y","");
				}
			},
			function(request) {
				common_popup("ERROR : " +request.status, "N","");
			}    		
        );
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />