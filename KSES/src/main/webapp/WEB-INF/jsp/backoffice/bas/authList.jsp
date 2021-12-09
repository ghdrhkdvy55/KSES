<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<!-- JSTree -->
<link rel="stylesheet" href="/resources/css/style.min.css">
<script type="text/javascript" src="/resources/js/jstree.min.js"></script>
<!-- //contents -->
<input type="hidden" id="mode" name="mode" />
<div class="breadcrumb">
 	<ol class="breadcrumb-item">
    	<li>기초 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">권한 관리</li>
	</ol>
</div>
<h2 class="title">권한 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
		<div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <a href="#" onClick="jqGridFunc.fn_AuthorInfo('Ins', '0');" class="right_box blueBtn">권한분류추가</a>  
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>  
        </div>
	</div>
</div>
<!-- contents//-->
<!-- //popup -->
<!--권한분류 추가 팝업-->
<div id="bas_auth_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">권한 분류 추가</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>권한 코드</th>
                        <td>
                            <input type="text" id="authorCode" name="authorCode" >
                            <span id="sp_Unqi">
                            <a href="javascript:jqGridFunc.fn_idCheck('Basic')" class="blueBtn">중복확인</a>
                            <input type="hidden" id="idCheck">
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>권한명</th>
                        <td>
                            <input type="text" id="authorNm" name="authorNm">
                        </td>
                    </tr>
                    <tr>
                        <th>상세설명</th>
                        <td>
                            <input type="text" id="authorDc" name="authorDc">
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="#" onClick="common_modelClose('bas_auth_add')" class="grayBtn">취소</a>
            <a href="#" class="blueBtn" id="btnUpdate" onClick="jqGridFunc.fn_CheckForm()">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- 프로그램 추가 팝업-->
