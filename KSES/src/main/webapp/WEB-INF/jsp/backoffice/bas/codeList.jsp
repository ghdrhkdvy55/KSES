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
<!-- //contents -->
<input type="hidden" id="mode" name="mode" />
<input type="hidden" id="subCodeId" name="subCodeId" />
<input type="hidden" id="hid_DelCode" name="hid_DelCode" />
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">공통 코드 관리</li>
	</ol>
</div>
<h2 class="title">공통 코드 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="whiteBox searchBox">
			<div class="sName">
              <h3>옵션 선택</h3>
            </div>
            <div class="top">                    
                <p>검색어</p>
                <input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하새요.">
            </div>
            <div class="inlineBtn">
                <a href="javascript:jqGridFunc.fn_search();" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
            <a href="#" onClick="jqGridFunc.fn_CodeInfo('Ins','0')" class="right_box blueBtn">분류코드추가</a> 
        </div>
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>  
        </div>
    </div>
</div>
<!-- contents//-->
<!-- //popup -->
<div id="bas_code_add" data-popup="bas_code_add" class="popup m_pop">
	<div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">분류 코드 추가</h2>
        <div class="pop_wrap">
            <table class="detail_table">
	            <tbody>
	                <tr>
	                    <th>코드 ID</th>
	                    <td>
	                        <input type="text" id="codeId" name="codeId" >
	                        <span id="sp_Unqi">
	                        <a href="javascript:jqGridFunc.fn_idCheck()" class="blueBtn">중복확인</a>
	                        <input type="hidden" id="idCheck">
	                        </span>
	                        
	                    </td>
	                </tr>
	                <tr>
	                    <th>코드명</th>
	                    <td><input type="text" id="codeIdNm" name="codeIdNm"></td>
	                </tr>
	                <tr>
	                    <th>코드 설명</th>
	                    <td><input type="text" id="codeIdDc" name="codeIdDc"></td>
	                </tr>
	                <tr>
	                    <th>사용 유무</th>
	                    <td>
	                        <label for="useAt_Y"><input name="useAt" type="radio" id="useAt_Y" value="Y"/>사용</label>
	                        <label for="useAt_N"><input name="useAt" type="radio" id="useAt_N" value="N"/>사용 안함</label>
	                    </td>
	                </tr>
	            </tbody>
            </table>
        </div>
        <div class="right_box">
        	<a href="#" class="blueBtn" id="btnSave" onClick="jqGridFunc.fn_CheckForm()">저장</a>
            <a href="#" onClick="common_modelClose('bas_code_add')" class="grayBtn b-close">취소</a>
            
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- 상세코드 추가 팝업 -->
<div data-popup="bas_detailcode_add" id="bas_detailcode_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">상세 코드 등록</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>코드명</th>
                        <td>
                            <input type="hidden" id="code" name="code">
                            <input type="text" id="codeNm" name="codeNm" />
                        </td>
                    </tr>
                    <tr>
                        <th>설명</th>
                        <td>
                            <input type="text" id="codeDc" name="codeDc" />
                        </td>
                    </tr>
                    <tr>
                        <th>기타</th>
                        <td>
                            <input type="text" id="codeEtc1" name="codeEtc1" />
                        </td>
                    </tr>
                    <tr>
                        <th>사용 유무</th>
                        <td>
                            <span>
                                <label for="detailUseAtY"><input type="radio" name="detailUseAt" value="Y" id="detailUseAtY">사용</label>
                            </span>
                            <span>
                                <label for="detailUseAtN"><input type="radio" name="detailUseAt" value="N" id="detailUseAtN">사용 안함</label>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
        	<a href="#" id="btnDetailUpdate" name="btnDetailUpdate" onClick="detailFunc.fn_detailUp()" class="blueBtn">저장</a>
            <a href="#" onClick="common_modelClose('bas_detailcode_add')" class="grayBtn b-close">취소</a>
            
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript">
var jqGridFunc  = {
		
		setGrid : function(gridOption){
			 var grid = $('#'+gridOption);
		    //ajax 관련 내용 정리 하기 
		
            var postData = {};
		    grid.jqGrid({
		    	url : '/backoffice/bas/codeListAjax.do' ,
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
    		 	                { label: 'code_id', key: true, name:'code_id',       index:'code_id',      align:'center', hidden:true},
    		 	                { label: '코드ID',  name:'code_id',         index:'code_id',        align:'left',   width:'10%'},
    		 	                { label: '코드명',  name:'code_id_nm',         index:'code_id_nm',        align:'left',   width:'10%'},
    		 	                { label: '코드설명',  name:'code_id_dc',         index:'code_id_dc',        align:'left',   width:'10%'},
    		 	                { label: '사용유무',  name:'use_at',         index:'use_at',        align:'left',   width:'10%'},
    		 	                { label: '수정자', name:'last_updusr_id',      index:'last_updusr_id',     align:'center', width:'14%'},
    			                { label: '수정 일자', name:'last_updt_pnttm', index:'last_updt_pnttm', align:'center', width:'12%', 
    			                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
    			                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : 
    			                  false, formatter:jqGridFunc.rowBtn}
			                ],  //상단면 
		        rowNum : 10,  //레코드 수
		        rowList : [10,20,30,40,50,100],  // 페이징 수
		        pager : pager,
		        refresh : true,
	            //rownumbers : true, // 리스트 순번
		        viewrecord : true,    // 하단 레코드 수 표기 유무
		        //loadonce : false,     // true 데이터 한번만 받아옴 
		        loadui : "enable",
		        loadtext:'데이터를 가져오는 중...',
		        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
		        height : "100%",
		        autowidth:true,
		        shrinkToFit : true,
		        refresh : true,
		        multiselect:false, 
		        subGrid: true,
		        //여기 부분 수정 하기 
		        subGridRowExpanded: function(subgrid_id, row_id) {
		        	var param = {"codeId" : row_id, "pageIndex" : fn_emptyReplace($("#pageIndex").val(), "1"), "pageSize" : "10" }
		        	var subgrid_table_id, pager_id;
		            subgrid_table_id = subgrid_id+"_t";
		            pager_id = "p_"+subgrid_table_id;
		            jQuery("#"+subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
		            //var sub_grid = $('#'+subgrid_table_id); -- 추후 페이지 작업
		            
		            jQuery("#"+subgrid_table_id).jqGrid({
		                url:"/backoffice/bas/CmmnDetailCodeList.do",
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
		                	{ label: 'code', key: true, name:'code',       index:'code',      align:'center', hidden:true},
		                	{ label: '분류명', name:'code_nm',       index:'code_nm',      align:'center', width:'10%'},
		 	                { label: '상세설명', name:'code_dc',     index:'code_dc',      align:'center', width:'10%'},
		 	                { label: '기타', name:'code_etc1',     index:'code_etc1',      align:'center', width:'10%'},
		 	                { label: '사용유무', name:'use_at',       index:'use_at',      align:'center', width:'10%'},
		 	                { label: '최종 수정자', name:'last_updusr_id', index:'last_updusr_id',     align:'center', width:'10%'},
			                { label: '최종 수정 일자', name:'last_updt_pnttm', index:'last_updt_pnttm', align:'center', width:'12%', 
			                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
			                { label: '등록', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : false, 
			                  formatter:detailFunc.rowBtn}
			            ],  //상단면 
			            rowNum : 100, 
		                height: '100%',
		                pager: pager_id,
		                autowidth:true,
	    		        shrinkToFit : true,
	    		        refresh : true,
		                sortname: 'code',
		                sortorder: "asc",
		                onCellSelect : function (rowid, index, contents, action){
	    	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
	    	                //console.log(cm);
	    	                if (cm[index].name=='code_nm' || cm[index].name=='code_dc' ){
	    	                	detailFunc.fn_DetailInfo("Edt", $(this).jqGrid('getCell', rowid, 'code'));
	            		    }
	    	                
	    	            },loadComplete : function (data){
	    	            	console.log(data);
	    	            	
	    	            	$("#codeId").val(data.regist.codeId);
	    	            	$("#"+subgrid_table_id+"_btn").click(function() {
	    	            		detailFunc.fn_DetailInfo("Ins",'0', data.regist);
	    	                });
	    		        },refreshGrid : function(){
	    		        	$('#'+ subgrid_id).jqGrid().trigger("reloadGrid");
	    	            }
		             });
		             
		             
		          
		        }, loadComplete : function (data){
		        	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
		        }, loadError:function(xhr, status, error) {
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
	                if (cm[index].name=='code_id' || cm[index].name=='code_nm'){
	                	jqGridFunc.fn_CodeInfo("Edt", $(this).jqGrid('getCell', rowid, 'code_id'));
        		    }
	            }
		    });
		},rowBtn: function (cellvalue, options, rowObject){
        	if (rowObject.code_id != "")
        	     return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.code_id+"\");'>삭제</a>";
        },refreshGrid : function(){
 	    	$('#mainGrid').jqGrid().trigger("reloadGrid");
        },delRow : function (codeId){
	    	if(codeId != "") {
	    		$("#hid_DelCode").val(codeId);
        		$("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_codeDel()");
        		fn_ConfirmPop("삭제 하시겠습니까?");
		    }
       }, fn_codeDel : function (){
    	   var params = {"codeId" : $("#hid_DelCode").val()};
			   fn_uniDelAction("/backoffice/bas/codeDelete.do", "POST",params, false, "jqGridFunc.fn_search");
			   $("#hid_DelCode").val('');
			  
       },fn_CodeInfo : function (mode, codeId){
    	    $("#mode").val(mode);
    	    if (mode == "Edt"){
	        	
	        	$("#codeId").val(codeId);
	        	$("#btnUpdate").text("수정");
	        	var params = {"codeId" : codeId};
	     	    var url = "/backoffice/bas/codeDetail.do";
	     	    fn_Ajax(url, "GET", params, false, 
	     	   		function(result) {
	     				       if (result.status == "LOGIN FAIL"){
	     				    	   common_popup(result.meesage, "Y", "bas_code_add");
		   						   location.href="/backoffice/login.do";
	       					   }else if (result.status == "SUCCESS"){
       						       //총 게시물 정리 하기
       						       var obj  = result.regist;
       						       $("#codeId").val(obj.code_id).attr('readonly', true);
       						       $("#codeIdNm").val(obj.code_id_nm);
       						       $("#codeIdDc").val(obj.code_id_dc);
       						       $("#codeId").val(obj.code_id);
       						       $("#sp_Unqi").hide();
       						       $("input:radio[name='useAt']:radio[value='"+obj.use_at+"']").prop('checked', true); 
       						       //toggleClick("useAt", obj.use_at);
					    		   $("#btnSave").text("수정");
	       					   }else{
	       						   alert(result.meesage);
	       					   }
	     				    },
	     				    function(request){
	     					    alert("Error:" +request.status );	       						
	     				    }    		
	               );
	        }else{
	        	
	        	$("#codeId").val('').attr('readonly', false);
	        	$("#codeIdNm").val('');
	        	$("#codeIdDc").val('');
	        	$("#sp_Unqi").show();
	        	$("#btnSave").text("입력");
	        	$("#useAt_Y").prop("checked", true);
	        }
    	    $("#bas_code_add").bPopup();
       },clearGrid : function() {
            $("#mainGrid").clearGridData();
       },fn_CheckForm:function (){
    	   if (any_empt_line_span("bas_code_add", "codeId", "코드를 입력해 주세요.","sp_message", "savePage") == false) return;
    	   if ($("#mode").val() == "Ins" && $("#idCheck").val() != "Y"){
			   if (any_empt_line_span("bas_code_add", "idCheck", "중복체크가 안되었습니다.","sp_message", "savePage") == false) return;
		   }
		   if (any_empt_line_span("bas_code_add", "codeIdNm", "코드명을 입력해 주세요.","sp_message", "savePage") == false) return;
		   var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
	       $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
   		   fn_ConfirmPop(commentTxt);
       },fn_update : function (){
    	  
		   $("#confirmPage").bPopup().close();
		   		   			   
	       var url = "/backoffice/bas/codeUpdate.do";
	       var params = {   'codeId' : $("#codeId").val(),
			    		     'clCode' : $("#clCode").val(),
			    		     'codeIdNm' : $("#codeIdNm").val(), 
			    		     'codeIdDc' : $("#codeIdDc").val(), 
			    			 /* 'useAt' :fn_emptyReplace($("#useAt").val(),"0"), */
			    			 'useAt' : $("input:radio[name='useAt']:checked").val(),
			    			 'mode' : $("#mode").val()
			    		 }; 
	       fn_Ajax(url, "POST", params,  true,
	      			function(result) {
	    		           
	 				       if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.message, "Y","bas_code_add");
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'
	   						   common_modelCloseM(result.message, "bas_code_add");
	   						   jqGridFunc.fn_search();
	   					   }else if (result.status == "FAIL"){
	   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "bas_code_add");
	   						   jqGridFunc.fn_search();
	   					   }
	 				    },
	 				    function(request){
	 				    	common_popup("Error:" + request.status, "Y", "bas_code_add");
	 				    }    		
	        );
	  },fn_search: function(){
		  //검색 
    	  $("#mainGrid").setGridParam({
    	    	datatype	: "json",
    	    	postData	: JSON.stringify({
          			"pageIndex": $("#pager .ui-pg-input").val(),
          			"searchKeyword" : $("#searchKeyword").val(),
         			"pageUnit":$('.ui-pg-selbox option:selected').val()
         		}),
    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
    	  }).trigger("reloadGrid");
	 }, fn_idCheck : function (){
        	//공용으로 활용 할지 정리 필요 
		    var url = "/backoffice/bas/codeIDCheck.do"
        	var param =  {"codeId" : $("#codeId").val()};
		    if ($("#codeId").val() != ""){
		        fn_Ajax(url, "GET", param, false, 
	        			    function(result) {	
        			              if (result != null) {
        			            	  var message = result.result == "OK" ? '<spring:message code="common.codeOk.msg" />' : '<spring:message code="common.codeFail.msg" />';
      			        		      var alertIcon =  result.result == "OK" ? "Y" : "N";
        			                if (result.status == "SUCCESS"){    			        		    
        			        		    common_popup(message ,alertIcon, "bas_code_add");
       			        		    	$("#idCheck").val(alertIcon);
									}else {
										common_popup(message, alertIcon, "bas_code_add");
										$("#idCheck").val(alertIcon);
									}
        			              }
							},
						    function(request){
								common_popup('서버 장애 입니다.', "N", "bas_code_add");
								$("#idCheck").val("N");	          						
						    }    		
		        ); 
        	}else {
        		 common_popup('<spring:message code="common.alertcode.msg" />', "N", "");
   		    	 $("#"+input_id).focus();
   		    	 return;		
	        }
	 }
}

