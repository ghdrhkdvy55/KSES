<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no;" />
    <title>경륜경정 스마트입장 관리자</title>
    
    <link rel="stylesheet" href="/resources/css/reset.css">
	<link rel="stylesheet" href="/resources/css/paragraph.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/toggle.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" />
    
    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <script src="/resources/js/bpopup.js"></script>
    <script src="/resources/js/jquery-ui.js"></script>
    
    <!-- jquery-ui.css -->
    <link rel="stylesheet" href="/resources/css/jquery-ui.css">
	<!-- <link rel="stylesheet" href="/css/jquery-ui.css"> -->
	
	<!-- timepicker -->
   	<script src="/resources/js/jquery.timepicker.js"></script>
   	<link rel="stylesheet" href="/resources/css/jquery.timepicker.css">
	
    
</head>
<body>
<div class="wrapper">
	<form:form name="regist" commandName="regist" method="post" action="/backoffice/bld/systeminfo.do">
	<c:import url="/backoffice/inc/top_inc.do" />
	
	<!-- header //-->
	<!--// contents-->
	<div id="contents">
    	<div class="breadcrumb">
      		<ol class="breadcrumb-item">
        		<li>기초 관리</li>
        		<li class="active">　> 환경설정</li>
      		</ol>
    	</div>

    	<h2 class="title">환경설정</h2><div class="clear"></div>
    	<!--// dashboard -->
    	<div class="dashboard">
        	<!--contents-->
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
                    	</tbody>
                	</table>
            	</div>

            	<div class="center_box">
                	<a href="javascript:fn_Checkform();" class="blueBtn">저장</a> 
            	</div>
        	</div>
    	</div>
    </div>
	<!-- contents//-->
    <c:import url="/backoffice/inc/popup_common.do" />
    <script type="text/javascript" src="/resources/js/back_common.js"></script>
	</form:form>
<!-- wrapper_end-->
</div>

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
					common_popup(result.meesage, "N","");
					
					location.href="/backoffice/login.do";
				} else if (result.status == "SUCCESS") {
					common_popup(result.meesage, "N","");
					location.reload();
				}
			},
			function(request) {
				common_popup("ERROR : " +request.status, "N","");
			}    		
        );
	}
</script> 
</body>
</html>