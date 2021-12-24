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
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="blklstSeq" name="blklstSeq">
<input type="hidden" id="searchBlklstDvsn" name="searchBlklstDvsn" value="BLKLST_DVSN_1">
<div class="breadcrumb">
 	<ol class="breadcrumb-item">
 		<li>고객 관리&nbsp;&gt;&nbsp;</li>
 		<li class="active">출입 통제 관리</li>
 	</ol>
</div>
<h2 class="title">출입 통제 관리</h2>
<div class="clear"></div>
<div class="dashboard">
  	<div class="boardlist">
    	<div class="whiteBox searchBox">
        	<div class="sName">
            	<h3>검색 옵션</h3>
          	</div>
      		<div class="top">
        		<p>검색 구분</p>
        		<select id="searchCondition">
          			<option value="USER_ID">아이디</option>
          			<option value="USER_NM">이름</option>
          			<option value="USER_PHONE">전화번호</option>
        		</select>
        		<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
      		</div>
      		<div class="inlineBtn">
        		<a href="javascript:jqGridFunc.fn_search();"class="grayBtn">검색</a>
      		</div>
    	</div>
    	
    	<div class="left_box mng_countInfo">
      		<p>총 : <span id="sp_totcnt">100</span>건</p>
    	</div>	
    	<div class="clear"></div>
    	
    	<div class="tabs blacklist">
      		<div id="BLKLST_DVSN_1" class="tab active" onclick="blackUserService.fn_changeBlklstDvsn(this);">블랙리스트</div>
      		<div id="BLKLST_DVSN_2" class="tab" onclick="blackUserService.fn_changeBlklstDvsn(this);">자가출입통제</div>
      		<div id="BLKLST_DVSN_3" class="tab" onclick="blackUserService.fn_changeBlklstDvsn(this);">패널티 고객</div>
    	</div>
    	
    	<div class="right_box">
        	<a href="javascript:$('#blacklist_add').bPopup()" class="blueBtn">입장 제한 고객 등록</a>
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
<!-- contents// -->
<!-- //popup -->
<!-- // 입장제한고객 등록 팝업 -->
<div id="blacklist_add" data-popup="blacklist_add" class="popup">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">입장 제한 고객 등록</h2>
      <div class="pop_wrap">
          <table class="detail_table blacklist_add_table">
              <tbody>
                  <tr>
                    <th>회원 조회</th>
                    <td>
                      <select id="userSearchCondition">
                          <option value="user_id">아이디</option>
                          <option value="user_nm">이름</option>    
                          <option value="user_phone">전화번호</option>             
                      </select>
                      <input type="text" id="userSearchKeyword">
                      <a href="javascript:blackUserService.fn_searchResult('user');" class="blueBtn">조회</a>
                    </td>
                      <th>아이디 </th>
                      <td><input type="text" id="userId" readonly></td>
                  </tr>
                  <tr>
                      <th>이름 </th>
                      <td><input type="text" id="userNm" readonly></td>
                      <th>전화번호 </th>
                      <td><input type="text" id="userPhone" readonly></td>
                  </tr>
                  <tr>
                    <th>제한 유형</th>
                    <td>
                        <select id="blklstDvsn">
                          <option value="BLKLST_DVSN_1">블랙리스트</option>
                          <option value="BLKLST_DVSN_2">자가출입통제</option>
                          <option value="BLKLST_DVSN_3">패널티 고객</option>
                        </select>
                    </td>
<!--                     <th>회원 구분</th> -->
<!--                     <td><input type="text" id=""></td> -->
                  </tr>
                  <tr>
                    <th>상세 내역</th>
                      <td colspan="3">
                        <textarea style="width: 400px; height: 150px;" id="blklstReason"></textarea>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>
      <div class="right_box">
          <a href="javascript:blackUserService.fn_checkForm();" class="blueBtn">등록</a>
          <a href="javascript:$('#blacklist_add').bPopup().close();" class="grayBtn">취소</a>
      </div>
      <div class="clear"></div>
  </div>
</div>
<!-- 관리자 등록 팝업 // -->
<!-- // 관리자 검색 팝업 -->
<div id="search_result" class="popup">
	<div class="pop_con">
		<a href="javascript:common_modalOpenAndClose('blacklist_add', 'search_result');" class="button pop-close">X</a>
		<h2 class="pop_tit">검색 결과</h2>
      	<div id="searchResult" class="pop_wrap">
        	<table id="searchResultTable" class="whiteBox main_table">
        	
        	</table>
      	</div>
  	</div>
