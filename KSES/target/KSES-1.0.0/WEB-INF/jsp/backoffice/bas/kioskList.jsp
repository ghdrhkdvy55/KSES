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
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" />
    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <script src="/resources/js/bpopup.js"></script>
    <!-- datepicker-->
    <script src="/resources/js/jquery-ui.js"></script>
    <!-- 체크 -->
    <link rel="stylesheet" href="/resources/css/jquery-ui.css">
    <!-- <link rel="stylesheet" href="/css/jquery-ui.css"> -->
    
   	<script src="/resources/js/common.js"></script>
    
    <!-- jqGrid -->
	<link rel="stylesheet" type="text/css" href="/resources/jqgrid/src/css/ui.jqgrid.css">
    <script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
    <script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
    
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
	<script type="text/javascript">
		$(document).ready(function() { 
			jqGridFunc.setGrid("mainGrid");
	 	});
    	
		var jqGridFunc  = 
		{
    		setGrid : function(gridOption) {
    			var grid = $('#'+gridOption);
    		    //ajax 관련 내용 정리 하기 
    			
                var postData = {};
    		    grid.jqGrid({
    		    	url : '/backoffice/bas/kioskListAjax.do' ,
    		        mtype :  'POST',
    		        datatype :'json',
    		        pager: $('#pager'),  
    		        ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
    		        ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
    		        ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
    		       
    		        postData :  JSON.stringify(postData),
    		        jsonReader : 
    		        {
						root : 'resultlist',
						"page":"paginationInfo.currentPageNo",
						"total":"paginationInfo.totalPageCount",
						"records":"paginationInfo.totalRecordCount",
						repeatitems:false
   		            },
   		         	//상단면
    		        colModel :  
					[
						{ label: '무인발권기 Serial',  name:'ticket_mchn_sno', index:'ticket_mchn_sno', align:'center', width:'15%', key:true},
						{ label: '지점명',  name:'center_nm', index:'center_cd', align:'center', width:'10%'},
						{ label: '사용 층수', name:'floor_nm', index:'floor_cd', align:'center', width:'15%'},
						{ label: '위치', name:'ticket_mchn_remark', index:'ticket_mchn_remark', align:'center', width:'15%'},
						{ label: '사용 여부', name:'use_yn', index:'use_yn', align:'center', width:'40%'},
						{ label: '수정일자', name:'last_updt_dtm', index:'last_updt_dtm', align:'center', width:'10%'},
						{ label: '수정자', name: 'last_updusr_id',  index:'last_updusr_id', align:'center', width: '10%'}
					],
					//레코드 수
    		        rowNum : 10,
    		     	// 페이징 수
    		        rowList : [10,20,30,40,50,100],  
    		        pager : pager,
    		        refresh : true,
    		     	// 리스트 순번
    	            rownumbers : false,
    	         	// 하단 레코R드 수 표기 유무
    		        viewrecord : true,
    		     	// true 데이터 한번만 받아옴
    		        //loadonce : false,      
    		        loadui : "enable",
    		        loadtext:'데이터를 가져오는 중...',
    		      	//빈값일때 표시
    		        emptyrecords : "조회된 데이터가 없습니다", 
    		        height : "100%",
    		        autowidth:true,
    		        shrinkToFit : true,
    		        refresh : true,
    		        multiselect: true,
    		        loadComplete : function (data){
    		        	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    		        },
    		        beforeSelectRow: function (rowid, e) {
    		            var $myGrid = $(this);
    		            var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
    		            var cm = $myGrid.jqGrid('getGridParam', 'colModel');
    		            return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
    		        },
    		        loadError:function(xhr, status, error) {
    		            alert(error); 
    		        }, 
    		        onPaging: function(pgButton){
						var gridPage = grid.getGridParam('page'); //get current  page
						var lastPage = grid.getGridParam("lastpage"); //get last page 
						var totalPage = grid.getGridParam("total");
    		              
						if (pgButton == "next"){
							/* gridPage = gridPage < lastPage ? gridPage +=1 : gridPage; */
							if (gridPage < lastPage ){
								gridPage += 1;
							} else {
								gridPage = gridPage;
							}
						} else if (pgButton == "prev") {
							/* gridPage = gridPage > 1 ? gridPage -=1 : gridPage; */
							if (gridPage > 1 ) {
								gridPage -= 1;
							} else {
								gridPage = gridPage;
							}
						} else if (pgButton == "first"){
							gridPage = 1;
						} else if (pgButton == "last") {
							gridPage = lastPage;
						} else if (pgButton == "user"){
							var nowPage = Number($("#pager .ui-pg-input").val());
    		            	  
							if (totalPage >= nowPage && nowPage > 0 ){
								gridPage = nowPage;
    		            	} else {
    		            		$("#pager .ui-pg-input").val(nowPage);
    		            		gridPage = nowPage;
    		            	}
						} else if (pgButton == "records") {
    		            	  gridPage = 1;
						}
						
						grid.setGridParam
						({
							page : gridPage,
							rowNum : $('.ui-pg-selbox option:selected').val(),
							postData : JSON.stringify
							({
								"pageIndex": gridPage,
								"searchKeyword" : $("#searchKeyword").val(),
								"searchCondition" : $("#searchCondition").val(),
								"searchCenterCd" : $("#searchCenterCd").val(),
								"pageUnit":$('.ui-pg-selbox option:selected').val()
							})
						}).trigger("reloadGrid");
					},
					onSelectRow: function(rowId){
    	                if(rowId != null) {  }// 체크 할떄
    	            },
    	            ondblClickRow : function(rowid, iRow, iCol, e){
    	            	grid.jqGrid('editRow', rowid, {keys: true});
    	            },
    	            //셀 선택시 이벤트 등록
    	            onCellSelect : function (rowid, index, contents, action) {
    	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
    	                if (cm[index].name != 'cb') {
    	                	jqGridFunc.fn_kioskInfo("Edt", $(this).jqGrid('getCell', rowid, 'ticket_mchn_sno'));
            		    }
    	            }
    		    });
    		},
    		refreshGrid : function() {
				$('#mainGrid').jqGrid().trigger("reloadGrid");
	       	},
	       	clearGrid : function() {
				$("#mainGrid").clearGridData();
			}, 
	       	fn_delCheck  : function(){
   	    	    //체크값 삭제 
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
   	        	var params = {'ticketMchnSno':$.trim($("#hid_DelCode").val())};
   	        	fn_uniDelAction("/backoffice/bas/kioskDelete.do", "GET", params, false, "jqGridFunc.fn_search");
   	        },
           	fn_kioskInfo : function (mode, ticketMchnSno) {
           		$("#bas_kiosk_add").bPopup();
           		$("#mode").val(mode);
		        if (mode == "Edt") {
		           	var params = {"ticketMchnSno" : ticketMchnSno};
		     	   	var url = "/backoffice/bas/kioskInfoDetail.do";
		     	    $("#ticketMchnSno").val(ticketMchnSno).prop('readonly', true);
		     	   	fn_Ajax
		     	   	(
						url, 
						"GET",
						params, 
						false,
						function(result) {
							if (result.status == "LOGIN FAIL"){
								common_modelCloseM(result.meesage, "Y", "bas_holiday_add");
								location.href="/backoffice/login.do";
							} else if (result.status == "SUCCESS") {
								//총 게시물 정리 하기
								var obj = result.regist;
								$("#ticketMchnSno").val(obj.ticket_mchn_sno);
								$("#targetTicketMchnSno").val(obj.ticket_mchn_sno);
								$("#centerCd").val(obj.center_cd);
								jqGridFunc.fn_floorCombo();								
								$("#floorCd").val(obj.floor_cd);
								$("textarea[name=ticketMchnRemark]").val(obj.ticket_mchn_remark);		
								$("input:radio[name='useYn']:radio[value='"+obj.use_yn+"']").prop('checked', true);
								$("#sp_Unqi").hide();
    						    $("#btnSave").text("수정");
							}else {
							    common_modelCloseM(result.message, "bas_holiday_add");
							}

						},
						function(request){
							common_modelCloseM("ERROR : " +request.status, "bas_holiday_add");
						}    		
					);
				} else {			
					$("#ticketMchnSno").val("").prop('readonly', false);
					$("#useY").prop("checked", true);
					$("#centerCd option:eq(0)").prop("selected", true);
					$("#floorCd option:eq(0)").prop("selected", true);
					$("textarea[name=ticketMchnRemark]").val("");
					$("#sp_Unqi").show();
				    $("#btnSave").text("등록");
		        }
				$("#bas_kiosk_add").bPopup();
           	},
           	fn_floorCombo : function(){
				if ($("#centerCd").val() != ""){
					var _url = "/backoffice/bld/floorComboInfo.do";
					var _params = {"centerCd" : $("#centerCd").val()};
					var returnVal = uniAjaxReturn(_url, "GET", false, _params, "lst");

					if (returnVal.length > 0){
				        var obj  = returnVal;
					    $("#floorCd").empty();
					    $("#floorCd").append("<option value=''>선택</option>");
					    for (var i in obj) {
					        var array = Object.values(obj[i])
					        $("#floorCd").append("<option value='"+ array[0]+"'>"+array[1]+"</option>");
					    }
					}else {
				      //값이 없을때 처리 
						$("#floorCd").empty();
				    }
			    }else {
			    	if (any_empt_line_span("bas_kiosk_add", "centerCd", "지점을 선택해주세요.","sp_message", "savePage") == false) return;
			    }
			 
			},
			fn_CheckForm  : function () {
				if (any_empt_line_span("bas_kiosk_add", "ticketMchnSno", "무인발권기 Serial 입력해주세요.","sp_message", "savePage") == false) return;
				if ($("#mode").val() == "Ins" && $("#idCheck").val() != "Y"){
					   if (any_empt_line_span("bas_kiosk_add", "ticketMchnSno", "중복체크가 안되었습니다.","sp_message", "savePage") == false) return;
				}
				if (any_empt_line_span("bas_kiosk_add", "centerCd", "지점을 선택해주세요.","sp_message", "savePage") == false) return;
				if (any_empt_line_span("bas_kiosk_add", "floorCd", "층수를 선택해주세요.","sp_message", "savePage") == false) return;
				var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
			    $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
	       		fn_ConfirmPop(commentTxt);
		  	},
		  	fn_update: function(){
		  	    $("#confirmPage").bPopup().close();
				var url = "/backoffice/bas/kioskUpdate.do";
				var params = 
				{ 	
					'ticketMchnSno' : $("#ticketMchnSno").val(),
					'targetTicketMchnSno' : $("#targetTicketMchnSno").val(),
					'centerCd' : $("#centerCd").val(),
					'floorCd' : $("#floorCd").val(),
					'useYn' : $("input:radio[name='useYn']:checked").val(),
					'ticketMchnRemark' : $("#ticketMchnRemark").val(),
					'mode' : $("#mode").val()
				}; 
				fn_Ajax
				(
					url,
					"POST",
					params,
					false,
					function(result) {
						if (result.status == "LOGIN FAIL"){
							common_popup(result.message, "Y","bas_kiosk_add");
							location.href="/backoffice/login.do";
						} else if (result.status == "OVERLAP FAIL"){
							common_popup(result.message, "Y", "bas_kiosk_add");
						} else if (result.status == "SUCCESS") {
							common_modelCloseM(result.message, "bas_kiosk_add");
							jqGridFunc.fn_search();
						}else if (result.status == "FAIL"){
	   						   common_popup(result.message, "Y", "bas_kiosk_add");
	   						   jqGridFunc.fn_search();
	   					}
					},
					function(request){
						common_modelCloseM("Error:" + request.status,"bas_kiosk_add");
					}    		
				);
		  	},
			fn_search: function(){
				$("#mainGrid").setGridParam({
					datatype : "json",
					postData : JSON.stringify({
						"pageIndex": $("#pager .ui-pg-input").val(),
						"searchKeyword" : $("#searchKeyword").val(),
						"searchCenterCd" : $("#searchCenterCd").val(),
						"pageUnit":$('.ui-pg-selbox option:selected').val()
					}),
					loadComplete : function(data) {
						$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
					}
				}).trigger("reloadGrid");
	 		}, 
			fn_idCheck : function(){
				if (any_empt_line_span("bas_kiosk_add", "ticketMchnSno", "무인발권기 Serial을 입력해 주세요.","sp_message", "savePage") == false) return;
	        	var url = "/backoffice/bas/kisokSerialCheck.do"
    	        var param =  {"ticketMchnSno" : $("#ticketMchnSno").val()};

	        	fn_Ajax(url, "GET", param, false,
        			    function(result) {	
     			           if (result != null) {	       	
     			        	   if (result.status == "SUCCESS"){
     			        		    var message = result.result == "OK" ? '등록되지 않은 발권기 입니다.' : '등록된 발권기 입니다.';
     			        		    var alertIcon =  result.result == "OK" ? "Y" : "N";
     			        		    
     			        		    common_popup(message, alertIcon, "bas_kiosk_add");
    			        		    $("#idCheck").val(alertIcon);
								}else {
									
									common_popup('<spring:message code="common.codeFail.msg" />', "N", "bas_kiosk_add");
									$("#idCheck").val("N");
								}
							}else{
								
								common_modelCloseM(result.message,"bas_kiosk_add");
							}
						},
					    function(request){
							common_popup('<spring:message code="common.codeFail.msg" />', "N", "bas_kiosk_add");
							$("#idCheck").val("N");	       						
					    }    		
		        ); 
			}   
    	}
	</script>
