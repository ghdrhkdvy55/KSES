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
<!-- //contents -->
<input type="hidden" id="searchCenterCd" name="searchCenterCd">
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="floorInfo" name="floorInfo">
<input type="hidden" id="centerHolySeq" name="centerHolySeq">
<input type="hidden" id="targetCenterHolySeq" name="targetCenterHolySeq">
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>시설 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">지점 관리</li>
	</ol>
</div>
<h2 class="title">지점 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
		<!--// search -->
		<div class="whiteBox searchBox">
			<div class="sName">
  				<h3>검색 옵션</h3>
			</div>
			
			<div class="top">
				<p>지점명</p>
				<input type="text" id="searchKeyword" name="searchKeyword"placeholder="검색어를 입력하세요.">
			</div>
			
			<div class="inlineBtn">
				<a href="javascript:jqGridFunc.fn_search();" class="grayBtn">검색</a>
			</div>
		</div>

		<div class="right_box">
			<a data-popup-open="bld_branch_add" onclick="jqGridFunc.fn_centerInfo('Ins','0')" class="blueBtn">지점 등록</a>
			<a href="#" onClick="jqGridFunc.fn_delCheck()" class="grayBtn">삭제</a>
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
<!-- // 지점 등록 팝업 -->
<div id="bld_branch_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">지점 등록</h2>
      	<div class="pop_wrap">
          	<table class="detail_table">
				<tbody>
                	<tr>
                    	<th>지점 CODE</th>
                    	<td><input type="text" id="centerCd"></td>
                    	<th>지점명</th>
                    	<td><input type="text" id="centerNm"></td>
                	</tr>
                	<tr>
                  		<th>주소</th>
                  		<td colspan="3">
                    		<input type="text" id="centerAddr1" style="width: 200px; margin-right: 5px;">
                    		<input type="text" id="centerAddr2" style="width: 200px; margin-right: 5px;">
                    		<input type ="button" onclick="execDaumPostcode()" value ="우편번호 찾기" >
                  		</td>
                	</tr>
                	<tr>
                    	<th>대표번호</th>
                    	<td><input type="text" id="centerTel" value="02-3422-0000"></td>
                    	<th>Fax</th>
                    	<td><input type="text" id="centerFax" value="02-3422-0001"></td>
                	</tr>
                	<tr>
                  		<th>전경사진</th>
                  		<td><input type="file" id="centerImg"></td>
                  		<th>내부이미지</th>
                  		<td><input type="file" id="centerMap"></td>
                	</tr>
                	<tr>
                  		<th>전체 사용 층</th>
                  		<td>
	                     	<select id="startFloor" onChange="jqGridFunc.fn_floorChange('')" style="width:120px">
		                        <option value="">시작 층수</option>
		                         <c:forEach items="${floorInfo}" var="floorList">
									<option value="${floorList.code}"><c:out value='${floorList.codenm}'/></option>
		                         </c:forEach>
	                    	</select> ~
	                    	<select id="endFloor" onChange="jqGridFunc.fn_floorChange('')"  style="width:120px">
		                        <option value="">종료 층수</option>
		                        <c:forEach items="${floorInfo}" var="floorList">
		                            <option value="${floorList.code}"><c:out value='${floorList.codenm}'/></option>
								</c:forEach>
	                    	</select> 
                  		</td>
                  		<th>사용 층수</th>
                  		<td>
							<span id="sp_floorInfo"></span> 
                  		</td>
					</tr>
                	<tr>
						<th>URL</th>
	                  	<td><input type="text" id="centerUrl"></td>
	                  	<th>사용 유무</th>
	                  	<td>
                    		<label for="useYn_Y"><input id="useYn_Y" type="radio" name="useYn" value="Y" checked>Y</label>
                    		<label for="useYn_N"><input id="useYn_N" type="radio" name="useYn" value="N">N</label>
                  		</td>
					</tr>
					<tr>
						<th>시범 지점 여부</th>
	                  	<td>
                    		<label for="centerPilotYn_Y"><input id="centerPilotYn_Y" type="radio" name="centerPilotYn" value="Y" checked>Y</label>
                    		<label for="centerPilotYn_N"><input id="centerPilotYn_N" type="radio" name="centerPilotYn" value="N">N</label>
                  		</td>
                  		<th>자유석 여부</th>
	                  	<td>
                    		<label for="centerStandYn_Y"><input id="centerStandYn_Y" type="radio" name="centerStandYn" value="Y" checked>Y</label>
                    		<label for="centerStandYn_N"><input id="centerStandYn_N" type="radio" name="centerStandYn" value="N">N</label>
                  		</td>
					</tr>
					<tr>
						<th>최대 자유석수</th>
	                  	<td><input type="text" id="centerStandMax" name="centerStandMax" onkeypress="onlyNum();"></td>
	                  	<th>지점 입장료</th>
	                  	<td><input type="text" id="centerEntryPayCost" name="centerEntryPayCost" onkeypress="onlyNum();"></td>
					</tr>
					<tr>
	                  	<th>SPEEDON CODE</th>
	                  	<td><input type="text" id="centerSpeedCd"  name="centerSpeedCd"></td>
	                  	<th>RBM CODE</th>
	                  	<td><input type="text" id="centerRbmCd" name="centerRbmCd" onkeypress="onlyNum();"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="right_box">
			<a id="btnUpdate" href="javascript:jqGridFunc.fn_CheckForm();" class="blueBtn">저장</a>
			<a href="javascript:common_modelClose('bld_branch_add');" class="grayBtn">취소</a>
		</div>
		<div class="clear"></div>
	</div>
