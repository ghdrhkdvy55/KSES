<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JQuery Grid -->
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
<!-- Xlsx -->
<script type="text/javascript" src="/resources/js/xlsx.js"></script>
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- FileSaver -->
<script type="text/javascript" src="/resources/js/FileSaver.min.js"></script>
<!-- jszip -->
<script type="text/javascript" src="/resources/js/jszip.min.js"></script>
<!-- //contents -->
<input type="hidden" id="mode" name="mode" />
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">프로그램 관리</li>
	</ol>
</div>
<h2 class="title">프로그램 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
            
        </div>
        <div class="right_box">
			<a id="export" onClick="jqGridFunc.fn_excelDown()" class="blueBtn">엑셀 다운로드</a> 
        	<a href="#" onClick="jqGridFunc.fn_ProgramInfo('Ins', '')" class="blueBtn">프로그램 등록</a>             	
        </div>
         
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>  
        </div>
    </div>
</div>
<!-- contents// -->
<!-- //popup -->
<!-- 프로그램 추가 팝업-->
<div id="bas_program_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">프로그램 등록</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>프로그램 파일명</th>
                        <td>
                            <input type="text" id="progrmFileNm" name="progrmFileNm">
                        </td>
                    </tr>
                    <tr>
                        <th>지정 경로</th>
                        <td>
                            <input type="text" id="progrmStrePath" name="progrmStrePath">
                        </td>
                    </tr>
                    <tr>
                        <th>한글명</th>
                        <td>
                            <input type="text" id="progrmKoreannm" name="progrmKoreannm">
                        </td>
                    </tr>
                    <tr>
                        <th>URL</th>
                        <td>
                            <input type="text" id="url" name="url">
                        </td>
                    </tr>
                    <tr>
                        <th>설명</th>
                        <td>
                            <textarea cols="25" rows="5" id="progrmDc" name="progrmDc"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
        	<a href="#" class="blueBtn" onClick="jqGridFunc.fn_CheckForm()" id="btnUpdate" class="blueBtn">등록</a>
            <a href="#" onClick="common_modelClose('bas_program_add')" class="grayBtn">취소</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/js/temporary.js"></script>
<script type="text/javascript">
	$(document).ready(function() { 
		   jqGridFunc.setGrid("mainGrid");
	 });
    var jqGridFunc  = {
    		
    		setGrid : function(gridOption){
    			var grid = $('#'+gridOption);
    		    var postData = {"pageIndex": "1"};
    		    grid.jqGrid({
    		    	url : '/backoffice/bas/progrmListAjax.do' ,
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
	    		 	                { label: '프로그램 파일명',  name:'progrm_file_nm',         index:'progrm_file_nm',        align:'left',   width:'10%'},
	    		 	                { label: '프로그램명',  name:'progrm_koreannm',         index:'progrm_koreannm',        align:'left',   width:'10%'},
	    		 	                { label: 'URL',  name:'url',         index:'url',        align:'left',   width:'10%'},
	    		 	                { label: '프로그램설명', name:'progrm_dc', index:'progrm_dc', align:'center', width:'12%'},
	      			                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : 
	    			                  false, formatter:jqGridFunc.rowBtn}
    			                ],  //상단면 
    		        rowNum : 10,  //레코드 수
    		        rowList : [10,20,30,40,50,100],  // 페이징 수
    		        pager : pager,
    		        refresh : true,
    	            rownumbers : false, // 리스트 순번
    		        viewrecord : true,    // 하단 레코드 수 표기 유무
    		        loadonce : false,     // true 데이터 한번만 받아옴 
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
    	                if (cm[index].name !='btn'){
    	                	jqGridFunc.fn_ProgramInfo("Edt", $(this).jqGrid('getCell', rowid, 'progrm_file_nm'));
            		    }
    	            }
    		    });
    		}, rowBtn: function (cellvalue, options, rowObject){
               if (rowObject.progrm_file_nm != "")
            	   return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.progrm_file_nm+"\");'>삭제</a>";
            }, refreshGrid : function(){
	           $('#mainGrid').jqGrid().trigger("reloadGrid");
	        }, fn_search: function(){
	    	   $("#mainGrid").setGridParam({
	    	    	 datatype	: "json",
	    	    	 postData	: JSON.stringify(  {
	    	    		"pageIndex": $("#pager .ui-pg-input").val(),
	         			"searchKeyword" : $("#searchKeyword").val(),
	         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		}),
	    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
	    	     }).trigger("reloadGrid");
 
	        }, delRow : function (progrmFileNm){
	        	if(progrmFileNm != "") {
	        		   $("#hid_DelCode").val(progrmFileNm)
	 				   $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
	        		   fn_ConfirmPop("삭제 하시겠습니까?");
			    }
            }, fn_del: function (){
			     var params = {'progrmFileNm': $("#hid_DelCode").val() };
			     fn_uniDelAction("/backoffice/bas/programeDelete.do","GET", params, false, "jqGridFunc.fn_search");
   		      
		    }, clearGrid : function() {
                $("#mainGrid").clearGridData();
            }, fn_ProgramInfo : function (mode, progrmFileNm){
            	$("#mode").val(mode);
        	    if (mode == "Edt"){
		        	$("#progrmFileNm").val(progrmFileNm).prop('readonly', true);
		        	$("#btnUpdate").text("수정");
		        	var params = {"progrmFileNm" : progrmFileNm};
		        	var url = "/backoffice/bas/programeDetail.do";
		        	fn_Ajax(url, "GET", params, false,
			          	    function(result) {
		        		       if (result.status == "LOGIN FAIL"){
	     				    	   common_modelCloseM(result.meesage, "Y", "bas_code_add");
		   						   location.href="/backoffice/login.do";
	       					   }else if (result.status == "SUCCESS"){
       						       var obj  = result.regist;
       						       $("#bas_program_add > div >h2").text("프로그램 수정");
       						       $("#progrmStrePath").val(obj.progrm_stre_path);
       						       $("#progrmKoreannm").val(obj.progrm_koreannm);
       						       $("#progrmDc").val(obj.progrm_dc);
       						       $("#url").val(obj.url);
       						       $("#btnSave").text("수정");
	       					   }else{
	       						   common_modelCloseM(result.message,"bas_code_add");
	       					   }
			     			},
			     			function(request){
			     			     
			     			     common_modelCloseM("Error:" + request.status,"bas_code_add");
			     			}
		               );
		        }else{
		        	$("#bas_program_add > div >h2").text("프로그램 등록");
		        	$("#progrmFileNm").val('').prop('readonly', false);
		        	$("#progrmStrePath").val('');
		        	$("#progrmKoreannm").val('');
		        	$("#progrmDc").val('');
		        	$("#url").val('');
		        	$("#btnUpdate").text("등록");
		        }
		        $("#bas_program_add").bPopup();
           },fn_CheckForm  : function (){
        	   if (any_empt_line_span("bas_program_add", "progrmFileNm", "프로그램를 입력해 주세요.","sp_message", "savePage") == false) return;
        	   if (any_empt_line_span("bas_program_add", "progrmKoreannm", "프로그램 명을 입력해 주세요.","sp_message", "savePage") == false) return;
			   if (any_empt_line_span("bas_program_add", "url", "url을 입력해 주세요.","sp_message", "savePage") == false) return;
			   var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
		       $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
       		   fn_ConfirmPop(commentTxt);
		       
		  }, fn_update : function(){
			  $("#confirmPage").bPopup().close();
			  var url = "/backoffice/bas/programeUpdate.do";
		      var params = {    'progrmFileNm' : $("#progrmFileNm").val(),
				    		     'progrmStrePath' : $("#progrmStrePath").val(),
				    		     'progrmKoreannm' : $("#progrmKoreannm").val(),
				    		     'progrmDc' : $("#progrmDc").val(),
				    		     'url' : $("#url").val(), 
				    		     'mode' : $("#mode").val()
		    	               }; 
		      fn_Ajax(url, "POST", params, false,
		      			function(result) {
		    	               if (result.status == "LOGIN FAIL"){
		 				    	   common_popup(result.meesage, "Y","bas_program_add");
		 				    	   location.href="/backoffice/login.do";
		   					   }else if (result.status == "OVERLAP FAIL" ){
		   						   common_popup(result.message,"N", "bas_program_add");
		   						   jqGridFunc.fn_search();
		   					   }else if (result.status == "SUCCESS"){
		   						   //총 게시물 정리 하기'
		   						   common_modelCloseM("정상적으로 저장 되었습니다.","bas_program_add");
		   						   jqGridFunc.fn_search();
		   					   }else {
		   						   common_popup(result.meesage, "N", "bas_program_add");
		   						   jqGridFunc.fn_search();
		   					   }
		 				    },
		 				    function(request){
		 				    	common_modelCloseM("Error:" + request.status,"bas_program_add");
		 				    }    		
		        );
		}, fn_excelDown : function (){
			
			if ($("#mainGrid").getGridParam("reccount") === 0) {
				alert('다운받으실 데이터가 없습니다.');
				return;
			}
			let params = {
				pageIndex: '1',
				pageUnit: '1000',
				searchKeyword: $('#searchKeyword').val()
			};
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/progrmListAjax.do', 
				params,
				null,
				function(json) {
					let ret = json.resultlist;
					if (ret.length <= 0) {
						return;
					}
					let excelData = new Array();
					excelData.push(['NO', '파일명', '한글명', 'URL', '설명']);
					for (let idx in ret) {
						let arr = new Array();
						arr.push(Number(idx)+1);
						arr.push(ret[idx].progrm_file_nm);
						arr.push(ret[idx].progrm_koreannm);
						arr.push(ret[idx].url);
						arr.push(ret[idx].progrm_dc);
						excelData.push(arr);
					}
					let wb = XLSX.utils.book_new();
					XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(excelData), 'sheet1');
					var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });
					saveAs(new Blob([EgovIndexApi.s2ab(wbout)],{ type: 'application/octet-stream' }), '프로그램관리.xlsx');
				},
				function(json) {
					alert(json.message);
				}
			);	
    	}
    }
</script>
<c:import url="/backoffice/inc/popup_common.do" />