</div>
<!-- 관리자 검색 팝업 // -->
<!-- popup// -->
<script type="text/javascript">
	$(document).ready(function() { 
		jqGridFunc.setGrid("mainGrid");
		
		/* rsv_blacklist tab (table) */
		$('.blacklist.tabs>.tab').on('click', function(){
		  var tabIdx = $(this).index();
		  var $tabBtn = $('.blacklist.tabs>.tab');
		  var $tbody = $('.blacklist.main_table>tbody');
		  $tabBtn.removeClass('active');
		  $(this).addClass('active');
		  $tbody.removeClass('active');
		  $tbody.eq(tabIdx).addClass('active');
		})
	});
    
	var jqGridFunc = {
		setGrid : function(gridOption) {
			var grid = $('#'+gridOption);
			
			//ajax 관련 내용 정리 하기 
			var postData = {"pageIndex": "1", "searchBlklstDvsn" : $("#searchBlklstDvsn").val()};
			
			grid.jqGrid({
				url : '/backoffice/rsv/blackListAjax.do',
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
					{label: 'blklst_seq', key: true, name:'blklst_seq', index:'blklst_seq', align:'center', hidden:true},
					{label: '이름', name:'user_nm', index:'user_nm', align:'center', hidden:true},
					{label: '이름', name:'blklst_dvsn', index:'user_nm', align:'center', hidden:true},
					{label: '아이디', name:'user_id', index:'user_id', align:'center'},
					{label: '전화번호', name:'user_phone', index:'user_phone', align:'center'},
					{label: '유형', name:'blklst_dvsn_txt', index:'blklst_dvsn_txt', align:'center'},
					{label: '상세내용', name:'blklst_reason', index:'blklst_reason', align:'center'},
					{label: '노쇼카운트', name:'user_noshow_cnt', index:'user_noshow_cnt', align:'center',
						    formatter:jqGridFunc.fn_NoShowInfo},
					{label: '변경일자', name:'user_noshow_last_dt', index:'user_noshow_last_dt', align:'center'},
					{label: '해제', name:'blklst_cancel_yn', index:'blklst_cancel_yn', align:'center', sortable : false, formatter:jqGridFunc.buttonSetting},
				], 
				rowNum : 10,  //레코드 수
				rowList : [10,20,30,40,50,100],  // 페이징 수
				pager : pager,
				refresh : true,
			    multiselect : false, // 좌측 체크박스 생성
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
					$("#"+gridOption).jqGrid('hideCol', ["user_noshow_cnt", "user_noshow_last_dt"]);
					//resize
					gridResize(gridOption);
					
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
				ondblClickRow : function(rowid, iRow, iCol, e) {
					grid.jqGrid('editRow', rowid, {keys: true});
				},
				onCellSelect : function (rowid, index, contents, action){
/* 					var cm = $(this).jqGrid('getGridParam', 'colModel');
					
					if (cm[index].name !='btn'){
						jqGridFunc.fn_resvInfo("Edt", $(this).jqGrid('getCell', rowid, 'resv_seq'));
					} */
				},
				//체크박스 선택시에만 체크박스 체크 적용
				beforeSelectRow: function (rowid, e) { 
					var $myGrid = $(this), i = $.jgrid.getCellIndex($(e.target).closest('td')[0]), 
					cm = $myGrid.jqGrid('getGridParam', 'colModel'); 
					return (cm[i].name === 'cb'); 
				}
				
			});
		}, fn_NoShowInfo : function(cellvalue, options, rowObject) {
			return (rowObject.blklst_dvsn_txt != "없음") ?  rowObject.user_noshow_cnt + "" : 
				    rowObject.user_noshow_cnt + "<a href='#' onClick='jqGridFunc.fn_NoShowInsert(&#39;" + rowObject.user_id + "&#39;,&#39;" + rowObject.user_nm + "&#39;,&#39;" + rowObject.user_phone + "&#39;)' class='blueBtn'> 패널티 고객 등록</a>";
		}, fn_NoShowInsert : function(userId, userNm, userPhone){
			
			
			var url = "/backoffice/rsv/updateBlackUserInfo.do";
			var params = {
				"mode" : "Ins", 
				"blklstCancelYn" : "N",
				"blklstDvsn" : "BLKLST_DVSN_3",
				"userId" : userId,
				"userNm" :userNm,
				"userClphn" :userPhone,
				"blklstReason" : "페털티 고객이 등록되었습니다."
			};
			
			var resultTxt = "페털티 고객이 등록되었습니다.";
			
			fn_Ajax
			(
				url, 
				"POST",
				params,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "N","");
						location.href="/backoffice/login.do";
			    	} else if (result.status == "SUCCESS") {
			    		common_popup(resultTxt, "Y","");
			    		jqGridFunc.fn_search();
					}
				},
				function(request){
					common_popup("Error:" + request.status,"");
				}    		
			);
			
			
			
			
			
		},
    	useYn : function(cellvalue, options, rowObject) {
			return (rowObject.use_yn ==  "Y") ? "사용" : "사용안함";
		},
		buttonSetting : function (cellvalue, options, rowObject) {
			var cancelYn = "";
			var mode = "";
			if(rowObject.blklst_cancel_yn == "Y") {
				cancelYn = "재등록";
				mode = "N";
			} else {
				cancelYn = "해제";
				mode = "Y";				
			}

			return '<a href="javascript:blackUserService.fn_cancelBlklst(&#39;' + mode + '&#39;,&#39;' + rowObject.blklst_seq + '&#39;,&#39;' + rowObject.blklst_dvsn + '&#39,&#39;' + rowObject.user_id + '&#39;);" class="blueBtn">' + cancelYn + '</a>';	
		},			
		refreshGrid : function(){
			$('#mainGrid').jqGrid().trigger("reloadGrid");
		},
		clearGrid : function() {
			$("#mainGrid").clearGridData();
		},
		fn_search: function(){
			$("#mainGrid").setGridParam({
				datatype : "json",
				postData : JSON.stringify({
					"pageIndex": $("#pager .ui-pg-input").val(),
					"searchBlklstDvsn" : $("#searchBlklstDvsn").val(),
					"searchKeyword" : $("#searchKeyword").val(),
					"searchCondition" : $("#searchCondition").val(),
					"pageUnit":$('.ui-pg-selbox option:selected').val()
				}),
				loadComplete : function(data) {
					$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
					if ($("#searchBlklstDvsn").val() == "BLKLST_DVSN_3"){
						$("#mainGrid").jqGrid('showCol', ["user_noshow_cnt", "user_noshow_last_dt"]);
					}else {
						$("#mainGrid").jqGrid('hideCol', ["user_noshow_cnt", "user_noshow_last_dt"]);
					}
					//resize
					gridResize("mainGrid");
				}
			}).trigger("reloadGrid");
 		}
	}
	function gridResize(gridId) { 
		maxGridWidth = $("#contents").width() - 2; 		
		resizeJqGridWidth(gridId, "contents", maxGridWidth);

	}
	function resizeJqGridWidth(grid_id, div_id, width){ 
		// window에 resize 이벤트를 바인딩 한다. 
		$(window).bind('resize', function() { 
			// 그리드의 width 초기화 
			$('#' + grid_id).setGridWidth(width, false); 
			// 그리드의 width를 div 에 맞춰서 적용
			$('#' + grid_id).setGridWidth($('#' + div_id).width() , false); 
			//Resized to new width as per window 
		    }).trigger('resize'); 
	}

		
	var blackUserService = {
		fn_changeBlklstDvsn : function(el){
			$("#searchKeyword").val("");
			$('.ui-pg-selbox option:selected').val(10);
			$("#searchBlklstDvsn").val($(el).attr("id"));
			jqGridFunc.fn_search();
		},
		fn_blacklistAdd : function() {
			$("#userSearchCondition option:eq(0)").prop("selected",true);
			$("#userSearchKeyword option:eq(0)").prop("selected",true); 
			$("#userId").val("");
			$("#userNm").val("");
			$("#userPhone").val("");
			$("#blklstDvsn option:eq(0)").prop("selected",true);
			$("#blklstReason").val("");
		},
		fn_checkForm : function() {
			$("#mode").val("Ins");
			if (any_empt_line_span("blacklist_add", "userId", "회원 아이디를 입력해 주세요.","sp_message", "savePage") == false) return;
			
			var url = "/backoffice/rsv/updateBlackUserInfo.do";
			var params = {
				"mode" : $("#mode").val(), 
				"blklstCancelYn" : "N",
				"blklstDvsn" : $("#blklstDvsn").val(),
				"userId" : $("#userId").val(),
				"userNm" : $("#userNm").val(),
				"userClphn" : $("#userPhone").val(),
				"blklstReason" : $("#blklstReason").val()
			};
			
			var resultTxt = "출입통제 정보가 정상적으로 등록 되었습니다.";
			
			fn_Ajax
			(
				url, 
				"POST",
				params,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "N","");
						location.href="/backoffice/login.do";
			    	} else if (result.status == "SUCCESS") {
			    		common_popup(resultTxt, "Y","");
			    		jqGridFunc.fn_search();
					}
				},
				function(request){
					common_popup("Error:" + request.status,"");
				}    		
			);
		},
		fn_cancelBlklst : function (blklstCancelYn, blklstSeq, blklst_dvsn, userId) {
			$("#mode").val("Edt");
			
			var url = "/backoffice/rsv/updateBlackUserInfo.do";
			var params = {"mode" : $("#mode").val(), "blklstSeq" : blklstSeq,"blklstCancelYn" : blklstCancelYn, "blklstDvsn" : blklst_dvsn, "userId" : userId};
			var resultTxt = blklstCancelYn == "Y" ? "출입통제가 정상적으로 해제되었습니다." : "출입통제가 정상적으로 재등록 되었습니다.";
			
			fn_Ajax
			(
				url, 
				"POST",
				params,
				false,
				function(result) {
					if (result.status == "LOGIN FAIL") {
						common_popup(result.meesage, "N","");
						location.href="/backoffice/login.do";
			    	} else if (result.status == "SUCCESS") {
			    		common_popup(resultTxt, "Y","");
			    		jqGridFunc.fn_search();
					}
				},
				function(request){
					common_popup("Error:" + request.status,"");
				}    		
			);
		},
		fn_searchResult : function (searchDvsn){
			var setHtml = "<table id='searchResultTable' class='whiteBox main_table'>";
			$("#searchResult").empty();
			$("#searchResult").append(setHtml);
			
			var checkTag = "";
			var colModel = "";
			var gridEmp = $("#searchResultTable");
			var postData = "";
			var url = "";
			gridEmp.jqGrid('clearGridData',true);
			
			if(searchDvsn == "user") {
				url ="/backoffice/cus/userListAjax.do";
				checkTag = "userSearchKeyword";
				colModel =
				[
					{ label: '아이디', name:'user_id', index:'user_id', align:'left', width:'150px'},
					{ label: '이름',  name:'user_nm', index:'user_nm', align:'left', width:'150px'},
					{ label: '전화번호', name:'user_phone', index:'user_phone', align:'left', width:'150px'},
				];
				postData = {"pageIndex": "1", "mode": "", "searchCondition" : $("#userSearchCondition").val(), "searchKeyword" : $("#userSearchKeyword").val()};
			} else {
				url = "/backoffice/mng/empListAjax.do";
				checkTag = "empSearchKeyword";
				colModel =
				[
					{ label: '부서', name:'dept_nm', index:'dept_nm', align:'left', width:'150px'},
					{ label: '사번', name:'emp_no', index:'emp_no', align:'left', width:'150px'},
					{ label: '이름', name:'emp_nm', index:'emp_nm', align:'left', width:'150px'},
					{ label: '전화번호', name:'emp_clphn', index:'emp_clphn', align:'left', width:'0px', hidden:true},
					{ label: '이메일', name:'emp_email', index:'emp_email', align:'left', width:'0px', hidden:true}
				];
				postData = {"pageIndex": "1", "mode": "search", "searchCondition" : $("#empSearchCondition").val(), "searchKeyword" : $("#empSearchKeyword").val()};
			}
			
			if (any_empt_line_span("blacklist_add", checkTag, "검색어를 입력해 주세요.","sp_message", "savePage") == false) return;	
			
			$("#search_result").bPopup();
			
			gridEmp.jqGrid({
				url : url,
				mtype :  'POST',
				datatype :'json',
				ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
				ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
				ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
				postData : JSON.stringify( postData ),
				jsonReader : {
					root : 'resultlist',
					"page":"paginationInfo.currentPageNo",
					"total":"paginationInfo.totalPageCount",
					"records":"paginationInfo.totalRecordCount",
					repeatitems:false
				},
				colModel : colModel,  //상단면 
				rowNum : 1000,  //레코드 수
				refresh : false,
				rownumbers : false, // 리스트 순번
				viewrecord : true,    // 하단 레코드 수 표기 유무
			    loadui : "enable",
			    loadtext:'데이터를 가져오는 중...',
			    emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
			    height : "100%",
			    autowidth:false,
			    frozen:true, 
			    shrinkToFit : false,
			    refresh : true,
			    multiselect:false,
			    loadonce : true,
			    loadComplete : function (data){
			    	//완료 표시 
			    }, 
			    loadError:function(xhr, status, error) {
			    	loadtext:'시스템 장애... '
			    }, 
				onSelectRow: function(rowId){
					if(rowId != null) {  }// 체크 할떄
				}, 
				onCellSelect : function (rowid, index, contents, action){
					var cm = $('#searchResultTable').jqGrid('getGridParam', 'colModel');
					//console.log(cm);
					if (cm[index].name !='btn' ){
						blackUserService.fn_inSearchInfo(	
							$(this).jqGrid('getCell', rowid, 'user_id'),
							$(this).jqGrid('getCell', rowid, 'user_nm'),
							$(this).jqGrid('getCell', rowid, 'user_phone')
						);
					}
				}
			});
		
			//추후 변경 예정 
			$("#searchResultTable").setGridParam({
				datatype : "json",
				postData : JSON.stringify(postData),
				loadComplete : function(data) {}
			}).trigger("reloadGrid");
		},
		fn_inSearchInfo : function(userId, userNm, userPhone) {
			$("#userId").val(userId);
			$("#userNm").val(userNm);
			$("#userPhone").val(userPhone);
			$("#search_result").bPopup().close();
			$("#blacklist_add").bPopup();
		}
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />