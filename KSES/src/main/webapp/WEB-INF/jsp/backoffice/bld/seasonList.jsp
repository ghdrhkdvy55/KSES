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
<!-- GUI js/css -->
<script type="text/javascript" src="/resources/js/modernizr.custom.js"></script>
<script type="text/javascript" src="/resources/js/classie.js"></script>
<script type="text/javascript" src="/resources/js/dragmove.js"></script>
<style type="text/css">
	.cbp-spmenu {
		background: #3670c5;
		position: fixed;
  	}
  	.cbp-spmenu a {
		display: block;
		color: #fff;
		font-size: 1.1em;
		font-weight: 300;
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
<link rel="stylesheet" href="/resources/css/paragraph_new.css">
<!-- //contents -->
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="floorCd" name="floorCd">
<input type="hidden" id="seasonCdGui" name="seasonCdGui">
<input type="hidden" id="partExits" name="partExits">
<input type="hidden" id="seasonCenterinfo" name="seasonCenterinfo">
<input type="hidden" id="adminId" name="adminId" value="${LoginVO.adminId}">
<div class="breadcrumb">
  	<ol class="breadcrumb-item">
    	<li>시설 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">시즌 관리</li>
  	</ol>
</div>
<h2 class="title">시즌 관리</h2>
<div class="clear"></div>
<div class="dashboard">
  <div class="boardlist">
    <div class="whiteBox searchBox">
        <div class="sName">
          <h3>검색 옵션</h3>
        </div>
      <div class="top">
        <p>지점</p>
        <select id="searchCenter" name="searchCenter">
           <option value="">지점</option>
           <c:forEach items="${centerCombo}" var="centerCombo">
                 <option value="${centerCombo.center_cd}"><c:out value='${centerCombo.center_nm}'/></option>
		   </c:forEach>
        </select>
        <p>검색어</p>
        <select id="searchCondition"  name="searchCondition">
          <option value="0">선택</option>
          <option value="SEASON_NM">시즌명</option>
          <option value="SEASON_DC">시즌 상세 설명</option>
        </select>
        <input type="text" id="searchKeyword" name="searchKeyword"  placeholder="검색어를 입력하세요.">
      </div>
      <div class="inlineBtn">
        <a href="javascript:jqGridFunc.fn_search()"class="grayBtn">검색</a>
      </div>
    </div>
    <div class="left_box mng_countInfo">
      <p>총 : <span id="sp_totcnt"></span>건</p>
      
    </div>
    <div class="right_box">
        <a href="javascript:jqGridFunc.fn_SeasonInfo('Ins', '')" class="blueBtn">시즌 등록</a>
    </div>
    <div class="clear"></div>
    <div class="whiteBox">
      <table id="mainGrid">
      </table>
	  <div id="pager" class="scroll" style="text-align:center;"></div>
	  <div id="paginate"></div>
    </div>
  </div>
</div>
<!-- contents//-->
<!-- //popup -->
<!-- // 시즌 관리 팝업 -->
<div data-popup="bld_season_add" id="bld_season_add" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">시즌 등록</h2>
      <div class="pop_wrap">
          <table class="detail_table">
              <tbody>
                  <tr>
                    <th>시즌명</th>
                    <td><input type="text" id="seasonNm" name="seasonNm">
                        <input type="hidden" id="seasonCd" name="seasonCd">
                    </td>
                    <th>사용유무</th>
                    <td>
                      <label for="useAt_Y"><input name="useYn" type="radio" id="useAt_Y" value="Y"/>사용</label>
                      <label for="useAt_N"><input name="useYn" type="radio" id="useAt_N" value="N"/>사용 안함</label>
                    </td>
                  </tr>
                  <tr>
                    <th>시작일</th>
                    <td><input type="text" id="seasonStartDay" name="seasonStartDay" class="cal_icon"></td>
                    <th>종료일</th>
                    <td><input type="text" id="seasonEndDay" name="seasonEndDay" class="cal_icon"></td>
                  </tr>
                  <tr>
                    <th>해당 지점</th>
                    <td colspan="3">
                      <c:forEach items="${centerCombo}" var="centerCombo">
                         <input type="checkbox" name="seasonCenterinfo" id="${centerCombo.center_cd}" value="${centerCombo.center_cd}" />
                         <c:out value='${centerCombo.center_nm}'/>
			          </c:forEach>
                    </td>
                  </tr>
                  <tr>
                    <th>상세 설명</th>
                    <td colspan="3">
                      <textarea style="width: 400px; height: 150px;" id="seasonDc" name="seasonDc"></textarea>
                    </td>
                  </tr>
              </tbody>
          </table>
      </div>
      <div class="right_box">
		  <a href="javascript:jqGridFunc.fn_CheckForm()" class="blueBtn" id="btnUpdate">저장</a>
          <a href="javascript:common_modelClose('bld_season_add')" class="grayBtn">취소</a>  
      </div>
      <div class="clear"></div>
  </div>
</div>
<!-- 시즌 관리 팝업 // -->
<!-- popup// -->
<!--  GUI MODE -->
<!-- // 좌석 위치 세팅 팝업 -->
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
					<a href="javascript:jqGridFunc.fn_SeasonGuiSearch()" class="defaultBtn">검색</a>
					<div class="btn_bot">
					</div>
				</div>
				
				<table class="search_tab">
					<tbody>
						<tr>
						    <th>지점</th>
							<td>
								<select id="searchCenterCd" name="searchCenterCd">
									<option value="">검색 지점</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>층</th>
							<td>
								<select id="searchFloorCd" name="searchFloorCd">
									<option value="">검색 층수</option>
								</select>
							</td>
						</tr>
						<tr>
						   <th>구역</th>
							<td>
								<select id="searchPartCd" name="searchPartCd">
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
						<a href="javascript:fn_SeasonSave()" class="defaultBtn">저장</a>
					</div>
					
					<div class="scroll_table">
						<div class="scroll_div">
							<table class="total_tab gui_table" id="seat_resultList">
								<thead>
									<tr>
										<th style="float: left; width:80px;">사용유무</th>
										<th style="float: left;">레이블</th>
										<th style="float: left;">Top</th>
										<th style="float: left;">Left</th>
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
<script type="text/javascript">
$(document).ready(function() { 
	if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
		$("#searchCenter").val($("#loginCenterCd").val());
		$(".top > p:first").hide();
		$(".top > select:first").hide();
		
	}
	
	jqGridFunc.setGrid("mainGrid");
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
		yearRange: '2021:2099' //1990년부터 2020년까지
    };	       
	   $("#seasonStartDay").datepicker(clareCalendar);
	   $("#seasonEndDay").datepicker(clareCalendar);
	   $("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
	   $("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
});


var jqGridFunc  = {
	setGrid : function(gridOption){
		var grid = $('#'+gridOption);
		var postData = {"pageIndex": "1"};
		grid.jqGrid({
			url : '/backoffice/bld/seasonListAjax.do' ,
			mtype :  'POST',
			datatype :'json',
			
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
							{ label: '시즌코드', key: true, name:'season_cd', index:'season_cd', align:'left', hidden:true},
							{ label: '시즌명', name:'season_nm', index:'season_nm', align:'left', width:'10%'},
							{ label: '시즌시작일', name:'season_start_day', index:'season_start_day', align:'left', width:'10%'},
							{ label: '시즌종료일', name:'season_end_day', index:'season_end_day', align:'left', width:'10%'},
							{ label: '사용유무', name:'use_yn', index:'use_yn', align:'left', width:'10%',	formatter:jqGridFunc.useYn},
							{ label: '적용지점', name:'season_centerinfo_nm', index:'season_centerinfo_nm', align:'left', width:'20%'},
							{ label: '적용지점', name:'season_centerinfo', index:'season_centerinfo', align:'left', hidden:true},
							{ label: '설정', name:'seasonSetting', index:'seasonSetting', align:'left', width:'10%', formatter:jqGridFunc.seasonSetting },
							{ label: '수정자', name:'last_updusr_id', index:'last_updusr_id', align:'center', width:'14%'},
							{ label: '수정 일자', name:'last_updt_dtm', index:'last_updt_dtm', align:'center', width:'12%', sortable:'date', 
							formatter: "date", formatoptions: { newformat: "Y-m-d"}},
							{ label: '삭제', name: 'btn', index:'btn', align:'center', width: 50, fixed:true, sortable: false,
							formatter:jqGridFunc.rowBtn}
			            ],  //상단면 
			rowNum : 10,  //레코드 수
			rowList : [10,20,30,40,50,100],  // 페이징 수
			pager: $('#pager'),  
			pager : pager,
			viewrecord : false,    // 하단 레코드 수 표기 유무
			
			refresh : true,
			rownumbers : false, // 리스트 순번
			loadonce : false,     // true 데이터 한번만 받아옴 
			loadui : "enable",
			loadtext:'데이터를 가져오는 중...',
			emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
			height : "100%",
			autowidth:true,
			shrinkToFit : true,
			refresh : true,
			multiselect : false,
			loadComplete : function (data){
				$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
				var rowIds  = $("#listRepairLoaner").jqGrid('getDataIDs');
				for( var n = 0; n <= rowIds.length; n++ ) {
					var rowId = rowIds[n];
					//cbox라는 class를 적용받는데 해당 class에서 선택을 방지
					$("#jqg_listRepairLoaner_"+rowId).removeClass("cbox");
				}
			}, beforeSelectRow: function (rowid, e) {
				var $myGrid = $(this);
				var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
				var cm = $myGrid.jqGrid('getGridParam', 'colModel');
				return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
			}, loadError:function(xhr, status, error) {
				alert("loadError:" + error); 
			},onSelectRow: function(rowId){
				if(rowId != null) {  }// 체크 할떄
			},ondblClickRow : function(rowid, iRow, iCol, e){
				grid.jqGrid('editRow', rowid, {keys: true});
			},onCellSelect : function (rowid, index, contents, action){
				var cm = $(this).jqGrid('getGridParam', 'colModel');
				//console.log(cm);
				if (cm[index].name !='cb'){
					jqGridFunc.fn_SeasonInfo("Edt", $(this).jqGrid('getCell', rowid, 'season_cd'));
				}
			}
		});
	}, useYn: function (cellvalue, options, rowObject){
		return rowObject.use_yn == "Y" ? "사용" : "사용안함";
	}, seasonSetting : function(cellvalue, options, rowObject){
		return '<a href="javascript:jqGridFunc.fn_SeasonFloorInfo(&#39;'+rowObject.season_cd+'&#39;);" class="orangeBtn">층 관리</a>';	
	}, refreshGrid : function(){
		$('#mainGrid').jqGrid().trigger("reloadGrid");
	}, fn_search: function(){
		$("#mainGrid").setGridParam({
			datatype	: "json",
			postData	: JSON.stringify(  {
				"pageIndex": $("#pager .ui-pg-input").val(),
				"searchCenter" : $("#searchCenter").val(),
				"searchCondition" : $("#searchCondition").val(),
				"searchKeyword" : $("#searchKeyword").val(),
				"pageUnit":$('.ui-pg-selbox option:selected').val()
      		}),
			loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
		}).trigger("reloadGrid");
	}, clearGrid : function() {
		$("#mainGrid").clearGridData();
	}, fn_SeasonInfo : function (mode, seasonCd){
		$("#mode").val(mode);
		if (mode == "Edt"){
			$("#seasonCd").val(seasonCd).prop('readonly', true);
			$("#btnUpdate").text("수정");
			var params = {"seasonCd" : seasonCd};
			var url = "/backoffice/bld/seasonInfoDetail.do";
			fn_Ajax(url, "GET", params, false, 
				function(result) {
					if (result.status == "LOGIN FAIL"){
						common_popup(result.meesage, "Y", "bas_menu_add");
						location.href="/backoffice/login.do";
					}else if (result.status == "SUCCESS"){
						var obj  = result.regist;
						      
						$("#seasonNm").val(obj.season_nm);
						$("#seasonStartDay").val(obj.season_start_day);
						$("#seasonEndDay").val(obj.season_end_day);
						$("#seasonDc").val(obj.season_dc);
						$("input:radio[name='useYn']:radio[value='"+obj.use_yn+"']").prop('checked', true)
						fn_CheckboxChoice("seasonCenterinfo", obj.season_centerinfo);
						$("#btnUpdate").text("수정");
						$("#bld_season_add > div >h2").text("시즌 정보 수정");
						if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
							$("#bld_season_add .detail_table > tbody > tr:eq(2)").hide();
							obj.season_centerinfo != $("#loginCenterCd").val() ? $("#btnUpdate").hide() : $("#btnUpdate").show();
						}
					}else{
						common_modelCloseM(result.message, "bas_menu_add");
					}
				},
				function(request){
					common_modelCloseM("ERROR : " +request.status, "bas_menu_add");
				}
			);
		}else{
			$("#seasonCd").val('').prop('readonly', false);
			$("#seasonNm").val('');
			$("#seasonStartDay").val('');
			$("#seasonEndDay").val('');
			if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
				fn_CheckboxChoice("seasonCenterinfo", $("#loginCenterCd").val());
				$("#bld_season_add .detail_table > tbody > tr:eq(2)").hide();
			} else {
				fn_CheckboxAllChange("seasonCenterinfo", false);
			}
			$("#seasonDc").val('');				  
			$("#btnUpdate").text("등록");
			$("#useAt_Y").prop("checked", true);
			$("#bld_season_add > div >h2").text("시즌 정보 등록");
		}
		$("#bld_season_add").bPopup();
    },fn_CheckForm  : function (){
		if (any_empt_line_span("bld_season_add", "seasonNm", "시즌명를 입력해 주세요.","sp_message", "savePage") == false) return;
		if (any_empt_line_span("bld_season_add", "seasonStartDay", "시즌 시작일를 선택해 주세요.","sp_message", "savePage") == false) return;
		if (any_empt_line_span("bld_season_add", "seasonEndDay", "시즌 시작일를 선택해 주세요.","sp_message", "savePage") == false) return;
		if (endday_early_check("bld_season_add", "seasonStartDay", "seasonEndDay", "종료일이 시작일 보다 빠릅니다.","sp_message", "savePage") == false) return;
		var choiceCenter = ckeckboxValue("시즌을 사용할 지점을 선택 하지 않았습니다.", "seasonCenterinfo", "bld_season_add");
 	 
 	   
		$("#seasonCenterinfo").val(choiceCenter);
		var commentTxt = ($("#mode").val() == "Ins") ? "신규 시즌 정보를 등록 하시겠습니까?" : "입력한 시즌 정보를 저장 하시겠습니까?";
		$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
		fn_ConfirmPop(commentTxt);
	}, fn_update : function(){
		$("#confirmPage").bPopup().close();
		var url = "/backoffice/bld/seasonInfoUpdate.do";
		var params = {'seasonCd' : $("#seasonCd").val(),
						'seasonNm' : $("#seasonNm").val(),
						'useYn' :fn_emptyReplace($("input[name='useYn']:checked").val(),"Y"),
						'seasonStartDay' : $("#seasonStartDay").val(),
						'seasonEndDay' : $("#seasonEndDay").val(),
						'seasonCenterinfo' : $("#seasonCenterinfo").val(),
						'seasonDc' : $("#seasonDc").val(),
						'mode' : $("#mode").val()
					}; 
		fn_Ajax(url, "POST", params, false,
			function(result) {
				if (result.status == "LOGIN FAIL"){
					common_popup(result.message, "Y","bld_season_add");
					location.href="/backoffice/login.do";
				}else if (result.status == "OVERLAP FAIL" ){
					common_popup(result.message, "N", "bld_season_add");
					jqGridFunc.fn_search();
				}else if (result.status == "SUCCESS"){
					//총 게시물 정리 하기'
					common_modelCloseM(result.message, "bld_season_add");
					jqGridFunc.fn_search();
				}else if (result.status == "FAIL"){
					common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "bld_season_add");
					jqGridFunc.fn_search();
				}
			},
			function(request){
				common_popup("Error:" + request.status, "Y", "bld_season_add");
			}    		
		);
	}, rowBtn: function (cellvalue, options, rowObject){
        if (rowObject.season_cd != "")
        	if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
        		if(rowObject.season_centerinfo == $("#loginCenterCd").val()){
        			return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.season_cd+"\");'>삭제</a>";
        		} else {
        			return '<a href="javascript:void(0);"></a>';
        		}
        	} else {
        		return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.season_cd+"\");'>삭제</a>";
        	}
			
	}, delRow : function (seasonCd){
     	if(seasonCd != "") {
    		 $("#hid_DelCode").val(seasonCd)
				 $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
   		     fn_ConfirmPop("삭제 하시겠습니까?");
		    }
    }, fn_del: function (){
		var params = {'seasonCd': $.trim($("#hid_DelCode").val()) };
		fn_uniDelAction("/backoffice/bld/seasonInfoDelete.do", "POST", params, false, "jqGridFunc.fn_search");
	}, fn_SeasonFloorInfo : function (seasonCd){
		//시즌 정리 하기 
		  
		$("#dv_Title").html("시즌 좌석 설정");
		  	
		showLeft(); //좌측 메뉴 나오게 하기 
		$("#seasonCdGui").val(seasonCd);
		var url = "/backoffice/bld/seasonCenterLst.do"
		var params = {"seasonCd": seasonCd};
		fn_Ajax(url, "GET", params, false,
			function(result) {
				if (result.status == "LOGIN FAIL"){
					showLeft(); 
					location.href="/backoffice/login.do";
				}else if (result.status == "SUCCESS"){
					//총 게시물 정리 하기'
					//alert(result.status);
					
					fn_comboListJson("searchCenterCd", result.regist, "fn_floorChange", "100px;", "");
					fn_comboListJson("searchFloorCd", result.floorlist, "fn_partChange", "100px;", "");
					if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
						$("#searchCenterCd").val( $("#loginCenterCd").val()).trigger("change");	
						$(".search_tab > tbody > tr:first").hide();
					} else {
						$("#searchFloorCd option:eq(0)").prop("selected", true);	
					}		
					$("#searchFloorCd option:eq(0)").prop("selected", true);
					if ( result.partlist.length > 0){
						$("#searchPartCd").show();
						fn_comboListJson("searchPartCd", result.partlist, "", "100px;", ""); 
						$("#searchPartCd option:eq(0)").prop("selected", true);
					}else {
						$("#searchPartCd").hide();
					}
						fn_GuiSearch($("#seasonCdGui").val());
				}else if (result.status == "FAIL"){
					showLeft(); 
					common_popup(result.message, "N", "");
				}
			},
			function(request){
				common_popup("Error:" + request.status, "N", "");
			}
		);
	}, fn_SeasonGuiSearch: function () {
		if($("#searchFloorCd option").length > 1 && $("#searchFloorCd").val() == ""){
			if (any_empt_line_span_noPop("searchFloorCd", "층을 선택해주세요.") == false) return;	
		}
		if($("#searchPartCd option").length > 1 && $("#searchPartCd").val() == ""){
			if (any_empt_line_span_noPop("searchPartCd", "구역을 선택해주세요.") == false) return;	
		}
		fn_GuiSearch($("#seasonCdGui").val());
	}
}
 	var menuRight = document.getElementById('cbp-spmenu-s2')
    function showLeft() {
 	    classie.toggle(menuRight, 'cbp-spmenu-open');
 	}
 	function fn_layerClick(code, tr_code){
 		var layerCss = rgb2hex($("#s"+code).css("background-color"));
 		var color = (layerCss == "#65a5d2") ? "#ffffff" :"#65a5d2";
 		//tr 값 확인 
 		//tr_SEASON211109001C21110405_02_01_253
 		$("#seat_resultList tr").filter("#tr_"+tr_code).css("background-color", color);
 		$("#s"+code).css("backgroundColor", color);
 	
 	}
 	function fn_GuiSearch(seasonCd) {	
		var title = "시즌 좌석 관리";
	    $(".sp_title").text(title);
 	    var params = {
			"seasonCd": seasonCd,
 	        "searchCenter": $("#searchCenterCd").val(),
 	        "searchFloorCd": $("#searchFloorCd").val(),
 	        "searchPartCd": fn_emptyReplace($("#searchPartCd").val(), "0"),
 	        "pageUnit": "2000"
 	    };

		fn_Ajax
 	    (
			"/backoffice/bld/seasonSeatListAjax.do",
			"POST",
			params,
			false,
 	        function(result) {
 	            if (result.status == "LOGIN FAIL") {
 	                showLeft(); 
 	                location.href = "/backoffice/login.do";
 	            } else if (result.status == "SUCCESS") {
 	                //테이블 정리 하기
 	                var img = "";
 	                if (result.seatMapInfo != null) {
 	                    img = $("#partCd").val() != "0" ? "/upload/"+result.seatMapInfo.part_map1 : "/upload/"+result.seatMapInfo.floor_map1;
 	                } 
 	                console.log("img:" + img)
 	                $('.mapArea').css({
                        "background": "#fff url("+img+")",
                        'background-repeat': 'no-repeat',
                        'background-position': ' center'
                    });
 	               
 	                
					$("#seat_resultList > tbody").empty();
 	                if (result.resultlist.length > 0) {
 	                    var shtml = '';
 	                    var thtml = '';
 	                    var obj = result.resultlist;
 	                    
 	                    
 	                    
	                        for (var i in result.resultlist) {
	                        	var check = (obj[i].use_yn == "Y") ? "checked" : "";
	                        	if (check == "checked"){
	                        		shtml += '<li id="s' + trim(obj[i].season_seat_label) + '" class="seat" season_seat-cd="' + obj[i].season_seat_cd + '" name="' + obj[i].season_seat_cd + '" onClick="fn_layerClick(&#34;' + trim(obj[i].season_seat_label ) + '&#34;,&#34;' + trim(obj[i].season_seat_cd ) + '&#34;)">' + fn_NVL(obj[i].season_seat_number) + '</li>';
	                        		$('#seat_list').html(shtml);
	                        		//동적 클릭 하는 부분 처리 나중에 확인 하기 
	                        		
	                        	}
	                        	
	                        	thtml += "<tr id='tr_"+obj[i].season_seat_cd+"'>" +
								"   <input type='hidden' name='season_seat_cd' value='" + obj[i].season_seat_cd + "'></td>" +
								"   <td style='width:80px;'><input type='checkbox' id='check_"+obj[i].season_seat_cd+"' "+check+">" +
                               	"   <td><input type='text' id='label_"+obj[i].season_seat_cd+"' value='"+ obj[i].season_seat_label +"' style='width:80px;' />"+
                               	"   <td><a href='javascript:top_up(&#34;" + obj[i].season_seat_cd + "&#34;)' class='up'></a>" +
                               	"   <input type='text' id='top_" + obj[i].season_seat_cd + "' name='top_" + obj[i].season_seat_cd + "' value='" + obj[i].season_seat_top + "' onchange='top_chage(&#34;" + obj[i].season_seat_cd + "&#34;, this.value)'  style='width:70px;'>" +
                               	"   <a href='javascript:top_down(&#34;" + obj[i].season_seat_cd + "&#34;)' class='down'></a></td>" +
                               	"   <td><a href='javascript:left_up(&#34;" + obj[i].season_seat_cd + "&#34;)' class='leftB'></a>" +
                               	"   <input type='text' id='left_" + obj[i].season_seat_cd + "' name='left_" + obj[i].season_seat_cd + "' value='" + obj[i].season_seat_left + "' onchange='left_chage(&#34;" + obj[i].season_seat_cd + "&#34, this.value)'  style='width:70px;'>" +
                               	"   <a href='javascript:left_down(&#34;" + obj[i].season_seat_cd + "&#34;)' class='rightB'></a></td>" +
                               	"</tr>";
                               	$("#seat_resultList > tbody").append(thtml);
                               	thtml = "";
	                        }
 	                    //여기 부분 확인 하기
	                        for (var i in result.resultlist) {
	                        	if (obj[i].use_yn == "Y"){
	                        		$('.mapArea ul li#s' + trim(obj[i].season_seat_label)).css({
 	                                "top": obj[i].season_seat_top + "px",
 	                                "left": obj[i].season_seat_left + "px"
 	                            });  
	                        	}
	                        }
 	                    $('.seat').dragmove();
 	                } else {
 	                    $('#seat_list').html('');
 	                    ""
 	                }
 	            } else {
 	                showLeft(); 
				    common_popup(result.message, "N", "");
 	            }
 	        },
 	        function(request) {
 	            showLeft(); 
			    common_popup("ERROR : " + request.status, "N", "");
 	        }
 	    );
 	}


 	
 	
 	
 	function fn_floorChange() {
 		
 		var url = "/backoffice/bld/floorComboInfo.do"
 		var params = {"centerCd" : $("#searchCenterCd").val()}
 		var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
 		fn_comboListJson("searchFloorCd", returnVal, "fn_partChange", "100px;", "");
 		if (returnVal.length > 0){
 			$("#searchFloorCd option:eq(0)").prop("selected", true);
 		}else {
 			$("#searchFloorCd").hide();
 		}
 		$("#searchPartCd").hide();
	}
	function fn_partChange(){
		var url = "/backoffice/bld/partInfoComboList.do"
	    var params = {"floorCd" : $("#searchFloorCd").val()}
	 	var returnVal = uniAjaxReturn(url, "GET", false, params, "lst");
		fn_comboListJson("searchPartCd", returnVal, "", "100px;", "");
		if (returnVal.length > 0){
 			$("#searchPartCd option:eq(0)").prop("selected", true);
 			$("#searchPartCd").show();
 		}else {
 			
 			$("#searchPartCd").hide();
 			//검색으로 바로 가기 
 			fn_GuiSearch($("#seasonCdGui").val());
 		}
	}

 	function fn_SeasonSave() {
    	$("#id_ConfirmInfo").attr("href", "javascript:fn_SeasonUpdate()");
      		fn_ConfirmPop('저장 하시겠습니까?');
 	}
 	function fn_SeasonUpdate(){
 		$("#confirmPage").bPopup().close();
 		
 		
	        var SeasonSeatArray = new Array();
	        //여기 부분 좌표값으로 가지고 오기 
	        $("input:hidden[name=season_seat_cd]").each(function() {
	            var SeasonSeatInfo = new Object();
	            SeasonSeatInfo.seasonSeatCd = $(this).val();
	            SeasonSeatInfo.seasonSeatLabel = $("#label_" + SeasonSeatInfo.seasonSeatCd).val();
	            SeasonSeatInfo.useYn =  $("#check_" + SeasonSeatInfo.seasonSeatCd).is(":checked") == true ? "Y" : "N";
	            SeasonSeatInfo.seasonSeatTop = $("#top_" + SeasonSeatInfo.seasonSeatCd).val(); // $(this).css('top').replace('px', '');
	            SeasonSeatInfo.seasonSeatLeft = $("#left_" + SeasonSeatInfo.seasonSeatCd).val(); //$(this).css('left').replace('px', '');
	            SeasonSeatArray.push(SeasonSeatInfo);
	        });

	        var param = new Object();
	        param.data = SeasonSeatArray;
	        if (SeasonSeatArray.length == 0) {
	            common_popup('저장할 내용이 없습니다.', "N", "");
	            return false;
	        }
	        var url = "/backoffice/bld/seasonGuiUpdate.do";
	        fn_Ajax(url, "POST", param, false,
	            function(result) {
	                if (result.status == "LOGIN FAIL") {
	                	//추후 로그인 부분 확인 하기 
	                	location.href = "/backoffice/login.do";
	                } else if (result.status == "SUCCESS") {
	                    common_popup('수정되었습니다.', "Y", "");
	                    fn_GuiSearch($("#seasonCdGui").val());
	                }else {
	                	common_popup(result.message, "N", "");
	                } 
	            },
	            function(request) {
	            	common_popup("ERROR : " + request.status, "N", "");
	            }
	        );
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
<c:import url="/backoffice/inc/popup_common.do" />