</div>

<!-- 지점 정보 수정 팝업 // -->
<!-- 사전 예약  -->
<div id="bld_early_set" data-popup="bld_early_set" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">사전 예약 설정 <span>[장안지점]</span></h2>
      	<div class="pop_wrap">
        <fieldset class="whiteBox searchBox">
			<div class="top" style="border-bottom: 0px; padding: 0px;">
	            <p>복사지점</p>
	            <select id="preOpenCenterList" onChange="jqGridFunc.fn_preOpenInfo('change',this)">
					<option value="">지점 선택</option>
					<c:forEach items="${centerInfoComboList}" var="centerInfoComboList">
						<option value="${centerInfoComboList.center_cd}"><c:out value='${centerInfoComboList.center_nm}'/></option>
					</c:forEach>
	            </select>
	            <a href="javascript:jqGridFunc.fn_preOpenCopyModel();" class="grayBtn">복사</a>
			</div>
		</fieldset>
        <table class="whiteBox main_table">
			<thead>
				<tr>
	            	<th>요일</th>
	            	<th>회원 오픈 시간</th>
	            	<th>회원 예약 종료 시간</th>
	            	<th>비회원 오픈 시간</th>
	            	<th>비회원 예약 종료 시간</th>
	            	<th>최종 수정 일자</th>
            	</tr>
          </thead>
          <tbody class="inTxt">

          </tbody>
        </table>
		<div class="center_box">
          	<a href="javascript:jqGridFunc.fn_preOpen();" id="preopenChange" class="blueBtn">저장</a> 
          	<a href="javascript:common_modelClose('bld_early_set');" class="grayBtn">취소</a>
        </div>
		</div>
  </div>
</div>
<!-- 자동 취소 정보  -->
<div id="bld_noshow_set" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">자동 취소 설정 <span>[장안지점]</span></h2>
		<div class="pop_wrap">
		<fieldset class="whiteBox searchBox">
			<div class="top" style="border-bottom: 0px; padding: 0px;">
				<p>복사지점</p>
				<select id="noshowCenterList" onChange="jqGridFunc.fn_noshowInfo('change',this)">
					<option value="">지점 선택</option>
					<c:forEach items="${centerInfoComboList}" var="centerInfoComboList">
						<option value="${centerInfoComboList.center_cd}"><c:out value='${centerInfoComboList.center_nm}'/></option>
					</c:forEach>
	            </select>
	            <a href="javascript:jqGridFunc.fn_noshowInfoCopy();" class="grayBtn">복사</a>
			</div>
        </fieldset>
        <table class="whiteBox main_table">
			<thead>
				<tr>
		            <th>요일</th>
		            <th>1차 자동취소 시간</th>
		            <th>2차 자동취소 시간</th>
		            <th>최종 수정 일자</th>
		            <th>최종 수정자</th>
	            </tr>
          	</thead>
			<tbody class="inTxt">

          	</tbody>
		</table>
        <div class="center_box">
          	<a href="javascript:jqGridFunc.fn_noshow();" id="changeNoshow" class="blueBtn">저장</a> 
          	<a href="javascript:common_modelClose('bld_noshow_set');" class="grayBtn">취소</a>
        </div>
      </div>
  </div>
</div>
<!-- // 휴일관리 팝업 -->
<div id="bld_holiday_add" data-popup="bld_holiday_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">지점 휴일 정보 <span></span></h2>
		<div class="pop_wrap">
        	<fieldset class="whiteBox searchBox">
	          	<div class="top" style="border-bottom: 0px; padding: 0px;">
	            	<p>복사지점</p>
	            	<select id="centerHolyList" onChange="jqGridFunc.fn_centerHolyInfo('change',this)">
						<c:forEach items="${centerInfoComboList}" var="centerInfoComboList">
							<option value="${centerInfoComboList.center_cd}"><c:out value='${centerInfoComboList.center_nm}'/></option>
						</c:forEach>
	            	</select>
					<a href="javascript:jqGridFunc.fn_centerHolyCopyModel();"class="grayBtn">복사</a>
	          	</div>
        	</fieldset>
        	<table class="whiteBox main_table">
				<thead>
					<tr>
	            		<th>날짜</th>
	            		<th>휴일명</th>
	            		<th>사용유무</th>
	            		<th>최종수정자</th>
	                    <th>추가 ｜ 삭제</th>
					</tr>
	          	</thead>
	          	<tbody class="inTxt">
	            	<tr>
	              		<td><input type="text" id="holyDt" class="cal_icon" name="holyDt" autocomplete=off></td>
	              		<td><input type="text" id="holyNm"></td>
	              		<td>
							<select id="useYn">
								<option value="Y">사용</option>
								<option value="N">사용안함</option>
							</select>
						</td>
	              		<td><input type="text" id="lastUpdusrId" value="${sessionScope.LoginVO.adminId}" readonly></td>
	              		<td><a href="javascript:jqGridFunc.fn_HolyCheckForm();" class="blueBtn">추가</a></td>
	            	</tr>
	          	</tbody>
			</table>
		</div>
	</div>