<div data-popup="bas_menu_create" id="bas_menu_create" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">메뉴 생성</h2>
        <div class="pop_wrap">
            <span id="sp_tree" style="display:none">
            </span>
            <div id="jstree">
            
            </div>
        </div>
        <div class="right_box">
            <a href="" onClick="fn_jstreeClose()" class="grayBtn">취소</a>
            <a href="#" onClick="fn_jstreeCheck()" class="blueBtn">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript">
	$(document).ready(function() { 
		   jqGridFunc.setGrid("mainGrid");
	});
	
	var jqGridFunc  = {
			
			setGrid : function(gridOption){
				var grid = $('#'+gridOption);
			    var postData = {"pageIndex": "1"};
			    grid.jqGrid({
			    	url : '/backoffice/bas/authListAjax.do' ,
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
	 		 	                { label: '권한 코드',  name:'author_code',         index:'author_code',        align:'left',   width:'10%'},
	 		 	                { label: '권한 명',  name:'author_nm',         index:'author_nm',        align:'left',   width:'10%'},
	 		 	                { label: '상세 설명',  name:'author_dc',         index:'author_dc',        align:'left',   width:'10%'},
	 		 	                { label: '생성일', name:'author_creat_de', index:'author_creat_de', align:'center', width:'12%', 
	   			                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
	   			                { label: '메뉴설정여부',  name:'menuCheck',         index:'menuCheck',        align:'left',   width:'10%',
	   			                	formatter:jqGridFunc.fn_menuCheck},
	   			                { label: '매뉴설정',  name:'menuBtn',         index:'menuBtn',        align:'left',   width:'10%'
	   			                  , formatter:jqGridFunc.fn_menuBtn},
	   			                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : 
	 			                  false, formatter:jqGridFunc.rowBtn}
				                ],  //상단면 
			        rowNum : 10,  //레코드 수
			        rowList : [10,20,30,40,50,100],  // 페이징 수
			        pager : pager,
			        refresh : true,
		            rownumbers : false, // 리스트 순번
			        viewrecord : true,    // 하단 레코드 수 표기 유무
			        //loadonce : false,     // true 데이터 한번만 받아옴 
			        loadui : "enable",
			        loadtext:'데이터를 가져오는 중...',
			        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
			        height : "100%",
			        autowidth:true,
			        shrinkToFit : true,
			        refresh : true,
			        loadComplete : function (data){
			        	 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
			        },loadError:function(xhr, status, error) {
			            alert(error); 
			        }, onPaging: function(pgButton){
			        	  var gridPage = grid.getGridParam('page'); //get current  page
			        	  var lastPage = grid.getGridParam("lastpage"); //get last page 
			        	  var totalPage = grid.getGridParam("total");
			              if (pgButton == "next"){
			            	  if (gridPage < lastPage ){
			            		  gridPage += 1;
			            	  }else{
			            		  gridPage = gridPage;
			            	  }
			              }else if (pgButton == "prev"){
			            	  if (gridPage > 1 ){
			            		  gridPage -= 1;
			            	  }else{
			            		  gridPage = gridPage;
			            	  }
			              }else if (pgButton == "first"){
			            	  gridPage = 1;
			              }else if  ( pgButton == "last"){
			            	  gridPage = lastPage;
			              } else if (pgButton == "user"){
			            	  var nowPage = Number($("#pager .ui-pg-input").val());
			            	  
			            	  if (totalPage >= nowPage && nowPage > 0 ){
			            		  gridPage = nowPage;
			            	  }else {
			            		  $("#pager .ui-pg-input").val(nowPage);
			            		  gridPage = nowPage;
			            	  }
			              }else if (pgButton == "records"){
			            	  gridPage = 1;
			              }
			              grid.setGridParam({
		    		          	  page : gridPage,
		    		          	  rowNum : $('.ui-pg-selbox option:selected').val(),
		    		          	  postData : JSON.stringify(  {
							    		          			"pageIndex": gridPage,
							    		          			"searchKeyword" : $("#searchKeyword").val(),
							    		          			"pageUnit":$('.ui-pg-selbox option:selected').val()
							    		          		})
			          		}).trigger("reloadGrid");
			        },onSelectRow: function(rowId){
		                if(rowId != null) {  }// 체크 할떄
		            },ondblClickRow : function(rowid, iRow, iCol, e){
		            	grid.jqGrid('editRow', rowid, {keys: true});
		            },onCellSelect : function (rowid, index, contents, action){
		            	var cm = $(this).jqGrid('getGridParam', 'colModel');
		                //console.log(cm);
		                if (cm[index].name=='author_code' || cm[index].name=='author_nm' || cm[index].name=='author_dc'){
		                	jqGridFunc.fn_AuthorInfo("Edt", $(this).jqGrid('getCell', rowid, 'author_code'));
	     		    }
		            }
			    });
			}, fn_menuCheck : function(cellvalue, options, rowObject){
			   return 	rowObject.chk_menu == "0" ? "미생성" : "생성";
			}, fn_menuBtn : function(cellvalue, options, rowObject){
				var mode = rowObject.chk_menu == "0" ? 'Ins':'Edt';
				
				return "<a  onClick=\"jqGridFunc.fn_menuCreate('"+ mode + "','"+ rowObject.author_code + "')\" class=\"blueBtn\" style='color: #FFF;'>메뉴 설정</a>";
			}, fn_menuCreate : function(mode, authorCode){
				 $("#mode").val(mode);
				 $("#authorCode").val(authorCode);
				 $("#bas_menu_create").bPopup();
				 $('#jstree').jstree("deselect_all"); //전체 선택 해제
	
				 if (mode == "Edt")
					  fn_menuCheck(authorCode);
			}, rowBtn: function (cellvalue, options, rowObject){
	        if (rowObject.author_code != "")
	     	   return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.author_code+"\");'>삭제</a>";
	     },refreshGrid : function(){
	        $('#mainGrid').jqGrid().trigger("reloadGrid");
	     },fn_search: function(){
	 	   $("#mainGrid").setGridParam({
	 	    	 datatype	: "json",
	 	    	 postData	: JSON.stringify(  {
	 	    		"pageIndex": $("#pager .ui-pg-input").val(),
	      			"searchKeyword" : $("#searchKeyword").val(),
	      			"pageUnit":$('.ui-pg-selbox option:selected').val()
	      		}),
	 	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
	 	     }).trigger("reloadGrid");
	
	     }, delRow : function (authorCode){
	     	if(authorCode != "") {
	     		 $("#hid_DelCode").val(authorCode)
					 $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
	    		     fn_ConfirmPop("삭제 하시겠습니까?");
			    }
	     }, fn_del: function (){
				var params = {'authorCode': $.trim($("#hid_DelCode").val()) };
				fn_uniDelAction("/backoffice/bas/authDelete.do", "POST", params, false, "jqGridFunc.fn_search");
		    }, clearGrid : function() {
	         $("#mainGrid").clearGridData();
	     }, fn_AuthorInfo : function (mode, authorCode){
	     	$("#bas_auth_add").bPopup();
	     	$("#mode").val(mode);
	 	    if (mode == "Edt"){
		        	$("#authorCode").val(authorCode).prop('readonly', true);
		        	$("#btnUpdate").text("수정");
		        	var params = {"authorCode" : authorCode};
		        	var url = "/backoffice/bas/authInfoDetail.do";
		        	
		        	fn_Ajax(url, "GET", params, true,
			          	    function(result) {
	  				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.message, "Y", "mng_admin_add");
		   						   location.href="/backoffice/login.do";
	    					   }else if (result.status == "SUCCESS"){
							       var obj  = result.regist;
	 						       $("#authorNm").val(obj.author_nm);
	 						       $("#authorDc").val(obj.author_dc);
	 						       $("#sp_Unqi").hide();
	 						       $("#btnSave").text("수정");
							   }else{
	    						  common_modelCloseM(result.message, "mng_admin_add");
	    					   }
			     			},
			     			function(request){
			     				 common_modelCloseM("Error:" +request.status, "mng_admin_add");
			     			}
		               );
		        }else{
		        	$("#authorCode").val('').prop('readonly', false);
		        	$("#authorNm").val('');
		        	$("#authorDc").val('');
		        	$("#sp_Unqi").show();
		        	$("#btnSave").text("입력");
		        }
		        $("#bas_auth_add").bPopup();
	    },fn_CheckForm  : function (){
	 	   if (any_empt_line_span("bas_auth_add", "authorCode", "코드를 입력해 주세요.","sp_message", "savePage") == false) return;
	 	   if ($("#mode").val() == "Ins" && $("#idCheck").val() != "Y"){
				   if (any_empt_line_span("bas_auth_add", "codeId", "중복체크가 안되었습니다.","sp_message", "savePage") == false) return;
			   }
			   if (any_empt_line_span("bas_auth_add", "authorNm", "권한명을 입력해 주세요.","sp_message", "savePage") == false) return;
			   var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
		       $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
			   fn_ConfirmPop(commentTxt);
		      
		  }, fn_update : function (){
			   $("#confirmPage").bPopup().close();
			   var url = "/backoffice/bas/authUpdate.do";
		       var params = {
		    		         'authorCode' : $("#authorCode").val(),
				    		 'authorNm' : $("#authorNm").val(),
				    		 'authorDc' : $("#authorDc").val(), 
				    		 'mode' : $("#mode").val()
		    	             }; 
		       fn_Ajax(url, "POST", params, true,
		      			function(result) {
		 				       if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y","bas_auth_add");
		   						   location.href="/backoffice/login.do";
		   					   }else if (result.status == "SUCCESS"){
		   						   //총 게시물 정리 하기'
		   						   common_modelClose("bas_auth_add");
		   						   jqGridFunc.fn_search();
		   					   }else if (result.status == "FAIL"){
		   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "bas_auth_add");
		   						   jqGridFunc.fn_search();
		   					   }
		 				    },
		 				    function(request){
		 				    	common_modelCloseM("Error:" + request.status,"bas_auth_add");
		 				    }    		
		       );
		    	
		  }, fn_idCheck : function (){
	     	//공용으로 활용 할지 정리 필요 
			 	var url = "/backoffice/bas/authorIDCheck.do"
	     	var param =  {"authorCode" : $("#authorCode").val()};
	     	if ($("#authorCode").val() != ""){
	     		fn_Ajax(url, "GET", param, false, 
	     			    function(result) {	
	 			              if (result != null) {
	 			                if (result.status == "SUCCESS"){
	 			        		    var message = result.result == "OK" ? '<spring:message code="common.codeOk.msg" />' : '<spring:message code="common.codeFail.msg" />';
	 			        		    var alertIcon =  result.result == "OK" ? "Y" : "N";
	 			        		    common_popup(message, alertIcon, "bas_auth_add");
				        		    	$("#idCheck").val(alertIcon);
									}else {
										common_popup('<spring:message code="common.codeFail.msg" />', "N", "bas_auth_add");
										$("#idCheck").val("N");
									}
	 			              }
							},
						    function(request){
								common_popup('서버 장애 입니다.', "N", "bas_code_add");
								$("#idCheck").val("N");	          						
						    }    		
		            ); 
	     	}else {
	     		 common_popup('<spring:message code="common.alertcode.msg" />', "N", "bas_auth_add");
			    	 $("#authorCode").focus();
			    	 return;	
		        }
		 }   
	}
	function fn_jstreeClose(){
		$("#bas_menu_create").bPopup().close();
		$("#authorCode").val('');
		$("#mode").val('');
	}
	function fn_jstreeCheck(){
		var arrSelect =  $("#jstree").jstree(true).get_selected('full',true);  
		var selectId = "";
		var menuArray = new Array();
		$.each(arrSelect, function(index, item){    
			menuArray.push(item.id);
		}); 
		if (menuArray.length > 0){
			  menuArray.push("0");
			  var params = {'checkedMenuNo':menuArray.join(","), 'mode' : $("#mode").val(), 'authorCode': $("#authorCode").val() };
			  var url = "/backoffice/bas/menuCreateUpdateAjax.do"
			  fn_Ajax(url, "POST", params, true,
	      			function(result) {
 				       if (result.status == "LOGIN FAIL"){
 				    	   common_popup(result.meesage, "Y","bas_menu_create");
   						   location.href="/backoffice/login.do";
   					   }else if (result.status == "SUCCESS"){
   						   //총 게시물 정리 하기'
   						   common_modelCloseM(result.message,"bas_menu_create");
   						   jqGridFunc.fn_search();
   					   }else if (result.status == "FAIL"){
   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "bas_menu_create");
   						   jqGridFunc.fn_search();
   					   }
	 				},
	 				function(request){
	 				    common_modelCloseM("Error:" + request.status,"bas_menu_create");
	 				}    		
			  );
			  $("#authorCode").val('');
			  $("#mode").val('');
		}else {
			  
			  common_popup("체크된 값이 없습니다.", "N", "bas_menu_create");
			  return;
		}
		menuArray = null;
	}
	function fn_menuCheck(authorCode){
		var params = {'authorCode': authorCode};
		var returnval = uniAjaxReturn("/backoffice/bas/menuCreateMenuListAjax.do", "GET", false, params,  "lst");
		
		for (var i in returnval){
			  var node = returnval[i].menu_no;
			  $('#jstree').jstree('select_node', node);
		}
	}
	$(function () {
		 var params = {"pageUnit" : 1000};
		 var returnval = uniAjaxReturn("/backoffice/bas/menuListAjax.do", "POST", false, params,  "lst");
		 
		 
		 
		 if (returnval.length> 0){
			 for (var i in returnval){
				 if (returnval[i].level == "1"){
					 var ul_list = $("#sp_tree"); 
					 ul_list.append("<ul id='ul_list'></ul>");
					 $("#ul_list").append("<li id='"+returnval[i].menu_no+"'>메뉴설정</li>");    	
					 $("#"+returnval[i].menu_no+"").append("<ul id='ul_"+returnval[i].menu_no+"'></ul>");
							 
				 }else if  (returnval[i].level == "2"){
					 var ul_list = $("#ul_"+returnval[i].upper_menu_no+""); //ul_list선언
					 ul_list.append("<li id='"+returnval[i].menu_no+"'>"+returnval[i].menu_nm+"</li>");
					 $("#"+returnval[i].menu_no+"").append("<ul id='ul_"+returnval[i].menu_no+"'></ul>");
				 }else {
					 var ul_list = $("#ul_"+returnval[i].upper_menu_no+""); //ul_list선언
    				 ul_list.append("<li id='"+returnval[i].menu_no+"'>"+returnval[i].menu_nm+"</li>");
				 }
			 }
			 $("#jstree").append($("#sp_tree").html());
		}
		 
	    $("#jstree").jstree({
	    	"checkbox" : {
	            "keep_selected_style": false
		    },
		    'plugins' : ["checkbox","dnd","contextmenu"]
		});
	    $("#jstree").jstree('open_all');
		
	});
</script>
<c:import url="/backoffice/inc/popup_common.do" />