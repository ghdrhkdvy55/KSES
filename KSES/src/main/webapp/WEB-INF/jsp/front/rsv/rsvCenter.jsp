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
<form:form name="regist" commandName="regist" method="get" action="/front/rsvSeat.do">	
	<input type="hidden" id="userDvsn" name="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	
	<input type="hidden" id="centerCd" name="centerCd" value="">
	<input type="hidden" id="resvDate" name="resvDate" value="">
    
    <div class="wrapper rsvBack">
        <!--// header -->
        <div id="rsv_header">
            <ul class="rsv_info">
                <li class="backImg"></li>
                <li class="rsv_branch hidden"></li>
                <li class="rsv_state"><span class="date"></span> 좌석 예약 중 입니다.</li>
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

                <div class="selBtn branch_btn">
                    <a href="javascript:centerService.fn_checkForm();">지점 선택</a>
                </div>
            </div>

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

    <!--메뉴버튼 속성-->
    <script>
		$(document).ready(function() {			
			if(sessionStorage.getItem("resvDate") == null) {
				alert("예약일자 정보가 존재하지 않습니다.\n처음부터 예약을 진행해주세요");
				location.href = "/front/main.do";
			}
			
			var date = new Date();
			var today = date.format("yyyy-MM-dd");
			$(".date").html(today);
			
			$("#resvDate").val(sessionStorage.getItem("resvDate"));
			resvUsingTimeCheck(sessionStorage.getItem("resvUsingTime"));
    		centerService.fn_makeCenterInfoArea(sessionStorage.getItem("resvDate"));
    	});
    	
    	var centerService =
		{ 
			fn_makeCenterInfoArea: function(resvDate) {
				var url = "/front/rsvCenterListAjax.do";
				
				var parmas = {"resvDate" : resvDate};
				
				fn_Ajax
				(
				    url,
				    "GET",
				    parmas,
					false,
					function(result) {
						if (result.status == "SUCCESS") {
							if(result.resultlist != null) {
								$(".branch_list").empty();
								$.each(result.resultlist, function(index, item) {
									var setHtml = "";
									setHtml += "<li><ul id='" + item.center_cd + "'><li><span>" 
									+ item.center_nm + "</span></li><li></li><li>잔여석 <em>" 
									+ (item.center_seat_max_count - item.center_seat_use_count) 
									+ "</em>석</li></ul></li>";
									$(".branch_list").append(setHtml);
								});
								centerService.fn_centerButtonSetting();
							}
						} else {
							
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	    						
			},
			fn_checkForm : function() {
				if($("#centerCd").val() == "") {
					alert("지점을 선택해주세요");
					return;
				}
				
				var centerCd = $("#centerCd").val();
				
				// 현재 시간 기준 해당 지점이 예약가능한 지점인가에 대한 Ajax 통신 처리 필요
				// 잔여석에 따른 버튼 disabled처리 유무 확인
				
				///////////////////////////////////////////////////////
				
				sessionStorage.setItem("centerCd", centerCd);
				fn_pageMove('regist','/front/rsvSeat.do');
			},
			fn_centerButtonSetting : function() {
				var sBtn = $(".branch_list > li"); //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
				sBtn.find("ul").click(function() { // sBtn에 속해 있는  a 찾아 클릭 하면.
					sBtn.removeClass("active"); // sBtn 속에 (active) 클래스를 삭제 한다.
					$(this).parent().addClass("active"); // 클릭한 a에 (active)클래스를 넣는다.
					$("#centerCd").val($(this).attr("id"));
				})
			},
			fn_centerResvVaildCheck : function(centerCd) {
				
			}
		}
    </script>
    
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
	</form:form>
</body>
</html>