</head>

<body>
<form:form name="regist" commandName="regist" method="post" action="/backoffice/bas/kioskList.do">
<div id="wrapper">	
	
		<c:import url="/backoffice/inc/top_inc.do" />
		<input type="hidden" name="mode" id="mode" >

		
		<div id="contents">
    		<div class="breadcrumb">
      			<ol class="breadcrumb-item">
        			<li>기초 관리</li>
       				<li class="active">　> 무인발권기 관리</li>
      			</ol>
    		</div>
    		
    		<h2 class="title">무인발권기 관리</h2>
    		<div class="clear">
    	</div>
    	<div class="dashboard">
        <!--contents-->
        	<div class="boardlist">
       <!--// search -->
	          	<div class="whiteBox searchBox">
	                <div class="sName">
	                  <h3>옵션 선택</h3>
	                </div>
	                <div class="top">
	                    <p>검색어</p>
	                    <select name="searchCenterCd" id="searchCenterCd"->
							<option value="">지점 선택</option>
							<c:forEach items="${centerInfo}" var="centerInfo">
								<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
							</c:forEach>
				        </select>
	                    <select id="searchCondition" name="searchCondition">
	                        <option value="ALL">전체</option>
							<option value="CENTER_NM">지점명</option>
							<option value="FLOOR_NM">사용층수</option>
	                    </select>
	                    <input type="text" name="searchKeyword" id="searchKeyword"   placeholder="검색어를 입력하새요.">
	                </div>
	                <div class="inlineBtn ">
	                    <a href="javascript:jqGridFunc.fn_search();" class="grayBtn">검색</a>
	                </div>
	            </div>
	            <div class="left_box mng_countInfo">
	              <p>총 : <span id="sp_totcnt"></span>건</p>
	            </div>
	            <div class="right_box">
	                <a href="#" class="blueBtn" onclick="jqGridFunc.fn_kioskInfo('Ins','')">무인발권기 등록</a>
	                <a href="#" onClick="jqGridFunc.fn_delCheck()" class="grayBtn">삭제</a>
	            </div>
	            <div class="clear"></div>
	            <div class="whiteBox"></div>
			</div>
		</div>


        <div class="Swrap tableArea">
			<table id="mainGrid">
			</table>
			<div id="pager" class="scroll" style="text-align:center;"></div>     
			<br />
			<div id="paginate"></div>   
		</div>
	</div>

