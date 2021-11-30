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
	
	<!-- chart.js -->
    <script src="/resources/js/chart.min.js"></script>
    <script src="/resources/js/utils.js"></script>
    
   	<script src="/resources/js/common.js"></script>
    
    <!-- jqGrid js/css -->
	<link rel="stylesheet" type="text/css" href="/resources/jqgrid/src/css/ui.jqgrid.css">
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
    
    <!-- GUI js/css -->
	<script type="text/javascript" src="/js/modernizr.custom.js"></script>
    <script type="text/javascript" src="/js/classie.js"></script>
    <script type="text/javascript" src="/js/dragmove.js"></script>
    <script type="text/javascript" src="/js/common.js"></script>
    <script type="text/javascript" src="/js/back_common.js"></script>
    
	<style>
		.cbp-spmenu {
			background: #47a3da;
			position: fixed;
	  	}
      	.cbp-spmenu a {
			display: block;
			color: #fff;
			font-size: 1.1em;
			font-weight: 300;
		}
/* 		.cbp-spmenu a:hover {
			background: #258ecd;
		} */
		.cbp-spmenu a:active {
			background: #afdefa;
			color: #47a3da;
		}
		.cbp-spmenu-right {
			right: -1700px;
		}
		.cbp-spmenu-right.cbp-spmenu-open {
			right: 0px;
		}
		.cbp-spmenu-vertical {
			width: 1700px;
			height: 100%;
			top: 0;
			z-index: 1000;
		}
		.cbp-spmenu-push {
			overflow-x: hidden;
			position: relative;
			left: 0;
		}
		.cbp-spmenu-push-toright {
			left: 840px;
		}
		.cbp-spmenu,
		.cbp-spmenu-push {
			-webkit-transition: all 0.3s ease;
			-moz-transition: all 0.3s ease;
			transition: all 0.3s ease;
		}
		.drag {
            -webkit-transition: all 150ms ease-out;
            -moz-transition: all 150ms ease-out;
            -o-transition: all 150ms ease-out;
            transition: all 150ms ease-out;
        }
    </style>
     <link rel="stylesheet" href="/resources/css/paragraph_new.css">
    
	<script>
		jQuery.browser = {};
		(function () {
		    jQuery.browser.msie = false;
		    jQuery.browser.version = 0;
		    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
		        jQuery.browser.msie = true;
		        jQuery.browser.version = RegExp.$1;
		    }
		})();
	</script>
    
<form:form name="regist" commandName="regist" method="post" action="/backoffice/bld/floorList.do">
<input type="hidden" name="centerCd" id="centerCd" value="${regist.center_cd}">
<input type="hidden" name="floorCd" id="floorCd">
<input type="hidden" name="partCd" id="partCd">
<input type="hidden" id="mode" name="mode">

<div class="wrapper">
	<c:import url="/backoffice/inc/top_inc.do" />
	<!--// header -->
  	<!-- header //-->
  	<!--// contents-->
	
	<div id="contents">
    	<div class="breadcrumb">
      		<ol class="breadcrumb-item">
        		<li>시설 관리 > 지점 시설 관리</li>
        		<li class="active">　> 층 관리</li>
      		</ol>
    	</div>

		<h2 class="title">${regist.center_nm} 층 정보 관리</h2><div class="clear"></div>
    	<!--// dashboard -->
    	<div class="dashboard">
	    	<!--contents-->
	      	<div class="boardlist">
	        	<div class="whiteBox searchBox">
					<div class="sName">
	            		<h3>검색 옵션</h3>
	          		</div>
	          		<div class="top">
	            		<p>지점명</p>
						<select id="searchCenterCd">
							<option value="">지점 선택</option>
							<c:forEach items="${centerInfoComboList}" var="centerInfoComboList">
								<option value="${centerInfoComboList.center_cd}">${centerInfoComboList.center_nm}</option>
							</c:forEach>
						</select>
<!-- 	            	<p>검색어</p>
	            		<select>
	            			<option value="0">층 명</option>
	              			<option value="0">수정자</option>
	            		</select> -->
	            		<input type="text" placeholder="검색어를 입력하세요.">
	          		</div>
	          		<div class="right_box">
	            		<a href=""class="grayBtn">검색</a>
	          		</div>
	        	</div>
	        	<div class="left_box mng_countInfo">
	        		총 : <span id="sp_totcnt"></span>건
	        	</div>
	        	<div class="clear"></div>
	
				<div class="whiteBox">
					<table id="mainGrid">
	        				
					</table>
					<div id="pager" class="scroll" style="text-align:center;"></div>     
					<br/>
					<div id="paginate"></div>
				</div>
	      	</div>
		</div>
   	</div>
  	<!-- contents//-->
</div>

<!-- wrapper_end-->
<!-- // 층 정보 관리 팝업 -->
<div id="bld_floor_add" data-popup="bld_floor_add" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">층 정보</h2>
      <div class="pop_wrap">
          <table class="detail_table">
              <tbody>
                  <tr>
                      <th>층 이름</th>
                      <td><input type="text" id="floorNm"></td>
                      <th>구역 사용 여부</th>
                      <td>
						<select id="floorPartDvsn">
							<option value="">구역 사용여부</option>
							<c:forEach items="${floorPart}" var="floorPart">
								<option value="${floorPart.code}">${floorPart.codenm}</option>
							</c:forEach>
						</select>
                      </td>
                  </tr>
                  <tr>
                    <th>웹 도면 이미지</th>
                    <td><input type="file" id="floorMap1"></td>
                    <th>사용 유무</th>
                    <td>
						<label for="floor_use_yn_y"><input id="floor_use_yn_y" type="radio" name="floor_use_yn" value="Y" checked>Y</label>
						<label for="floor_use_yn_n"><input id="floor_use_yn_n" type="radio" name="floor_use_yn" value="N">N</label>
                    </td>
                  </tr>
                  <tr>
                      <th>층 이름 규칙</th>
                      <td colspan="3"><input type="text" id="floorSeatRule"></td>
                  </tr>
              </tbody>
          </table>
      </div>
      <div class="right_box">
          <a href="javascript:bPopupClose('bld_floor_add');" class="grayBtn">취소</a>
          <a href="javascript:floorService.fn_floorUpdate();" id="floorInfoUpdateBtn" class="blueBtn">저장</a>
      </div>
      <div class="clear"></div>
  </div>
