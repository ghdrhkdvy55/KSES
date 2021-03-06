<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="refresh" content="600; URL=/front/main.do">
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
	<link rel="stylesheet" href="/resources/css/section.css">   
 
	<script type="text/javascript" src="/resources/js/modernizr.custom.js"></script>
	<script type="text/javascript" src="/resources/js/classie.js"></script>
	<script type="text/javascript" src="/resources/js/dragmove.js"></script>
	<script type="text/javascript" src="/resources/js/modernizr.custom.js"></script>
    
	<link href="/resources/css/front/widescreen_temp.css" rel="stylesheet" media="only screen and (min-width : 1080px)">
	<link href="/resources/css/front/mobile_temp.css" rel="stylesheet" media="only screen and (max-width:1079px)">
</head>

<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/rsvSeat.do">
	<input type="hidden" name="userDvsn" id="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	
	<input type="hidden" name="isReSeat" id="isReSeat" value="${resvInfo.isReSeat}">
	<input type="hidden" name="resvUserNm" id="resvUserNm" value="">
	<input type="hidden" name="resvSeq" id="resvSeq" value="">
	<input type="hidden" name="resvDate" id="resvDate" value='<c:out value="${resvInfo.resvDate}"/>'>
	
	<input type="hidden" name="centerEntryPayCost" id="centerEntryPayCost" value="${resvInfo.center_entry_pay_cost}">
	<input type="hidden" name="centerStandYn" id="centerStandYn" value="${resvInfo.center_stand_yn}">
	<input type="hidden" name="centerPilotYn" id="centerPilotYn" value="${resvInfo.center_pilot_yn}">
	<input type="hidden" name="centerAutoPaymentYn" id="centerAutoPaymentYn" value="${resvInfo.center_auto_payment_yn}">
		
	<!-- 예약정보 sessionStorage검토 -->
	<input type="hidden" name="seasonCd" id="seasonCd">
	<input type="hidden" name="centerCd" id="centerCd" value="${resvInfo.centerCd}">
	<input type="hidden" name="partCd" id="partCd" value="">
	<input type="hidden" name="floorCd" id="floorCd" value="">
	<input type="hidden" name="seatCd" id="seatCd" value="">
	<input type="hidden" name="entryDvsn" id="entryDvsn" value="">
	
	<!-- 좌석 다시 앉기 sessionStorage검토 -->
	<input type="hidden" name="reSeatCenterCd" id="reSeatCenterCd" value="${resvInfo.centerCd}">
	<input type="hidden" name="rePartCd" id="rePartCd" value="${resvInfo.partCd}">
	<input type="hidden" name="reFloorCd" id="reFloorCd" value="${resvInfo.floorCd}">
	<input type="hidden" name="reSeatCd" id="reSeatCd" value="${resvInfo.seatCd}">
	<input type="hidden" name="reEnterDvsn" id="reEnterDvsn" value="${resvInfo.entryDvsn}">

    <div class="wrapper rsvBack">
        <!--// header -->
        <div id="rsv_header">
            <ul class="rsv_info rsv_prsc">
                <li class="backImg"></li>
                <li class="rsv_branch">
                	<span class="sel_center_nm"><c:out value='${resvInfo.center_nm}'/></span>
                	<span class="sel_floor_nm"></span> 
                	<span class="sel_part_nm"></span>
                	<span class="sel_seat_nm"></span>
				</li>	
                <li class="rsv_state"><span class="date"></span> 좌석 예약 중 입니다.</li>
                <li class="rsv_paycost">[총 금액 : <span><fmt:formatNumber value="${resvInfo.center_entry_pay_cost}" pattern="#,###" />원</span>]</li>
            </ul>             
        </div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <div>
                <div class="contents">      
                    <h4>
						선택한 지점 
                        <span class="change_br">
                            <a href="/front/rsvCenter.do"><img src="/resources/img/front/refresh.svg" alt="change">지점변경</a>
                        </span>
                    </h4>
                    <div class="branch">
                        <p><c:out value='${resvInfo.center_nm}'/></p>
                    </div>
                    
                    <div class="date_sel">
						<h4>예약일을 선택하세요.</h4>
						<ul id="menu_ul" class="tabs">
							<c:forEach items="${resvDateList}" var="resvDateList">
							<li class="tab-link" data-date="${resvDateList.resv_date}" onclick="seatService.fn_resvDateChange(this);">
								<ul>
									<li><c:out value='${resvDateList.resv_date}'/></li>
								</ul>
							</li>
							</c:forEach>
						</ul>
					</div>
                    <div class="null"></div>
                    
                    <!--입장유형 선택-->
                    <div class="entry_sel">
                    <h4>입장 유형을 선택하세요.</h4>
                    <div class="enter_type">
                        <ul>
							<li id="ENTRY_DVSN_1" onclick="seatService.fn_enterTypeChange('ENTRY_DVSN_1');">
								<ul>
									<li>자유석</li>
								</ul>
							</li>
							<li id="ENTRY_DVSN_2" onclick="seatService.fn_enterTypeChange('ENTRY_DVSN_2');">
								<ul>
									<li>좌석</li>
								</ul>
							</li>
                        </ul>
                    </div>
					</div>
                    
                    <div id="showHide" align="middle">
                        <section>
                        <!--예약 정보 입력-->
                            <h4>예약 정보 입력</h4>
                            <ul id="ENTRY_DVSN_1_resv_area">
                                <li><input type="text" id="ENTRY_DVSN_1_resvUserNm" class="nonMemberArea" placeholder="이름을 입력해주세요." autocomplete="off"></li>
                                <li><input type="number" id="ENTRY_DVSN_1_resvUserClphn" class="nonMemberArea" onkeypress="onlyNum(this);" placeholder="전화번호를 '-'없이 입력해주세요." autocomplete="off"></li>
                                <li class="certify nonMemberArea" onclick="javascript:seatService.fn_SmsCertifi();">
                                	<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증번호 받기</a>
                                </li>
								
								<li class="nonMemberArea"><input type="number" id="ENTRY_DVSN_1_resvCertifiCode" placeholder="인증번호를 입력하세요." autocomplete="off"></li>
								<li class="certify nonMemberArea" onclick="javascript:seatService.fn_checkCertifiCode();">
									<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증 하기</a>
								</li>
                                
                                <!--전자문진표-->
                                <li class="covid19_qna">
                                    <p>
                                        <span>&lt;전자문진표 작성&gt;</span>
                                        <ol>
                                            <li>확진자/자가격리자와 동거 또는 본인 확진</li>
                                            <li>PCR 검사 결과 대기자</li>
                                            <li>발열(37.5도 이상), 근육통, 기침, 인후통 등 호흡기 증상</li>
                                            <li>지자체(기관)로부터 코로나19 검사 요청(능동감시자)</li>
                                            <li class="check_impnt">
                                                <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_1_qna_check" value="Y">
                                                <label for="ENTRY_DVSN_1_qna_check">
                                               	 위 사항에 해당사항이 없으며, 허위기재로 문제발생시 본인에게 책임이 있음을 확인합니다.
                                                </label>     
                                            </li>
                                        </ol>
                                    </p>
                                </li>
                                
								<!-- 자동결제동의 -->
								<li class="auto_payment_check">
									<p>
										<span>&lt;자동결제동의&gt;</span>
										<ol>
											<li>스피드온 결제가능시간(수목 10:30~18:00/금토일 10:30~19:00) 예약 시 입장료 및 좌석이용료가 스피드온에서 자동 결제 됩니다.</li>
											<li>스피드온 결제불가시간에 예약된 내역은 결제가능시간에 스마트입장시스템 로그인 시 자동결제됩니다.</li>
											<li>스피드온 잔액부족 시 자동결제는 이루어지지 않습니다. 자동결제가 되지 않을 시 스피드온 잔액 충전 후 스마트입장시스템에 로그인하면 자동결제됩니다.</li>
                                            <li>미입장한 결제내역은 예약지점의 입장마감시간에 일괄환불됩니다.(강남지점 17시)</li>
                                            <li class="check_impnt">
												<input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_1_auto_payment_check" value="Y">
                                                <label for="ENTRY_DVSN_1_auto_payment_check">
                                                 	스피드온 사전결제에 동의합니다.
                                                </label>     
                                            </li>
										</ol>
									</p>
								</li>
                                
								<!--개인정보동의-->
								<li class="person_check nonMemberArea">
									<p>
										<span>&lt;개인정보 수집 이용 동의 안내&gt;</span>
										<ol>
											<li>코로나 19 확산 방지를 위하여 다음과 같이 개인정보 수집 이용 및 제 3자 제공에 대한 동의를 얻고자 합니다.</li>
											<li class="prsn_agree"><a data-popup-open="person_agree">자세히 ></a></li>
											<br>
											<li class="check_impnt">
												<input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_1_person_agree" value="Y">
											<label for="ENTRY_DVSN_1_person_agree">동의합니다.</label>     
											</li>
										</ol>
									</p>
								</li>
								
								<!--기타고지사항-->
								<li class="person_check">
									<p><span>&lt;기타 고지 사항 &gt;</span></p>
									<ol>
										<li class="notiCon">개인정보 보호법 제15조 제1항 제2호에 따라 정보주체의 동의 없이 개인정보를 수집·이용합니다.</li>
										<li class="prsn_agree"><a data-popup-open="ect_agree">자세히 &gt;</a></li>
									</ol>																														
								</li>    
                            </ul>

                            <ul class="rsv_btn">
                                <li><a href="javascript:seatService.fn_checkForm();">예약하기</a></li>
                                <li><a data-popup-open="rsv_cancel">취소</a></li>
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
										<option value="${floorList.floor_cd}"><c:out value='${floorList.floor_nm}'/></option>
									</c:forEach>
                                </select>
                            </div>

                            <!--구역선택-->
                            <div id="section_sel" > 
                                <h4>구역을 선택하세요.</h4>
                                <!--구역선택 맵-->
								<div id="part_select" class="seat_select">
									
								</div>

                                <h5>좌석 이용료 <span>(입장료 별도)</span></h5>
                                <!--요금안내-->
                                <div id="price" class="price">
                                    <table>
                                        <tbody>
											<c:forEach var="item" items="${partClass}" begin="0" step="1" varStatus="status">
												<c:if test="${(status.index + 1)%2 != 0}"><tr></c:if>
													<td>
														<img src="/upload/${item.part_icon}"><c:out value='${item.part_class_nm}'/>
													<c:if test="${item.part_pay_cost ne 0}">
														<span><fmt:formatNumber value="${item.part_pay_cost}" pattern="#,###" />원</span>
													</c:if>
													<c:if test="${item.part_pay_cost eq 0}">
														<span>무료</span>
													</c:if>
													</td>
											    <c:if test="${(status.index + 1)%2 == 0}"><tr></c:if>
											</c:forEach>
                                        </tbody>                                          
                                    </table>
                                </div>

                                <!--구역선택 메뉴-->
                                <div id="part_area" class="section_menu">                                                                         
                            		<div id="part_sel" class="part_sel">
                                		<select id="selectPartCd" class="select_box" onchange="seatService.fn_partChange();">
                                    		
                                		</select>
                            		</div>                                             
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
                                    <div id="seat_select" class="seat_select test_sel">
                                        <div>
                                   			
                                        </div>
									</div>

                                    <!--예약 정보 입력-->
                                    <h4>예약 정보 입력</h4>
                                    <ul id="ENTRY_DVSN_2_resv_area">
                                        <li class="nonMemberArea"><input type="text" id="ENTRY_DVSN_2_resvUserNm" placeholder="이름을 입력해주세요." autocomplete="off"></li>
                                        <li class="nonMemberArea"><input type="number" id="ENTRY_DVSN_2_resvUserClphn" onkeyup="onlyNum(this);" placeholder="전화번호를 '-'없이 입력해주세요." autocomplete="off"></li>
										<li class="certify nonMemberArea" onclick="javascript:seatService.fn_SmsCertifi();">
											<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증번호 받기</a>
										</li>
										
                                		<li class="nonMemberArea"><input type="number" id="ENTRY_DVSN_2_resvCertifiCode" placeholder="인증번호를 입력하세요." autocomplete="off"></li>
                                        <li class="certify nonMemberArea" onclick="javascript:seatService.fn_checkCertifiCode();">
                                        	<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증 하기</a>
                                        </li>
                                        
                                        <!--전자문진표-->
                                        <li class="covid19_qna">
                                            <p>
                                                <span>&lt;전자문진표 작성&gt;</span>
                                                <ol>
                                            		<li>확진자/자가격리자와 동거 또는 본인 확진</li>
                                            		<li>PCR 검사 결과 대기자</li>
                                                    <li>발열(37.5도 이상), 근육통, 기침, 인후통 등 호흡기 증상</li>
                                                    <li>지자체(기관)로부터 코로나19 검사 요청(능동감시자)</li>
                                                    <li class="check_impnt">
                                                        <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_2_qna_check" value="Y">
                                                        <label for="ENTRY_DVSN_2_qna_check">
                                                        	위 사항에 해당사항이 없으며, 허위기재로 문제발생시 본인에게 책임이 있음을 확인합니다.
                                                        </label>
                                                    </li>
												</ol>
                                            </p>
                                        </li>
                                        
										<!-- 자동결제동의 -->
										<li class="auto_payment_check">
                                            <p>
                                                <span>&lt;자동결제동의&gt;</span>
                                                <ol>
													<li>스피드온 결제가능시간(수목 10:30~18:00/금토일 10:30~19:00) 예약 시 입장료 및 좌석이용료가 스피드온에서 자동 결제 됩니다.</li>
													<li>스피드온 결제불가시간에 예약된 내역은 결제가능시간에 스마트입장시스템 로그인 시 자동결제됩니다.</li>
                                            		<li>스피드온 잔액부족 시 자동결제는 이루어지지 않습니다. 자동결제가 되지 않을 시 스피드온 잔액 충전 후 스마트입장시스템에 로그인하면 자동결제됩니다.</li>
                                            		<li>미입장한 결제내역은 예약지점의 입장마감시간에 일괄환불됩니다.(강남지점 17시)</li>
                                                    <li class="check_impnt">
                                                        <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_2_auto_payment_check" value="Y">
                                                        <label for="ENTRY_DVSN_2_auto_payment_check">
                                                        	스피드온 사전결제에 동의합니다.
                                                        </label>
                                                    </li>
                                                </ol>
                                            </p>
                                        </li>
										
										<!--개인정보동의-->
										<li class="person_check nonMemberArea">
											<p>
												<span>&lt;개인정보 수집 이용 동의 안내&gt;</span>
												<ol>
													<li>코로나 19 확산 방지를 위하여 다음과 같이 개인정보 수집 이용 및 제 3자 제공에 대한 동의를 얻고자 합니다.</li>
													<li class="prsn_agree"><a data-popup-open="person_agree">자세히 ></a></li>
													<br>
													<li class="check_impnt">
														<input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_2_person_agree" value="Y">
													<label for="ENTRY_DVSN_2_person_agree">동의합니다.</label>
													</li>
												</ol>
											</p>
										</li>
										
										<!--기타고지사항-->
										<li class="person_check">
											<p><span>&lt;기타 고지 사항 &gt;</span></p>
											<ol>
												<li class="notiCon">개인정보 보호법 제15조 제1항 제2호에 따라 정보주체의 동의 없이 개인정보를 수집·이용합니다.</li>
												<li class="prsn_agree"><a data-popup-open="ect_agree">자세히 &gt;</a></li>
											</ol>
										</li>
                                    </ul>

                                    <ul class="rsv_btn">
                                        <li><a href="javascript:seatService.fn_checkForm();">예약하기</a></li>
                                        <li><a data-popup-open="rsv_cancel">취소</a></li>
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
          	<div class="pop_wrap">
				<h4><img src="/resources/img/front/done.svg" alt="예약확인">해당 정보로 예약하시겠습니까?</h4>
               	<ul class="rsv_list">
					<li>
                        <ol>
                            <li>경주일</li>
                            <li><span id="rsv_date" class="rsv_date"></span></li>
                        </ol>
                    </li> 
                    <li>
                        <ol>
                            <li>지점</li>
                            <li><span id="rsv_center" class="rsv_center"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>층</li>
                            <li><span id="rsv_floor" class="rsv_floor"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>구역</li>
                            <li><span id="rsv_part" class="rsv_part"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="rsv_seat" class="rsv_seat"></span></li>
                        </ol>
					</li>
				</ul>
          	</div>
          	<div class="summit_btn">
              	<a href="javascript:seatService.fn_setResvInfo();" class="mintBtn">확인</a>
				<a href="javascript:bPopupClose('rsv_done');">취소</a>
          	</div>
			<div class="clear"></div>
		</div>
    </div>
    <!-- 예약완료 팝업 // -->

    <!-- // 예약취소 팝업 -->
    <div id="rsv_cancel" data-popup="rsv_cancel" class="popup">
		<div class="pop_con rsv_popup">
          	<div class="pop_wrap">
              	<h4><img src="/resources/img/front/cancle.svg" alt="예약취소">예약을 취소하시겠습니까?</h4>
          	</div>
          	<div class="cancel_btn other_btn">
          		<a href="/front/main.do" class="grayBtn">예</a>
				<a href="javascript:bPopupClose('rsv_cancel');" class="dbBtn">아니요</a>
          	</div>
          	<div class="clear"></div>
      	</div>
    </div>
    <!-- 예약취소 팝업 // -->
    
	<!-- // 개인정보 수집이용 약관 팝업 -->
    <div id="person_agree" data-popup="person_agree" class="popup">
    	<div class="pop_con rsv_popup">
          	<div class="pop_wrap">
            	<div class="text privacy_text">
                	<p class="font14 mg_l20">개인정보 수집·이용 및  제 3자 제공 동의서</p><br>                
                	<p class="font13 mg_l20">코로나19 확산방지를 위하여 경주사업총괄본부에서는 다음과 같이 개인정보 수집·이용 및 제 3자 제공에 대한 동의를 얻고자 합니다.</p>
                
                	<div class="tablet_wrap">
                         <div class="pd_l10 pd_r10">
                        	<p class="font13 mg_l10">▶ 개인정보수집·이용 동의</p>
                        	<table class="tb3" summary="개인정보수집·이용 동의">
                            	<caption>개인정보수집·이용 동의</caption>
                            	<colgroup>
                                	<col width="34%">
                                	<col width="33%">
                                	<col width="33%">
                            	</colgroup>
                            	<thead>
                                	<tr>
                                    	<th scope="col">항목</th>
                                    	<th scope="col">수집목적</th>
                                    	<th scope="col">보유기간</th>
                                	</tr>
                            	</thead>
                            	<tbody>             
	                                <tr>
	                                    <td>성명,전화번호,<br>출입시설,출입시간</td>
	                                    <td>코로나19 확진자<br>발생시 역학조사 및 <br>안내문자 발송</td>
	                                    <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">4주</td>
	                                </tr>                                              
                            	</tbody>
                        	</table><br>
                        
                        	<p class="font13 mg_l10">▶ 개인정보 제3자 제공 동의</p>
                        	<table class="tb3" summary="개인정보 제3자 제공 동의">
                            	<caption>개인정보 제3자 제공 동의</caption>
                            	<colgroup>
	                                <col width="27%">
	                                <col width="29%">
	                                <col width="26%">
	                                <col width="18%">
                            	</colgroup>
								<thead>
                                <tr>
                                    <th scope="col">제공받는 기관</th>
                                    <th scope="col">제공목적</th>
                                    <th scope="col">제공항목</th>
                                    <th scope="col">보유기간</th>
                                </tr>
                            </thead>
                            <tbody>             
                                <tr>
                                    <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">보건복지부,<br>질병관리청,<br>지자체</td>
                                    <td class="text_center" style="color:red; font-size:11px; font-weight:bold;">코로나19<br>확진자 발생 시<br>역학조사</td>
                                    <td>성명,전화번호,<br>출입시설,출입시간</td>
                                    <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">4주</td>
                                </tr>
                            </tbody>
                        </table>
                    </div><br>
                    
                    <p class="font13 mg_l20">※위의 개인정보 수집·이용 및 3자 제공에 대한 동의를 거부할 권리가 있습니다. 그러나 동의를 거부할 경우 출입이 제한될 수 있습니다. </p><br>
                </div>                
            </div>
          </div>
          <div class="cancel_btn">
              <a href="javascript:bPopupClose('person_agree');" class="grayBtn">닫기</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 개인정보 수집이용 약관 팝업 // -->  
    
	<!-- // 기타고지사항 팝업-->
    <div id="ect_agree" data-popup="ect_agree" class="popup">
    	<div class="pop_con rsv_popup">
          	<div class="pop_wrap">
            	<div class="text privacy_text">
                	<p class="font14 mg_l20">기타고지사항</p><br>                                
						<table class="tb3" summary="">                            	
			            	<colgroup>
				            	<col width="27%">
				                <col width="29%">
				                <col width="26%">
				                <col width="18%">
			                </colgroup>
							<thead>
				                <tr>
				                   <th scope="col">개인정보 처리사유</th>
				                   <th scope="col">개인정보 항목</th>
				                   <th scope="col">보유기간</th>
				                   <th scope="col">수집근거</th>
				                </tr>
				             </thead>
				             <tbody>             
				                <tr>
				                   <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">레저세<br>납부</td>
				                   <td class="text_center" style="color:red; font-size:11px; font-weight:bold;">휴대전화번호, <br>방문지점, <br>입장시간</td>
				                   <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">5년</td>
				                   <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">지방세법』제43조 <br>동법 시행령 제58조</td>
				                 </tr>
				             </tbody>
				         </table>                    		                    
                    <p class="font13 mg_l20">※ 코로나 방역, 천재지변 등으로 인한 긴급알림 문자는 동의가 없어도 해당 영업장 입장신청자들을 대상으로 발송됩니다. </p><br>
                </div>                
			</div>
		</div>
		<div class="cancel_btn resizeBtn">
			<a href="javascript:bPopupClose('ect_agree');" class="grayBtn">닫기</a>
		</div>
		<div class="clear"></div>
	</div>
    <!-- 기타고지사항 팝업 // -->    

    <!--층 선택 시 show/hide-->
    <script>
    	var isMember = "${sessionScope.userLoginInfo.userDvsn}" == "USER_DVSN_1" ? true : false;
    	
    	var certifiYn = false;
    	var certifiCode = "";
    	
		var setIntervalId = "";
		var reCertifiTime = 180;
		var reCertifiEndTime = 0;
		var reCertifiYn = true;
    	
    	var resvUserNm = isMember ? "${sessionScope.userLoginInfo.userNm}" : "";
    	var resvUserClphn = isMember ? "${sessionScope.userLoginInfo.userPhone}" : "";
    	
    	var pinchzoom = "";
    	var pinchInit = true;
    	var center ="";
    	
		$(document).ready(function() {
			var fResvDate = $("#menu_ul > li:eq(0)");
			$(".date").html(fResvDate.attr("data-date"));
			$(fResvDate).addClass("active");
			
			seatService.fn_tempEntryTrigger();
			if($("#isReSeat").val() == "Y") {
				seatService.fn_reSeat();
			}
		});
		
		var seatService =
		{ 
			fn_reSeat : function() {
				$("#" + $("#reEnterDvsn").val()).addClass("active");
				$("#" + $("#reEnterDvsn").val()).trigger("click");
				$("#selectFloorCd").val($("#reFloorCd").val()).trigger("change");
				$("#selectPartCd").val($("#rePartCd").val()).trigger("change");
				$("#" + $("#reSeatCd").val()).trigger("click");
				
				$("#mask").trigger("click");
			},
			// TO-DO : 비시범지점일 경우 "좌석" 버튼숨김 임시적용
			// 2022-04월 제거 예정
			fn_tempEntryTrigger : function() {
				if($("#centerStandYn").val() == "N" && $("#centerPilotYn").val() == "Y") {
					seatService.fn_enterTypeChange('ENTRY_DVSN_2');
					$(".entry_sel").hide();	
				} else if ($("#centerStandYn").val() == "Y" && $("#centerPilotYn").val() == "N") {
					seatService.fn_enterTypeChange('ENTRY_DVSN_1');
					$(".entry_sel").hide();						
				} else if ($("#centerStandYn").val() == "N" && $("#centerPilotYn").val() == "N") {
					fn_openPopup("예약 가능한 항목이 존재하지 않습니다.", "red", "ERROR", "확인", "/front/main.do");					
				}
			},
			fn_resvDateChange : function(el) {
				var resvDate = $(el).attr("data-date").replaceAll("-","");
				if(resvDate === $("#resvDate").val()) return;
				
				$(".date").html($(el).attr("data-date"));
				$("#resvDate").val(resvDate);
				seatService.fn_initializing("ALL");
				seatService.fn_tempEntryTrigger();
			},
			fn_enterTypeChange : function(entryDvsn) {
				if($("#entryDvsn").val() != entryDvsn) {
					if(entryDvsn == "ENTRY_DVSN_1") {
						$("#showHide").show();
						$("#showHide_seat").hide();

						$(".rsv_list").children("li").eq(2).hide();
						$(".rsv_list").children("li").eq(3).hide();
					} else { 
						$("#section_sel").hide();
						$("#showHide").hide();
						$("#showHide_seat").show();
						$(".rsv_list").children("li").eq(2).show();
						$(".rsv_list").children("li").eq(3).show();
					}
					
					seatService.fn_initializing("ENTRY");
					$("#entryDvsn").val(entryDvsn);
										
					$("#" + entryDvsn + "_resvUserNm").val("");
					$("#" + entryDvsn + "_resvUserClphn").val("");
					$("#" + entryDvsn + "_resvCertifiCode").val("");
					
					$("input:checkbox[id='" + entryDvsn + "_qna_check']").prop("checked", false);
					$("input:checkbox[id='" + entryDvsn + "_person_agree']").prop("checked", false);
					$("input:checkbox[id='" + entryDvsn + "_auto_payment_check']").prop("checked", false);
					
					if(isMember) {
						if($("#centerAutoPaymentYn").val() == "Y") {
							$("#" + entryDvsn + "_resv_area .auto_payment_check").show();
						} else {
							$("#" + entryDvsn + "_resv_area .auto_payment_check").hide();
						}
						$(".nonMemberArea").hide();
					} else {
						certifiYn = false;
						certifiCode = "";
				    	resvUserNm = "";
				    	resvUserClphn = "";
						$(".nonMemberArea").show();
					}
				}
			},
			fn_floorChange : function() {
				if($("#selectFloorCd").val() != "" && $("#selectFloorCd").val() != $("#floorCd")) {
					seatService.fn_initializing("FLOOR");
					$("#floorCd").val($("#selectFloorCd").val());
					$(".sel_floor_nm").html($("#selectFloorCd option:checked").text());
					$("#section_sel").show();
				} else {
					return;
				}
				
				var url = "/front/rsvPartListAjax.do";
				var params = 
				{
					"floorCd" : $("#floorCd").val(),
					"resvDate" : $("#resvDate").val()
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
							seatService.fn_initPinch("floor");
				    		if (result.seatMapInfo != null) {
				    		    var img = result.seatMapInfo.floor_map1;
				    		    $('.floor_map').css({
				    		        "background": "#fff url(/upload/" + img + ")",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		} else {
				    		    $('.floor_map').css({
				    		        "background": "#fff url()",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		}
				            
							if (result.resultlist.length > 0) {
								$("#selectPartCd").empty();
								$("#selectPartCd").append("<option value=''>구역 선택</option>");
								
								var setHtml = "";

								//층 도면 구역 아이콘 영역
								$.each(result.resultlist, function(index, item) {
									$("#selectPartCd").append("<option value='" + item.part_cd + "'>" + item.part_nm + "</option>");
									
									setHtml = '<div class="box-wrapper"><li id="s' + trim(fn_NVL(item.part_cd)) + '" class="seat" seat-id="' + item.part_cd + '" style="opacity: 0.7;text-align: center; display: inline-block;" name="' + item.part_cd + '" >' 
	                                  		+  '<div class="section">'
	                                  		+  '   <div class="circle">'
	                                  		+  '       <span class=' + fn_NVL(item.part_css) + '>' + fn_NVL(item.part_nm);
									
									setHtml += item.part_class != "SEAT_CLASS_1" ? '<em class="circle_class">(' + fn_NVL(item.part_class_text) + ')</em>' : "";
	                                setHtml +=  '</div></div></li></div>';
	                             
	                            	$('#floor_area_Map').append(setHtml);
								});
								
                            	$.each(result.resultlist, function(index, item) {
	 	                            $('.floor_map ul li#s' + trim(fn_NVL(item.part_cd))).css({
	 	                                "top": fn_NVL(item.part_mini_top) + "px",
	 	                                "left": fn_NVL(item.part_mini_left) + "px",
	 	                                "width": fn_NVL(item.part_mini_width) + "px",
	 	                                "height": fn_NVL(item.part_mini_height) + "px",
	 	                                '-moz-transform': 'rotate(' + fn_NVL(item.part_mini_rotate) + 'deg)',
	 	                                '-webkit-transform': 'rotate(' + fn_NVL(item.part_mini_rotate) + 'deg)',
	 	                            });
                            	});
                            	
	 		 	                   
 		 	                    $('.seat').draggable({
 		 	                      	stop : function(e, ui){
										var obj = e.target;
	 				 	                var get_id = obj.id;
	 				 	                var top_id = 'top_' + $('#'+get_id)[0].attributes.name.value;
	 				 	                var left_id ='left_' + $('#'+get_id)[0].attributes.name.value;
	 				 	                $('#'+top_id).val(item.part_mini_top);
	 				 	                $('#'+left_id).val(item.part_mini_left);
 		 	                    	}
 		 	                    });
								
 		 	                    $('.seat').draggable("option", "disabled", true);
								$(".box-wrapper li").click(function () {
									var partCd = $(this).attr("id").substring(1);
									$("#selectPartCd").val(partCd).trigger("change");
								});
								
								fn_scrollMove($("#section_sel"));
							} else {
								fn_openPopup("해당층은 현재 예약 가능한 구역이 존재하지 않습니다.");
							}
				    	}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);
			},
			fn_partChange : function() {
				if($("#selectPartCd").val() != "" && $("#selectPartCd").val() != $("#partCd")) {
					seatService.fn_initializing("PART");
					$("#partCd").val($("#selectPartCd").val());
					$(".sel_part_nm").html($("#selectPartCd option:selected").html() + "구역");
				} else {
					return;
				} 
									
				var url = "/front/rsvSeatListAjax.do";
				var params = 
				{	
					"centerCd" : $("#centerCd").val(),
					"partCd" : $("#partCd").val(),
					"resvDate" : $("#resvDate").val()
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
				    		seatService.fn_initPinch("seat");
				    		
				    		// 시즌유무확인
				    		result.seasonCd != null ? $("#seasonCd").val(result.seasonCd) : $("#seasonCd").val("");
				    		
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
				    		        shtml += '<li id="' + fn_NVL(obj[i].seat_cd) + '" class="' + addClass + '" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_nm + '" >' + obj[i].seat_number + '</li>';
				    		    }
				    		    
				    		    $('#area_Map').html(shtml);
				    		    
				    		    for (var i in result.resultlist) {
				    		        $("#" + fn_NVL(obj[i].seat_cd)).css({
				    		            "top": fn_NVL(obj[i].seat_top) + "px",
				    		            "left": fn_NVL(obj[i].seat_left) + "px"
				    		        });
				    		        
				    		        $("#" + fn_NVL(obj[i].seat_cd)).data("seat_paycost", obj[i].pay_cost);
				    		        $("#" + fn_NVL(obj[i].seat_cd)).data("seat_class", obj[i].seat_class);
				    		    }
				    		    
				    		    var seatList = $("#area_Map li");
				    		    $(seatList).click(function() {
				    		    	if($(this).attr("id") == $("#seatCd").val()){
				    		    		$("#seatCd").val("");
				    		    		$(".sel_seat_nm").html("");
				    		    		
				    		    		$(this).removeClass("select");
				    		    		$(this).addClass("seatUse");
				    		    		
				    		    		$(".rsv_paycost span").html(fn_cashFormat($("#centerEntryPayCost").val()) + "원")
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
										
										var payCost = fn_cashFormat(parseInt($("#centerEntryPayCost").val()) + parseInt($("#" + $(this).attr("id")).data("seat_paycost")));
										$(".rsv_paycost span").html(payCost + "원");
										fn_scrollMove($("#ENTRY_DVSN_2_resv_area"));
				    		    	}
								});
				    		    
				    		    fn_scrollMove($("#tab-a"));
				    		}
				    	}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");       						
					}    		
				);	
			},
			fn_initPinch : function(dvsn) {
				if(dvsn == "seat") {
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
			         
					//닫기 버튼을 눌렀을 때
					$(document).on("click",".window .close",function() { 
						//링크 기본동작은 작동하지 않도록 한다.
						e.preventDefault();
						$('#mask, .window').hide();
		 			});
			            
					//검은 막을 눌렀을 때
					$(document).on("click","#mask",function() { 
						$(this).hide();
						$('.window').hide();
		 			});
	                	
	
					setHtml += '    <div class="part_map pinch-zoom" style="background-repeat: no-repeat; background-position: center center">';
					setHtml += '        <div class="seat">';
					setHtml += '            <ul id="area_Map">';
					setHtml += '            </ul>';
					setHtml += '        </div>';
					setHtml += '    </div>';
					setHtml += '</div>';
					
					seat_select.append(setHtml);

					var el = document.querySelector('.part_map');
					var pinchzoom = new PinchZoom.default(el, {});
				} else {
					var part_select = $("#part_select");
					part_select.empty();
					
					var setHtml = '';
					setHtml += '<div id="floor_gui_seat" class="gui_seat mapbottom pinch-zoom-parent">';
					setHtml += '    <div class="floor_map pinch-zoom" style="background-repeat: no-repeat; background-position: center center">';
					setHtml += '        <div class="floor">';
					setHtml += '            <ul id="floor_area_Map">';
					setHtml += '            </ul>';
					setHtml += '        </div>';
					setHtml += '    </div>';
					setHtml += '</div>';
					
					part_select.append(setHtml);
					
					var partSelect = document.querySelector('#part_select');
					var el = document.querySelector('.pinch-zoom');
					var pinchzoom = new PinchZoom.default(el, {});
				}
			},
			fn_seatSearch : function() {
				var searchSeatCd = $("#searchSeatCd").val();
				$("#" + searchSeatCd).attr("tabindex", -1).focus();
			},
			fn_SmsCertifi : function() {
				var entryDvsn = $("#entryDvsn").val();
				var certifiNm = $("#" + entryDvsn + "_resvUserNm").val();
				var certifiNum = $("#" + entryDvsn + "_resvUserClphn").val();
				
				var duplicateParams = {"userDvsn" : $("#userDvsn").val(), "userPhone" : certifiNum, "resvDate" : $("#resvDate").val()};
				
				if(!fn_resvDuplicateCheck(duplicateParams)) {
					if(certifiYn) {
						fn_openPopup("이미 인증을 진행하였습니다.", "red", "ERROR", "확인", ""); return;
					} else if (!reCertifiYn) {
						fn_openPopup("이미 인증번호가 발송되었습니다.<br>" + reCertfiEndTime + "초 후 다시 시도해주세요.", "red", "ERROR", "확인", ""); return;
					} else {
						if(certifiNm == "") {
							fn_openPopup("이름을 입력해주세요.", "red", "ERROR", "확인", ""); return;
						} else if (certifiNum == "") {
							fn_openPopup("휴대폰번호를 입력해주세요.", "red", "ERROR", "확인", ""); return;
						} else if (!validPhNum(certifiNum)) {
							fn_openPopup("올바른 휴대폰번호를 입력해주세요.", "red", "ERROR", "확인", ""); return;
						}
						
						var url = "/front/resvCertifiSms.do";
						var params = {
							"certifiNm" : certifiNm,
							"certifiNum" : certifiNum
						}
						
						fn_Ajax
						(
						    url,
						    "POST",
						    params,
							false,
							function(result) {
						    	if(result.status == "SUCCESS") {
						    		// 인증요청 3분 인터벌 적용
						    		reCertifiYn = false;
						    		reCertfiEndTime = reCertifiTime;
									setIntervalId = setInterval(function () {
										if (reCertfiEndTime == 0) {
											reCertifiYn = true;
											clearInterval(setIntervalId);
										} else {
											reCertfiEndTime --;	
										}
									},1000);
						    		
						    		fn_openPopup("인증번호가 발송 되었습니다.", "blue", "SUCCESS", "확인", "");
									certifiCode = result.certifiCode;
							    	resvUserNm = certifiNm;
							    	resvUserClphn = certifiNum;
						    	} else if(result.status == "LOGIN FAIL") {
						    		fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
						    	} else {
						    		fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
						    	}
							},
							function(request) {
								fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
							}    		
						);
					}
				}
			},
			fn_checkCertifiCode : function() {
				var entryDvsn = $("#entryDvsn").val();
				var inCertifiCode = $("#" + entryDvsn + "_resvCertifiCode").val();
				
				if(inCertifiCode == "") {fn_openPopup("인증번호를 입력해주세요", "red", "ERROR", "확인", ""); return;}
				if(inCertifiCode != certifiCode) {fn_openPopup("인증번호가 일치하지 않습니다.", "red", "ERROR", "확인", ""); return;}
				
		    	fn_openPopup("정상적으로 인증되었습니다.", "blue", "SUCCESS", "확인", "");
		    	certifiYn = true;
			},
			fn_checkForm : function() {
				var entryDvsn = $("#entryDvsn").val();
				
				if(entryDvsn != "ENTRY_DVSN_1" && $("#seatCd").val() == "") {
					fn_openPopup("좌석을 선택해주세요", "red", "ERROR", "확인", ""); 
					return;
				}
				if(!isMember && !certifiYn) {
					fn_openPopup("본인인증을 진행해주세요", "red", "ERROR", "확인", ""); 
					return;
				}
				if(!$("input:checkbox[id='" + entryDvsn + "_qna_check']").is(":checked")) {
					fn_openPopup("전자문진표 작성여부에 동의해주세요", "red", "ERROR", "확인", ""); 
					return;
				}
				if(!$("input:checkbox[id='" + entryDvsn + "_person_agree']").is(":checked") && !isMember) {
					fn_openPopup("개인정보 수집 이용여부에 대하여 동의해주세요", "red", "ERROR", "확인", ""); 
					return;
				}
				if(!$("input:checkbox[id='" + entryDvsn + "_auto_payment_check']").is(":checked") && isMember && $("#centerAutoPaymentYn").val() == "Y") {
					fn_openPopup("사전결제동의 항목에 체크해주세요", "red", "ERROR", "확인", ""); 
					return;
				}
				
				var resvDate = $("#resvDate").val().substring(0,4) + "-" + $("#resvDate").val().substring(4,6) + "-" + $("#resvDate").val().substring(6,8);
				$("#rsv_date").html(resvDate);
				$("#rsv_center").html($(".sel_center_nm").html());
				
				if(entryDvsn != "ENTRY_DVSN_1") {
					$("#rsv_part").html($(".sel_part_nm").html());
					$("#rsv_floor").html($(".sel_floor_nm").html());
					$("#rsv_seat").html($(".sel_seat_nm").html());
				} else {
					$("#rsv_seat").html("자유석").show();					
				}
				
				$("#rsv_done").bPopup();
			},
			fn_setResvInfo : function() {
				var entryDvsn = $("#entryDvsn").val();
				var url = "/front/updateUserResvInfo.do";
				var params = {};
				
				var checkDvsn = entryDvsn == "ENTRY_DVSN_1" ? "STANDING" : "SEAT";
				params = {
					"checkDvsn" : checkDvsn,
					"inResvDate" : $("#resvDate").val(),
					"userDvsn" : $("#userDvsn").val(),
					"userId" : $("#userId").val(),
					"userPhnum" : resvUserClphn,
					"centerCd" : $("#centerCd").val(),
					"floorCd" : $("#floorCd").val(),
					"partCd" : $("#partCd").val(),
					"seatCd" : $("#seatCd").val(),
					"userId" : $("#userId").val()
				}
					
				var result = fn_resvVaildCheck(params);
				if(result.resultCode != "SUCCESS") {return;}
				
				params = {
					"mode" : "Ins",
					"resvDate" : $("#resvDate").val(),
					"resvUserDvsn" : $("#userDvsn").val(),
					"resvEntryDvsn" : entryDvsn,
					"seasonCd" : $("#seasonCd").val(),
					"centerCd" : $("#centerCd").val(),
					"floorCd" : $("#floorCd").val(),
					"partCd" : $("#partCd").val(),
					"seatCd" : $("#seatCd").val(),
					"resvUserNm" : resvUserNm,
					"resvUserClphn" : resvUserClphn,
					"resvUserAskYn" : $("input:checkbox[id='" + entryDvsn + "_qna_check']").val(),
					"resvIndvdlinfoAgreYn" : $("#" + entryDvsn + "_person_agree").val()
				}
				
				// 예약 요금 
				params.resvSeatPayCost = entryDvsn == "ENTRY_DVSN_2" ? $("#" + $("#seatCd").val()).data("seat_paycost") : 0; 
				params.resvRcptYn = "N"
				params.resvRcptDvsn = "";
				params.resvRcptTel =  "";
 				
				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
				    		if(result.resvInfo != null) {	
				    			bPopupClose('rsv_done');
				    			fn_openPopup("예약정보가 정상적으로 등록되었습니다.", "blue", "SUCCESS", "확인", "javascript:location.replace('/front/main.do');");
				    			setTimeout("location.replace('/front/main.do')", 5000);
				    		}
				    	} else if(result.status == "LOGIN FAIL") {
				    		fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
				    	} else {
				    		fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "/front/main.do");
				    	}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "/front/main.do");
					}
				);	
			},
			fn_initializing : function(division) {
				if(division == "ALL") {
					$("#entryDvsn").val("");
					$(".enter_type ul > li").removeClass("active");
					$("#section_sel, #tab-a, #showHide_seat, #showHide").hide();
					$("#floorCd, #partCd, #seatCd, #selectFloorCd").val("");
					$(".sel_floor_nm, .sel_part_nm, .sel_seat_nm").html("");
			    } else if(division == "ENTRY") {
					$("#section_sel, #tab-a").hide();
					$("#floorCd, #partCd, #seatCd, #selectFloorCd").val("");
					$(".sel_floor_nm, .sel_part_nm, .sel_seat_nm").html("");
				} else if (division == "FLOOR") {
					$("#section_sel").show();
					$("#tab-a").hide();
					$("#partCd, #seatCd").val("");
					$(".sel_part_nm, .sel_seat_nm").html("");
				} else if (division == "PART") {
					$("#tab-a").show();
					$("#seatCd").val("");
					$(".sel_seat_nm").html("");
				}
				
				$("#seasonCd").val("");
				$(".rsv_paycost span").html(fn_cashFormat($("#centerEntryPayCost").val()) + "원");
			}
		}
    </script>
 
 	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
	</form:form>
</body>
</html>