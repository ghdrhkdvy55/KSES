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
<input type="hidden" id="seatCd" name="seatCd">
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="pageIndex" name="pageIndex">
<input type="hidden" id="selectFloorCd" name="selectFloorCd">
<input type="hidden" id="selectPartCd" name="selectPartCd">
<input type="hidden" id="changeFloorCd" name="changeFloorCd">
<input type="hidden" id="authorCd" name="authorCd" value="${loginVO.authorCd}">
<input type="hidden" id="loginCenterCd" name="loginCenterCd" value="${loginVO.centerCd}">
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>시설 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">좌석 관리</li>
	</ol>
</div>
<h2 class="title">좌석 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
        <div class="whiteBox searchBox">
			<div class="sName">
            	<h3>검색 옵션</h3>
            </div>
			<div class="top">
            	<p>지점</p>
             	<select id="searchCenterCd" onChange="jqGridFunc.fn_centerChange('search')">
                    <option value="">선택</option>
                     <c:forEach items="${centerList}" var="centerList">
						<option value="${centerList.center_cd}">${centerList.center_nm}</option>
                     </c:forEach>
            	</select>
            	<p>층</p>
            	<select id="searchFloorCd" onChange="jqGridFunc.fn_floorChange('search')">
					<option value="">선택</option>
            	</select>
            	<p>구역</p>
            	<select id="searchPartCd">
              		<option value="">선택</option>
            	</select>
            	<p>검색어</p>
            	<select id="searchCondition">
              		<option value="">선택</option>
              		<option value="seatNm">좌석명</option>
              		<option value="seatClass">좌석등급</option>
            	</select>
            	<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
          	</div>
          	
          	<div class="inlineBtn">
            	<a href="javascript:jqGridFunc.fn_search();" class="grayBtn">검색</a>
          	</div>
        </div>

		<div class="right_box">
			<a data-popup-open="bld_seat_add" onclick="jqGridFunc.fn_seatInfo('Ins','0')" class="blueBtn">좌석 등록</a>
			<a onClick="jqGridFunc.fn_delCheck()" class="grayBtn">삭제</a>
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
<!-- contents//-->
<!-- //popup -->
<!-- // 좌석 추가 팝업 -->
<div id="bld_seat_add" data-popup="bld_seat_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">좌석 정보 등록(수정)</h2>
		<div class="pop_wrap">
			<table class="detail_table">
				<tbody>
					<tr>
						<th>구역 선택</th>
							<td colspan="3">
	                     	<select id="centerCd" onChange="jqGridFunc.fn_centerChange('popup')">
		                        <option value="">지점선택</option>
								<c:forEach items="${centerList}" var="centerList">
									<option value="${centerList.center_cd}">${centerList.center_nm}</option>
								</c:forEach>
	                    	</select>
                        	<select id="floorCd" onChange="jqGridFunc.fn_floorChange('popup')">
                          		<option value="">층선택</option>
                        	</select>
                        	<select id="partCd">
                          		<option value="">구역선택</option>
                        	</select>
						</td>
                  	</tr>
                  	<tr>
                    	<th>좌석명</th>
                    	<td><input type="text" id="seatNm"></td>
                    	<th>좌석 구분</th>
                    	<td>
	                     	<select id="seatDvsn">
		                        <option value="">좌석 구분</option>
		                         <c:forEach items="${seatDvsn}" var="seatDvsn">
									<option value="${seatDvsn.code}">${seatDvsn.codenm}</option>
		                         </c:forEach>
	                    	</select>
                    	</td>
                  	</tr>
                  	<tr>
                    	<th>좌석 등급</th>
                    	<td>
	                     	<select id="seatClass">
		                        <option value="">좌석 등급</option>
		                         <c:forEach items="${seatClass}" var="seatClass">
									<option value="${seatClass.code}">${seatClass.codenm}</option>
		                         </c:forEach>
	                    	</select>
                    	</td>
                    	<th>사용유무</th>
                    	<td>
                    		<label for="useYn_Y"><input id="useYn_Y" type="radio" name="useYn" value="Y" checked>Y</label>
                    		<label for="useYn_N"><input id="useYn_N" type="radio" name="useYn" value="N">N</label>
                    	</td>
                  	</tr>
                  	<tr>
                    	<th>지불 구분</th>
                    	<td>
                      		<select id="payDvsn">
		                        <option value="">지불 구분</option>
		                         <c:forEach items="${payDvsn}" var="payDvsn">
									<option value="${payDvsn.code}">${payDvsn.codenm}</option>
		                         </c:forEach>
                      		</select>
                    	</td>
                    	<th>좌석 금액</th>
                    	<td><input type="text" id="payCost"></td>
                  	</tr>
              	</tbody>
			</table>
      	</div>
      	<div class="right_box">
			<a id="btnUpdate" href="javascript:jqGridFunc.fn_CheckForm();" id="btnUpdate" class="blueBtn">등록</a>
			<a href="javascript:bPopupClose('bld_seat_add');" class="grayBtn">취소</a>
      	</div>
      	<div class="clear"></div>
  	</div>
</div>
<!-- 좌석 추가 팝업 // -->
<!-- poopup// -->
<script type="text/javascript">
	$(document).ready(function() {
		if($("#authorCd").val() != "ROLE_ADMIN" && $("#authorCd").val() != "ROLE_SYSTEM") {
			/* $(".hideAuthor").hide(); */
			$(".top > p").eq(0).hide();
			$(".top > select").eq(0).hide();
		}
		
		jqGridFunc.setGrid("mainGrid");
	});
    
	var jqGridFunc  = {
		setGrid : function(gridOption){
			var grid = $('#'+gridOption);
			
			//ajax 관련 내용 정리 하기 
			var postData = {"pageIndex": "1"};
			
			grid.jqGrid({
				url : '/backoffice/bld/seatListAjax.do',
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
					{label: '좌석코드', key: true, name:'seat_cd', index:'seat_cd', align:'center', hidden:true},
					{label: '지점코드', name:'center_cd', index:'center_cd', align:'center', hidden:true},
					{label: '층코드', name:'floor_cd', index:'floor_cd', align:'center', hidden:true},
					{label: '구역코드', name:'part_cd', index:'part_cd', align:'center', hidden:true},
					{label: '지점', name:'center_nm', index:'center_nm', align:'center'},
					{label: '층수', name:'floor_nm', index:'floor_nm', align:'center'},
					{label: '구역', name:'part_nm', index:'part_nm', align:'center'},
					{label: '좌석명', name:'seat_nm', index:'seat_nm', align:'center'},
					{label: '좌석등급', name:'seat_class_txt', index:'seat_class_txt', align:'center'},
					{label: '좌석구분', name:'seat_dvsn_txt', index:'seat_dvsn_txt', align:'center'},
					{label: '금액', name: 'pay_cost',  index:'pay_cost', align:'center'},
					{label: '정렬순서', name: 'seat_order',  index:'seat_order', align:'center'},
					{label: '사용유무', name: 'use_yn', index:'use_yn', align:'center'},
					{label: '수정일자', name:'last_updt_dtm', index:'last_updt_dtm', align:'center'},
					{label: '수정자', name:'last_updusr_id', index:'last_updusr_id', align:'center'},
				], 
				rowNum : 10,  //레코드 수
				rowList : [10,20,30,40,50,100],  // 페이징 수
				pager : pager,
				refresh : true,
			    multiselect : true, // 좌측 체크박스 생성
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
										"searchCenterCd" : $("#searchCenterCd").val(),
										"searchFloorCd" : $("#searchFloorCd").val(),
										"searchPartCd" : $("#searchPartCd").val(),
										"searchFloorCd" : $("#searchFloorCd").val(),
										"searchCondition" : $("#searchCondition").val(),
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
						jqGridFunc.fn_seatInfo("Edt", $(this).jqGrid('getCell', rowid, 'seat_cd'));
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
    	useYn : function(cellvalue, options, rowObject) {
			return (rowObject.use_yn ==  "Y") ? "사용" : "사용안함";
		},
		rowBtn : function (cellvalue, options, rowObject) {
			return '<input type="button" onclick="jqGridFunc.delRow('+rowObject.center_cd+')" value="DEL"/>';
		},
		SettingButton : function (cellvalue, options, rowObject) {
			return '<a href="javascript:jqGridFunc.fn_Info(&#39;list&#39;,&#39;'+rowObject.seat_cd+'&#39;);" class="detailBtn">설정</a>';
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
	    	var params = {'seatCd':$("#hid_DelCode").val() };
         	    fn_uniDelAction("/backoffice/bld/seatInfoDelete.do", "GET", params, false, "jqGridFunc.fn_search");
         	},
 		delRow : function (centerCd) {
			if(trim(center_id) != "") {
				var params = {'centerCd' : trim(seatCd)};
				$("#searchKeyword").val("")
				fn_uniDelAction("/backoffice/bld/centerInfoDelete.do", params, "jqGridFunc.fn_search");
			}
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
					"searchCondition" : $("#searchCondition").val(),
					"searchCenterCd" : $("#searchCenterCd").val(),
					"searchFloorCd" : $("#searchFloorCd").val(),
					"searchPartCd" : $("#searchPartCd").val(),
					"pageUnit":$('.ui-pg-selbox option:selected').val()
				}),
				loadComplete : function(data) {
					$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
				}
			}).trigger("reloadGrid");
 		}, 
		fn_centerChange : function(division) {
			var el = division == "search" ? $("#searchCenterCd") : $("#centerCd");
			var targetEl = division == "search" ? $("#searchFloorCd") : $("#floorCd");
			var url = "/backoffice/bld/floorComboInfo.do";
			var param = {"centerCd" : el.val()};
			$("#searchPartCd").val("").prop("selected",true);
			jqGridFunc.fn_comboList(targetEl, url, param);
		},
		fn_floorChange : function(division) {
			var el = division == "search" ? $("#searchFloorCd") : $("#floorCd");
			var targetEl = division == "search" ? $("#searchPartCd") : $("#partCd");
			var url = "/backoffice/bld/partInfoComboList.do";
			var param = {"floorCd" : el.val()};				
			jqGridFunc.fn_comboList(targetEl, url, param);
		},
		fn_comboList : function(el, url, param) {
			var resultlist = uniAjaxReturn(url, "GET", false, param, "lst");

			if (resultlist.length > 0){
				var obj = resultlist;
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
		},
		fn_seatInfo : function (mode, seatCd) {
			$("#bld_seat_add").bPopup();
			$("#mode").val(mode);
		
				if (mode == "Ins") {
				$("#bld_seat_add .pop_tit").html("좌석 정보 등록");
				$("#btnUpdate").text('등록');
				
				$("#seatNm").val("");
				$("#centerCd").val(""); 
				$("#floorCd").val("");
				$('#floorCd').children('option:not(:first)').remove();
				$("#partCd").val("");
				$('#partCd').children('option:not(:first)').remove();
				$("#seatDvsn").val("");
				$("#seatClass").val("");
				$("#payDvsn").val("");
				$("#payCost").val("");
				$("input:radio[name='useYn']:radio[value='Y']").prop('checked', true);
			} else {
				$("#seatCd").val(seatCd);
				var url = "/backoffice/bld/seatInfoDetail.do";
				var params = {"seatCd" : seatCd};
      			  
				fn_Ajax
				(
					url, 
					"POST",
					params,
					false,
					function(result) {
						if (result.status == "LOGIN FAIL") {
							alert(result.meesage);
							location.href="/backoffice/login.do";
						} else if (result.status == "SUCCESS") {
							var obj = result.regist;
							
							$("#bld_seat_add .pop_tit").html("[" + obj.seat_nm + "] 좌석 정보 수정");
							$("#btnUpdate").text('저장');
							
							$("#seatNm").val(obj.seat_nm);
							$("#centerCd").val(obj.center_cd);
							jqGridFunc.fn_centerChange("popup");
							$("#floorCd").val(obj.floor_cd);
							jqGridFunc.fn_floorChange("popup");
							$("#partCd").val(obj.part_cd);
							$("#seatDvsn").val(obj.seat_dvsn);
							$("#seatClass").val(obj.seat_class);
							$("#payDvsn").val(obj.pay_dvsn);
							$("#payCost").val(obj.pay_cost);
							$("input:radio[name='useYn']:radio[value='" + obj.use_yn + "']").prop('checked', true);
						}
					},
					function(request){
						alert("ERROR : " +request.status);	       						
					}    		
				);
			}
		},
		fn_CheckForm : function () {
			if (any_empt_line_id("seatNm", "좌석명을 입력해주세요.") == false) return;		  
			if (any_empt_line_id("seatDvsn", "좌석 구분값을 선택해주세요.") == false) return;
			if (any_empt_line_id("seatClass", "좌석 등급을 선택해주세요.") == false) return;
			if (any_empt_line_id("payDvsn", "지불 구분값을 입력해주세요.") == false) return;
			if (any_empt_line_id("payCost", "금액을 입력해주세요.") == false) return;
			if($("#floorCd option").length > 1){
				if (any_empt_line_id("floorCd", "층을 선택해주세요.") == false) return;	
			}
			if($("#partCd option").length > 1){
				if (any_empt_line_id("partCd", "구역을 선택해주세요.") == false) return;
			}
			
			var commentTxt = ($("#mode").val() == "Ins") ? "신규 좌석 정보를 등록 하시겠습니까?" : "입력한 좌석 정보를 저장 하시겠습니까?";
			var resultTxt = ($("#mode").val() == "Ins") ? "신규 좌석 정보가 정상적으로 등록 되었습니다." : "지점 좌석가 정상적으로 저장 되었습니다.";
     		
			if (confirm(commentTxt)== true) {
				var params = {
		     	    'seatCd' : $("#seatCd").val(),
		     	    'seatNm' : $("#seatNm").val(),
		     	    'centerCd' : $("#centerCd").val(),
		     	    'floorCd' : $("#floorCd").val(),
		     	    'partCd' : $("#partCd").val(),
		     	    'seatClass' : $("#seatClass").val(),
		     	   	'seatDvsn' : $("#seatDvsn").val(),
		     	   	'payDvsn' : $("#payDvsn").val(),
		     	   	'payCost' : $("#payCost").val(),
		     	   	'useYn': $('input[name=useYn]:checked').val(),
		     	    'mode' : $("#mode").val()
				};
				var url = "/backoffice/bld/seatInfoUpdate.do";
				fn_Ajax
				(
					url,
					"POST",
					params,
					false,
					function(result) {
	 				       if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.meesage, "Y","bas_holiday_add");
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'
	   						   common_modelClose("bld_seat_add");
	   						   jqGridFunc.fn_search();
	   					   }else if (result.status == "FAIL"){
	   						   common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "Y", "bld_seat_add");
	   						   jqGridFunc.fn_search();
	   					   }
	 				    },
	 				    function(request){
	 				    	common_modelCloseM("Error:" + request.status,"bld_seat_add");
	 				    }    		 		
				);
			} 
		}   
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />