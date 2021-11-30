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
    <!-- Zoom CSS -->
    <script src="/resources/js/front/pinch-zoom.umd.js"></script>
    
    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
    
	<link href="/resources/css/front/widescreen_temp.css" rel="stylesheet" media="only screen and (min-width : 1080px)">
	<link href="/resources/css/front/mobile_temp.css" rel="stylesheet" media="only screen and (max-width:1079px)">
</head>

<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/rsvSeat.do">
	<input type="hidden" name="resvDate" id="resvDate" value="${resvInfo.resvDate}">	
	<input type="hidden" name="resvUserDvsn" id="resvUserDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="resvUserNm" id="resvUserNm" value="">
	
	<input type="hidden" name="centerCd" id="centerCd" value="${resvInfo.center_cd}">
	<input type="hidden" name="partCd" id="partCd" value="">
	<input type="hidden" name="floorCd" id="floorCd" value="">
	<input type="hidden" name="seatCd" id="seatCd" value="">
	<input type="hidden" name="enterDvsn" id="enterDvsn" value="">

	
	
    <div class="wrapper rsvBack">
        <!--// header -->
        <div id="rsv_header">
            <ul class="rsv_info rsv_prsc">
                <li class="backImg"></li>
                <li class="rsv_branch">
                	<span class="sel_center_nm">${resvInfo.center_nm}</span>
                	<span class="sel_floor_nm"></span> 
                	<span class="sel_part_nm"></span>
                	<span class="sel_seat_nm"></span>
				</li>	
                <li class="rsv_state"><span class="date"></span> 좌석 예약 중 입니다.</li>
                <li></li>
            </ul>             
        </div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <div>
                <div class="contents">                  
                    <h3>
						선택한 지점 
                        <span class="change_br">
                            <a href="javascript:fn_moveReservation();"><img src="/resources/img/front/refresh.svg" alt="change">지점변경</a>
                        </span>
                    </h3>
                    <div class="branch">
                        <p>${resvInfo.center_nm}</p>
                    </div>
                    <div class="null"></div>

                    <!--입장유형 선택-->
                    <h4>입장 유형을 선택하세요.</h4>
                    <div class="enter_type">
                        <ul>
							<li onclick="seatService.fn_enterTypeChange('ENTRY_DVSN_1');">
								<ul>
									<li>입석</li>
								</ul>
							</li>
							<li onclick="seatService.fn_enterTypeChange('ENTRY_DVSN_2');">
								<ul>
									<li>좌석</li>
								</ul>
							</li>
                        </ul>
                    </div>

                    <div id="showHide" align="middle">
                        <section>
                        <!--예약 정보 입력-->
                            <h4>예약 정보 입력</h4>
                            <ul id="standing_resv_area">
                                <li><input type="text" id="ENTRY_DVSN_1_resvUserNm" placeholder="이름을 입력해주세요."></li>
                                <li><input type="text" id="ENTRY_DVSN_1_resvUserClphn" placeholder="전화번호를 '-'없이 입력해주세요."></li>
                                <li class="certify" onclick="javascript:seatService.fn_certification();"><a href=""><img src="/resources/img/front/certify.svg" alt="">인증 하기</a></li>
                                <!--전자문진표-->
                                <li class="covid19_qna">
                                    <p>
                                        <span>&lt;전자문진표 작성&gt;</span>
                                        <ol>
                                            <li>확진자/자가격리자 접촉</li>
                                            <li>해외 및 코로나19 감염 위험지역 방문</li>
                                            <li>발열(37.5도 이상), 근육통, 기침, 인후통 등 호흡기 증상</li>
                                            <li>지자체(기관)로부터 코로나19 검사 요청(능동감시자)</li>
                                            <li class="check_impnt">
                                                <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_1_qna_check" value="Y">
                                                <label for="ENTRY_DVSN_1_qna_check">
                                               	 최근14일 이내 위 사항에 해당사항이 없으며, 허위기재로 문제발생시 본인에게 책임이 있음을 확인합니다.
                                                </label>     
                                            </li>
                                        </ol>
                                    </p>
                                </li>
                            </ul>

                            <!--현금 영수증 발급-->
                            <h4>현금 영수증 발급</h4>
                            <ul id="ENTRY_DVSN_1_cash_area" class="cash_refund">
                                <li>
                                    <input class="cash_radio" type="radio" checked name="ENTRY_DVSN_1_rcpt_dvsn" id="ENTRY_DVSN_1_rcpt_dvsn1" value="RCPT_DVSN1">
                                    <label for="ENTRY_DVSN_1_rcpt_dvsn1"><span></span>소득 공제용</label>
                                </li>
                                <li>
                                    <input class="cash_radio" type="radio" name="ENTRY_DVSN_1_rcpt_dvsn" id="ENTRY_DVSN_1_rcpt_dvsn2" value="RCPT_DVSN2">
                                    <label for="ENTRY_DVSN_1_rcpt_dvsn2"><span></span>지출 증빙용</label>
                                </li>
                                <li><input type="text" id="ENTRY_DVSN_1_cash_number" placeholder="'-'없이 입력해 주세요."></li>
                            </ul>
                            <ul class="rsv_btn">
                                <li><a href="javascript:seatService.fn_checkForm();">예약하기</a></li>
                                <li><a data-popup-open="rsv_cancle">취소</a></li>
                            </ul>
                        </section>
                    </div>
                    
                    <!--show2 좌석 예약-->
                    <div id="showHide_seat" align="middle">
                        <!--층선택-->
                        <section>
                            <h4>층을 선택하세요.</h4>
                            <div id="floor_sel" class="floor_sel">
                                <select id="selectFloorCd" class="select_box" onchange="seatService.fn_floorChange();">
                                    <option value="">층 선택</option>
									<c:forEach items="${floorList}" var="floorList">
										<option value="${floorList.floor_cd}">${floorList.floor_nm}</option>
									</c:forEach>
                                </select>
                            </div>

                            <!--구역선택-->
                            <div id="section_sel" > 
                                <h4>구역을 선택하세요.</h4>
                                <h5>좌석 이용료 <span>(입장료 별도)</span></h5>
                                <!--요금안내-->
                                <div id="price" class="price">
                                    <table>
                                        <tbody>
                                        	<tr>
                                            	<td><img src="/resources/img/front/basic.svg" alt="일반석">일반석 <span>무료</span></td>
                                            	<td><img src="/resources/img/front/standard.svg" alt="스탠다드">스탠다드<span>5,000원</span></td>
                                            </tr>
                                            <tr>
                                            	<td><img src="/resources/img/front/premir.svg" alt="프리미엄">프리미엄<span>10,000원</span></td>
                                            	<td><img src="/resources/img/front/noble.svg" alt="노블레스">노블레스<span>15,000원</span></td>
											</tr>
                                        </tbody>                                          
                                    </table>
                                </div>
                                <!--구역선택 맵-->
                                <div id="part_map" class="section_map">
<!--                                     <ul>
                                        <li><span class="stand">A</span></li>
                                        <li><span class="premir">B</span></li>
                                        <li><span class="noble">C</span></li>
                                    </ul> -->
                                    <p><img src="/resources/img/front/gangnam_6f.svg" class="map"></p>                                    
                                </div>

                                <!--구역선택 메뉴-->
                                <div id="part_area" class="section_menu">                                                                         
                                    <ul id="menu_ul" class="tabs">
                                        <li class="tab-link" data-tab="tab-a">
                                            <ul>
                                                <li><span>A</span>구역</li>
                                                <li><span class="rest">65</span>석 신청 / <span class="total">150</span>석</li>
                                            </ul>
                                        </li>
                                        <li class="tab-link" data-tab="tab-a">
                                            <ul>
                                                <li><span>B</span>구역</li>
                                                <li><span class="rest">65</span>석 신청 / <span class="total">150</span>석</li>
                                            </ul>
                                        </li>
                                        <li class="tab-link" data-tab="tab-a">
                                            <ul>
                                                <li><span>C</span>구역</li>
                                                <li><span class="rest">65</span>석 신청 / <span class="total">150</span>석</li>
                                            </ul>
                                        </li>
                                        <li class="tab-link" data-tab="tab-a">
                                            <ul>
                                                <li><span>D</span>구역</li>
                                                <li><span class="rest">65</span>석 신청 / <span class="total">150</span>석</li>
                                            </ul>
                                        </li> 
                                    </ul>                                                 
                                </div>
                                <!--좌석선택-->
                                <div id="tab-a" class="tab-content">
                                    <div id="seat_tit" class="seat_tit">
                                       <h4>좌석선택</h4>
                                       <ul>
                                           <li><span class="disable"></span>신청불가</li>
                                           <li><span class="possible"></span>신청가능</li>
                                           <li><span class="select_Seat"></span>선택좌석</li>
                                       </ul> 
                                    </div>
                                    <div id="seat_select" class="seat_select">
                                        <div>
                                   			
                                        </div>
                                        
                                        <!--GUI영역-->
<!-- 										<div class="gui_seat mapbottom">
											<div class="mapArea pinch-zoom-parent">
												<div class="mapBox">
													<div class="part_map pinch-zoom"  style="background-repeat: no-repeat; background-position: center center">
                                    					<div class="seat">
                                        					<ul id="area_Map">
                                        					</ul>
                                    					</div>
                                					</div>
                        						</div>
                    						</div>
                						</div> -->
									</div>

                                    <!--예약 정보 입력-->
                                    <h4>예약 정보 입력</h4>
                                    <ul id="ENTRY_DVSN_2_resv_area">
                                        <li><input type="text" id="ENTRY_DVSN_2_resvUserNm" placeholder="이름을 입력해주세요."></li>
                                        <li><input type="text" id="ENTRY_DVSN_2_resvUserClphn" placeholder="전화번호를 '-'없이 입력해주세요."></li>
                                        <li class="certify" onclick="javascript:seatService.fn_certification();"><a href=""><img src="/resources/img/front/certify.svg" alt="">인증 하기</a></li>
                                        <!--전자문진표-->
                                        <li class="covid19_qna">
                                            <p>
                                                <span>&lt;전자문진표 작성&gt;</span>
                                                <ol>
                                                    <li>확진자/자가격리자 접촉</li>
                                                    <li>해외 및 코로나19 감염 위험지역 방문</li>
                                                    <li>발열(37.5도 이상), 근육통, 기침, 인후통 등 호흡기 증상</li>
                                                    <li>지자체(기관)로부터 코로나19 검사 요청(능동감시자)</li>
                                                    <li class="check_impnt">
                                                        <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_2_qna_check" value="Y">
                                                        <label for="ENTRY_DVSN_2_qna_check">
                                                        	최근14일 이내 위 사항에 해당사항이 없으며, 허위기재로 문제발생시 본인에게 책임이 있음을 확인합니다.
                                                        </label>     
                                                    </li>
                                                </ol>
                                            </p>
                                        </li>
                                    </ul>

                                    <!--현금 영수증 발급-->
                                    <h4>현금 영수증 발급</h4>
                                    <ul id="ENTRY_DVSN_2_cash_area" class="cash_refund">
                                        <li>
                                            <input class="cash_radio" type="radio" checked name="ENTRY_DVSN_2_rcpt_dvsn" id="ENTRY_DVSN_2_rcpt_dvsn1" value="RCPT_DVSN1">
                                            <label for="ENTRY_DVSN_2_rcpt_dvsn1"><span></span>소득 공제용</label>
                                        </li>
                                        <li>
                                            <input class="cash_radio" type="radio" name="ENTRY_DVSN_2_rcpt_dvsn" id="ENTRY_DVSN_2_rcpt_dvsn2" value="RCPT_DVSN2">
                                            <label for="ENTRY_DVSN_2_rcpt_dvsn2"><span></span>지출 증빙용</label>
                                        </li>
                                        <li><input type="text" id="ENTRY_DVSN_2_cash_number" placeholder="'-'없이 입력해 주세요."></li>
                                    </ul>
                                    <ul class="rsv_btn">
                                        <li><a href="javascript:seatService.fn_checkForm();">예약하기</a></li>
                                        <li><a data-popup-open="rsv_cancle">취소</a></li>
                                    </ul>                                 
                                </div>
                            </div>
                        </section>
                    </div>

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

    <!-- // 예약완료 팝업 -->
    <div id="rsv_done" class="popup">
      <div class="pop_con rsv_popup">
          <a class="button b-close">X</a>
          <div class="pop_wrap">
              <h4><img src="/resources/img/front/done.svg" alt="예약완료">예약이 완료 되었습니다.</h4>
               <ul class="rsv_list">
                   <li>
                        <ol>
                            <li>예약번호</li>
                            <li><span id="rsv_num" class="rsv_num"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>지점</li>
                            <li><span id="rsv_brch" class="rsv_brch"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="rsv_seat" class="rsv_seat"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>일시</li>
                            <li><span id="rsv_date" class="rsv_date"></span></li>
                        </ol>
                    </li> 
               </ul>
          </div>
          <div class="summit_btn">
              <a href="/front/main.do" class="mintBtn">예약내역 확인</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 예약완료 팝업 // -->

    <!-- // 예약취소 팝업 -->
    <div data-popup="rsv_cancle" class="popup">
      <div class="pop_con rsv_popup">
          <a class="button b-close">X</a>
          <div class="pop_wrap">
              <h4><img src="/resources/img/front/cancle.svg" alt="예약취소">예약이 취소 되었습니다.</h4>
          </div>
          <div class="cancle_btn">
              <a href="/front/main.do" class="grayBtn">처음으로</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 예약취소 팝업 // -->

    <!--층 선택 시 show/hide-->
    <script>
    	var pinchzoom = "";
    	var pinchInit = true;
    	var certification = false;
    	var center ="";
    	
		$(document).ready(function() {
			if($("#centerCd").val() == null){
				alert("지점정보가 존재하지 않습니다.\n처음부터 예약을 진행해주세요");
				location.href = "/front/main.do";
			}
						
			var date = new Date();
			var today = date.format("yyyy-MM-dd");
			$(".date").html(today);
			resvUsingTimeCheck(sessionStorage.getItem("resvUsingTime"));

        	$('.section_menu ul.tabs li').click(function(){
	            var tab_id = $(this).attr('data-tab');
	
	            $('.section ul.tabs li').removeClass('current');
	            $('.tab-content').removeClass('current');
	
	            $(this).addClass('current');
	            $("#"+tab_id).addClass('current');
        	});
		});
		
		var seatService =
		{ 
			fn_makeResvArea: function(centerCd) {
				var url = "/front/rsvSeatAjax.do";
				
				var parmas = {"resvDate" : sessionStorage.getItem("resvDate")};
				
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
			fn_enterTypeChange : function(enterDvsn) {
				
				if($("#enterDvsn").val() != enterDvsn) {
					if(enterDvsn == "ENTRY_DVSN_1") {
						$(".sel_floor_nm").html("");
						$(".sel_part_nm").html("");
						$(".sel_seat_nm").html("");
						
						$("#showHide").show();
						$("#showHide_seat").hide();				
					} else {
						$("#showHide").hide();
						$("#showHide_seat").show();
						$("#section_sel").hide();
						$("#selectFloorCd").val("");
					}
					
					$("#enterDvsn").val(enterDvsn);
					$("#" + enterDvsn + "_resvUserNm").val("");
					$("#" + enterDvsn + "_resvUserClphn").val("");
					$("#" + enterDvsn + "_cash_number").val("");
					$("input:radio[name='" + enterDvsn + "_rcpt_dvsn']").eq(0).prop("checked", true);
					$("input:checkbox[id='" + enterDvsn + "_qna_check']").prop("checked", false);
				}
			},
			fn_floorChange : function() {
				if($("#selectFloorCd").val() != "" ) {
					seatService.fn_initializing("FLOOR");
				} else {					
					return;
				}
				$("#floorCd").val($("#selectFloorCd").val());
				$(".sel_floor_nm").html($("#selectFloorCd option:checked").text());
				$("#section_sel").show();
				//seatService.fn_initializing("FLOOR");
				
				var url = "/front/rsvPartListAjax.do";
				var params = 
				{
					"floorCd" : $("#floorCd").val(),
					"resvDate" : sessionStorage.getItem("resvDate")
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
				            if (result.seatMapInfo != null) {
			 	                var img = result.seatMapInfo.floor_map1;
								img = (img == undefined) ? "#fff url(/resources/img/no_image.png)" : "/upload/" + img;
			 	                
			 	                $('.section_map img').attr("src", img);
			 	            }
							
							if (result.resultlist.length > 0){
								$("#menu_ul").empty();
								$.each(result.resultlist, function(index, item) {
									var setHtml = "";
									
									setHtml += "<li class='tab-link' data-tab='tab-a'>";
									setHtml += "<ul id='" + item.part_cd + "' name='" + item.part_nm + "'onClick='seatService.fn_partChange(&#39;" + item.part_cd + "&#39;);'><li><span>" + item.part_nm + "</span>구역</li>";
									setHtml += "<li><span class='rest'>" + item.part_seat_use_count + "</span>석 신청 / <span class='total'>" + item.part_seat_max_count + "</span>석</li></ul>"
									setHtml += "</li>";
									$("#menu_ul").append(setHtml);
								});
								
								var sBtn = $(".section_menu ul > li"); //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
								sBtn.find("ul").click(function() { // sBtn에 속해 있는  a 찾아 클릭 하면.
									sBtn.removeClass("active"); // sBtn 속에 (active) 클래스를 삭제 한다.
									$(this).parent().addClass("active"); // 클릭한 a에 (active)클래스를 넣는다.
									$("#partCd").val($(this).attr("id"));
									
									$(".sel_part_nm").html($(this).attr("name") + "구역");
								})
							} else {
								alert("해당층은 현재 선택 가능한 구역이 존재하지 않습니다.")
							}
				    	}
					},
					function(request) {
						alert("ERROR : " +request.status);	       						
					}    		
				);	
			},
			fn_partChange : function(partCd) {
				/* $("#tab-a").show(); */
				if(partCd != $("#partCd").val()) {
					seatService.fn_initializing("PART");
				} else {
					return;
				}
				
				var url = "/front/rsvSeatListAjax.do";
				var params = 
				{
					"partCd" : partCd,
					"resvDate" : sessionStorage.getItem("resvDate")
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
				    		// 좌석 GUI HTML세팅(PinchZoom)
				    		seatService.fn_initPinch();
				    		
				    		if (result.seatMapInfo != null) {
				    		    var img = result.seatMapInfo.part_map1;
				    		    $('.part_map').css({
				    		        "background": "#fff url(/upload/" + img + ")",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		} else {
				    		    $('.part_map').css({
				    		        "background": "#fff url()",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		}
								
							if (result.resultlist.length > 0) {
				    		    var shtml = "";
				    		    var obj = result.resultlist;
				    		    for (var i in result.resultlist) {
				    		        var addClass = (obj[i].status == "0") ? "seatUse" : "none";
				    		        var onClick = "seatService.fn_seatChange(this);"; 
				    		        shtml += '<li id="' + fn_NVL(obj[i].seat_cd) + '" class="' + addClass + '" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_nm + '" >' + obj[i].seat_order + '</li>';
				    		    }
				    		    $('#area_Map').html(shtml);
				    		    
				    		    for (var i in result.resultlist) {
				    		        $("#" + fn_NVL(obj[i].seat_cd)).css({
				    		            "top": fn_NVL(obj[i].seat_top) + "px",
				    		            "left": fn_NVL(obj[i].seat_left) + "px"
				    		        });
				    		    }
				    		    
				    		    var seatList = $("#area_Map li");
				    		    $(seatList).click(function() {
				    		    	if($(this).attr("id") == $("#seatCd").val()){
				    		    		$("#seatCd").val("");
				    		    		$(".sel_seat_nm").html("");
				    		    		$(this).removeClass("select");
				    		    		$(this).addClass("seatUse");
				    		    		return;
				    		    	};

				    		    	if(!$(this).hasClass("none")) {
				    		    		var oldSel = $("#area_Map li.select");
				    		    		
				    		    		oldSel.removeClass("select");
				    		    		oldSel.addClass("seatUse");
				    		    		
				    		    		$(this).removeClass("seatUse");
										$(this).addClass("select");
										
										var seatCd = $(this).attr("id");
										$("#seatCd").val(seatCd);
										
 										var seatNm = $(this).attr("name");
										$(".sel_seat_nm").html(seatNm);
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
			fn_initPinch : function() {
				var seat_select = $("#seat_select");
				seat_select.empty();
				
				var setHtml = '';
				setHtml += '<div class="window"></div>';
				setHtml += '<div id="gui_seat" class="gui_seat mapbottom pinch-zoom-parent">';

				setHtml += '    <div id="mask">';
				setHtml += '        <div class="info_img">';
				setHtml += '            <img src="/resources/img/front/finger.png" alt="">';
				setHtml += '            <p>손가락으로 펼쳐 확대해보세요.</p>';
				setHtml += '        </div>';
				setHtml += '    </div>';
		         
		         //검은 막 띄우기
		         $(document).on("click",".openMask",function(){ 
		             e.preventDefault();
		             wrapWindowByMask();
	 			});
		            
				//닫기 버튼을 눌렀을 때
				$(document).on("click",".window .close",function(){ 
					//링크 기본동작은 작동하지 않도록 한다.
					e.preventDefault();
					$('#mask, .window').hide();
	 			});
		            
				//검은 막을 눌렀을 때
				$(document).on("click","#mask",function(){ 
					$(this).hide();
					$('.window').hide();
	 			});
                	

				setHtml += '    <div class="part_map pinch-zoom"  style="background-repeat: no-repeat; background-position: center center">';
				setHtml += '        <div class="seat">';
				setHtml += '            <ul id="area_Map">';
				setHtml += '            </ul>';
				setHtml += '        </div>';
				setHtml += '    </div>';
				setHtml += '</div>';
				
				seat_select.append(setHtml);
				
				var gui_seat = document.getElementById("gui_seat");
				var el = document.querySelector('div.pinch-zoom');
				var pinchzoom = new PinchZoom.default(el, {});
			},
			fn_seatChange : function(el) {
				var seatBtn = $("#area_Map li[id^='s']");
				
			},
			fn_seatSearch : function() {
				var searchSeatCd = $("#searchSeatCd").val();
				$("#" + searchSeatCd).attr("tabindex", -1).focus();
			},
			fn_certification : function() {
				alert("인터페이스 연계 일정에 작업 예정");
			},
			fn_checkForm : function() {
				var enterDvsn = $("#enterDvsn").val();

				if(enterDvsn != "ENTRY_DVSN_1") {
					if($("#seatCd").val() == "") {
						alert("좌석을 선택해주세요");
						return;
					} else if(!$("input:checkbox[id='" + enterDvsn + "_qna_check']").is(":checked")) {
						alert("전자문진표 작성여부에 동의해주세요");
						return;
					}
				}
 				
				
 				var url = "/front/updateUserResvInfo.do";
				var params = {
					"mode" : "Ins",
					"resvDate" : $("#resvDate").val(),
					"resvUserDvsn" : $("#resvUserDvsn").val(),
					"resvEntryDvsn" : enterDvsn,
					"centerCd" : $("#centerCd").val(),
					"floorCd" : $("#floorCd").val(),
					"partCd" : $("#partCd").val(),
					"seatCd" : $("#seatCd").val(),
					"resvUserNm" : $("#" + enterDvsn + "_resvUserNm").val(),
					"resvUserClphn" : $("#" +  enterDvsn + "_resvUserClphn").val(),
					"resvUserAskYn" : $("input:checkbox[id='" + enterDvsn + "_qna_check']").val(),
					"resvRcptNumber" : $("#" + enterDvsn + "_cash_number").val()
				}
					
				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
				    		if(result.resvInfo != null) {				    			
				    			$("#rsv_num").html(result.resvInfo.resv_seq);   
								$("#rsv_brch").html(result.resvInfo.center_nm)
								$("#rsv_seat").html(result.resvInfo.seat_nm);
								$("#rsv_date").html(result.resvInfo.resv_req_date);
								
				    			$("#rsv_done").bPopup();
				    		}
				    	} else {
				    		alert("ERROR : " + result.status);	
				    	}
					},
					function(request) {
						alert("ERROR : " + request.status);
					}
				);	
			},
			fn_initializing : function(division) {
				if(division == "ALL") {
					$("#section_sel").hide();
					$("#tab-a").hide();
					
					$("#floorCd").val("");
					$("#partCd").val("");
					$("#seatCd").val("");
					
					$(".sel_floor_nm").html("");
					$(".sel_part_nm").html("");
					$(".sel_seat_nm").html("");
				} else if (division == "FLOOR") {
					// SHOW & HIDE
					$("#section_sel").show();
					$("#tab-a").hide();
					
					// VALUE
					$("#partCd").val("");
					$("#seatCd").val("");
					
					$(".sel_part_nm").html("");
					$(".sel_seat_nm").html("");
				} else if (division == "PART") {
					$("#tab-a").show();
					$("#seatCd").val("");
					$(".sel_seat_nm").html("");
				}
			}
		}  
    </script>

    <!--입석/좌석 버튼속성-->
    <script>
		$(function(){
			var sBtn = $(".section_menu ul > li, .enter_type ul > li");   //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
			sBtn.find("ul").click(function(){   // sBtn에 속해 있는  ul 찾아 클릭 하면.
				sBtn.removeClass("active");     // sBtn 속에 (active) 클래스를 삭제 한다.
				$(this).parent().addClass("active"); // 클릭한 a에 (active)클래스를 넣는다.
			})
		})
    </script>
 
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
	</form:form>
</body>
</html>