</div>

	<!-- 무인발권기 정보 추가 팝업-->
	<div id="bas_kiosk_add" class="popup m_pop">
		<div class="pop_con">
			<a class="button b-close">X</a>
        	<h2 class="pop_tit">무인발권기 등록</h2>
        	<div class="pop_wrap">
        		<table class="detail_table">
               		<tbody>
                   		<tr>
							<th>무인발권기 Serial</th>
		                    <td>
		                    	<input type="text" name="ticketMchnSno" id="ticketMchnSno">
		                    	<span id="sp_Unqi">
                                <a href="javascript:jqGridFunc.fn_idCheck()" class="blueBtn">중복확인</a>
                                <input type="hidden" id="idCheck">
                                </span>
		                    </td>
						</tr>
						<tr>
					        <th>지점명</th>
				            <td>
				            	<select name="centerCd" id="centerCd" onchange="jqGridFunc.fn_floorCombo()">
									<option value="">지점 선택</option>
									<c:forEach items="${centerInfo}" var="centerInfo">
										<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
									</c:forEach>
				                 </select>
							</td>
						</tr>
						<tr>
					        <th>층수</th>
				            <td>
				            	
								<select name="floorCd" id="floorCd">
									<option value="">선택</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>사용 유무</th>
						    <td>
					            <span>
				                    <input type="radio" name="useYn" id="useY" value="Y" checked="checked">
				                    <label for="y">사용</label>
								</span>
							    <span>
						            <input type="radio" name="useYn" id="useN" value="N">
					                <label for="n">사용 안함</label>
				                </span>
			                </td>
		                </tr>
	                    <tr>
	                    	<th>설명</th>
							<td>
						        <textarea name="ticketMchnRemark" id="ticketMchnRemark" rows="5"></textarea>
					        </td>
				        </tr>
					</tbody>
				</table>
			</div>
		    <div class="right_box">
	        	<a href="#" onClick="common_modelClose('bas_kiosk_add')" class="grayBtn b-close">취소</a>
			    <a href="javascript:jqGridFunc.fn_CheckForm();" id="btnSave" class="blueBtn">저장</a>
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<c:import url="/backoffice/inc/popup_common.do" />
	<script type="text/javascript" src="/resources/js/back_common.js"></script>
</form:form>
</body>
</html>