</div>

<!-- 층 정보 관리 팝업 // -->
<!-- // 좌석구역 생성 팝업 -->
<div id="bld_seat_add" data-popup="bld_seat_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">구역 좌석 일괄 생성</h2>
      	<div class="pop_wrap">
          	<table class="detail_table">
              	<tbody>
                  	<tr>
                    	<th>설정 범위</th>
                    	<td colspan="3">
                        	<select id="seatStr" name="seatStr">
		                  		<c:forEach var="cnt" begin="1" end="1000" step="1">
		                     		<option value="${cnt}">${cnt}</option>
		                  		</c:forEach> 
			             	</select>~
			             	<select id="seatEnd" name="seatEnd">
			                  	<c:forEach var="cnt" begin="1" end="1000" step="1">
			                     	<option value="${cnt}">${cnt}</option>
			                  	</c:forEach> 
			             	</select>
                    	</td>
                  	</tr>
                  	<tr>
                    	<th>좌석 등급</th>
                    	<td>
							<select id="seatClass">
								<option value="">좌석 등급 선택</option>
								<c:forEach items="${seatClass}" var="seatClass">
									<option value="${seatClass.code}">${seatClass.codenm}</option>
								</c:forEach>
							</select>
                    	</td>
                    	<th>금액</th>
						<td><input type="number" id="payCost"></td>
                  	</tr>
                  	<tr>
						<th>좌석 구분</th>
                    	<td>
							<select id="seatDvsn">
								<option value="">좌석 구분 선택</option>
								<c:forEach items="${seatDvsn}" var="seatDvsn">
									<option value="${seatDvsn.code}">${seatDvsn.codenm}</option>
								</c:forEach>
							</select>
                    	</td>
						<th>지불 구분</th>
                    	<td>
							<select id="payDvsn">
								<option value="">지불 구분 선택</option>
								<c:forEach items="${payDvsn}" var="payDvsn">
									<option value="${payDvsn.code}">${payDvsn.codenm}</option>
								</c:forEach>
							</select>
                    	</td>
                  	</tr>
                  	<tr style="display: none;">
						<th>오전 좌석 금액</th>
						<td><input type="hidden" id="payAmCost" value=0></td>
						<th>오후 좌석 금액</th>
						<td><input type="hidden" id="payPmCost" value=0></td>
                  	</tr>
              	</tbody>
          	</table>
      	</div>
      	<div class="right_box">
			<a href="#" onClick="floorService.fn_seatUpdate()" class="blueBtn">확인</a>
          	<a href="javascript:bPopupClose('bld_seat_add');" class="grayBtn">취소</a>
      	</div>
		<div class="clear"></div>
	</div>
</div>

<!-- 좌석구역 생성 팝업 // -->
<!-- // 구역 생성 팝업 -->
<div id="bld_section_add" data-popup="bld_section_add" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">구역 정보</h2>
      <div class="pop_wrap">
          <table class="detail_table">
			<tbody>
				<tr>
					<th>구역 명</th>
					<td><input type="text" id="partNm"></td>
                    <th>구역 CSS</th>
                    <td><input id="partCss" type="text"></td>
				</tr>
				<tr>
                    <th>웹 도면 이미지</th>
                    <td><input type="file" id="partMap1"></td>
                    <th>사용 유무</th>
                    <td>
						<label for="part_use_yn_y"><input id="part_use_yn_y" type="radio" name="part_use_yn" value="Y" checked>Y</label>
						<label for="part_use_yn_n"><input id="part_use_yn_n" type="radio" name="part_use_yn" value="N">N</label>
                    </td>
				</tr>
				<tr>
                    <th>정렬 순서</th>
                    <td><input type="number" id="partOrder" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
					<th>좌석 네이밍</th>
                    <td><input type="text" id="partSeatRule"></td>
				</tr>
				<tr>
                    <th>미니맵 CSS</th>
                    <td><input type="text" id="partMiniCss"></td>
                    <td colspan="2"></td>
				</tr>
				<tr>
                    <th>미니맵 LEFT</th>
                    <td><input type="number" id="partMiniLeft" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
					<th>미니맵 TOP</th>
                    <td><input type="number" id="partMiniTop" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
				</tr>  
				<tr>
                    <th>미니맵 WIDTH</th>
                    <td><input type="number" id="partMiniWidth" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
					<th>미니맵 HEIGHT</th>
                    <td><input type="number" id="partMiniHeight" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
				</tr>                
			</tbody>
		</table>
      </div>
      <div class="right_box">
          <a href="javascript:partFunc.fn_partUpdate();" id="partInfoUpdateBtn" class="blueBtn">저장</a>
          <a href="javascript:bPopupClose('bld_section_add');" class="grayBtn">취소</a>
      </div>
      <div class="clear"></div>
  </div>
</div>

<!-- 좌석 GUI설정 팝업 -->
<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right" id="cbp-spmenu-s2">
	<a href="javascript:showLeft()">닫기</a>
	<!-- contents -->
	<div class="content">
		<h2 class="title only_tit"><span class="sp_title"></span>위치 GUI Mode</h2>
	</div>
	
	<div class="content back_map">
		<div class="box_shadow w1100 float_left">
			<div class="box_padding">						
				<div class="page pinch-zoom-parent">
					<div class="pinch-zoom" style="transform:unset !important;">
						<div class="map_box_sizing">
							<div class="mapArea floatL">
								<ul id="seat_list">
								
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="box_shadow w400 float_left left24">
			<div class="custom_bg">
				<div class="txt_con">
					<p>Business area</p>
					<div class="btn_bot">
						<a href="javascript:search()" class="defaultBtn">검색</a>
						<!-- <a href="" class="defaultBtn">초기화</a> -->
					</div>
				</div>
				
				<table class="search_tab">
					<tbody>
						<tr>
							<th>층</th>
							<td>
								<select class="" id="searchFloorCd" name="searchFloorCd" onChange="fn_floorChange('search');">
									<option value="">검색 층수</option>
									<c:forEach items="${floorListSeq}" var="floorList">
										<option value="${floorList.floor_cd}">${floorList.floor_nm}</option>
									</c:forEach>
								</select>
							</td>
							<th>구역</th>
							<td>
								<select class="" id="searchPartCd" name="searchPartCd">
									<option value="">검색 구역</option>						
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div class="box_padding">
				<div class="gui_text">
					<div class="txt_con">
						<p><span class="sp_title"></span>위치</p>
						<a href="javascript:save('0')" class="defaultBtn">저장</a>
					</div>
					
					<div class="scroll_table">
						<div class="scroll_div">
							<table class="total_tab gui_table" id="seat_resultList">
								<thead>
									<tr>
									<th style="float: left;"><span class="sp_title"></span>이름</th>
									<th style="left: 14%; float: left;">Top</th>
									<th style="right: 19.6%; float: right;">Left</th>
									</tr>
								</thead>
								<tbody>
								
								</tbody>
							</table>
						</div>
					</div>
				</div>				        
			</div>
		</div>
	</div>
</nav>

<!-- 구역 생성 팝업 // -->
<!-- // 좌석 위치 세팅 팝업 -->
<div data-popup="bld_seat_setting" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">좌석 GUI 위치 셋팅</h2>
      <div class="pop_wrap pop_seat_setting">
        <div class="mapArea" style="background: url(/resources/img/floor_bg.png) no-repeat center;">
          <div class="subTitle left_box">1층 - A구역</div>
          <ul class="seat">
            <li><span>1</span></li>
            <li><span>2</span></li>
            <li><span>3</span></li>
            <li><span>4</span></li>
            <li><span>5</span></li>
            <li><span>6</span></li>
            <li><span>7</span></li>
            <li><span>8</span></li>
            <li><span>9</span></li>
            <li><span>10</span></li>
          </ul>
        </div>
        <div class="seatLocationInfo">
          <div class="subTitle left_box">좌석 위치 </div>
          <a href="" class="blueBtn right_box">저장</a>
          <div class="clear"></div>
          <table class="main_table">
            <thead>
              <tr>
                <th>좌석 이름</th>
                <th>가격</th>
                <th>등급</th>
                <th>구분</th>
                <th>Top</th>
                <th>Left</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
              <tr>
                <td><input type="text"></td>
                <td><input type="text"></td>
                <td>
                  <select>
                    <option value="0">등급</option>
                  </select>
                </td>
                <td>
                  <select>
                    <option value="0">구분</option>
                  </select>
                </td>
                <td><input type="text" class="positionValue"></td>
                <td><input type="text" class="positionValue"></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
  </div>