</div>
<!-- 휴일관리 팝업 // -->
<!-- popup// -->
<script type="text/javascript">
	var isMultiSelect = true;

	$(document).ready(function() { 
		if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
			isMultiSelect = false;
			$(".right_box").eq(0).hide();
			$(".detail_table > tbody > tr").eq(8).hide();
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
		yearRange: '1970:2030' //1990년부터 2020년까지
        };	       
	    $("#holyDt").datepicker(clareCalendar);
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		$("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김			
 	});
   		    
	var jqGridFunc  = {
		setGrid : function(gridOption){			
			var grid = $('#'+gridOption);
			
			//ajax 관련 내용 정리 하기 
			var postData = {"pageIndex": "1"};
			
			grid.jqGrid({
				url : '/backoffice/bld/centerListAjax.do',
				mtype : 'POST',
				datatype : 'json',
				pager: $('#pager'),  
				ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
				ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
				ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
				
				postData : JSON.stringify(postData),
				
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
					{label: 'center_cd', key: true, name:'center_cd', index:'center_cd', align:'center', hidden:true},
					{label: '지점', name:'center_img', index:'center_img', align:'center', formatter: jqGridFunc.imageFomatter },
					{label: '지점명', name:'center_nm', index:'center_nm', align:'center'},
					{label: '연락처', name:'center_tel', index:'center_tel', align:'center'},
					{label: '주소', name:'center_addr', index:'center_addr', align:'center', formatter:jqGridFunc.address},
					{label: '사용유무', name:'use_yn', index:'use_yn', align:'center', sortable : false, formatter:jqGridFunc.useYn},
					{label: '최대자유석수', name:'center_stand_max', index:'center_stand_max', align:'center'},
					{label: '사전예약시간', name:'preOpenSetting', index:'preOpenSetting', align:'center', sortable : false, formatter:jqGridFunc.preOpenSettingButton},
					{label: '자동취소', name: 'noshowSetting',  index:'noshowSetting', align:'center', sortable : false, formatter:jqGridFunc.noshowSettingButton},
					{label: '층 관리', name: 'floorInfoSetting',  index:'floorInfoSetting', align:'center', sortable : false, formatter:jqGridFunc.floorInfoButton},
					{label: '휴일 관리', name: 'center_holy_use_yn', index:'center_holy_use_yn', align:'center', sortable : false, formatter:jqGridFunc.holyDaySettingButton},
					{label: '수정자', name:'last_updusr_id', index:'last_updusr_id', align:'center'},
					{label: '수정일자', name:'last_updt_dtm', index:'last_updt_dtm', align:'center'},
					//{label: '삭제', name: 'btn',  index:'btn', align:'center', sortable : false, formatter:jqGridFunc.rowBtn}
				], 
				rowNum : 10,  //레코드 수
				rowList : [10,20,30,40,50,100],  // 페이징 수
				pager : pager,
				refresh : true,
			    multiselect : isMultiSelect, // 좌측 체크박스 생성
				rownumbers : false, // 리스트 순번
				viewrecord : true,  // 하단 레코드 수 표기 유무
				//loadonce : false, // true 데이터 한번만 받아옴 
				loadui : "enable",
				loadtext:'데이터를 가져오는 중...',
				emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
				height : "100%",
				autowidth:true,
				shrinkToFit : true,
				refresh : true,
				loadComplete : function (data) {
					$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
				},
				loadError:function(xhr, status, error) {
					alert(error); 
				}, 
				onPaging: function(pgButton) {
					var gridPage = grid.getGridParam('page'); //get current  page
					var lastPage = grid.getGridParam("lastpage"); //get last page 
					var totalPage = grid.getGridParam("total");
    		              
					if (pgButton == "next"){
						if (gridPage < lastPage ){
							gridPage += 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "prev") {
						if (gridPage > 1 ){
							gridPage -= 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "first") {
						gridPage = 1;
                    } else if (pgButton == "last") {
						gridPage = lastPage;
					} else if (pgButton == "user") {
						var nowPage = Number($("#pager .ui-pg-input").val());
						
						if (totalPage >= nowPage && nowPage > 0 ) {
							gridPage = nowPage;
						} else {
							$("#pager .ui-pg-input").val(nowPage);
							gridPage = nowPage;
						}
					} else if (pgButton == "records") {
						gridPage = 1;
					}
					
					grid.setGridParam({
						page : gridPage,
						rowNum : $('.ui-pg-selbox option:selected').val(),
						postData : JSON.stringify({
										"pageIndex": gridPage,
										"searchKeyword" : $("#searchKeyword").val(),
										"pageUnit":$('.ui-pg-selbox option:selected').val()
									})
					}).trigger("reloadGrid");
				},
				onSelectRow : function(rowId) {
					// 체크 할떄
					if(rowId != null) {  
						
					}
				},
				ondblClickRow : function(rowid, iRow, iCol, e){
					grid.jqGrid('editRow', rowid, {keys: true});
				},
				onCellSelect : function (rowid, index, contents, action){
					var cm = $(this).jqGrid('getGridParam', 'colModel');
					
					if (cm[index].name !='cb'){
						jqGridFunc.fn_centerInfo("Edt", $(this).jqGrid('getCell', rowid, 'center_cd'));
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
		imageFomatter : function(cellvalue, options, rowObject) {
			//이미지 URL	
			var centerImg = (rowObject.center_img == "no_image.png") ? "/resources/img/no_image.png": "/upload/"+ rowObject.center_img;
			return '<img src="' + centerImg + ' " style="width:120px">';
    	},
    	address : function(cellvalue, options, rowObject) {
			/* return rowObject.center_zipcd + "<br>"+ CommonJsUtil.NVL(rowObject.center_addr1) +"  "+ CommonJsUtil.NVL( rowObject.center_addr2) */
			return CommonJsUtil.NVL(rowObject.center_addr1) +"  "+ CommonJsUtil.NVL( rowObject.center_addr2)
		},
    	useYn : function(cellvalue, options, rowObject) {
			return (rowObject.use_yn ==  "Y") ? "사용" : "사용안함";
		},
		rowBtn : function (cellvalue, options, rowObject) {
			return '<input type="button" onclick="jqGridFunc.delRow('+rowObject.center_cd+')" value="DEL"/>';
		},
		preOpenSettingButton : function (cellvalue, options, rowObject) {
			return '<a href="javascript:jqGridFunc.fn_preOpenInfo(&#39;list&#39;,&#39;'+rowObject.center_cd+'&#39;);" class="detailBtn">설정</a>';
		},			
		noshowSettingButton : function (cellvalue, options, rowObject) {
			return '<a href="javascript:jqGridFunc.fn_noshowInfo(&#39;list&#39;,&#39;'+rowObject.center_cd+'&#39;);" class="detailBtn">설정</a>';
		},
		floorInfoButton : function (cellvalue, options, rowObject) {
			return '<a href="javascript:jqGridFunc.fn_centerFloorInfo(&#39;'+rowObject.center_cd+'&#39;);" class="orangeBtn">층 관리</a>';	
		},
		holyDaySettingButton : function (cellvalue, options, rowObject) {
			return '<a href="javascript:jqGridFunc.fn_centerHolyInfo(&#39;list&#39;,&#39;'+rowObject.center_cd+'&#39;);" class="blueBtn">휴일 추가</a>';	
		},
		refreshGrid : function(){
			$('#mainGrid').jqGrid().trigger("reloadGrid");
		},
		fn_delCheck  : function(){      
			var menuArray = new Array();
 			    getEquipArray("mainGrid", menuArray);
 			    if (menuArray.length > 0){
 				  $("#hid_DelCode").val(menuArray.join(","))
 				  $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
 				  menuArray = null;
        		      fn_ConfirmPop("삭제 하시겠습니까?");
 			    }else {
 				  menuArray = null;
 				  common_modelCloseM("체크된 값이 없습니다.", "savePage");
 			    }
 			    
	    },
	    fn_del : function (){
	    	var params = {'centerList':$("#hid_DelCode").val() };
         	    fn_uniDelAction("/backoffice/bld/centerInfoDelete.do", "GET", params, false, "jqGridFunc.fn_search");
         	},
		clearGrid : function() {
			$("#mainGrid").clearGridData();
		},
		fn_search: function(){
			$("#mainGrid").setGridParam({
				datatype : "json",
				postData : JSON.stringify({
					"pageIndex": $("#pager .ui-pg-input").val(),
					"searchKeyword" : $("#searchKeyword").val(),
					"pageUnit":$('.ui-pg-selbox option:selected').val()
				}),
				loadComplete : function(data) {
					$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
				}
			}).trigger("reloadGrid");
 		}, 
		fn_floorChange:function(floorinfo) {
			//층수로 input 생성 
			if ($("#startFloor").val() != "" && $("#endFloor").val() != "") {
				//선책 층 유효성 검사
				if (fnIntervalCheck($("#startFloor").val().replace("CENTER_FLOOR_", ""), $("#endFloor").val().replace("CENTER_FLOOR_", ""), "시작 층수가 종료 층수 보다 큽니다.", "bld_branch_add") == false) {
					return false;
				} else {
					fnCreatCheckbox("sp_floorInfo", $("#startFloor").val().replace("CENTER_FLOOR_", ""),  $("#endFloor").val().replace("CENTER_FLOOR_", ""), floorinfo, "floorInfos", "층");	
				}
			}
		},
		fn_centerInfo : function (mode, centerCd) {
			
			$("#mode").val(mode);
			$("#centerCd").val(centerCd).attr('readonly', true);
			if (mode == "Ins") {
				$("#bld_branch_add .pop_tit").html("지점 정보 등록");
				$("#btnUpdate").text('등록');
				$("#centerNm").val("");
				$("#startFloor").val("");
				$("#endFloor").val("");
				$("#centerAddr1").val("");
				$("#centerAddr2").val("");
				$("#centerTel").val("");
				$("#centerFax").val("");
				$("#centerUrl").val("");
				$("#centerSpeedCd").val("");					
				$("input:radio[name='centerStandYn']:radio[value='Y']").prop('checked', true);
				$("#centerStandMax").val("");
				$("#centerEntryPayCost").val("");
				$("#centerRbmCd").val("");
				$("input:radio[name='useYn']:radio[value='Y']").prop('checked', true);
				
				
				$("#sp_floorInfo").empty();
			} else {
				var url = "/backoffice/bld/centerInfoDetail.do";
				var param = {"centerCd" : centerCd};
				fn_Ajax
				(
				    url, 
				    "GET",
					param,
					false,
					function(result) {
						if (result.status == "LOGIN FAIL") {
							common_popup(result.meesage, "Y","");
							location.href="/backoffice/login.do";
					    } else if (result.status == "SUCCESS") {
							var obj = result.regist;
							$("#bld_branch_add .pop_tit").html("[" + obj.center_nm + "] 지점 정보 수정");
							$("#btnUpdate").text('저장');
							$("#centerCd").val(obj.center_cd).attr('readonly', true); 
							$("#centerNm").val(obj.center_nm);
							$("#centerAddr1").val(obj.center_addr1);
							$("#centerAddr2").val(obj.center_addr2);
							$("#centerTel").val(obj.center_tel);
							$("#centerFax").val(obj.center_fax);
							$("#startFloor").val(obj.start_floor);
							$("#endFloor").val(obj.end_floor);
							$("#centerUrl").val(obj.center_url);
							$("#centerSpeedCd").val(obj.center_speed_cd);
							$("input:radio[name='useYn']:radio[value='" + obj.use_yn + "']").prop('checked', true);
							$("input:radio[name='centerPilotYn']:radio[value='" + obj.center_pilot_yn + "']").prop('checked', true);
							$("input:radio[name='centerStandYn']:radio[value='" + obj.center_stand_yn + "']").prop('checked', true);
							$("#centerStandMax").val(obj.center_stand_max);
							$("#centerEntryPayCost").val(obj.center_entry_pay_cost);
							$("#centerRbmCd").val(obj.center_rbm_cd);
							$("#ir3").val(obj.center_info);
							fnCreatCheckbox("sp_floorInfo", $("#startFloor").val().replace("CENTER_FLOOR_", ""),  $("#endFloor").val().replace("CENTER_FLOOR_", ""), obj.floor_info, "floorInfos", "층") ;
						}
					},
					function(request){
						    common_popup("Error:" + request.status,"");
					}    		
				);
			}
			$("#bld_branch_add").bPopup();
		},
		//지점 사전예약시간 관련 function
		fn_preOpenInfo : function(division,centerCd) {
			centerCd = division == "list" ? centerCd : centerCd.value;
			if(division == "list") {
				$("#searchCenterCd").val(centerCd);
			}
			var url = "/backoffice/bld/preOpenInfoListAjax.do"; 
			var param = {"centerCd" : centerCd};
			$("#bld_early_set .inTxt").html("");
			fn_Ajax
			(
				url, 
				"GET",
				param,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "Y","");
				    	location.href="/backoffice/login.do";
				    } else if (result.status == "SUCCESS") {
				    	if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
							if($("#loginCenterCd").val() != centerCd){
								$("#preopenChange").hide();
							} else {
								$("#preopenChange").show();
							}
				    	}
						//지점 자동취소 정보 세팅
						var setHtml = "";
						if(result.regist != null) {
							$("#bld_early_set .pop_tit span").html("[" + result.result + "]");
 							for(var i in result.regist) {
 								setHtml = "";
 								var obj = result.regist[i];

 								var color = 
 									obj.open_day == "1" ? "red" : 
 									obj.open_day == "7" ? "blue" : "black";
 								
 								setHtml += "<tr id='" + obj.optm_cd + "'>";
								setHtml += "<td style='color : " + color + ";'>" + obj.open_day_text + "</td>";
								setHtml += "<td><input type='text' id='" + obj.optm_cd + "_open_member_tm" + "'value='" + obj.open_member_tm + "' onKeyup='inputTimeFormat(this);' placeholder='HH:MM' maxlength='5'/></td>";
								setHtml += "<td><input type='text' id='" + obj.optm_cd + "_close_member_tm" + "'value='" + obj.close_member_tm + "' onKeyup='inputTimeFormat(this);' placeholder='HH:MM' maxlength='5'/></td>";
								setHtml += "<td><input type='text' id='" + obj.optm_cd + "_open_guest_tm" +"'value='" + obj.open_guest_tm + "' onKeyup='inputTimeFormat(this);' placeholder='HH:MM' maxlength='5'/></td>";
								setHtml += "<td><input type='text' id='" + obj.optm_cd + "_close_guest_tm" +"'value='" + obj.close_guest_tm + "' onKeyup='inputTimeFormat(this);' placeholder='HH:MM' maxlength='5'/></td>";
								setHtml += "<td>" + obj.last_updt_dtm + "</td>";
								setHtml += "</tr>";
								
								$("#bld_early_set .inTxt").append(setHtml);
							}
						} else {
							$("#bld_early_set .inTxt").append("<tr colspan='4'>등록된 정보가 존재하지 않습니다.<tr>");	
						}
						
						
						$("#preOpenCenterList").val(centerCd);
					}
				},
				function(request){
					common_popup("Error:" + request.status,"");						
				}    		
			);
			$("#bld_early_set").bPopup();
		},
		fn_preOpen : function (){
			$("#bld_early_set").bPopup().close();
			$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_preOpenInfoUpdate()");
			fn_ConfirmPop("입력된 지점 사전예약정보를 저장하시겠습니까?");
		},
		fn_preOpenInfoUpdate : function() {
			$("#confirmPage").bPopup().close();
			var url = "/backoffice/bld/preOpenInfoUpdate.do";
			var params = new Array();
			$("#bld_early_set .inTxt tr").each(function(index, item) {
				var optmCd = $(item).attr('id');
				var param = new Object();
					param['optmCd'] = optmCd;
					param['openMemberTm'] = $("#" + optmCd + "_open_member_tm").val().replace(/\:/g, "");
					param['openGuestTm'] = $("#" + optmCd + "_open_guest_tm").val().replace(/\:/g, "");	
					param['closeMemberTm'] = $("#" + optmCd + "_close_member_tm").val().replace(/\:/g, "");	
					param['closeGuestTm'] = $("#" + optmCd + "_close_guest_tm").val().replace(/\:/g, "");	
					params.push(param);
			});
			
			
			fn_Ajax
			(
				url, 
				"POST",
				params,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "Y","bld_early_set");
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						common_modelCloseM(result.message, "bld_early_set");
					} else{
						common_popup("저장 도중 문제가 발생 하였습니다.", "N", "bld_early_set");
					}
				},
				function(request){
					common_modelCloseM("Error:" + request.status,"bld_early_set");
				}    		
			);
			
		},
		fn_preOpenCopyModel : function(){
			$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_preOpenInfoCopy()");
			fn_ConfirmPop("해당 지점의 사전예약정보를 복사 하시겠습니까?");
		},
		fn_preOpenInfoCopy : function() {
			$("#confirmPage").bPopup().close();
			var url = "/backoffice/bld/preOpenInfoCopy.do";
			var copyCenterCd = $("#preOpenCenterList option:selected").val();
			var targetCenterCd = $("#searchCenterCd").val();
			
			var params = 
			{
				"copyCenterCd" : copyCenterCd,
				"targetCenterCd" : targetCenterCd
			};
			
			fn_Ajax
			(
				url, 
				"POST",
				params,
				true,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "N","");
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						common_popup(result.message, "Y" ,"bld_early_set");
					}else {
						common_popup(result.meesage, "Y","bld_early_set");
					}
				},
				function(request){ 
					common_popup("Error:" + request.status,"");
				}    		
			);
			
		},
		//지점 자동취소시간 관련 function
		fn_noshowInfo : function(division,centerCd) {
			centerCd = division == "list" ? centerCd : centerCd.value;
			
			if(division == "list") {
				$("#searchCenterCd").val(centerCd);
			}
			
			var url = "/backoffice/bld/noshowInfoListAjax.do";
			var param = {"centerCd" : centerCd};

			$("#bld_noshow_set .inTxt").html("");
			
			fn_Ajax
			(
				url, 
				"GET",
				param,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "N","");
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
							if($("#loginCenterCd").val() != centerCd){
								$("#changeNoshow").hide();
							} else{
								$("#changeNoshow").show();
							}
				    	}
						//지점 자동취소 정보 세팅
						var setHtml = "";
						if(result.regist != null) {
							var noshowInfoList = result.regist;
							$("#bld_noshow_set .pop_tit span").html("[" + result.result + "]");
							
 							for(var i=0; i < noshowInfoList.length; i++) {
 								var obj = noshowInfoList[i];
 								var color = 
 									obj.noshow_day == "1" ? "red" : 
 									obj.noshow_day == "7" ? "blue" : "black";
 								
 								setHtml += "<tr id='" + obj.noshow_cd + "'>";
								setHtml += "<td style='color : " + color + ";'>" + obj.noshow_day_text + "</td>";
								/* 오전 노쇼,오후 노쇼 기능 제거
								setHtml += "<td><input type='text' id='" + obj.noshow_cd + "_noshow_am_tm" + "'value='" + obj.noshow_am_tm + "' onKeyup='inputTimeFormat(this);' placeholder='HH:MM' maxlength='5'/></td>";*/
								setHtml += "<td><input type='text' id='" + obj.noshow_cd + "_noshow_pm_tm" +"'value='" + obj.noshow_pm_tm + "' onKeyup='inputTimeFormat(this);' placeholder='HH:MM' maxlength='5'/></td>"; 
								setHtml += "<td><input type='text' id='" + obj.noshow_cd + "_noshow_all_tm" +"'value='" + obj.noshow_all_tm + "' onKeyup='inputTimeFormat(this);' placeholder='HH:MM' maxlength='5'/></td>";
								setHtml += "<td>" + obj.last_updt_dtm + "</td>";
								setHtml += "<td>" + obj.last_updusr_id + "</td>";
								setHtml += "</tr>";
							}
						} else {
							$("#bld_noshow_set .inTxt").append("<tr><td colspan='5'>등록된 자동취소정보가 존재하지 않습니다.<td></tr>");	
						}
						$("#bld_noshow_set .inTxt").append(setHtml);
						$("#noshowCenterList").val(centerCd);
					}
				},
				function(request){
					common_popup("Error:" + request.status,"");
				}    		
			);
			
			$("#bld_noshow_set").bPopup();
		},
		fn_noshow : function (){
			$("#bld_noshow_set").bPopup().close();
			$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_noshowInfoUpdate()");
			fn_ConfirmPop("입력된 지점 사전예약정보를 저장하시겠습니까?");
		},
		fn_noshowInfoUpdate : function() {
			$("#confirmPage").bPopup().close();
			var url = "/backoffice/bld/noshowInfoUpdate.do";
			var params = new Array();
			$("#bld_noshow_set .inTxt tr").each(function(index, item) {
				var noshowCd = $(item).attr('id');
				var param = new Object();
					param['noshowCd'] = noshowCd;
				/* 오전 노쇼,오후 노쇼 기능 제거
				param['noshowAmTm'] = $("#" + noshowCd + "_noshow_am_tm").val().replace(/\:/g, "");*/
				param['noshowPmTm'] = $("#" + noshowCd + "_noshow_pm_tm").val().replace(/\:/g, ""); 
				param['noshowAllTm'] = $("#" + noshowCd + "_noshow_all_tm").val().replace(/\:/g, "");
				params.push(param);
			});
			
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
						common_modelCloseM(result.message, "bld_noshow_set");
					}
				},
				function(request){
					common_modelCloseM("Error:" + request.status,"bld_noshow_set");
				}    		
			);
			
		},
		fn_noshowCopyModel : function(){
			$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_noshowInfoCopy()");
			fn_ConfirmPop("해당 지점의 사전예약정보를 복사 하시겠습니까?");
		},
		fn_noshowInfoCopy : function() {
		
			var url = "/backoffice/bld/noshowInfoCopy.do";
			var copyCenterCd = $("#noshowCenterList option:selected").val();
			var targetCenterCd = $("#searchCenterCd").val();
			
			var params = 
			{
				"copyCenterCd" : copyCenterCd,
				"targetCenterCd" : targetCenterCd
			};
			
			fn_Ajax
			(
				url, 
				"POST",
				params,
				true,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.message, "N","bld_noshow_set");
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						common_popup(result.message, "Y" ,"bld_noshow_set");
					}else {
						common_popup(result.message, "N","bld_noshow_set");
					}
				},
				function(request){ 
					common_popup("Error:" + request.status,"");
				}    		
			);
			
		},
		//지점 휴일정보시 관련 function
		fn_centerHolyInfo : function(division, centerCd, callbackYn) {
			centerCd = division == "list" ? centerCd : centerCd.value;
			if(division == "list") {
				$("#searchCenterCd").val(centerCd);
			}
			
			var url = "/backoffice/bld/centerHolyInfoListAjax.do";
			var param = {"centerCd" : centerCd};

			$("#bld_holiday_add .inTxt .cur_poin").remove();
			
			fn_Ajax
			(
				url, 
				"GET",
				param, 
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						alert(result.meesage);
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						//지점 자동취소 정보 세팅
						if(result.regist.length != 0) {
							var centerHolyInfoList = result.regist;
							var setHtml = "";
							
							$("#bld_holiday_add .pop_tit span").html("[" + result.result + "]");
							
 							for(var i=0; i < centerHolyInfoList.length; i++) {
 								var obj = centerHolyInfoList[i];
 								setHtml += "<tr id='" + obj.center_holy_seq + "' class='cur_poin'>";
								setHtml += "<td>" + obj.holy_dt + "</td>";
								setHtml += "<td>" + obj.holy_nm + "</td>";
								setHtml += "<td>" + obj.use_yn + "</td>";
								setHtml += "<td>" + obj.last_updusr_id + "</td>";
								setHtml += "<td><a onclick='jqGridFunc.fn_updateSelect(\"Edt\", "+ obj.center_holy_seq +")' class='blueBtn'>수정</a><a onclick='jqGridFunc.fn_holyDel(" + obj.center_holy_seq+ ")' class='grayBtn' style='margin-left: 5px;'>삭제</a></td>";;
								setHtml += "</tr>";
							}
						} else {
							setHtml += "<tr class='cur_poin'><td colspan='4'>등록된 휴일정보가 존재하지 않습니다.<td></tr>";	
						}
						
						$("#bld_holiday_add .inTxt").prepend(setHtml);
						$("#centerHolyList").val(centerCd);
					}
				},
				function(request){
					common_popup("Error:" + request.status,"");       						
				}    		
			);
			
			$("#holyDt").val("");
			$("#holyNm").val("");
			$("#useYn").val("Y");
			
			if(!callbackYn){
				$("#bld_holiday_add").bPopup();
			}
		},
			fn_updateSelect : function(mode, centerHolySeq){
			$("#centerHolySeq").val(centerHolySeq);
			$("#mode").val(mode);
			lastUpdusrId
			var url = "/backoffice/bld/centerHolyUpdateSelect.do";
			var param = {
							"centerHolySeq" : centerHolySeq,
							"mode" : mode,
						};
			
			fn_Ajax
			(
			    url, 
			    "GET",
				param,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "Y","");
						location.href="/backoffice/login.do";
				    } else if (result.status == "SUCCESS") {
				    	console.log(result);
						var obj = result.regist;
						$("#centerHolySeq").val(obj.center_holy_seq);
						$("#holyDt").val(obj.holy_dt);
						$("#holyNm").val(obj.holy_nm);
						$("#useYn").val(obj.use_yn).prop("selected", true);;
					}
				},
				function(request){
					    common_popup("Error:" + request.status,"");
				}    		
			);
		}, 
		fn_centerHolyUpdate : function (){
			//확인 
			/* $("#confirmPage").bPopup().close(); */
			var url = "/backoffice/bld/centerHolyInfoUpdate.do";
			var params =
			{ 	
				'centerHolySeq' : $("#centerHolySeq").val(),
				'centerCd' : $("#searchCenterCd").val(),
				'holyDt' : $("#holyDt").val(),
				'holyNm' : $("#holyNm").val(),
				'useYn' : $("#useYn").val(),
				'lastUpdusrId' : $("#lastUpdusrId").val(),
				'mode' : $("#mode").val()
			}; 
			
			fn_Ajax(url, "POST", params, true,
	      			function(result) {
	 				       if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.meesage, "Y","bld_holiday_add");
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'								
								common_popup("저장에 성공했습니다.", "Y", "bld_holiday_add");
		 				    	jqGridFunc.fn_centerHolyInfo("list",$("#searchCenterCd").val(), true);
	   					   }else if (result.status == "OVERLAP FAIL"){
	   							common_popup("휴일 일자가 중복 발생 하였습니다.", "Y", "bld_holiday_add");
	   							jqGridFunc.fn_holySearch();
	   					   }else if (result.status == "FAIL"){
	   						   common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "Y", "bld_holiday_add");
							   jqGridFunc.fn_holySearch();
	   					   }
	 				    },
	 				    function(request){
	 				    	common_modelCloseM("Error:" + request.status,"bld_holiday_add");
	 				    }    		
	        );
			$("#centerHolySeq").val("");
			$("#holyDt").val("");
			$("#holyNm").val("");
			$("#useYn").val("");
		},
		fn_centerHolyCopyModel : function(){
			$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_centerHolyInfoCopy()");
			fn_ConfirmPop("해당 지점의 사전예약정보를 복사 하시겠습니까?");
		},
		fn_centerHolyInfoCopy : function() {
			
			var url = "/backoffice/bld/centerHolyInfoCopy.do";
			var copyCenterCd = $("#centerHolyList option:selected").val();
			var targetCenterCd = $("#searchCenterCd").val();
			
			var params = 
			{
				"copyCenterCd" : copyCenterCd,
				"targetCenterCd" : targetCenterCd
			};
			
			fn_Ajax
			(
				url, 
				"POST",
				params,
				true,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "N","");
						location.href="/backoffice/login.do";
					} else if (result.status == "SUCCESS") {
						$("#bld_early_set").bPopup().close();
						common_modelClose("bld_holiday_add");
					}else {
						common_popup(result.meesage, "Y","bld_holiday_add");
					}
				},
				function(request){ 
					common_popup("Error:" + request.status,"");
				}    		
			);
		},		
		fn_HolyCheckForm : function () {
			if (any_empt_line_span("bld_holiday_add", "holyDt",  "날짜를 선택해주세요.","sp_message", "savePage") == false) return;
			if (any_empt_line_span("bld_holiday_add", "holyNm", "휴일명을 입력해주세요.","sp_message", "savePage") == false) return;
			if (any_empt_line_span("bld_holiday_add", "useYn", "사용유무를 입력해주세요","sp_message", "savePage") == false) return;
			if (any_empt_line_span("bld_holiday_add", "lastUpdusrId", "최종수정자를 입력해주세요","sp_message", "savePage") == false) return;
			var commentTxt = ($("#mode").val() == "Edt") ? "입력한 지점 휴일 정보를 수정 하시겠습니까?" : "신규 지점 휴일 정보를 등록 하시겠습니까?";
			
			javascript:jqGridFunc.fn_centerHolyUpdate();
       		
		},
		fn_holyDel : function(centerHolySeq) {
			var params = {'centerHolySeq': centerHolySeq};
			fn_uniDelAction("/backoffice/bld/centerHolyInfoDelete.do", "GET", params, false, "jqGridFunc.fn_search");
			jqGridFunc.fn_centerHolyInfo("list",$("#searchCenterCd").val(), true);
		},
		fn_centerFloorInfo : function(centerCd) {
			$("#searchCenterCd").val(centerCd);
			//location.href= "/backoffice/bld/floorList.do?centerCd=" + centerCd;
			//$("form[name=regist]").attr("action", "/backoffice/bld/floorList.do").submit();
			$('#contents').load('/backoffice/bld/floorList.do?searchCenterCd='+ centerCd);
		},
		fn_CheckForm : function () {
			if (any_empt_line_span("bld_branch_add", "centerNm",  "지점명을 입력해주세요.","sp_message", "savePage") == false) return;
			if (any_empt_line_span("bld_branch_add", "centerAddr1", "주소를 입력해주세요.","sp_message", "savePage") == false) return;
			if (any_empt_line_span("bld_branch_add", "centerTel", "지점연락처를 입력해주세요","sp_message", "savePage") == false) return;
			var floorInfo = ckeckboxValue("체크된 층수가 없습니다.", "floorInfos", "bld_branch_add");
			$("#floorInfo").val(floorInfo);
     		var commentTxt = ($("#mode").val() == "Ins") ? "신규 지점 정보를 등록 하시겠습니까?" : "입력한 지점 정보를 저장 하시겠습니까?";
			$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
       		fn_ConfirmPop(commentTxt);
		},
		fn_update : function(floorInfo){
			
			if(floorInfo == false) return;
			
			//체크 박스 체그 값 알아오기 
			var formData = new FormData();
    			  
			formData.append('centerImg', $('#centerImg')[0].files[0]);
			formData.append('centerMap', $('#centerMap')[0].files[0]);
     	    formData.append('centerCd' , $("#centerCd").val());
     	    formData.append('centerNm' , $("#centerNm").val());
     	    formData.append('centerAddr1' , $("#centerAddr1").val());
     	    formData.append('centerAddr2' , $("#centerAddr2").val());
     	    formData.append('centerTel' , $("#centerTel").val());
     	    formData.append('centerFax' , $("#centerFax").val());
     	   	formData.append('centerUrl' , $("#centerUrl").val());
     	    formData.append('mode' , $("#mode").val());
     	    formData.append('centerInfo' , $("#centerInfo").val());
     	    formData.append('startFloor' , $("#startFloor").val());
     	    formData.append('endFloor' , $("#endFloor").val());
     	    formData.append('floorInfo' , $("#floorInfo").val());
     	    formData.append('useYn', $('input[name=useYn]:checked').val());
     	    formData.append('centerPilotYn', $('input[name=centerPilotYn]:checked').val());
     	    formData.append('centerSpeedCd' , $("#centerSpeedCd").val());
     	   	formData.append('centerStandYn', $('input[name=centerStandYn]:checked').val());
     	    formData.append('centerStandMax' , $("#centerStandMax").val());
     	    formData.append('centerEntryPayCost' , $("#centerEntryPayCost").val());
     	    formData.append('centerRbmCd' , $("#centerRbmCd").val());
     	   
     	    uniAjaxMutipart
     	    (
				"/backoffice/bld/centerInfoUpdate.do", 
				formData, 
				function(result) {
					//결과값 추후 확인 하기 	
					if (result.status == "SUCCESS"){
						common_modelCloseM(result.message, "confirmPage");
						    jqGridFunc.fn_search();
					} else if (result.status == "LOGIN FAIL") {
						common_modelClose("bld_branch_add");
						    document.location.href="/backoffice/login.do";
					} else {
						common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "Y", "bld_branch_add");
					}
				},
				function(request){
					common_modelCloseM("Error:" +request.status, "N", "bld_branch_add");	
				}    		
			);
		}
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />