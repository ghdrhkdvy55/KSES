<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code="URL.TITLE" /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">   
    
    <link href="/css/reset.css" rel="stylesheet" />
    <link href="/css/global.css" rel="stylesheet" />
    <link href="/css/page.css" rel="stylesheet" />
    <link rel="stylesheet" href="/css/needpopup.min.css" />
    <link rel="stylesheet" href="/css/needpopup.css">
    
    <link rel="stylesheet" type="text/css" href="/css/toggle.css">
    <link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
    
    <script type="text/javascript" src="/js/jquery-2.2.4.min.js"></script>
    
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
	
    <!-- bpopup 사용 -->
    <script type="text/javascript" src="/js/bpopup.js"></script>
    <link rel="stylesheet" href="/css/kiosk/popup.css">
    
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
		.cbp-spmenu a:hover {
			background: #258ecd;
		}
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
    <link rel="stylesheet" href="/css/new/paragraph_new.css"> 
    
</head>
<body>
 <div id="wrapper">	
<form:form name="regist" commandName="regist" method="post"   action="/backoffice/bas/empList.do">
<c:import url="/backoffice/inc/top_inc.do" />
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
								<select class="" id="searchfloorId" name="searchfloorId" onChange="fn_partInfo()">
									<option value="">검색 층수</option>
									<c:forEach items="${floorListSeq}" var="floorList">
										<option value="${floorList.floor_seq}">${floorList.floor_name}</option>
									</c:forEach>
								</select>
							</td>
							<th>구역</th>
							<td><select class="" id="area_id" name="area_id" style="display:none"></select></td>
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
									<th style="float: left;"><span class="sp_title"></span>이름</th>
									<th style="left: 14%; float: left;">Top</th>
									<th style="right: 19.6%; float: right;">Left</th>
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
    


<input type="hidden" name="pageIndex" id="pageIndex">
<input type="hidden" name="mode" id="mode" >
<input type="hidden" name="centerCode" id="centerCode" value="${regist.center_id}">
<input type="hidden" name="floorSeq" id="floorSeq" >
<input type="hidden" name="floorInfos" id="floorInfos" value="${regist.floor_info}">
<input type="hidden" name="nowVal" id="nowVal" >
<input type="hidden" name="newVal" id="newVal" >
<input type="hidden" name="partSeq" id="partSeq" >
<input type="hidden" name="viewMode" id="viewMode" >
<div class="Aconbox">
	<div class="rightT">
		<div class="Smain">
			<div class="Swrap Stitle">
				<div class="infomenuA">
					<img src="/images/home.png" alt="homeicon" />
					<span>></span>
					<spring:message code="menu.menu01" />
					<span>></span>
					<strong>층 정보</strong>
				</div>
			</div>
		</div>

		<div class="Swrap Asearch">
			<div class="Atitle" id="div_totalInfo">
			
			</div>
			<section class="Bclear">
            	<table class="pop_table searchThStyle">
		            <tr class="tableM">
		            	<th><spring:message code="search.chooseTxt" /></th>
		            	<td>
		            		<input class="nameB" type="text" name="searchKeyword" id="searchKeyword" >  
						<a href="javascript:jqGridFunc.fn_search();"><span class="searchTableB"><spring:message code="button.inquire" /></span></a>
		            	</td>
		            	<td class="text-right">
		            		  <a href="#" onclick="floorService.fn_floorInfo('Ins','0')"><span class="deepBtn"> <spring:message code="button.create" /></span></a>
		            	</td>		                	
					</tr>
                </table>
                <br/>                
            </section>
		</div>
            
		<div class="Swrap tableArea">
			<table id="mainGrid"></table>
				<div id="pager" class="scroll" style="text-align:center;"></div>     
               	<br/>
               <div id="paginate"></div>          
		</div>
	</div>
</div>
    
   
<div id='floorPop' class="needpopup">
	<div class="popHead" id="popTitle">
		<h2>층 관리</h2>
	</div>
	
	<!-- pop contents-->   
	<div class="popCon">
		<!--// 팝업 필드박스-->
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">*층명 <span class="join_id_comment joinSubTxt"></span></p>
				<input name="floorName" id="floorName" class="input_noti" size="10"/>    
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">*구역 사용여부 <span class="join_id_comment joinSubTxt"></span></p>
					<select id="floorPart" style="width:120px">
						<option value="">구역 사용여부</option>
						<c:forEach items="${floorPart}" var="partGubun">
							<option value="${partGubun.code}">${partGubun.codeNm}</option>
						</c:forEach>
					</select>
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">웹도면이미지 <span class="join_id_comment joinSubTxt"></span></p>
					<input type="file" id="floorMap" name="floorMap"> 
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">키오스크 도면 이미지 <span class="join_id_comment joinSubTxt"></span></p>
				<input type="file" id="floorMap1" name="floorMap1"> 
			</div>                
		</div>    
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">* 층 선택 <span class="join_id_comment joinSubTxt"></span></p>
				<select id="floorInfo" style="width:120px" onChange="floorService.fn_floorState()">
					<option value="">층 선택</option>
					<c:forEach items="${floorlistInfo}" var="floorList">
						<option value="${floorList.code}">${floorList.codeNm}</option>
					</c:forEach>
				</select>
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">*<spring:message code="common.UseYn.title" /> <span class="join_id_comment joinSubTxt"></span></p>
				<label class="switch">                                               
					<input type="checkbox" id="floorUseyn" onclick="toggleValue(this)" value="Y">
					<span class="slider round"></span> 
				</label>
			</div>                
		</div>
	</div>
	<div class="clear"></div>
	
	<div class="pop_footer">
		<span id="join_confirm_comment" class="join_pop_main_subTxt">내용을 모두 입력후 클릭해주세요.</span>
		<a href="javascript:floorService.fn_floorUpdate();" class="redBtn" id="btnUpdate"><spring:message code="button.create" /></a>    
	</div>   
</div>  
    
<div id='partPop' class="needpopup">
	<div class="popHead" id="popTitle">
		<h2>구역 관리</h2>
	</div>
	
	<!-- pop contents-->   
	<div class="popCon">
		<!--// 팝업 필드박스-->
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">* 층 정보<span class="join_id_comment joinSubTxt"></span></p>
				<select id="part_floorSeq" onChange="floorService.fn_floorState()" style="width:120px;display: none;">
					<option value="">층 선택</option>
					<c:forEach items="${floorListSeq}" var="floorList">
						<option value="${floorList.floor_seq}">${floorList.floor_name}</option>
					</c:forEach>
				</select>
				<span id="sp_floorNm"></span>
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">*구역명 <span class="join_id_comment joinSubTxt"></span></p>
				<input type="text" id="partName" name="partName">    
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">*구역 css <span class="join_id_comment joinSubTxt"></span></p>
				<input type="text" id="partCss" name="partCss">    
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">웹도면이미지 <span class="join_id_comment joinSubTxt"></span></p>
				<input type="file" id="partMap1" name="partMap1"> 
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">키오스크 도면 이미지 <span class="join_id_comment joinSubTxt"></span></p>
				<input type="file" id="partMap2" name="partMap2"> 
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">좌석 규칙 <span class="join_id_comment joinSubTxt"></span></p>
				<input type="text" id="partSeatrule" name="partSeatrule">    
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">미니맵 Top <span class="join_id_comment joinSubTxt"></span></p>
				<input type="number" id="partMiniTop" name="partMiniTop" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">    
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">미니맵 Left <span class="join_id_comment joinSubTxt"></span></p>
				<input type="number" id="partMiniLeft" name="partMiniLeft" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">    
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">미니맵 Css <span class="join_id_comment joinSubTxt"></span></p>
				<input type="text" id="partMiniCss" name="partMiniCss">    
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">정렬순서<span class="join_id_comment joinSubTxt"></span></p>
				<input type="number" id="partOrder" name="partOrder" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
			</div>                
		</div>
		<div class="pop_box50">
			<div class="padding15">
				<p class="pop_tit">*<spring:message code="common.UseYn.title" /> <span class="join_id_comment joinSubTxt"></span></p>
				<label class="switch">                                               
					<input type="checkbox" id="partUseyn" onclick="toggleValue(this)" value="Y">
					<span class="slider round"></span> 
				</label>
			</div>                
		</div>
	</div>
	<div class="clear"></div>
	
	<div class="pop_footer">
		<span id="join_confirm_comment" class="join_pop_main_subTxt">내용을 모두 입력후 클릭해주세요.</span>
		<a href="javascript:partFunc.fn_partUpdate();" class="redBtn" id="btnPartUpdate"><spring:message code="button.create" /></a>    
	</div>   
</div>  
    
<!-- 좌석 설정  -->
<div data-popup="dv_seatSetting" class="popup focusPop">
	<div class="popup_con">
		<span class="button b-close">&times;</span>
		<div class="top" id="dv_Title">좌석 등록</div>
		<div class="con" style="background-color: white;">
			<table id="tb_setting" style="width:450px;">
				<tr>
					<th>설정 범위</th>
						<td colspan="3"  style="text-align:left">
                        <select id="seatStr" name="seatStr">
		                  <c:forEach var="cnt" begin="1" end="100" step="1">
		                     <option value="${cnt}">${cnt}</option>
		                  </c:forEach> 
			             </select>~
			             <select id="seatEnd" name="seatEnd">
			                  <c:forEach var="cnt" begin="1" end="100" step="1">
			                     <option value="${cnt}">${cnt}</option>
			                  </c:forEach> 
			             </select>
                     </td>
                  </tr>
                  <tr id="tr_seat">
                     <th>예약구분</th>
                     <td style="text-align:left">
                         <select id="seatGubun" style="width:120px">
	                         <option value="">구분 선택</option>
	                         <c:forEach items="${seatGubun}" var="seatGubun">
	                            <option value="${seatGubun.code}">${seatGubun.codeNm}</option>
	                         </c:forEach>
				         </select>
                     </td>
                     <th>고정여부</th>
                     <td style="text-align:left">
                         <label class="switch">                                               
	                    	<input type="checkbox" id="seatFixUseryn" onclick="toggleValue(this);" value="Y">
		                    <span class="slider round"></span> 
	                     </label> 
                     </td>
                  </tr>
                  <tr id="tr_meeting">
                     <th><span class="redText">*</span>회의실타입</th>
		             <td style="text-align:left">
                           <select id="roomType" name="roomType" style="width:120px">
                                 <option value="">회의실 구분</option>
		                         <c:forEach items="${selectSwcGubun}" var="code">
		                            <option value="${code.code}">${code.codeNm}</option>
		                         </c:forEach>
                           </select>
		             </td>
                     <th>관리자 승인</th>
                     <td style="text-align:left">
                           <label class="switch">                                               
		                    	<input type="checkbox" id="meetingConfirmgubun" onclick="toggleValue(this);" value="Y">
			                    <span class="slider round"></span> 
		                   </label>
                     </td>
                  </tr>
                  <tr>
                     <th>유료구분</th>
                     <td colspan="3" style="text-align:left">
                         <select id="payClassification" style="width:100px" onChange="backoffice_common.fn_payClassGubun('0','0','sp_PayInfo')">
				              <option value=""> 선택</option>
				              <c:forEach items="${payGubun}" var="payGubun">
				                <option value="${payGubun.code}">${payGubun.codeNm}</option>
				              </c:forEach>
				         </select>
				         <span id="sp_PayInfo"/>
                     </td>
                  </tr>
               </table>
               
            </div>
            <a href="#" onClick="floorService.fn_SeatUpdate()" class="greenBtn">확인</a>
        </div>
    </div>
    
<c:import url="/backoffice/inc/bottom_inc.do" /> 
<button id="btn_message" style="display:none" data-needpopup-show='#floorPop'>확인1</button>
<button id="btn_part" style="display:none" data-needpopup-show='#partPop'>확인1</button>