</div>
<!-- 좌석 위치 세팅 팝업 // -->
<script src="/js/kses/common.js"></script>
</form:form>

	<script type="text/javascript">
		$(document).ready(function() { 
			jqGridFunc.setGrid("mainGrid");
		});
		
		//bpop 확인 하기 
		$('[data-popup-open]').bind('click', function () {
			var targeted_popup_class = jQuery(this).attr('data-popup-open');
			$('[data-popup="' + targeted_popup_class + '"]').bPopup();
		});
		 
		$('[data-popup-close]').on('click', function(e)  {
			var targeted_popup_class = jQuery(this).attr('data-popup-close');
			$('[data-popup="' + targeted_popup_class + '"]').fadeOut(1000).bPopup().close();
			$('body').css('overflow', 'auto');
			e.preventDefault(); 
		});
		
		var jqGridFunc = {
			setGrid : function(gridOption) {
				var grid = $('#'+gridOption);
				var postData = {"centerCd": $("#centerCd").val()};
				
				grid.jqGrid({
					url : '/backoffice/bld/floorListAjax.do',
					mtype : 'POST',
					datatype :'json',
					pager: $('#pager'),  
					ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
					ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
					ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
	    		    postData :  JSON.stringify( postData ),
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
						{ label: 'floor_cd', name: 'floor_cd', key: true,  index: 'floor_cd', align: 'center', hidden: true},
						{ label: '도면이미지', name: 'floor_map1', index: 'floor_map1',  align: 'center', formatter: jqGridFunc.imageFomatter},
						{ label: '층수', name: 'floor_info_txt', index: 'floor_info_txt', align: 'center'},
						{ label: '층 이름', name: 'floor_nm', index: 'floor_nm', align: 'center'},
						{ label: '좌석 현황', name:'floor_seat_cnt', index: 'floor_seat_cnt', align: 'center'},
						{ label: '사용 유무', name:'use_yn', index: 'use_yn', align: 'center'},
						{ label: 'floor_part_dvsn', name:'floor_part_dvsn', index:'floor_part_dvsn', align:'center', hidden:true},
		                { label: '구역사용', name:'floor_part', index:'floor_part', align:'center', formatter: jqGridFunc.partInfoFomatter},
						{ label: '수정자', name:'last_updusr_id', index:'last_updusr_id', align:'center'},
						{ label: '수정일자', name: 'last_updt_dtm', index: 'last_updt_dtm', align: 'center', sortable: 'date'}
						//{ label: '삭제', name: 'btn',  index:'btn', align:'center', fixed: true, sortable: false, formatter: jqGridFunc.rowBtn}
					],
					//레코드 수
					rowNum : 10, 
					// 페이징 수
					rowList : [10,20,30,40,50,100],  
					pager : pager,
					refresh : true,
					// 리스트 순번
					rownumbers : true,
					// 하단 레코드 수 표기 유무
					viewrecord : true,
					// true 데이터 한번만 받아옴
					//loadonce : true,      
					loadui : "enable",
					loadtext:'데이터를 가져오는 중...',
					//빈값일때 표시
					emptyrecords : "조회된 데이터가 없습니다",  
					height : "100%",
					autowidth : true,
					shrinkToFit : true,
					refresh : true,
					// 서브 그리드 세팅
					subGrid: true,
					subGridRowExpanded: showChildGrid, 
					subGridBeforeExpand : function (pID, id) {
						//alert("pID:" + pID + ":" + id);
					},
					isHasSubGrid : function (rowId) {
						var cell = grid.jqGrid('getCell', rowId, "floor_part_dvsn");

						if(cell === "FLOOR_PART_2") {
							return false;
						}
						return true;
					},
					subGridOptions :{
						plusicon: "ui-icon-triangle-1-e",
						minusicon: "ui-icon-triangle-1-s",
						openicon: "ui-icon-arrowreturn-1-e"
					},
					loadComplete : function (data) {
						//$("#mainGrid_subgrid").text("구역");
						$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
					},
					loadERROR : function(xhr, status, error) {
						alert("ERROR : " + error); 
					},
					onSelectRow: function(rowId) {
						if(rowId != null) { 
							//멀트 체크 할떄 특정 값이면 다른 값에 대한 색 변경 	
						}
						// 체크 할떄
					},
					ondblClickRow : function(rowid, iRow, iCol, e){
						grid.jqGrid('editRow', rowid, {keys: true});
					},
					onCellSelect : function (rowid, index, contents, action){
						var cm = $(this).jqGrid('getGridParam', 'colModel');
						
						if (cm[index].name !='btn'){
							floorService.fn_floorInfo("Edt", $(this).jqGrid('getCell', rowid, 'floor_cd'));
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
			imageFomatter : function(cellvalue, options, rowObject){
				var floorMap1 = (rowObject.floor_map1 == "no_image.png" || rowObject.floor_map1 == undefined ) ? "/resources/img/no_image.png" : "/upload/"+ rowObject.floor_map1;
				return '<img src="' + floorMap1 + ' " style="width:100px">';
			},
			centerInfoButton : function (cellvalue, options, rowObject) {
				return '<a href="javascript:jqGridFunc.fn_centerInfo(&#39;'+rowObject.center_cd+'&#39;);" class="blueBtn">지점 관리</a>';	
			},
			rowBtn : function (cellvalue, options, rowObject){
				if (rowObject.floor_cd != "")
				return '<a href="#"><img src="/resources/img/del.png" onclick="javascript:jqGridFunc.delRow(&#34;'+rowObject.floor_cd+'&#34;)"></a>';
			}, 
			refreshGrid : function(){
				$('#mainGrid').jqGrid().trigger("reloadGrid");
			}, 
			delRow : function (floor_cd){
				if(floor_cd != "") {
					var params = {'floorCd' : floor_cd};
					fn_uniDelAction("/backoffice/bld/floorInfoDelete.do", params, "jqGridFunc.fn_search");
				}
			},
			clearGrid : function() {
				$("#mainGrid").clearGridData();
			},
			fn_search : function(){
				$("#mainGrid").setGridParam({
					datatype : "json",
					postData : JSON.stringify({
						"pageIndex": $("#pager .ui-pg-input").val(),
						"centerCd": $("#centerCd").val(),
						"searchKeyword" : $("#searchKeyword").val(),
						"pageUnit":$('.ui-pg-selbox option:selected').val()
					}),
					loadComplete : function(data) {
						$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
					}
				}).trigger("reloadGrid");
			},
			fn_partList : function(floorCd) {
				$("#mainGrid").attr('width', 200);
				$("#floorCd").val(floorCd);
				partFunc.fn_partList(floorCd);
			},
			partInfoFomatter : function (cellvalue, options, rowObject){
				//구역 설정 
				var info = 
				(rowObject.floor_part_dvsn === "FLOOR_PART_1") ? "<a href=\"#\" onClick='partFunc.fn_partInfo(\"Ins\", \"0\",\"" 
							+ rowObject.floor_cd+"\",\"" 
							+ rowObject.floor_nm+"\",\"" + rowObject.center_nm +"\")' class=\"blueBtn\">구역 등록</a>"
							: "<a href=\"#\" onClick='floorService.fn_seatSetting(\"" + rowObject.floor_cd+"\", \"0\")' class=\"blueBtn\">좌석 설정</a>";
				return info;
			}
		}
		
		var floorService = {
			fn_seatSetting : function(floorCd, partCd) {
				//좌석 설정 
				$("#floorCd").val(floorCd);
				$("#partCd").val(partCd);
			        
				// 좌석 등록 되어 있는지 아닌지 
				$("#dv_Title").html("좌석 설정");
				
				var params = {
					"floorCd": $("#floorCd").val(),
					"partCd": $("#partCd").val(),
				};
				
				var floorCheck = fn_returnVal("/backoffice/bld/seatCountInfo.do", params, "fn_seatCheck");
				
				$("#tr_seat").show();
			},
			fn_floorInfo : function (mode, floorCd) {
				$("#bld_floor_add").bPopup();
				$("#floorCd").val(floorCd);
				$("#mode").val(mode);
			
				if (mode == "Ins") {
					$("#bld_floor_add .pop_tit").html("층 정보 등록");
					$("#floorInfoUpdateBtn").text('등록');
					  
					$("#floorNm").val("");
					$("#floorPart").val("");
					$("#floorMap1").val("");
					$("#floorSeatRule").val("");
					$("input:radio[name='floor_use_yn']:radio[value='Y']").prop('checked', true);
				} else {
					var url = "/backoffice/bld/floorInfoDetail.do";
					var param = {"floorCd" : floorCd};
	      			  
					uniAjax
					(
					    url, 
						param, 
						function(result) {
							if (result.status == "LOGIN FAIL") {
								alert(result.meesage);
								location.href="/backoffice/login.do";
							} else if (result.status == "SUCCESS") {
								var obj = result.regist;
								
								$("#bld_floor_add .pop_tit").html(obj.center_nm + " " + obj.floor_nm + " 층 정보 수정");
								$("#floorInfoUpdateBtn").text('저장');
								
								$("#floorNm").val(obj.floor_nm);
								$("#floorPartDvsn").val(obj.floor_part_dvsn);
								$("#floorSeatRule").val(obj.floor_seat_rule);
								$("input:radio[name='floor_use_yn']:radio[value='" + obj.use_yn + "']").prop('checked', true);
							}
						},
						function(request) {
							alert("ERROR : " +request.status);	       						
						}    		
					);
				}
			},
			fn_floorUpdate : function() {
			    //층 업데이트
			    if (any_empt_line_id("floorNm", "층명을 입력해주세요.") == false) return;
			    if (any_empt_line_id("floorPartDvsn", "구역 사용 여부를 선택해 주세요.") == false) return;
			    
				var commentTxt = ($("#mode").val() == "Ins") ? "신규 층 정보를 등록 하시겠습니까?" : "입력한 층 정보를 저장 하시겠습니까?";
				var resultTxt = ($("#mode").val() == "Ins") ? "신규 층 정보가 정상적으로 등록 되었습니다." : "층 정보가 정상적으로 저장 되었습니다.";
			    
				if (confirm(commentTxt) == true) {
			        //체크 박스 체그 값 알아오기 
			        var formData = new FormData();
			        formData.append('floorMap1', $('#floorMap1')[0].files[0]);
			        formData.append('floorCd', $("#floorCd").val());
			        formData.append('centerCd', $("#centerCd").val());
			        formData.append('floorNm', $("#floorNm").val());
			        formData.append('useYn', $('input[name=floor_use_yn]:checked').val());
			        formData.append('floorSeatRule', $("#floorSeatRule").val());
			        formData.append('floorPartDvsn', $("#floorPartDvsn").val());
			        formData.append('mode', $("#mode").val());
			        
			        uniAjaxMutipart
			        (
						"/backoffice/bld/floorInfoUpdate.do", 
						formData,
			            function(result) {
							if (result.status == "SUCCESS") {
								alert(resultTxt);
								$("#bld_floor_add").bPopup().close();
			                    jqGridFunc.fn_search();
			                } else if (result.status == "LOGIN FAIL") {
			                    document.location.href = "/backoffice/login.do";
			                } else {
								alert(result.message);
			                }
			            },
			            function(request) {
			                alert("ERROR : " + request.status);
			            }
			        );
			    }
			},
			fn_floorState : function() {
			    if ($("#floorInfo").val() != $("#nowVal").val())
			        $("#newVal").val($("#floorInfo").val().replace("CENTER_FLOOR_", ""));
			},
			fn_seatUpdate : function() {
			    //좌석 업데이트 하기 
			    if (any_empt_line_id("seatStr", "장비 시작 카운터을 선택해주세요.") == false) return;
			    if (any_empt_line_id("seatEnd", "장비 종료 카운터를 선택해주세요.") == false) return;
			    if (fnIntervalCheck($("#seatStr").val(), $("#seatEnd").val(), "시작이 종료 보다 클수 없습니다.") == false) return;

			    alert($("#partCd").val());
			    
			    
			    var url = "/backoffice/bld/floorSeatUpdate.do";
			    var params = {
			        "floorCd": $("#floorCd").val(),
			        "partCd": $("#partCd").val(),
			        "seatStr": $("#seatStr").val(),
			        "seatEnd": $("#seatEnd").val(),
			        "seatClass": $("#seatClass").val(),
			        "seatDvsn": $("#seatDvsn").val(),
			        "payDvsn": $("#payDvsn").val(),
			        "payCost": fn_emptyReplace($('#payCost').val(), "0"),
			        "payAmCost": fn_emptyReplace($('#payAmCost').val(), "0"),
			        "payPmCost": fn_emptyReplace($('#payPmCost').val(), "0"),
			    };
			    uniAjax(url, params,
			        function(result) {
			    		console.logai;
			            if (result.status == "LOGIN FAIL") {
			                alert(result.meesage);
			                location.href = "/backoffice/login.do";
			            } else if (result.status == "SUCCESS") {
			                //정상적으로 좌석 등록 되었으면 좌석 세팅 페이지로 넘어가기
			                alert("좌석이 정상적으로 생성되었습니다.")
			                jqGridFunc.fn_search();
			                showLeft();
			                fn_GuiSearch();
			                $('#bld_seat_add').bPopup().close();
			            } else {
			                alert(result.message);
			            }
			        },
			        function(request) {
			            alert("ERROR : " + request.status);
			        }
			    );
			}
		}
		
		//sub쿼리 
		function showChildGrid(subgrid_id, row_id) {
			var param = {"floorCd" : row_id, "pageIndex" : fn_emptyReplace($("#pageIndex").val(), "1"), "pageSize" : "100" }
			var subgrid_table_id, pager_id;
			
			subgrid_table_id = subgrid_id+"_t";
			pager_id = "p_"+subgrid_table_id;
			jQuery("#"+subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
			jQuery("#"+subgrid_table_id).jqGrid({
				url:"/backoffice/bld/partListAjax.do",
				mtype : 'POST',
				datatype :'json',
	                
	            ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
 		        ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
 		        ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
 		        
 		        postData :  JSON.stringify(param),
 		        jsonReader : {
					root : 'resultlist',
					"page":"paginationInfo.currentPageNo",
					"total":"paginationInfo.totalPageCount",
					"records":"paginationInfo.totalRecordCount",
					repeatitems:false
				},
				// 상단면
				colModel :  
				[
	                	{ label: 'part_cd', key: true, name:'part_cd', index:'part_cd', align:'center', hidden:true},
	                	{ label: 'center_nm', name:'center_nm', index:'center_nm', align:'center', hidden:true},
	                	{ label: 'floor_cd', name:'floor_cd', index:'floor_cd', align:'center', hidden:true},
	                	{ label: 'floor_nm', name:'floor_nm', index:'floor_nm', align:'center', hidden:true},
	                	{ label: '구역명', name:'part_nm', index:'part_nm', align:'center'},
	 	                { label: '도면이미지', name:'part_map1', index:'part_map1', align:'center', formatter:partFunc.imageFomatter},
	 	                { label: '좌석 네이밍', name:'part_seat_rule', index:'part_seat_rule', align:'center'},
	 	                { label: '미니맵Top', name:'part_mini_top', index:'part_mini_top', align:'center'},
	 	                { label: '미니맵Left', name:'part_mini_left', index:'part_mini_left', align:'center'},
		                { label: '미니맵Css', name:'part_mini_css', index:'part_mini_css', align:'center'},
		                { label: '정렬순서', name:'part_order', index:'part_order', align:'center'},
		                { label: '사용유무', name:'use_yn', index:'use_yn', align:'center'},
		                { label: '좌석설정', name:'seat_cnt', index:'seat_cnt', align:'center', formatter:partFunc.partSeatSetting},
						{ label: '수정자', name:'last_updusr_id', index:'last_updusr_id', align:'center'},
						{ label: '수정일자', name: 'last_updt_dtm', index: 'last_updt_dtm', align: 'center', sortable: 'date'},
		                { label: '삭제', name: 'btn', index:'btn', align:'center', fixed:true, sortable : false, formatter:partFunc.rowBtn}
				],  
				rowNum : 20, 
				height: '100%',
				//pager: pager_id,
				autowidth : true,
 		        shrinkToFit : true,
 		        refresh : true,
				rowNum : 20,
				sortname: 'update_date',
				sortorder: "asc",
				onCellSelect : function (rowid, index, contents, action) {
					var cm = $(this).jqGrid('getGridParam', 'colModel');
					var center_nm = $(this).jqGrid('getCell', rowid, 'center_nm');
					var part_cd = $(this).jqGrid('getCell', rowid, 'part_cd');
					var floor_cd = $(this).jqGrid('getCell', rowid, 'floor_cd');
					var floor_nm = $(this).jqGrid('getCell', rowid, 'floor_nm');
					
					if (cm[index].name !='btn'){
						partFunc.fn_partInfo("Edt", part_cd, floor_cd, floor_nm, center_nm);
					}
 	            },
 	            loadComplete : function (data){
 	            	console.log(data);
 		        },
 		        refreshGrid : function(){
 		        	$('#'+ subgrid_id).jqGrid().trigger("reloadGrid");
 	            },
				//체크박스 선택시에만 체크박스 체크 적용
				beforeSelectRow: function (rowid, e) { 
					var $myGrid = $(this), i = $.jgrid.getCellIndex($(e.target).closest('td')[0]), 
					cm = $myGrid.jqGrid('getGridParam', 'colModel'); 
					return (cm[i].name === 'cb'); 
				}
			});
		}
		
		var partFunc = {
			imageFomatter: function(cellvalue, options, rowObject) {
				var partMap1 = (rowObject.part_map1 == "no_image.png" || rowObject.part_map1 == undefined ) ? "/resources/img/no_image.png" : "/upload/"+ rowObject.part_map1;
				return '<img src="' + partMap1 + ' " style="width:100px">';
			},
			rowBtn: function(cellvalue, options, rowObject) {
			    if (rowObject.part_cd != "" && rowObject.floor_cd != "")
			    	
			        return '<a href="#"><img src="/resources/img/del.png" onclick="javascript:partFunc.delRow(&#34;' + rowObject.part_cd + '&#34;,&#34;' + rowObject.floor_cd + '&#34;)"></a>';
			},
			delRow: function(part_cd, floor_cd) {
			    var params = {
			        "partCd": part_cd
			    }
			    fn_uniDelAction("/backoffice/bld/partInfoDelete.do", params, "partFunc.fn_search", part_cd);
			},
			partSeatSetting : function(cellvalue, options, rowObject) {
			    return '<a href="javascript:floorService.fn_seatSetting(&#34;' + rowObject.floor_cd + '&#34;,&#34;' + rowObject.part_cd + '&#34;);" class="redsel">' + rowObject.seat_cnt + '</a>';
			},
			fn_search: function(gridId) {
			    console.log("gridId:" + gridId)
			    $("#mainGrid_" + gridId + "_t").setGridParam({
			        datatype: "json",
			        postData: JSON.stringify({
			            "floorCd": gridId,
			            "pageIndex": 1,
			        }),
			        loadComplete: function(data) {}
			    }).trigger("reloadGrid");
			},
			fn_partUpdate : function() {
			    //구역 업데이트
			    if (any_empt_line_id("partNm", "구역명을 입력해주세요.") == false) return;
			    
				var commentTxt = ($("#mode").val() == "Ins") ? "신규 구역 정보를 등록 하시겠습니까?" : "입력한 구역 정보를 저장 하시겠습니까?";
				var resultTxt = ($("#mode").val() == "Ins") ? "신규 구역 정보가 정상적으로 등록 되었습니다." : "구역 정보가 정상적으로 저장 되었습니다.";
			    
				if (confirm(commentTxt) == true) {

			        //체크 박스 체그 값 알아오기 
			        var formData = new FormData();
			        
			        formData.append('centerCd', $("#centerCd").val());
			        formData.append('floorCd', $("#floorCd").val());
			        formData.append('partCd', $("#partCd").val());
			        formData.append('partMap1', $('#partMap1')[0].files[0]);
			        formData.append('partCss', $("#partCss").val());
			        formData.append('partSeatRule', $("#partSeatRule").val());
			        formData.append('partNm', $("#partNm").val());
			        formData.append('partMiniCss', $("#partMiniCss").val());
			        formData.append('partMiniTop', fn_emptyReplace($("#partMiniTop").val(), "0"));
			        formData.append('partMiniLeft', fn_emptyReplace($("#partMiniLeft").val(), "0"));
			        formData.append('partMiniWidth', fn_emptyReplace($("#partMiniWidth").val(), "0"));
			        formData.append('partMiniHeight', fn_emptyReplace($("#partMiniHeight").val(), "0"));
			        formData.append('partOrder', fn_emptyReplace($("#partOrder").val(), "0"));
			        formData.append('useYn', fn_emptyReplace($('input[name=part_use_yn]:checked').val(), "Y"));
			        formData.append('mode', $("#mode").val());
			        uniAjaxMutipart
			        (
						"/backoffice/bld/partUpdate.do", 
						formData,
			            function(result) {
			                if (result.status == "SUCCESS") {
								$("#bld_section_add").bPopup().close();
								alert(resultTxt);
			                    /* jqGridFunc.fn_search(); */
			                    partFunc.fn_search($("#floorCd").val());
			                } else if (result.status == "LOGIN FAIL") {
			                    document.location.href = "/backoffice/login.do";
			                } else {
			                    alert(result.message);
			                }
			            },
			            function(request) {
			                alert("ERROR : " + request.status);
			            }
			        );
			    }
			},
			fn_partInfo: function(mode, partCd, floor_cd, floor_nm, center_nm) {
				$("#bld_section_add").bPopup();
				$("#floorCd").val(floor_cd);
				$("#partCd").val(partCd);
				$("#mode").val(mode);
				
			    if (mode == "Ins") {
					$("#bld_section_add .pop_tit").html(center_nm + " " + floor_nm + " 구역 정보 등록");
					$("#partInfoUpdateBtn").text('저장');
			    	
                    $("#partNm").val("");
                    $("#partCss").val("");
                    $("#partMap1").val("");
                    $("#partSeatrule").val("");
                    $("#partMiniCss").val("");
                    $("#partMiniTop").val("");
                    $("#partMiniLeft").val("");
                    $("#partMiniWidth").val("");
                    $("#partMiniHeight").val("");			                    
                    $("#partOrder").val("");
					$("input:radio[name='part_use_yn']:radio[value='Y']").prop('checked', true);
			        
			    } else {
			        var url = "/backoffice/bld/partDetail.do";
			        var param = {
			            "partCd" : partCd
			        };
			        uniAjaxSerial
			        (
						url, 
						param,
			            function(result) {
			                if (result.status == "LOGIN FAIL") {
			                    alert(result.meesage);
			                    location.href = "/backoffice/login.do";
			                } else if (result.status == "SUCCESS") {
			                    var obj = result.regist;
			                	
			                	$("#bld_section_add .pop_tit").html(obj.center_nm + " " + obj.floor_nm + " " + obj.part_nm +  "구역 정보 수정");
			                    $("#btnPartUpdate").text('수정');

			                    $("#partNm").val(obj.part_nm);
			                    $("#partCss").val(obj.part_css);
			                    $("#partSeatRule").val(obj.part_seat_rule);
			                    $("#partMiniCss").val(obj.part_mini_css);
			                    $("#partMiniTop").val(obj.part_mini_top);
			                    $("#partMiniLeft").val(obj.part_mini_left);
			                    $("#partMiniWidth").val(obj.part_mini_width);
			                    $("#partMiniHeight").val(obj.part_mini_height);			                    
			                    $("#partOrder").val(obj.part_order);
			                    $("input:radio[name='part_use_yn']:radio[value='" + obj.use_yn + "']").prop('checked', true);
			                }
			            },
			            function(request) {
			                alert("ERROR : " + request.status);
			            }
			        );
			    }
			}
		}
  	</script>

 	<script type="text/javascript">
	 	var menuRight = document.getElementById('cbp-spmenu-s2')
	
	 	function fn_partInfo() {
	 	    //구역 확인 한 다음 있는지 처리
			var url = "/backoffice/bld/partInfoComboList.do";
			var param = {"floorCd" : floorCd};
  			  
			uniAjax
			(
			    url, 
				param, 
				function(result) {
					if (result.status == "LOGIN FAIL") {
						alert(result.meesage);
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						if(result.regist != null) {
							var partInfoComboList = result.regist;
							
							$("#searchPartCd").empty();
							$("#searchPartCd").append("<option value=''>구역 선택</option>");
							
							for (var i in partInfoComboList) {
								$("#searchPartCd").append("<option value='"+ partInfoComboList[i].part_cd +"'>"+ partInfoComboList[i].part_nm +"</option>");
							}
							$("#searchPartCd").val(centerCd);
						}
					}
				},
				function(request) {
					alert("ERROR : " +request.status);	       						
				}    		
			);
	 	}
	
	 	function fn_seatCheck(count) {
	 	    if (parseInt(count) > 0) {
	 	        showLeft();
	 	        fn_GuiSearch();
	 	    } else {
	 	        $("#seatStr").val("1");
	 	        $("#seatEnd").val("1");
	 	        $("#seatClass").val("");
	 	       	$("#seatDvsn").val("");
	 	      	$("#payDvsn").val("");
	 	        $("#payCost").val("0");
	 	       	$("#payAmCost").val("0");
	 	      	$("#payPmCost").val("0");
	 	        $("#bld_seat_add").bPopup();
	 	    }
	 	}
	 	
	 	function showLeft() {
	 	    classie.toggle(menuRight, 'cbp-spmenu-open');
	 	}
	 	
	 	function fn_GuiSearch() {
			var url = "seatListAjax.do";
			var title = "좌석";
			
	 	    $(".sp_title").text(title);
	 	    
 	    	$("#searchFloorCd").val($("#floorCd").val());
 	    	fn_floorChange("search");
 	    	
 	    	var partCd = $("#partCd").val() == "0" ? "" : $("#partCd").val(); 
 	    	$("#searchPartCd").val(partCd);
			
	 	    
	 	    var params = {
	 	        "searchCenter": $("#centerCd").val(),
	 	        "searchFloorCd": $("#floorCd").val(),
	 	        "searchPartCd": $("#partCd").val(),
	 	        "pageUnit": "100"
	 	    };
	 	    
	 	    uniAjax
	 	    (
				"/backoffice/bld/" + url, 
				params,
	 	        function(result) {
	 	            if (result.status == "LOGIN FAIL") {
	 	                alert(result.message);
	 	                location.href = "/backoffice/login.do";
	 	            } else if (result.status == "SUCCESS") {
	 	                //테이블 정리 하기
	 	                console.log(result);
	 	                if (result.seatMapInfo != null) {
	 	                    var img = $("#partCd").val() != "0" ? result.seatMapInfo.part_map1 : result.seatMapInfo.floor_map1;
	 	                    $('.mapArea').css({
	 	                        "background": "#fff url(/upload/" + img + ")",
	 	                        'background-repeat': 'no-repeat',
	 	                        'background-position': ' center'
	 	                    });
	 	                } else {
	 	                    $('.mapArea').css({
	 	                        "background": "#fff url()",
	 	                        'background-repeat': 'no-repeat',
	 	                        'background-position': ' center'
	 	                    });
	 	                }
	 	                
						$("#seat_resultList > tbody").empty();
	
	 	                if (result.resultlist.length > 0) {
	 	                    var shtml = '';
	 	                    var obj = result.resultlist;
								
	 	                        for (var i in result.resultlist) {
	 	                            shtml += '<li id="s' + trim(CommonJsUtil.NVL(obj[i].seat_nm)) + '" class="seat" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_cd + '" >' + CommonJsUtil.NVL(obj[i].seat_order) + '</li>';
	 	                        }
	 	                        $('#seat_list').html(shtml);
	 	                        for (var i in result.resultlist) {
	 	                            $('.mapArea ul li#s' + trim(CommonJsUtil.NVL(obj[i].seat_nm))).css({
	 	                                "top": CommonJsUtil.NVL(obj[i].seat_top) + "px",
	 	                                "left": CommonJsUtil.NVL(obj[i].seat_left) + "px"
	 	                            });
	 	                        }
	 	                        $('.seat').dragmove();
	 	                        $("#seat_resultList > tbody").empty();
	 	                        if (result.resultlist.length > 0) {
	 	                            var obj = result.resultlist;
	 	                            var shtml = "";
	 	                            for (var i in obj) {
	 	                                shtml += "<tr>" +
	 	                                    "   <td>" + obj[i].seat_nm + "" +
	 	                                    "   <input type='hidden' id='seat_cd' name='seat_cd' value='" + obj[i].seat_cd + "'></td>" +
	 	                                    "   <td><a href='javascript:top_up(&#34;" + obj[i].seat_cd + "&#34;)' class='up'></a>" +
	 	                                    "   <input type='text' id='top_" + obj[i].seat_cd + "' name='top_" + obj[i].seat_cd + "' value='" + obj[i].seat_top + "' onchange='top_chage(&#34;" + obj[i].seat_cd + "&#34;, this.value)'>" +
	 	                                    "   <a href='javascript:top_down(&#34;" + obj[i].seat_cd + "&#34;)' class='down'></a></td>" +
	 	                                    "   <td><a href='javascript:left_up(&#34;" + obj[i].seat_cd + "&#34;)' class='leftB'></a>" +
	 	                                    "   <input type='text' id='left_" + obj[i].seat_cd + "' name='left_" + obj[i].seat_cd + "' value='" + obj[i].seat_left + "' onchange='left_chage(&#34;" + obj[i].seat_cd + "&#34, this.value)'>" +
	 	                                    "   <a href='javascript:left_down(&#34;" + obj[i].seat_cd + "&#34;)' class='rightB'></a></td>" +
	 	                                    "</tr>";
	 	                                $("#seat_resultList > tbody").append(shtml);
	 	                                shtml = "";
	 	                            }
	
	 	                        }
	 	                } else {
	 	                    $('#seat_list').html('');
	 	                    ""
	 	                }
	 	            } else {
	 	                alert(result.message);
	 	            }
	 	        },
	 	        function(request) {
	 	            alert("ERROR : " + request.status);
	 	        }
	 	    );
	 	}
	

	 	
	 	function search() {
 	    	$("#floorCd").val($("#searchFloorCd").val());
 	    	$("#partCd").val($("#searchPartCd").val());
 	    	
			if($("#searchFloorCd option").length > 1){
				if (any_empt_line_id("floorCd", "층을 선택해주세요.") == false) return;	
			}
			if($("#searchPartCd option").length > 1){
				if (any_empt_line_id("partCd", "구역을 선택해주세요.") == false) return;
			} else {
				$("#partCd").val("0");
			}
			
 	    	fn_GuiSearch();
	 	}
	 	
	 	function fn_floorChange(division) {
			var el = division == "search" ? $("#searchFloorCd") : $("#floorCd");
			var targetEl = division == "search" ? $("#searchPartCd") : $("#partCd");
			var url = "/backoffice/bld/partInfoComboList.do?floorCd=" + el.val();
			var param = {"floorCd" : el.val()}
			fn_comboList(targetEl, url, param);
		}
		
	 	function fn_comboList(el, url, param) {
			var returnVal = uniAjaxReturn(url, param);
			if (returnVal.resultlist.length > 0){
				var obj = returnVal.resultlist;
				el.empty();
				el.append("<option value=''>선택</option>");
					
				for (var i in obj) {
					var array = Object.values(obj[i])
					el.append("<option value='"+ array[0]+"'>"+array[1]+"</option>");
				}
			} else {
				//값이 없을때 처리 
				el.empty();
				el.append("<option value=''>선택</option>");
			}
		}
	

	
	 	function save() {
	 	    if (confirm('저장 하시겠습니까?')) {
	 	        var SeatsArray = new Array();
	 	        //여기 부분 좌표값으로 가지고 오기 
	 	        $("input:hidden[name=seat_cd]").each(function() {
	
	 	            var SeatsView = new Object();
	 	            SeatsView.seatCd = $(this).val();
	 	            SeatsView.seatTop = $("#top_" + SeatsView.seatCd).val(); // $(this).css('top').replace('px', '');
	 	            SeatsView.seatLeft = $("#left_" + SeatsView.seatCd).val(); //$(this).css('left').replace('px', '');
	 	            SeatsArray.push(SeatsView);
	 	        });

	 	        var param = new Object();
	
	 	        param.data = SeatsArray;
	 	        if (SeatsArray.length == 0) {
	 	            alert('저장할 내용이 없습니다.');
	 	            return false;
	 	        }

	 	        var url = "/backoffice/bld/seatGuiUpdate.do";
	 	        uniAjax(url, param,
	 	            function(result) {
	 	                if (result.status == "LOGIN FAIL") {
	 	                    alert(result.meesage);
	 	                    location.href = "/backoffice/login.do";
	 	                } else if (result.status == "SUCCESS") {
	 	                    alert('수정되었습니다.');
	 	                    fn_GuiSearch();
	 	                } 
	 	            },
	 	            function(request) {
	 	                alert("ERROR : " + request.status);
	 	            }
	 	        );
	
	 	    }
	 	}
	
	 	/***********************************
	 	 * + - 버튼
	 	 ************************************/
	 	function top_up(str) {
	 	    var top = parseInt($('#top_' + str).val()) + 1;
	 	    $('#top_' + str).val(top);
	 	    $('li[name="' + str + '"]').css('top', top + 'px');
	 	}
	
	 	function top_down(str) {
	 	    var top = parseInt($('#top_' + str).val()) - 1;
	 	    $('#top_' + str).val(top);
	 	    $('li[name="' + str + '"]').css('top', top + 'px');
	 	}
	
	 	function left_up(str) {
	 	    var left = parseInt($('#left_' + str).val()) + 1;
	 	    $('#left_' + str).val(left);
	 	    $('li[name="' + str + '"]').css('left', left + 'px');
	 	}
	
	 	function left_down(str) {
	 	    var left = parseInt($('#left_' + str).val()) - 1;
	 	    $('#left_' + str).val(left);
	 	    $('li[name="' + str + '"]').css('left', left + 'px');
	 	}
	
	
	 	/***********************************
	 	 * text mode top 수정
	 	 ************************************/
	 	function top_chage(str, str2) {
	 	    console.log('str : ' + str + ', str2 : ' + str2);
	 	    $('li[name="' + str + '"]').css('top', str2 + 'px');
	 	}
	
	 	/***********************************
	 	 * text mode left 수정
	 	 ************************************/
	 	function left_chage(str, str2) {
	 	    $('li[name="' + str + '"]').css('left', str2 + 'px');
	 	}
	</script>
</body>
</html>