var detailFunc  = {
	    fn_DetailInfo : function (mode, code, codeId){
	    	
		    $("#mode").val(mode);
		    $("#codeId").val(codeId);
		    if (mode == "Ins"){
		    	$("#code").val('');
			    $("#codeNm").val('');
			    $("#codeDc").val('');
			    $("#codeEtc1").val('');
	            $("#btnDetailUpdate").text("등록");
	            $("#detailUseAtY").prop("checked", true);
		    }else {
		    	
			    $("#btnDetailUpdate").text("수정");
			    $("#code").val(code);
			    var url = "/backoffice/bas/CmmnDetailView.do";
      		    var param = {"code" : code };
      		    fn_Ajax(url, "GET", param, true,
 		     			function(result) {
      		    	           if (result.status == "LOGIN FAIL"){
      		    	        	   common_popup(result.meesage, "N","bas_detailcode_add");
 								   location.href="/backoffice/login.do";
 		  					   }else if (result.status == "SUCCESS"){
 	                               //관련자 보여 주기 
 	                                var obj = result.regist;
 	                                $("#codeNm").val(obj.code_nm);
 	                                $("#codeId").val(obj.code_id);
     		  						$("#codeDc").val(obj.code_dc);
     		  						$("#codeEtc1").val(obj.code_etc1);
     		  						$("input:radio[name='detailUseAt']:radio[value='"+obj.use_at+"']").prop('checked', true); 
     		  				   }else{
     		  					   common_modelCloseM(result.meesage,"bas_detailcode_add");
 		  					   }
 						},
						    function(request){
 							common_modelCloseM("Error:" +request.status,"bas_detailcode_add");
						    }    		
 		       );
		    }
		    $("#bas_detailcode_add").bPopup();
		   
	   },rowBtn: function (cellvalue, options, rowObject){
		   if (rowObject.code != "")
        	   return '<a href="javascript:detailFunc.delRow(&#34;'+rowObject.code_id+'&#34;,&#34;'+rowObject.code+'&#34;);">삭제</a>';
       },delRow : function (codeId, code){
    	   if(code != "") {       		   
				$("#id_ConfirmInfo").attr("href", "javascript:detailFunc.fn_codeDel('"+ codeId +"', '"+ code +"')");
       			fn_ConfirmPop("삭제 하시겠습니까?");
    	   }
       }, fn_codeDel: function(codeId, code) {
    	   var params = {'code':code };
    	   fn_uniDelAction("/backoffice/bas/codeDetailCodeDelete.do","GET",params,false, "");
		   detailFunc.fn_search(codeId);
		   
       }, fn_detailUp : function (){
    	   if (any_empt_line_span("bas_detailcode_add", "codeNm", "분류명 입력해 주세요.","sp_message", "savePage") == false) return;
    	   var commentTxt = ($("#mode").val() == "Ins") ? "등록 하시겠습니까?":"저장 하시겠습니까?";
    	   $("#id_ConfirmInfo").attr("href", "javascript:detailFunc.fn_detailUpdate()");
       	   fn_ConfirmPop(commentTxt);
       }, fn_detailUpdate : function (){
    
    	   $("#confirmPage").bPopup().close();
 		   var param = {
 				        "codeId" : $("#codeId").val(),
     		     		"code" : $("#code").val(),
     		     		"codeNm" : $("#codeNm").val(),
     		     		"codeDc" : $("#codeDc").val(),
     		     		"codeEtc1" : $("#codeEtc1").val(),
     		     		"useAt" : fn_emptyReplace($('input[name="detailUseAt"]:checked').val(),"Y"),
     		     		"mode" : $("#mode").val()
 		                }
 		   //여기 부분 정리 하기  
 		   
 		   fn_Ajax("/backoffice/bas/CodeDetailUpdate.do", "POST", param, true,
 		    			function(result) {
 			               common_modelClose("bas_detailcode_add");
 			               if (result.status == "LOGIN FAIL"){
					    	   common_popup(result.message, "Y");
 							   location.href="/backoffice/login.do";
 		  				   }else if (result.status == "SUCCESS"){
 		  					   common_modelCloseM(result.message, "bas_detailcode_add");
 		  					   detailFunc.fn_search($("#codeId").val());
 	                       }else {
 		  					   common_popup(result.meesage, "Y");
 		  				   }
 					},
					    function(request){
						    common_popup("Error:" +request.status, "Y");
					    }    		
 		   );
 		   
	   }, fn_userDel: function (code){
		   var params = {'code':code };
		   fn_uniDelAction("/backoffice/bas/codeDetailCodeDelete.do","GET",params, false, "detailFunc.fn_detailList");
	   },fn_search : function(gridId){
		  
		   
		  $("#mainGrid_"+gridId+"_t").setGridParam({
    	    	 datatype	: "json",
    	    	 postData	: JSON.stringify(  {
    	    		"codeId" : gridId,
          			"pageIndex": 1
         		 }),
    	    	 loadComplete	: function(data) {
    	    	 }
	      }).trigger("reloadGrid");
	   }
}
$(document).ready(function() { 
	jqGridFunc.setGrid("mainGrid");
});
</script>
<c:import url="/backoffice/inc/popup_common.do" />