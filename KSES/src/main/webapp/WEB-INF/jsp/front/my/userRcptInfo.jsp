<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
    <link href="/resources/css/front/reset.css" rel="stylesheet" />
    <script src="/resources/js/front/jquery-3.5.1.min.js"></script>
    <link href="/resources/css/front/mobile.css" rel="stylesheet" />
    <link href="/resources/css/front/common.css" rel="stylesheet" />

    <!--check box _ css-->
    <link href="/resources/css/front/magic-check.min.css" rel="stylesheet" />
    
    <title>경륜경정 스마트 입장예약</title>

	<!-- qrcode -->
	<script src="/resources/js/front/qrcode.js"></script>

    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
</head>

<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/mypage.do">
	<input type="hidden" name="userDvsn" id="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	<input type="hidden" id="userNm" name="userNm" value="${sessionScope.userLoginInfo.userNm}">
	
    <div class="wrapper">
        <!--// header -->
        <div class="my_wrap">
            <div class="contents my_box rsv_history">
                <div class="navi_left">
                    <a href="javascript:history.back();" class="before_close"></a>
                </div>
                <h1>현금 영수증 관리<a href="javascript:history.back();" class="close"><img src="/resources/img/front/x_box.svg" alt="닫기"></a></h1>
            </div>           
        </div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <!-- // 현금영수증  -->
            <div class="contents cotents_wrap">
                <div class="receipt_cash">
                    <div>
                        <h4>현금영수증 사용 여부</h4>
                        <ul>
                            <li class="check_impnt check_use">
                                <input class="magic-checkbox qna_check" type="checkbox" name="userRcptYn" id="userRcptYn" value="Y">
                                <label for="userRcptYn">
                                	사용
                                </label>     
                            </li>
                        </ul>
                    </div>

                    <div>                                                
                        <h4>발급 정보</h4>
                        <ul class="cash_refund">
                            <li>
                                <input type="radio" checked name="userRcptDvsn" id="RCPT_DVSN_1" value="RCPT_DVSN_1">
                                <label for="RCPT_DVSN_1"><span></span>소득 공제용</label>
                            </li>
                            <li>
                                <input type="radio" name="userRcptDvsn" id="RCPT_DVSN_2" value="RCPT_DVSN_2">
                                <label for="RCPT_DVSN_2"><span></span>지출 증빙용</label>
                            </li>
                            <li><input type="text" id="userRcptNumber" onkeypress="onlyNum(this);" placeholder="'-'없이 입력해 주세요."></li>
                        </ul>                      
                    </div>

                    <div class="save_btn">
                        <a href="javascript:rcptService.fn_updateRcptInfo();">저장하기</a>
                    </div>
                </div>
                
            </div>
        </div>

        <div id="foot_btn">
            <div class="contents">
                <ul>
                    <li class="home"><a href="javascript:fn_pageMove('regist','/front/main.do');">home</a><span>HOME</span></li>
                    <li class="rsv"><a href="/front/rsvCenter.do">rsv</a><span>입장예약</span></li>
                    <li class="my active"><a href="javascript:fn_pageMove('regist','/front/mypage.do');">my</a><span>마이페이지</span></li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
        <!--contents //-->
    </div>  
	</form:form>
	
	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
		$(document).ready(function() {
			rcptService.fn_userRcptInfo();
		});
		
		var rcptService = {
			fn_userRcptInfo : function() {
				var url = "/front/userRcptInfoAjax.do"; 
				
				fn_Ajax
				(
				    url,
				    "POST",
					"",
					false,
					function(result) {
						if(result.status == "SUCCESS") {
							if(result.userRcptInfo != null) {
								var userRcptInfo = result.userRcptInfo;
								
								if(userRcptInfo.user_rcpt_yn == "Y") {
									$("input:checkbox[id='userRcptYn']").prop("checked", true);
								}
								
								if(userRcptInfo.user_rcpt_dvsn != "" && userRcptInfo.user_rcpt_dvsn != null) {
									$("input:radio[name='userRcptDvsn']:radio[value='" + userRcptInfo.user_rcpt_dvsn + "']").prop('checked', true);
								}
								
								$("#userRcptNumber").val(userRcptInfo.user_rcpt_number);
							} else {
								alert("예약된 정보가 존재하지 않습니다.");
							}
						} else if(result.status == "LOGIN FAIL") {
							
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);
			},
			fn_updateRcptInfo : function() {
				var url = "/front/updateUserRcptInfo.do";
				var userRcptYn = $("input:checkbox[id='userRcptYn']").is(":checked") ? "Y" : "N";
				
				var params = {
					"userRcptYn" : userRcptYn,
					"userRcptDvsn" : $('input[name="userRcptDvsn"]:checked').val(),
					"userRcptNumber" : $("#userRcptNumber").val()
				}
				
				console.log(params);
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if(result.status == "SUCCESS") {
							fn_openPopup("현금영수증 정보가 정상적으로 적용되었습니다.", "blue", "SUCCESS", "확인", "");
						} else if(result.status == "LOGIN FAIL") {
							
						} else {
							
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);
			}
		}
    </script>
</body>  
</html>