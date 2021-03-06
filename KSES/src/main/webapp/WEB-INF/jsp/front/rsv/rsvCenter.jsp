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
    <link href="/resources/css/front/common.css" rel="stylesheet" />
    <link rel="stylesheet" href="/resources/css/front/mobile.css">
	<!--check box _ css-->
	<link href="/resources/css/front/magic-check.min.css" rel="stylesheet" />
    <title>경륜경정 스마트 입장예약</title>
    <!-- DatePicker-->
    <script src="/resources/js/front/jquery-ui.js"></script>
    <link rel="stylesheet" href="/resources/css/front/jquery-ui.css">
    <!-- Link Swiper's CSS -->
    <link rel="stylesheet" href="/resources/css/front/swiper.min.css">
    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
</head>

<body>
<form:form name="regist" commandName="regist" method="get" action="/front/rsvCenter.do">	
	<input type="hidden" id="centerCd" name="centerCd" value="">
    
    <div class="wrapper rsvBack">
        <!--// header -->
        <div id="rsv_header">
            <ul class="rsv_info">
                <li class="backImg"></li>
                <li class="rsv_branch hidden"></li>
                <li class="rsv_state">지점 선택중입니다.</li>
                <li></li>
            </ul>             
        </div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <div>
                <div class="contents"> 
                    <!--지점선택-->                 
                    <h3>지점을 선택하세요.</h3>                    
                    <div class="branchSel">
                        <ul class="branch_list">

                        </ul>
                    </div>           	
                </div>
            </div>
            <!-- 예약가능 지점 없을때 표출 -->
            <div class="null_center"><p>현재 예약가능한 지점이 없습니다.</p></div>
            <!-- 예약가능 지 없을때 표출--//>
        </div>
        <!--contents //-->


        <div id="foot_btn">
            <div class="contents">
                <ul>
                    <li class="home"><a href="javascript:fn_pageMove('regist','/front/main.do');">home</a><span>HOME</span></li>
                    <li class="rsv active"><a href="javascript:fn_moveReservation();">rsv</a><span>입장예약</span></li>
                    <li class="my"><a href="/front/mypage.do">my</a><span>마이페이지</span></li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
    </div>  
</div>
    <!--메뉴버튼 속성-->
    <script>
		$(document).ready(function() {			
    		centerService.fn_makeCenterInfoArea();
    	});
    	
    	var centerService =
		{ 
			fn_makeCenterInfoArea: function() {
				var url = "/front/rsvCenterListAjax.do";
				
				fn_Ajax
				(
				    url,
				    "POST",
				    null,
					false,
					function(result) {
						if (result.status == "SUCCESS") {
							if(result.resultlist.length > 0) {
								$(".branch_list").empty();
								$.each(result.resultlist, function(index, item) {
									var setHtml = "";
									
									setHtml += "<li><ul id='" + item.center_cd + "'><li><span>" 
									+ item.center_nm 
									+ "</span></li><li>";
									
									if(item.center_pilot_yn == "Y") {
										setHtml += "지정석 <em>" 
										+ (item.center_seat_max_count - item.center_seat_use_count) + " / " + item.center_seat_max_count
										+ "</em>석"
										+ "<br>";
									}
									
									if(item.center_stand_yn == "Y") {
										setHtml += "자유석 <em>"
										+ (item.center_stand_max - item.center_standing_use_count) + " / " + item.center_stand_max
										+ "</em>석";
									}

									setHtml += "</li></ul></li>";
									$(".branch_list").append(setHtml);
								});
								
								var sBtn = $(".branch_list > li"); //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
								sBtn.find("ul").click(function() { // sBtn에 속해 있는  a 찾아 클릭 하면.
									sBtn.removeClass("active"); // sBtn 속에 (active) 클래스를 삭제 한다.
									$(this).parent().addClass("active"); // 클릭한 a에 (active)클래스를 넣는다.
									$("#centerCd").val($(this).attr("id"));
									
									var params = {
										"centerCd" : $("#centerCd").val(),
										"checkDvsn" : "CENTER"
									}
									centerService.fn_resvVaildCheck(params);
								});
							} else {
								$(".null_center").show();
							}
						} else if(result.status == "LOGINFAIL"){
							fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
						}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}  		
				);	    						
			},
			fn_resvVaildCheck : function(params) {
				var url = "/front/resvValidCheck.do";
				var validResult = false;
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if (result.status == "SUCCESS") {
							if(result.validResult != null) {
								if(result.validResult.resultCode != "SUCCESS") {
									fn_openPopup(result.validResult.resultMessage, "red", "ERROR", "확인", "");
								} else {
									validResult = result.validResult;
									sessionStorage.setItem("accessCheck","1");
									fn_pageMove('regist','/front/rsvSeat.do');
								}
							} else {
								fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "/front/main.do");	
							}
						} else if (result.status == "LOGIN FAIL") {
							fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
						}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "/front/main.do");	       						
					}    		
				);
			}
		}
    </script>
    
	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
	</form:form>
</body>
</html>