<a data-popup-open="dv_seatSetting"  style="display:none"  class="rightGBtn" id="btn_bpop" >좌석 세팅</a>


<script src="/js/needpopup.js"></script> 
<script src="/js/jquery-ui.js"></script>


</form:form>
</div>    
   
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
		 var tenn_array = new Array();
	     var jqGridFunc  = {
	    		
	    		setGrid : function(gridOption){
	    			 var grid = $('#'+gridOption);
	    		     var postData = {"centerCode": $("#centerCode").val()};
	    		     grid.jqGrid({
	    		    	url : '/backoffice/bas/centerViewAjax.do' ,
	    		        mtype :  'POST',
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
	    		        colModel :  [
			    		        	{ label: 'floor_seq', key: true, name:'floor_seq', index:'floor_seq', align:'center', hidden:true},
				                	{ label: '도면이미지', name:'floor_map',       index:'floor_map',      align:'center', width:'10%', 
			    		        	  formatter: jqGridFunc.imageFomatter},
				 	                { label: '층수', name:'floor_info_txt',   index:'floor_info_txt',      align:'center', width:'10%'},
				 	                { label: '층이름', name:'floor_name',      index:'floor_name',      align:'center', width:'10%'},
				 	                { label: '좌석 현황', name:'seat_cnt',      index:'seat_cnt',      align:'center', width:'10%'},
					                { label: '회의실 현황', name:'meet_cnt',      index:'meet_cnt',      align:'center', width:'10%' },
					                { label: '사용 유무', name:'floor_useyn',    index:'floor_useyn',      align:'center', width:'10%' },
					                { label: 'floor_part', name:'floor_part',       index:'floor_part',      align:'center', hidden:true},
					                { label: '구역사용', name:'floor_part',      index:'floor_part',      align:'center', width:'10%', 
					                  formatter: jqGridFunc.partInfo	},
					                { label: '최종 수정자', name:'update_id', index:'update_id',     align:'center', width:'10%'},
					                { label: '최종 수정 일자', name:'update_date', index:'update_date', align:'center', width:'12%', 
					                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
					                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : false, formatter:jqGridFunc.rowBtn}
			                  
	    		 	                
	    			         ],  //상단면 
	    		        rowNum : 10,  //레코드 수
	    		        rowList : [10,20,30,40,50,100],  // 페이징 수
	    		        pager : pager,
	    		        refresh : true,
	    	            rownumbers : true, // 리스트 순번
	    		        viewrecord : true,    // 하단 레코드 수 표기 유무
	    		        //loadonce : true,     // true 데이터 한번만 받아옴 
	    		        loadui : "enable",
	    		        loadtext:'데이터를 가져오는 중...',
	    		        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
	    		        height : "100%",
	    		        autowidth:true,
	    		        shrinkToFit : true,
	    		        refresh : true,
	    		        subGrid: true,
	    		        subGridRowExpanded: showChildGrid, 
	    		        subGridBeforeExpand : function (pID, id){
	    		        	//alert("pID:" + pID + ":" + id);
	    		        },
	    		        isHasSubGrid : function (rowId) {
					        
	    		        	var cell = grid.jqGrid('getCell', rowId, "floor_part");
							console.log(cell);
							if( cell === "FLOOR_PART_2") {
								return false;
							}
							return true;
						},subGridOptions : {
							plusicon: "ui-icon-triangle-1-e",
							minusicon: "ui-icon-triangle-1-s",
							openicon: "ui-icon-arrowreturn-1-e"
						},loadComplete : function (data){
	    		        	//$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
	    		        },loadError:function(xhr, status, error) {
	    		            alert("error:" + error); 
	    		        },onSelectRow: function(rowId){
	    	                if(rowId != null) { 
	    	                   //멀트 체크 할떄 특정 값이면 다른 값에 대한 색 변경 	
	    	                }// 체크 할떄
	    	            },ondblClickRow : function(rowid, iRow, iCol, e){
	    	            	grid.jqGrid('editRow', rowid, {keys: true});
	    	            },onCellSelect : function (rowid, index, contents, action){
	    	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
	    	                if (cm[index].name=='floor_map' || cm[index].name=='floor_info_txt' || cm[index].name=='floor_name'){
	    	                	floorService.fn_floorInfo("Edt", $(this).jqGrid('getCell', rowid, 'floor_seq'));
	            		    }
	    	                
	    	            }
	    		    });
	    	   },imageFomatter: function(cellvalue, options, rowObject){
	     		    var floorMap = (rowObject.floor_map == "no_image.png" || rowObject.floor_map == undefined ) ? "/resources/img/no_image.png": "/upload/"+ rowObject.floor_map;
	     		    return '<img src="' + floorMap + ' " style="width:100px">';
	     	   },rowBtn: function (cellvalue, options, rowObject){
	                if (rowObject.floor_seq != "")
	            	   return '<a href="javascript:jqGridFunc.delRow(&#34;'+rowObject.floor_seq+'&#34;);">삭제</a>';
	           }, refreshGrid : function(){
		        	$('#mainGrid').jqGrid().trigger("reloadGrid");
		       }, delRow : function (floor_seq){
	        	    if(floor_seq != "") {
	        		   var params = {'floorSeq':floor_seq };
	        		   fn_uniDelAction("/backoffice/bas/floorDelete.do",params, "jqGridFunc.fn_search");
			        }
	           },clearGrid : function() {
	                $("#mainGrid").clearGridData();
	           },fn_search : function(){
				    $("#mainGrid").setGridParam({
	    	    	 datatype	: "json",
	    	    	 postData	: JSON.stringify(  {
	    	    		"pageIndex": $("#pager .ui-pg-input").val(),
	    	    		"centerCode": $("#centerCode").val(),
		          		"searchKeyword" : $("#searchKeyword").val(),
	         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		 }),
	    	    	 loadComplete	: function(data) {
	    	    		 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
	    	    	 }
	    	      }).trigger("reloadGrid");
			   },fn_partList :  function(floorSeq){
				  $("#mainGrid").attr('width', 200);
				  $("#floorSeq").val(floorSeq);
				  partFunc.fn_partList(floorSeq);
			   },partInfo : function (cellvalue, options, rowObject){
				  //구역 설정 
				  var info = (rowObject.floor_part === "FLOOR_PART_1") ? "<a href=\"#\" onClick='partFunc.fn_partInfo(\"Ins\", \"0\",\"" + rowObject.floor_seq+"\",\"" + rowObject.floor_info+"\",\"" + rowObject.floor_name+"\")'>[구역 등록]</a>"
						     : "<a href=\"#\" onClick='floorService.fn_SeatSetting(\"S\",\"" + rowObject.floor_seq+"\", \"0\")'>[좌석 설정]</a>"
								+ "<a href=\"#\" onClick='floorService.fn_SeatSetting(\"M\",\"" + rowObject.floor_seq+"\", \"0\")'>[회의실 설정]</a>";
				  return info;
			  }
	     }
	     //sub쿼리 
	     function showChildGrid(subgrid_id, row_id) {
	    	    var param = {"floorSeq" : row_id, "pageIndex" : fn_emptyReplace($("#pageIndex").val(), "1"), "pageSize" : "100" }
	        	var subgrid_table_id, pager_id;
	            subgrid_table_id = subgrid_id+"_t";
	            pager_id = "p_"+subgrid_table_id;
	            jQuery("#"+subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
	            jQuery("#"+subgrid_table_id).jqGrid({
	                url:"/backoffice/bas/partListAjax.do",
	                mtype :  'POST',
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
	                colModel :  [
	                	{ label: 'part_seq', key: true, name:'part_seq',       index:'part_seq',      align:'center', hidden:true},
	                	{ label: '구역명', name:'part_name',       index:'part_name',      align:'center', width:'10%'},
	 	                { label: '도면이미지', name:'part_map1',     index:'part_map1',      align:'center', width:'10%' , formatter:partFunc.imageFomatter},
	 	                { label: '좌석명령규칙', name:'part_seatrule',     index:'part_seatrule',      align:'center', width:'10%'},
	 	                { label: '미니맵Top', name:'part_mini_top',       index:'part_mini_top',      align:'center', width:'10%'},
	 	                { label: '미니맵Left', name:'part_mini_left',       index:'part_mini_left',      align:'center', width:'10%'},
		                { label: '미니맵Css', name:'part_mini_css',   index:'part_mini_css',      align:'center', width:'10%' },
		                { label: '정렬순서', name:'part_order',       index:'part_order',      align:'center', width:'10%' },
		                { label: '사용유무', name:'part_useyn',     index:'part_useyn',      align:'center', width:'10%' },
		                { label: '좌석설정', name:'part_seq',     index:'part_seq',      align:'center', width:'10%' , formatter:partFunc.seatSetting},
		                { label: '회의실설정', name:'part_seq',     index:'part_seq',      align:'center', width:'10%' , formatter:partFunc.meetingSetting},
		                { label: '최종 수정자', name:'update_id', index:'update_id',     align:'center', width:'10%'},
		                { label: '최종 수정 일자', name:'update_date', index:'update_date', align:'center', width:'12%', 
		                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
		                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : false, formatter:partFunc.rowBtn}
		            ],  //상단면 
		            rowNum : 20, 
	                height: '100%',
	                //pager: pager_id,
	                autowidth:true,
 		        shrinkToFit : true,
 		        refresh : true,
	                rowNum:20,
	                sortname: 'update_date',
	                sortorder: "asc",
	                onCellSelect : function (rowid, index, contents, action){
 	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
 	                console.log(rowid);
 	                if (cm[index].name=='part_name' || cm[index].name=='part_map1' ){
 	                	partFunc.fn_partInfo("Edt", $(this).jqGrid('getCell', rowid, 'part_seq'));
         		    }
 	            },loadComplete : function (data){
 	            	console.log(data);
 		        },refreshGrid : function(){
 		        	$('#'+ subgrid_id).jqGrid().trigger("reloadGrid");
 	            }
	             });

	        }
	     // 층 정보 변경 
	    var floorService = {
	    		 fn_SeatSetting : function(mode, floorSeq, partSeq){
	       		  //좌석 설정 
	       		  $("#viewMode").val(mode);
	       		  $("#floorSeq").val(floorSeq);
	       		  $("#searchfloorId").val(floorSeq);
	       		  if (partSeq != "0")
	       			  $("#partSeq").val(partSeq);  
	       		     // 좌석 등록 되어 있는지 아닌지 
	       		  var title =  (mode == "M") ? "회의실 설정" :  "좌석 설정";
	       		  $("#dv_Title").html(title);
	       		  var params = {"floorSeq" : $("#floorSeq").val(), "partSeq" : $("#partSeq").val(), "type" : mode};
	       		  var floorCheck = fn_returnVal("/backoffice/bas/seatCount.do",params, "fn_seatCheck");
	       		  //기본값으로 설정 
	       		  
	       		  if (mode == "M") {
	       			  $("#tr_seat").hide();
	       			  $("#tr_meeting").show();
	       		  }else {
	       			  $("#tr_seat").show();
	       			  $("#tr_meeting").hide();
	       		  }
	       	   },fn_floorInfo : function(mode, floorSeq){
	       		    $("#btn_message").trigger("click");
	         	    $("#mode").val(mode);
	         	    $("#floorSeq").val(floorSeq);
	         	    if (mode == "Ins"){
	         	    	  //층 정보 정리 하기 
	         	    	  $('input:text[name^=floor]').val("");
		       			  $('#floorPart').val(""); 
		       			  $('#floorInfo').val(""); 
		       			  toggleDefault("floorUseyn");
		       		}else {
		       			  var url = "/backoffice/bas/floorDetail.do";
		       			  var param = {"floorSeq" : floorSeq};
		       			  uniAjaxSerial(url, param, 
		       		     			function(result) {
		       						       if (result.status == "LOGIN FAIL"){
		       						    	   alert(result.meesage);
		       		  						   location.href="/backoffice/login.do";
		       		  					   }else if (result.status == "SUCCESS"){
		       	                                $(".popHead > h2").html("층 정보 수정");
		       			                        $("#btnUpdate").text('수정');
		       		  						    var obj = result.regist;
		       		  						    $("#floorName").val(obj.floor_name);
		       		 		            	    $("#floorInfo").val(obj.floor_info);
		       		 		            	    $("#floorPart").val(obj.floor_part);
		       		 		            	    $("#nowVal").val(obj.floor_info.replace("CENTER_FLOOR_", ""));
		       		 		            	    toggleClick("floorUseyn", obj.floor_useyn);
		       		 		               }
		       						 },
		       						 function(request){
		       						    alert("Error:" +request.status );	       						
		       						 }    		
		       		       );
		       		  }
	       	  }, fn_floorUpdate : function(){
	    		  //층 업데이트
	    		  if (any_empt_line_id("floorName", "층명을 입력해주세요.") == false) return;		  
	     		  if (any_empt_line_id("floorInfo", "층를 선택해주세요.") == false) return;
	     		  if (any_empt_line_id("floorPart", "구역 사용 여부를 선택해 주세요.") == false) return;
	     		  var commentTxt = ($("#mode").val() == "Ins") ? "등록 하시겠습니까?":"저장 하시겠습니까?";
	     		  if (confirm(commentTxt)== true){
	     			  //체크 박스 체그 값 알아오기 
	     			  var formData = new FormData();
	     			  formData.append('floorMap', $('#floorMap')[0].files[0]);
	     			  formData.append('floorMap1', $('#floorMap1')[0].files[0]);
	     			  formData.append('centerCode' , $("#centerCode").val());
	     			  formData.append('floorName' , $("#floorName").val());
	     			  formData.append('floorInfo' , $("#floorInfo").val());
	     			  formData.append('floorPart' , $("#floorPart").val());
	     			  formData.append('floorSeq' , $("#floorSeq").val());
	     			  formData.append('nowVal' , $("#nowVal").val());
	     			  formData.append('newVal' , fn_domNullReplace( $("#newVal").val(), $("#nowVal").val()) );
	     			  formData.append('floorInfos' , $("#floorInfos").val());
	     			  formData.append('floorUseyn' , fn_emptyReplace($('#floorUseyn').val(),"Y"));
	     			  formData.append('mode' , $("#mode").val());
	     		      uniAjaxMutipart("/backoffice/bas/floorUpdate.do", formData, 
	     						function(result) {
	     						       if (result.status == "SUCCESS"){
	     						    	  need_close();
	     						    	  jqGridFunc.fn_search();
	     		    	               }else if (result.status == "LOGIN FAIL"){
	     								  document.location.href="/backoffice/login.do";
	     				               }else {
	     				            	  alert(result.message);
	     				            	  need_close();
	     				               }
	     						    },
	     						    function(request){
	     							    alert("Error:" +request.status );	       						
	     						    }    		
	     			 );
	     		    	
	     		  } 
	    	  }, fn_floorState: function (){
	    		  if ($("#floorInfo").val() != $("#nowVal").val())
	    			  $("#newVal").val($("#floorInfo").val().replace("CENTER_FLOOR_", "") );
	    	  }, fn_SeatUpdate : function (){
	    		  //좌석 업데이트 하기 
	    		  if (any_empt_line_id("seatStr", "장비 시작 카운터을 선택해주세요.") == false) return;		  
	     		  if (any_empt_line_id("seatEnd", "장비 종료 카운터를 선택해주세요.") == false) return;
	     		  if (fnIntervalCheck($("#seatStr").val(), $("#seatEnd").val(), "시작이 종료 보다 클수 없습니다.") == false) return;
	     		  
	    		  var url = "/backoffice/bas/floorSeatUpdate.do";
	    		  var params = {"floorSeq" : $("#floorSeq").val(),
	    				        "partSeq" : $("#partSeq").val(), 
	    				        "seatStr": $("#seatStr").val(), 
	    				        "viewMode": $("#viewMode").val(), 
	    				        "seatEnd" : $("#seatEnd").val(),
	    				        //추가값
	    				        "roomType" : $("#roomType").val(),
	    				        "seatGubun" : $("#seatGubun").val(),
	    				        "meetingConfirmgubun" : fn_emptyReplace($('#meetingConfirmgubun').val(),"N"),
	    				        "seatFixUseryn" : fn_emptyReplace($('#seatFixUseryn').val(),"N"),
	    				        //비용 처리 
	    				        "payClassification" : fn_emptyReplace($('#payClassification').val(),"PAY_CLASSIFICATION_2"),
	    				        "payGubun" : fn_emptyReplace($('#payGubun').val(),"N"),
	    				        "payCost" : fn_emptyReplace($('#payCost').val(),"0"),
	    				        };
	    		  uniAjax(url, params, 
			     			function(result) {
	    			               if (result.status == "LOGIN FAIL"){
							    	   alert(result.meesage);
			  						   location.href="/backoffice/login.do";
			  					   }else if (result.status == "SUCCESS"){
		                               //정상적으로 좌석 등록 되었으면 좌석 세팅 페이지로 넘어가기
		                               jqGridFunc.fn_search();
		                               fn_GuiSearch();
		                               $('[data-popup="dv_seatSetting"]').bPopup().close();
		                               
		                    	   }else {
		                    		   alert(result.message);
		                    	   }
							    },
							    function(request){
								    alert("Error:" +request.status );	       						
							    }    		
			          ); 
	    	  }	 
	    }
	    var partFunc = {
	    		 imageFomatter: function(cellvalue, options, rowObject){
	    			 var partMap = (rowObject.part_map1 == "no_image.png" || rowObject.part_map1 == undefined ) ? "/resources/img/no_image.png": "/upload/"+ rowObject.part_map1;
		     		 return '<img src="' + partMap + ' " style="width:100px">';
	    		 },rowBtn: function (cellvalue, options, rowObject){
		               if (rowObject.part_seq != "" && rowObject.floor_seq != "" )
		            	   return '<a href="javascript:partFunc.delRow(&#34;'+rowObject.part_seq+'&#34;,&#34;'+rowObject.floor_seq+'&#34;);">삭제</a>';
	    		 },delRow: function(part_seq, floor_seq){
	    			var params = {"partSeq": part_seq}
	 	          	fn_uniDelAction("/backoffice/bas/partDelete.do",params, "partFunc.fn_search", floor_seq);
	 	       	   
	    		 },fn_search : function(gridId){
					 console.log("gridId:" + gridId)
					 $("#mainGrid_"+gridId+"_t").setGridParam({
			    	    	 datatype	: "json",
			    	    	 postData	: JSON.stringify({
			    	    		"floorSeq" : gridId,
			          			"pageIndex": 1,
			         		 }),
			    	    	 loadComplete	: function(data) {
			    	    	 }
				      }).trigger("reloadGrid");
				 }, fn_partUpdate : function(){
	       		      //구역 업데이트
	       		      if (any_empt_line_id("partName", "구역명을 입력해주세요.") == false) return;		  
	        		  if (any_empt_line_id("part_floorSeq", "층를 선택해주세요.") == false) return;
	        		  var commentTxt = ($("#mode").val() == "Ins") ? "등록 하시겠습니까?":"저장 하시겠습니까?";
	        		  if (confirm(commentTxt)== true){
	        			   
	        			  //체크 박스 체그 값 알아오기 
	        			  var formData = new FormData();
	        			  formData.append('partMap1', $('#partMap1')[0].files[0]);
	        			  formData.append('partMap2', $('#partMap2')[0].files[0]);
	        			  formData.append('centerCode' , $("#centerCode").val());
	        			  formData.append('partCss' , $("#partCss").val());
	        			  formData.append('floorSeq' , $("#part_floorSeq").val());
	        			  formData.append('partSeq' , $("#partSeq").val());
	        			  formData.append('partSeatrule' , $("#partSeatrule").val());
	        			  formData.append('partName' , $("#partName").val());
	        			  formData.append('partMiniTop' , fn_emptyReplace($("#partMiniTop").val(),"0"));
	        			  formData.append('partMiniLeft' , fn_emptyReplace($("#partMiniLeft").val(),"0"));
	        			  formData.append('partMiniCss' , $("#partMiniCss").val());
	        			  formData.append('partOrder' , fn_emptyReplace($("#partOrder").val(),"0"));
	        			  formData.append('partUseyn' , fn_emptyReplace($('input[name=partUseyn]:checked').val(),"Y"));
	        			  formData.append('mode' , $("#mode").val());
	        			  uniAjaxMutipart("/backoffice/bas/partUpdate.do", formData, 
	        						function(result) {
	        						       if (result.status == "SUCCESS"){
	        		    	                 partFunc.fn_search($("#part_floorSeq").val());
	        		    	               }else if (result.status == "LOGIN FAIL"){
	        								  document.location.href="/backoffice/login.do";
	        				               }else {
	        				            	  alert(result.message);
	        				               }
	        						       need_close();
	        						    },
	        						    function(request){
	        							    alert("Error:" +request.status );	       						
	        						    }    		
	        			 );
	        		  } 
	       	     },fn_partInfo : function(mode, partSeq, floor_seq, floor_name){
	       	    	 console.log("floor_seq:" + floor_seq  + ":" + partSeq);
	    			 $("#btn_part").trigger("click");
	    	      	 $("#mode").val(mode);
	    	      	 $("#partSeq").val(partSeq);
	    	      	
	    	      	 if (mode == "Ins"){
	    	      		  $('input[name^=part]').val("");
	    	      		  $("#part_floorSeq").val(floor_seq);
	    	      		  toggleDefault("partUseyn");
	    	      		  $("#sp_floorNm").text(floor_name);
	    	      		  
	    	      	 }else{
	    	      		  var url = "/backoffice/bas/partDetail.do";
		      			  var param = {"partSeq" : partSeq};
		      			  uniAjaxSerial(url, param, 
		      		     			function(result) {
		      						       if (result.status == "LOGIN FAIL"){
		      						    	   alert(result.meesage);
		      		  						   location.href="/backoffice/login.do";
		      		  					   }else if (result.status == "SUCCESS"){
		      	                               $("#partPop .popHead > h2").html("구역 정보 수정");
		      			                       $("#btnPartUpdate").text('수정');
		      		  						   var obj = result.regist;
		      		  						   $("#part_floorSeq").val(obj.floor_seq);
		      		 		            	   $("#partName").val(obj.part_name);
		      		 		            	   $("#partCss").val(obj.part_css);
		      		 		            	   $("#partSeatrule").val(obj.part_seatrule);
		      		 		            	   $("#partMiniTop").val(obj.part_mini_top);
		      		 		            	   $("#partMiniLeft").val(obj.part_mini_left);
		      		 		            	   $("#partMiniCss").val(obj.part_mini_css);
		      		 		            	   $("#partOrder").val(obj.part_order);
		      		 		            	   $("#sp_floorNm").text(obj.floor_name);
		      		 		            	   toggleClick("partUseyn", obj.part_useyn);
		      		 		               }
		      						    },
		      						    function(request){
		      							    alert("Error:" +request.status );	       						
		      						    }    		
		      		      ); 
	    	      	 }
	    		},seatSetting : function(cellvalue, options, rowObject){
	    			return '<a href="javascript:floorService.fn_SeatSetting(&#34;'+rowObject.floor_seq+'&#34;,&#34;'+rowObject.part_seq+'&#34;);">좌석 설정</a>';
	    		},meetingSetting : function(cellvalue, options, rowObject){
	    			return '<a href="javascript:floorService.fn_SeatSetting(&#34;'+rowObject.floor_seq+'&#34;,&#34;'+rowObject.part_seq+'&#34;);">회의실 설정</a>';
	    		}
	    		 
	    		 
	     }
  </script>

   
 <script type="text/javascript">
     var menuRight = document.getElementById('cbp-spmenu-s2')
     
     function fn_partInfo(){
    	 //구역 확인 한 다음 있는지 처리 
    	 
     }
     function fn_GuiSearch(){
    	  var url = "";
    	  var title = "";
    	  switch ($("#viewMode").val()){
		    case "S":
		    	url ="seatListAjax.do";
		    	title = "좌석";
		    	break;
		    case "M":
		    	url ="officeMeetingListAjax.do";
		    	title = "회의실";
		    	break;
		    default :
		    	url ="seatListAjax.do"; 
		        title = "좌석";
    	  }
    	  $(".sp_title").text(title);
    	  var params = {"searchCenter": $("#centerCd").val(), "searchFloorSeq" : $("#floorCd").val(), "searchPartSeq" : $("#partSeq").val(), "pageUnit" : "100"};
		  uniAjax("/backoffice/bas/"+url, params, 
		 			function(result) {
					       if (result.status == "LOGIN FAIL"){
					    	        alert(result.message);
					    	        location.href="/backoffice/login.do";
							   }else if (result.status == "SUCCESS"){
								    //테이블 정리 하기
								    if(result.seatMapInfo != null){
	 									var img=   $("#partSeq").val() != "" ? result.seatMapInfo.part_map1 : result.seatMapInfo.floor_map;
	 									$('.mapArea').css({"background":"#fff url(/upload/"+img+")", 'background-repeat' : 'no-repeat', 'background-position':' center'});
	 								}else{
	 									$('.mapArea').css({"background":"#fff url()", 'background-repeat' : 'no-repeat', 'background-position':' center'});
	 								}
 								
	 								if(result.resultlist.length > 0){
	 									var shtml = '';
	 									var obj = result.resultlist;
	 									
	 									if ($("#viewMode").val() == "S" ){
	 										for (var i in result.resultlist) {
	 	 										shtml += '<li id="s'+trim(CommonJsUtil.NVL(obj[i].seat_name)) +'" class="seat" seat-id="'+ obj[i].seat_id +'" name="'+obj[i].seat_id +'" >'+ CommonJsUtil.NVL(obj[i].seat_name) +'</li>';
	 	 									}
	 	 									$('#seat_list').html(shtml);
	 	 									for (var i in result.resultlist) {
	 	 										$('.mapArea ul li#s' + trim(CommonJsUtil.NVL(obj[i].seat_name))).css({"top" : CommonJsUtil.NVL(obj[i].seat_top)+"px", "left" : CommonJsUtil.NVL(obj[i].seat_left)+"px"});
	 	 									}
	 	 									$('.seat').dragmove();
	 	 									$("#seat_resultList > tbody").empty();
	 	 									if(result.resultlist.length > 0 ){
	 	 										var obj = result.resultlist;
	 	 										var shtml = "";
	 				  							for ( var i in obj) {
	 				  								shtml += "<tr>"
	 				  								      +  "   <td>"  + obj[i].seat_name +""
	 				  								      +  "   <input type='hidden' id='seat_id' name='seat_id' value='"+ obj[i].seat_id + "'></td>"
	 				  								      +  "   <td><a href='javascript:top_up(&#34;" + obj[i].seat_id + "&#34;)' class='up'></a>"
	 				  								      +  "   <input type='text' id='top_"+obj[i].seat_id+"' name='top_"+obj[i].seat_id+"' value='"+obj[i].seat_top +"' onchange='top_chage(&#34;"+obj[i].seat_id +"&#34;, this.value)'>"
	 				  								      +  "   <a href='javascript:top_down(&#34;" + obj[i].seat_id + "&#34;)' class='down'></a></td>"
	 				  								      +  "   <td><a href='javascript:left_up(&#34;" + obj[i].seat_id + "&#34;)' class='leftB'></a>"
	 				  								      +  "   <input type='text' id='left_"+obj[i].seat_id+"' name='left_"+obj[i].seat_id+"' value='"+ obj[i].seat_left +"' onchange='left_chage(&#34;"+obj[i].seat_id+"&#34, this.value)'>"
	 				  								      +  "   <a href='javascript:left_down(&#34;" + obj[i].seat_id  + "&#34;)' class='rightB'></a></td>"
	 				  								      +  "</tr>";
	 				  								$("#seat_resultList > tbody").append(shtml);
	 				  								shtml = "";
	 				  							}
	 				  							
	 			  						    }
	 									}else {
	 										for (var i in result.resultlist) {
	 	 										shtml += '<li id="s'+ trim(CommonJsUtil.NVL(obj[i].meeting_name)) +'" class="seat" seat-id="'+ obj[i].meeting_id +'" name="'+obj[i].meeting_id +'" >'+ CommonJsUtil.NVL(obj[i].meeting_name) +'</li>';
	 	 									}
	 	 									$('#seat_list').html(shtml);
	 	 									for (var i in result.resultlist) {
	 	 										$('.mapArea ul li#s' + trim(CommonJsUtil.NVL(obj[i].meeting_name))).css({"top" : CommonJsUtil.NVL(obj[i].meeting_top)+"px", "left" : CommonJsUtil.NVL(obj[i].meeting_left)+"px"});
	 	 									}
	 	 									$('.seat').dragmove();
	 	 									$("#seat_resultList > tbody").empty();
	 	 									if(result.resultlist.length > 0 ){
	 	 										var obj = result.resultlist;
	 	 										var shtml = "";
	 				  							for ( var i in obj) {
	 				  								shtml += "<tr>"
	 				  								      +  "   <td>"  + obj[i].meeting_name +""
	 				  								      +  "   <input type='hidden' id='seat_id' name='seat_id' value='"+ obj[i].meeting_id + "'></td>"
	 				  								      +  "   <td><a href='javascript:top_up(&#34;" + obj[i].meeting_id + "&#34;)' class='up'></a>"
	 				  								      +  "   <input type='text' id='top_"+obj[i].meeting_id+"' name='top_"+obj[i].meeting_id+"' value='"+obj[i].meeting_top +"' onchange='top_chage(&#34;"+obj[i].meeting_id +"&#34;, this.value)'>"
	 				  								      +  "   <a href='javascript:top_down(&#34;" + obj[i].meeting_id + "&#34;)' class='down'></a></td>"
	 				  								      +  "   <td><a href='javascript:left_up(&#34;" + obj[i].meeting_id + "&#34;)' class='leftB'></a>"
	 				  								      +  "   <input type='text' id='left_"+obj[i].meeting_id+"' name='left_"+obj[i].meeting_id+"' value='"+ obj[i].meeting_left +"' onchange='left_chage(&#34;"+obj[i].meeting_id+"&#34, this.value)'>"
	 				  								      +  "   <a href='javascript:left_down(&#34;" + obj[i].meeting_id  + "&#34;)' class='rightB'></a></td>"
	 				  								      +  "</tr>";
	 				  								
	 				  								$("#seat_resultList > tbody").append(shtml);
	 				  								shtml = "";
	 				  							}
	 				  							
	 			  						    }
	 									}
	 									
	 								}else{
	 									$('#seat_list').html('');""
	 								}
								   }else {
									    alert(result.message);
								   }
					    },
					    function(request){
						    alert("Error:" +request.status );	       						
					    }    		
		       );
     }
     function fn_seatCheck(count){
    	 if (parseInt(count) > 0){
    		 showLeft();
			 fn_GuiSearch();	
		 }else{
			 $("#seatGubun").val("");
			 $("#roomType").val("");
			
			 toggleDefault("meetingConfirmgubun");
			 toggleDefault("seatFixUseryn");
			 $("#seatStr").val("1");
			 $("#seatEnd").val("1");
			 //유료 무료 
			 $('input[name^=pay]').val("");
			 $("#payClassification").val("");
			 $("#payGubun").val("");
			 $("#payCost").val("0");
			 $("#payGubun").hide();
			 $("#payCost").hide();
			 $("#btn_bpop").trigger("click");  
		 }
     }
	 function need_close(){
     	needPopup.hide();
     }
	 function showLeft(){
			classie.toggle( menuRight, 'cbp-spmenu-open' );
	 }
	 function save(){
			if(confirm('저장 하시겠습니까?')){
				var SeatsArray = new Array();
				//여기 부분 좌표값으로 가지고 오기 
				$("input:hidden[name=seat_id]").each(function () {
					
		        	var SeatsView = new Object();
		            SeatsView.seatId = $(this).val();
		            SeatsView.seatTop = $("#top_"+SeatsView.seatId).val();// $(this).css('top').replace('px', '');
		            SeatsView.seatLeft = $("#left_"+SeatsView.seatId).val(); //$(this).css('left').replace('px', '');
		            SeatsArray.push(SeatsView);
		        });
				/*
		        $('.seat').each(function () {
		        	var SeatsView = new Object();
		            SeatsView.seatId = $(this).attr('seat-id');
		            SeatsView.seatTop = $(this).css('top').replace('px', '');
		            SeatsView.seatLeft = $(this).css('left').replace('px', '');
		            SeatsArray.push(SeatsView);
		        });
				*/
		        var param =  new Object();
		       
		        param.data = SeatsArray;
		        if(SeatsArray.length == 0){
		        	alert('저장할 내용이 없습니다.');
		        	return false;
		        }
		        param.type = $("#viewMode").val();
		        var url = "/backoffice/bas/seatGuiUpdate.do";
		        uniAjax(url, param, 
   		     			function(result) {
   						       if (result.status == "LOGIN FAIL"){
   						    	   alert(result.meesage);
   		  						   location.href="/backoffice/login.do";
   		  					   }else if (result.status == "SUCCESS"){
	   		  					   alert('수정되었습니다.');
	   		  					   fn_GuiSearch();
   		  					   }
   						},
   						function(request){
   							    alert("Error:" +request.status );	       						
   						}    		
    		    );
				
			}
	 }

	 /***********************************
	 * + - 버튼
	 ************************************/
	 function top_up(str){
	 	var top = parseInt($('#top_'+str).val())+1;
	 	$('#top_'+str).val(top);
	 	$('li[name="'+str+'"]').css('top', top+'px');
	 }

	 function top_down(str){
	 	var top = parseInt($('#top_'+str).val())-1;
	 	$('#top_'+str).val(top);
	 	$('li[name="'+str+'"]').css('top', top+'px');
	 }

	 function left_up(str){
	 	var left = parseInt($('#left_'+str).val())+1;
	 	$('#left_'+str).val(left);
	 	$('li[name="'+str+'"]').css('left', left+'px');
	 }

	 function left_down(str){
	 	var left = parseInt($('#left_'+str).val())-1;
	 	$('#left_'+str).val(left);
	 	$('li[name="'+str+'"]').css('left', left+'px');
	 }


	 /***********************************
	 * text mode top 수정
	 ************************************/
	 function top_chage(str, str2){
	 	console.log('str : ' + str + ', str2 : '+ str2);
	 	$('li[name="'+str+'"]').css('top', str2+'px');
	 }

	 /***********************************
	 * text mode left 수정
	 ************************************/
	 function left_chage(str, str2){
	 	$('li[name="'+str+'"]').css('left', str2+'px');
	 }
     needPopup.config.custom = {
         'removerPlace': 'outside',
         'closeOnOutside': false,
         onShow: function() {
				console.log('needPopup is shown');
         },
         onHide: function() {
             console.log('needPopup is hidden');
         }
     };
     needPopup.init();
 </script>

</body>    
</html>