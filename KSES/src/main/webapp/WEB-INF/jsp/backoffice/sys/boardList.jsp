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
<script type="text/javascript" src="/resources/SE/js/HuskyEZCreator.js" ></script>
<style type="text/css">
	.upload-btn-wrapper, .delete-btn-wrapper {
		position: relative;
		overflow: hidden;
		display: inline-block;
	}
	
	.delete-btn-wrapper {
		float : right;
	}
	
	.upload-btn, .delete-btn {
		border: 2px solid gray;
		color: gray;
		background-color: white;
		padding: 8px 20px;
		border-radius: 8px;
		font-weight: bold;
		cursor: pointer;
	}
	
	.upload-btn-wrapper input[type=file] {
		font-size: 100px;
		position: absolute;
		left: 0;
		top: 0;
		opacity: 0;
	}
	
	#fileDragDesc {
		width: 100%; 
		height: 100%; 
		margin-left: auto; 
		margin-right: auto; 
		padding: 5px; 
		text-align: center; 
		line-height: 300px; 
		vertical-align:middle;
	}
</style>
<!-- //contents -->
<input type="hidden" id="boardCd" name="boardCd" value="${regist.board_cd }">
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="boardSeq" name="boardSeq">
<input type="hidden" id="boardRefno" name="boardRefno">
<input type="hidden" id="boardClevel" name="boardClevel">
<input type="hidden" id="boardGroup" name="boardGroup">
<input type="hidden" id="boardCn" name="boardCn">
<input type="hidden" id="authorCd" name="authorCd" value="${loginVO.authorCd}">
<div class="breadcrumb">
	<ol class="breadcrumb-item">
    	<li>공용 게시판&nbsp;&gt;&nbsp;</li>
    	<li class="active"><c:out value='${regist.board_title}'/></li>
	</ol>
</div>
<h2 class="title"><c:out value='${regist.board_title}'/></h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="whiteBox searchBox">
         <div class="sName">
                <h3>검색 옵션</h3>
              </div>
          <div class="top">
            <p>검색어</p>
            <input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하세요.">
          </div>
          <div class="inlineBtn">
            <a href="#" onclick="jqGridFunc.fn_search()" class="grayBtn">검색</a>
          </div>
        </div>
        <div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <a onClick="boardinfo.fn_boardInfo('Ins', '0');" class="right_box blueBtn">게시글 등록</a>  
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
<div id="bas_board_preview" class="popup">
	<div class="pop_container">
        <!--//팝업 타이틀-->
        <div class="pop_header">
            <div class="pop_contents">
            <h2 style="margin-left:8px;"><span id="sp_preview"></span>
             </h2>
            </div>
        </div>
        <!--팝업타이틀//-->
        <!--//팝업 내용-->
        <div class="pop_contents">
	        <div class="Swrap tableArea viewArea" style="margin:16px">
                <div class="view_contents">
	                <table class="margin-top30 backTable mattersArea">
		                <tbody>
		                    <tr class="tableM">
		                        <th>제목</th>
		                        <td colspan="3" class="preview_in_title"><span id="sp_boardTitle"></span></td>
		                    </tr>
	                        <tr><th>공지기간</th>
	                           <td style='text-align:left' colspan='3' class='preview_in_day'><span id="sp_interval"></span></td>
	                        </tr>
	                        <tr id="tr_boardFile">
	                        	<th>첨부파일</th>
	                        	<td style='text-align:left' colspan='3' class='preview_in_file'>
	                        	 <table class="detail_table" id="tb_fileInfo">
						            <tbody>
						            </tbody>
						          </table>
	                        	</td>
	                        </tr>
				     		<tr>
				     			<th>내용</th>
				     			<td colspan="3" class="preview_in_contents">
				     			<span id="sp_boardContent"></span>
				     			</td>
				     		</tr>	                    
		                </tbody>
		            </table>
            	</div>
        	</div>
       	</div>
        <div class="footerBtn">
            <a href="javascript:common_modelClose('bas_board_preview');" class="grayBtn" style="margin-bottom:16px;">닫기</a>
            <c:if test="${regist.board_cmnt_use} == 'Y'">
            <a href="#" onClick="boardinfo.fn_Ref()" class="blueBtn" id="btnRef">답글</a>
            </c:if>
        </div>
    </div>
</div>	
<div id="bas_board_add" class="popup">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit" id="h2_txt">등록</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
	                    <tr>
	                        <th><span class="redText">*</span>제목</th>
	                        <td colspan="3">
	                        <input type="text" name="boardTitle" id="boardTitle" style="width:470px;" />
	                        </td>
	                    </tr>
	                    <tr>
                      		<th>공지기간</th>
	                        <td style="text-align:left" colspan="3">
	                        <input type="text" class="cal_icon" name="boardNoticeStartDay" style="width:200px" maxlength="20" id="boardNoticeStartDay" />
	                        ~
	                        <input type="text" class="cal_icon" name="boardNoticeEndDay"  style="width:200px"  maxlength="20" id="boardNoticeEndDay" />	                        
	                        </td>
	                    </tr>
	                    <tr>
                            <th><span class="redText">*</span>사용유무</th>
	                        <td style="text-align:left">
		                        <label class="switch">                                               
			                   	   <input type="checkbox" id="useYn" onclick="toggleValue(this);" value="Y">
			                       <span class="slider round"></span> 
			                    </label> 
		                    </td>
<!-- 		                <th><span class="redText">*</span>팝업 여부</th>
	                        <td style="text-align:left">
		                        <label class="switch">                                               
			                   	   <input type="checkbox" id="boardPopup" onclick="toggleValue(this);" value="Y">
			                       <span class="slider round"></span> 
			                    </label> 
		                    </td> -->
	                    </tr>
	                    <c:choose>
	                       <c:when test="${loginVO.authorCd ne 'ROLE_ADMIN' && loginVO.authorCd ne 'ROLE_SYSTEM' }">
	                            <input type="hidden" id="boardCenterId" name="boardCenterId" value="${loginVO.centerCd}">
                                <input type="hidden" id="boardAllNotice" name="boardAllNotice" value="N">
	                       </c:when>
	                       <c:otherwise>
                                <tr>
			                        <th>지점 선택</th>
			                        <td><span id="sp_boardCenter"></span>
			                        <th>전 지점  선택</th>
			                        <td><input type="checkbox" id="boardAllNotice" name="boardAllNotice" onClick="fn_CheckboxAllChangeInfo('boardAllNotice', 'boardCenterId');">
			                        </td>
			                    </tr>
			                    
                                
	                       </c:otherwise>
	                    </c:choose>
	                   
	                    <tr id="tr_fileUpload">
	                       <th><span class="redText" id="sp_returntxt">파일 업로드</span></th>
	                       <td colspan="4">
								<div class="upload-btn-wrapper">
									<input type="file" id="input_file" multiple="multiple" style="height: 100%;" />
									<button class="upload-btn">파일선택</button>
								</div>
								
								<div class="delete-btn-wrapper">
									<button class="delete-btn" onClick="boardinfo.fn_FileDel()" >삭제</button>
								</div>
	                       
	                            <table class="detail_table" id="tb_fileInfoList">
						            <thead>
						            	<tr>
						                	<th><input type="checkbox" id="allCheck" name="allCheck" onClick="boardinfo.fn_FileCheck()"></th>
						                	<th>파일명</th>
						                </tr>
						            </thead>
						            <tbody>
						            </tbody>
						        </table>
						          

								<div id="dropZone" style="width: 700px; height: 100px; border-style: solid; border-color: black; ">
									<div id="fileDragDesc"> 파일을 드래그 해주세요. </div>
									
									<table id="fileListTable" width="100%" border="0px">
										<tbody id="fileTableTbody">
										</tbody>
									</table>
						      </div>
	                       </td>
	                    </tr>
	                    <tr>
	                        <th><span class="redText" id="sp_returntxt">*</span>내용</th>
	                        <td colspan="3" style="text-align:left">
	                            <textarea name="ir1" id="ir1" style="width:700px; height:100px; display:none;"></textarea>
	                        </td>
	                    </tr>
	                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="#" onClick="boardinfo.fn_CheckForm()" class="blueBtn" id="btnUpdate">저장</a>
            <a href="javascript:common_modelClose('bas_board_add')" class="grayBtn">취소</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript">
	var insertBoardCenterId = ""
	var insertBoardAllCk = ""
	$(document).ready(function() { 
		 if($("#authorCd").val() != "ROLE_ADMIN" && $("#authorCd").val() != "ROLE_SYSTEM") {
			 insertBoardCenterId = $("#boardCenterId").val();
			 insertBoardAllCk = "N"
		 } else {
			 insertBoardAllCk =  $("#boardAllNotice").is(":checked") == true ? "Y" : "N";
		 }
		 
		 ("${regist.board_file_upload_yn }" == "Y") ? $("#tr_fileUpload").show() : $("#tr_fileUpload").hide();
		
		 
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
		           buttonImageOnly: true, //이미지표시
		           buttonText: '달력선택', //버튼 텍스트 표시
		           buttonImage: '/images/invisible_image.png', //이미지주소
		           yearRange: '1970:2030', //1990년부터 2020년까지
				   currentText: "Today"
	    };	      
	    $("#boardNoticeStartDay, #boardNoticeEndDay").datepicker(clareCalendar);   
		/* $("#boardNoticeStartDay, #boardNoticeEndDay").val(new Date().format("yyyyMMdd")); */
	    $("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
	    $("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
	});
	
	
	var jqGridFunc  = {
			 setGrid : function(gridOption){
				 var postData = {"pageIndex": "1", "boardCd" : $("#boardCd").val(), "searchKeyword" : $("#searchKeyword").val()};
			     
			     $('#'+gridOption).jqGrid({
						url : '/backoffice/sys/boardListAjax.do' ,
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
					    	    	{ label: 'board_seq', key: true, name:'board_seq',       index:'board_seq',      align:'center', hidden:true},
					            	{ label: '제목', name:'board_title',       index:'board_title',  align:'left',  width:'20%'},
					            	/* 미리보기 주석처리
					            	{ label: '미리보기', name:'board_title',    index:'board_title',  align:'center', width:'10%'
					            	  , formatter:jqGridFunc.boardPreviewBtn	},
					            	   */
					            	{ label: '공지기간', name:'board_notice_startday', index:'board_notice_startday',   align:'center', width:'10%'
					            	  , formatter:jqGridFunc.boardNoticeDay	},
					            	{ label: '조회수', name:'board_visit_cnt',      index:'board_visit_cnt',      align:'center', width:'10%'},
					                { label: '최종 수정자', name:'last_updusr_id', index:'last_updusr_id',     align:'center', width:'10%'},
					                { label: '최종 수정 일자', name:'last_updt_dtm', index:'last_updt_dtm', align:'center', width:'12%', 
					                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
					                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : false, 
					                  formatter:jqGridFunc.rowBtn}
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
					    loadComplete : function (data){
					    	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
					    },loadError:function(xhr, status, error) {
					        alert("error:" + error); 
					    }, onPaging: function(pgButton){
	   		        	  var gridPage = $('#'+gridOption).getGridParam('page'); //get current  page
	   		        	  var lastPage = $('#'+gridOption).getGridParam("lastpage"); //get last page 
	   		        	  var totalPage = $('#'+gridOption).getGridParam("total");
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
	   		              $('#'+gridOption).setGridParam({
			    		          	  page : gridPage,
			    		          	  rowNum : $('.ui-pg-selbox option:selected').val(),
			    		          	  postData : JSON.stringify(  {
								    		          			"pageIndex": gridPage,
								    		          			"boardGubun" : $("#boardGubun").val(),
								    		    	    		"searchKeyword" : $("#searchKeyword").val(),
								    		          			"pageUnit":$('.ui-pg-selbox option:selected').val()
								    		          		})
	   		          		}).trigger("reloadGrid");
	   		        },onSelectRow: function(rowId){
					        if(rowId != null) { 
					           //멀트 체크 할떄 특정 값이면 다른 값에 대한 색 변경 	
					        }// 체크 할떄
					    },ondblClickRow : function(rowid, iRow, iCol, e){
					    	grid.jqGrid('editRow', rowid, {keys: true});
					    },onCellSelect : function (rowid, index, contents, action){
					    	var cm = $(this).jqGrid('getGridParam', 'colModel');
					    	
					        if (cm[index].name == 'board_title' ){
					        	boardinfo.fn_boardInfo("Edt", $(this).jqGrid('getCell', rowid, 'board_seq'));
						    }
					        
					    }, beforeSelectRow: function (rowid, e) {
	   		            var $myGrid = $(this);
	   		            var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
	   		            var cm = $myGrid.jqGrid('getGridParam', 'colModel');
	   		            return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
	   		        }
					    
				 });
			 }, boardPreviewBtn : function (cellvalue, options, rowObject){
				 return "<a href='javascript:preview(\""+rowObject.board_seq+"\");'>미리보기</a>";
			 }, boardNoticeDay :function (cellvalue, options, rowObject){
				 if ( rowObject.board_notice_startday != "")
				 return fn_emptyReplace(rowObject.board_notice_start_day,"")+"~"+fn_emptyReplace(rowObject.board_notice_end_day, "");
			 },rowBtn : function (cellvalue, options, rowObject){
				 
				 //삭제 값 정리 하기 
				 <c:choose>
	                       <c:when test="${loginVO.authorCd ne 'ROLE_ADMIN' && loginVO.authorCd ne 'ROLE_SYSTEM' }">
	                          if (rowObject.board_seq != "" &&  rowObject.last_updusr_id == "${loginVO.empNo}" )
	        	           	  	 return '<a href="javascript:jqGridFunc.delRow(&#34;'+rowObject.board_seq+'&#34;);">삭제</a>';
	        	           	  else
	        	           		  return "";
	                       </c:when>
	                       <c:otherwise>
	                          if (rowObject.board_seq != "" )
	        	           	  	 return '<a href="javascript:jqGridFunc.delRow(&#34;'+rowObject.board_seq+'&#34;);">삭제</a>';
	                       </c:otherwise>
	             </c:choose>
				 
	           
	        }, delRow : function (board_seq){
	       	 $("#hid_DelCode").val(board_seq)
				 $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
				 fn_ConfirmPop("삭제 하시겠습니까?");
	   		 
	   	 },fn_del: function(){
	   		var params = {'boardSeq': $.trim($("#hid_DelCode").val()) };
				fn_uniDelAction("/backoffice/sys/boardDelete.do", "GET", params, false, "jqGridFunc.fn_search");
	        },fn_search : function(){
				  $("#mainGrid").setGridParam({
		    	    	 datatype	: "json",
		    	    	 postData	: JSON.stringify(  {
		    	    		"pageIndex": $("#pager .ui-pg-input").val(),
		    	    		"boardCd" : $("#boardCd").val(),
		    	    		"searchKeyword" : $("#searchKeyword").val(),
		         			"pageUnit":$('.ui-pg-selbox option:selected').val()
		         		 }),
		    	    	 loadComplete	: function(data) {
		    	    		 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
		    	    	 }
		    	   }).trigger("reloadGrid");
			 }
	    
	}
	
	var boardinfo = {
			 fn_boardInfo : function(mode, boardSeq) {
				    $("#mode").val(mode);
			        $("#boardSeq").val(boardSeq);
			        
			        $("#fileListTable > tbody").empty();
			        if (mode == "Edt"){
			           $("#btnUpdate").text("수정");
			           $("#bas_board_add > div >h2").text("게시글 수정");
			     	   var params = {"boardSeq" : boardSeq, "boardVisited": 0};
			     	   var url = "/backoffice/sys/boardView.do";
			     	   fn_Ajax(url, "GET", params, false, 
			          			function(result) {
			     				       if (result.status == "LOGIN FAIL"){
			     				    	   location.href="/backoffice/login.do";
			       					   }else if (result.status == "SUCCESS"){
			       						   //총 게시물 정리 하기
			       						    var obj  = result.regist;
			       						    $("#boardTitle").val(obj.board_title);
			       						    $("#ir1").val(obj.board_cn);
			       						    
			       						    $("#boardNoticeStartDay").val(obj.board_notice_start_day);
				       						$("#boardNoticeEndDay").val(obj.board_notice_end_day);
				       						$("#board_clevel").val(obj.board_clevel); //몇번째
				       						$("#board_refno").val(obj.board_refno); //부모값
				       						$("#boardGroup").val(obj.board_group); //부모값
				       						var allCheck = (obj.board_all_notice == "Y") ? true : false;
				       						
				       						$("input:checkbox[id='boardAllNotice']").prop("checked", allCheck); 	
				       						
				       						
				       						if ("${regist.board_cd }"  == "Not"){
			    						    	   var url = "/backoffice/bld/centerCombo.do"
			    	    						   var returnVal = uniAjaxReturn(url, "GET", false, null, "lst");
			    						    	   fn_checkboxListJsonOnChange("sp_boardCenter", returnVal,obj.board_center_id, "boardCenterId", "boardinfo.fn_BoardCheck()");   
			    						    }
				       						var fileViewCss = "";
				       						<c:choose>
						 	                       <c:when test="${loginVO.authorCd ne 'ROLE_ADMIN' && loginVO.authorCd ne 'ROLE_SYSTEM' }">
						 	                          if (obj.last_updusr_id == "${loginVO.empNo}" ){
						 	                        	 $("#btnUpdate").show();
						 	                        	 fileViewCss = "display:block;"
						 	                          }else{
						 	                        	 fileViewCss = "display:none;"; 
						 	                        	 $("#btnUpdate").hide(); 
						 	                          } 
						 	                       </c:when>
						 	                       <c:otherwise>
						 	                           fileViewCss = "display:block;"
						 	                           $("#btnUpdate").show();
						 	                       </c:otherwise>
							 	            </c:choose>
							 	            toggleClick("useYn", obj.use_yn);
								    		//toggleClick("boardPopup", obj.board_popup);
								    		
								    		
								    		if (result.resultlist.length > 0){
				  						    	var sHtml = "";
				  						    	$("#allCheck").prop("style", fileViewCss);
				  						    	$("#btn_FileDel").prop("style", fileViewCss);
				  						    	
				  						    	$("#tb_fileInfoList > tbody").empty();
				  						    	for (var i in result.resultlist){
				  						    		var obj = result.resultlist[i];

				  						    		sHtml += "<tr>"
				  						    		      +  " <td><input type=\"checkbox\" id=\"fileInfo"+obj.stre_file_nm+"\" name=\"fileInfo\" value=\""+obj.stre_file_nm+"\" style='"+fileViewCss+"'></td>"
				  						    		      +  " <td colspan=\"2\"><a href=\"#\" onClick=\"boardinfo.fn_FileDown('" + obj.atch_file_id + "')\">"
				  						    		      +  " "+obj.orignl_file_nm +" </a></td>"
				  						    		      +  "</tr>";
				  						    		
				  						    		 $("#tb_fileInfoList > tbody:last").append(sHtml);
				  						    		 sHtml = "";
				  						    	}
				  						    	$("#tb_fileInfoList").show();
				  						    }else {
				  						    	$("#tb_fileInfoList").hide();
				  						    }
								    		
								       }
			     				    },
			     				    function(request){
			     					    alert("Error:" +request.status );	       						
			     				    }    		
			            );
			        }else {
			        	$("#boardSeq").val('');
			        	$("#btnUpdate").text("등록");
			        	$("#boardTitle").val('');
						$("#boardNoticeStartDay").val('');
						$("#boardNoticeEndDay").val('');
						$("#boardGroup").val(''); //부모값
						$("#boardRefno").val(''); //부모값
						$("#boardClevel").val(''); //부모값
						$("input:checkbox[id='boardAllNotice']").prop("checked", false); 
						$("#bas_board_add > div >h2").text("게시글 등록");
						$("#btnUpdate").show();
						$('#ir1').val('');
						
						if ("${regist.board_cd }"  == "Not"){
							   var url = "/backoffice/bld/centerCombo.do"
 						       var returnVal = uniAjaxReturn(url, "GET", false, null, "lst");
					    	   fn_checkboxListJsonOnChange("sp_boardCenter", returnVal, "", "boardCenterId", "boardinfo.fn_BoardCheck()"); 
					    }
						//여기 파일 정리 하기 
						$("#tb_fileInfoList").hide();
						$("#tb_fileInfoList > tbody").empty();
						
					    /* oEditors.getById["ir1"].exec("SET_IR", [""]); */						
						toggleDefault("useYn");
			        	//toggleDefault("boardPopup");
			        	
			        	
			        }
			        $("#bas_board_add").bPopup();
			 }, fn_BoardCheck : function(){
				 var checked = ($("input[name=boardCenterId]").length != $("input[name=boardCenterId]:checked").length ) ? false : true;
				 $("input[id=boardAllNotice]").prop("checked", checked);
				 
			 },fn_CheckForm  : function (){
				    var sHTML = oEditors.getById["ir1"].getIR();
				    $("#boardCn").val(sHTML);
				    if (any_empt_line_span("bas_board_add", "boardTitle", "제목을 입력해 주세요.","sp_message", "savePage") == false) return;
				    //시작일 종료일 체크 
					if (dateIntervalCheck(fn_emptyReplace($("#boardNoticeStartday").val(),"0"), 
										  fn_emptyReplace($("#boardNoticeEndDay").val(),"0") ,
										  "시작일이 종료일 보다 앞서 있습니다.") == false) return;	
	
				    var commentTxt = ($("#mode").val() == "Ins") ? "등록 하시겠습니까?":"저장 하시겠습니까?";
				    $("#id_ConfirmInfo").attr("href", "javascript:boardinfo.fn_update()");
		       		fn_ConfirmPop(commentTxt);
			 },fn_update: function (){
		    	//체크 박스 체그 값 알아오기 
		    	    var uploadFileList = Object.keys(fileList);
				    var formData = new FormData();
				    for (var i = 0; i < uploadFileList.length; i++) {
						formData.append('files', fileList[uploadFileList[i]]);
					}
				    //사용자 값에 따른 변경값
		            boardCenterId = ($("#authorCd").val() != "ROLE_ADMIN" && $("#authorCd").val() != "ROLE_SYSTEM")  
		            	? insertBoardCenterId : ckeckboxValueNoPopup("boardCenterId");
		            boardAllCk = ($("#authorCd").val() != "ROLE_ADMIN" && $("#authorCd").val() != "ROLE_SYSTEM")  
	            	? "N" : $("#boardAllNotice").is(":checked") == true ? "Y" : "N";

				    formData.append('mode' , $("#mode").val());
				    formData.append('boardSeq' , $("#boardSeq").val());
				    formData.append('boardTitle' , $("#boardTitle").val());
				    formData.append('boardRefno' , fn_emptyReplace($("#boardRefno").val(),"0"));
				    formData.append('boardClevel' , fn_emptyReplace($("#boardClevel").val(),"0"));
				    formData.append('boardGroup' , fn_emptyReplace($("#boardGroup").val(),"0"));
				    formData.append('boardNoticeStartDay' , $("#boardNoticeStartDay").val());
				    formData.append('boardNoticeEndDay' , $("#boardNoticeEndDay").val());
				    formData.append('boardCn' , $("#boardCn").val());
				    formData.append('boardCd' , $("#boardCd").val());
				    formData.append('useYn' , fn_emptyReplace($("#useYn").val(),"N"));
				    //formData.append('boardPopup' , fn_emptyReplace($("#boardPopup").val(),"N"));
				    formData.append('boardCenterId' , boardCenterId);
				    formData.append('boardAllNotice' , boardAllCk);
				    
				    
				    
				    uniAjaxMutipart("/backoffice/sys/boardUpdate.do", formData, 
				  		function(result) {
				  	           //alert("result:" + result);
				  		       //결과값 추후 확인 하기 	
		    	                 if (result.status == "SUCCESS"){
		    	                	 
		    	                	 common_modelCloseM("정상적으로 적용 되었습니다.", "confirmPage");
		    	              	     jqGridFunc.fn_search();
		    	                 }else if (result.status == "LOGIN FAIL"){
				  				     document.location.href="/backoffice/login.do";
				                 }else {
				              	     common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "confirmPage");
				                 }
				  		 },
				  		 function(request){
				  			    common_modelCloseM("Error:" +request.status, "confirmPage");
				  		 }    		
				    );
		     }, fn_FileCheck : function (){
		    	 //파일 전체 선택
		    	 var checked = $("input:checkbox[name=allCheck]").is(":checked");
		    	 fn_CheckboxAllChange("fileInfo", checked);
		     }, 
		     fn_FileDown : function(atchFileId) {
		    	 location.href = "/backoffice/sys/fileDownload.do?atchFileId=" + atchFileId	
		     }, fn_FileDel : function (){
		    	 var url = "/backoffice/sys/boardFileDelete.do"
		    	 var files = ckeckboxValue("체크된 값이 없습니다.", "fileInfo", "");
		    	 if (files == false) retrun;
		    	 var params = {'fileSeqs' : files  };
		    	 fn_Ajax(url, "GET", params, false,
			      			function(result) {
			    	               if (result.status == "LOGIN FAIL"){
			 				    	   common_popup(result.message, "Y","bas_board_add");
			   						   location.href="/backoffice/login.do";
			   					   }else if (result.status == "SUCCESS"){
			   						   //총 게시물 정리 하기'
			   						   common_modelCloseM(result.message, "bas_board_add");	
			   						   $("#btn_Comfirm").click(function(){
			   							boardinfo.fn_boardInfo("Edt",$("#boardSeq").val());
			   						   });
			   						   /* common_popup(result.message, "Y","bas_board_add"); */
			   					   }else if (result.status == "FAIL"){
			   						   common_popup("삭제 도중 문제가 발생 하였습니다.", "Y", "bas_board_add");
			   					   }
			 				    },
			 				    function(request){
			 					    common_popup("Error:" + request.status, "Y", "bas_board_add");
			 				    }
			      );
		     }, fn_Ref : function (){
		    	 //답글 달기
		    	 $("#bas_board_preview").bPopup().close();
		    	 var params = {"boardSeq" : $("#boardSeq").val(), "boardVisited": 0};
			     var url = "/backoffice/sys/boardView.do";
	    	     fn_Ajax(url, "GET", params, false, 
	         			function(result) {
	    				       if (result.status == "LOGIN FAIL"){
	    				    	   location.href="/backoffice/login.do";
	      					   }else if (result.status == "SUCCESS"){
	      						   //총 게시물 정리 하기
	      						    var obj  = result.regist;
	      						    $("#boardTitle").val('[Ref]' +obj.board_title);
	      						    $("#ir1").val("-----------------------------------<br>" + obj.board_cn);
	      						    $("#boardNoticeStartDay").val('');
		       						$("#boardNoticeEndDay").val('');
		       						alert(obj.board_clevel + ":" + obj.board_seq + ":" + obj.board_group);
		       						$("#boardClevel").val( parseInt(parseInt( fn_emptyReplace(obj.board_clevel, "0")) +  parseInt(1)) ); //몇번째
		       						$("#boardRefno").val(obj.board_seq); //부모값
		       						$("#boardSeq").val('');
		       						$("#boardGroup").val(obj.board_group); //부모값
		       						$("#mode").val('Ref');
		       			    	    $("#btnUpdate").text("답글");
		       			            $("#h2_txt").text("답글");
		       			            toggleDefault("useYn");
		    			        	//toggleDefault("boardPopup");
		    			        	$("#bas_board_add").bPopup();
						       }
	    				    },
	    				    function(request){
	    					    alert("Error:" +request.status );	       						
	    				    }    		
			     );
			     	   
		    	
		     }
		     
	}  
	function preview(boardSeq){
			var popSpec = "width=920,height=600,top=10,left=350,scrollbars=yes";
			$("#board_preView").attr("style", popSpec);
			$("#bas_board_preview").bPopup();
			var url = "/backoffice/sys/boardView.do";
			$("#boardSeq").val(boardSeq); 
			params = {"boardSeq" : boardSeq, "boardVisited": 0};
			fn_Ajax(url, "GET", params, false, 
	     			function(result) {
					       if (result.status == "LOGIN FAIL"){
					    	   location.href="/backoffice/login.do";
	  					   }else if (result.status == "SUCCESS"){
	  						   //총 게시물 정리 하기
	  						    var obj  = result.regist;
	  						    //$("#ir1").val(obj.board_cn);
	  						    $("#sp_boardTitle").text(obj.board_title);
	  						    
	  						    if (fn_emptyReplace(obj.board_notice_start_day, "") != ""){
	  						    	$("#sp_interval").html(fn_emptyReplace(obj.board_notice_start_day, "") + "~"+ fn_emptyReplace(obj.board_notice_end_day, ""));
	  						    }
	  						    $("#sp_boardContent").html(obj.board_cn);
	  						    if (result.resultlist.length > 0){
	  						    	var sHtml = "";
	  						    	$("#tb_fileInfo > tbody").empty();
	  						    	for (var i in result.resultlist){
	  						    		console.log("test : " + obj.atch_file_id);
	  						    		return;
	  						    		var obj = result.resultlist[i];
	  						    		sHtml += "<tr>"
	  						    		      +  " <td colspan=\"2\"><a href=\"#\" onClick=\"boardinfo.fn_FileDown('"+obj.atch_file_id+"')\">"
	  						    		      +  " "+obj.orignl_file_nm +" </a></td>"
	  						    		      +  "</tr>";
	  						    		 $("#tb_fileInfo > tbody:last").append(sHtml);
	  						    		  sHtml = "";
	  						    	}
	  						    	$("#tr_boardFile").show();
	  						    }else {
	  						    	$("#tr_boardFile").hide();
	  						    }
	      						
					       }
					    },
					    function(request){
						    alert("Error:" +request.status );	       						
					    }    		
	       );
			
			
	}
 	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
	     oAppRef: oEditors,
	     elPlaceHolder: "ir1",                        
	     sSkinURI: "/resources/SE/SmartEditor2Skin.html",
	     htParams: { bUseToolbar: true,
	         fOnBeforeUnload: function () {},
	         //boolean 
	     },
	     fCreator: "createSEditor2"
	});
	$(document).ready(function() {
		$("#input_file").bind('change', function() {
			selectFile(this.files);
			this.value=null;
		});
	});

	// 파일 리스트 번호
	var fileIndex = 0;
	// 등록할 전체 파일 사이즈
	var totalFileSize = 0;
	// 파일 리스트
	var fileList = new Array();
	// 파일 사이즈 리스트
	var fileSizeList = new Array();
	// 등록 가능한 파일 사이즈 MB
	var uploadSize = 50;
	// 등록 가능한 총 파일 사이즈 MB
	var maxUploadSize = 500;

	$(function() {
		// 파일 드롭 다운
		fileDropDown();
	});

	// 파일 드롭 다운
	function fileDropDown() {
		var dropZone = $("#dropZone");
		//Drag기능 
		dropZone.on('dragenter', function(e) {
			e.stopPropagation();
			e.preventDefault();
			// 드롭다운 영역 css
			dropZone.css('background-color', '#E3F2FC');
		});
		dropZone.on('dragleave', function(e) {
			e.stopPropagation();
			e.preventDefault();
			// 드롭다운 영역 css
			dropZone.css('background-color', '#FFFFFF');
		});
		dropZone.on('dragover', function(e) {
			e.stopPropagation();
			e.preventDefault();
			// 드롭다운 영역 css
			dropZone.css('background-color', '#E3F2FC');
		});
		dropZone.on('drop', function(e) {
			e.preventDefault();
			// 드롭다운 영역 css
			dropZone.css('background-color', '#FFFFFF');

			var files = e.originalEvent.dataTransfer.files;
			if (files != null) {
				if (files.length < 1) {
					/* alert("폴더 업로드 불가"); */
					console.log("폴더 업로드 불가");
					return;
				} else {
					selectFile(files)
				}
			} else {
				alert("ERROR");
			}
		});
	}

	// 파일 선택시
	function selectFile(fileObject) {
		var files = null;
		if (fileObject != null) {
			files = fileObject;
		} else {
			// 직접 파일 등록시
			files = $('#multipaartFileList_' + fileIndex)[0].files;
		}
		// 다중파일 등록
		if (files != null) {
			if (files != null && files.length > 0) {
				$("#fileDragDesc").hide(); 
				$("fileListTable").show();
			} else {
				$("#fileDragDesc").show(); 
				$("fileListTable").hide();
			}
			
			for (var i = 0; i < files.length; i++) {
				// 파일 이름
				var fileName = files[i].name;
				var fileNameArr = fileName.split("\.");
				// 확장자
				var ext = fileNameArr[fileNameArr.length - 1];
				
				var fileSize = files[i].size; // 파일 사이즈(단위 :byte)
				console.log("fileSize="+fileSize);
				if (fileSize <= 0) {
					console.log("0kb file return");
					return;
				}
				
				var fileSizeKb = fileSize / 1024; 
				var fileSizeMb = fileSizeKb / 1024;
				
				var fileSizeStr = "";
				if ((1024*1024) <= fileSize) {	// 파일 용량이 1메가 이상인 경우 
					console.log("fileSizeMb="+fileSizeMb.toFixed(2));
					fileSizeStr = fileSizeMb.toFixed(2) + " Mb";
				} else if ((1024) <= fileSize) {
					console.log("fileSizeKb="+parseInt(fileSizeKb));
					fileSizeStr = parseInt(fileSizeKb) + " kb";
				} else {
					console.log("fileSize="+parseInt(fileSize));
					fileSizeStr = parseInt(fileSize) + " byte";
				}

				if ($.inArray(ext, [ 'hwp', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'png', 'pdf', 'jpg', 'jpeg', 'gif', 'zip' ]) <= 0) {
					alert("등록이 불가능한 파일 입니다.("+fileName+")");
				} else if (fileSizeMb > uploadSize) {
					// 파일 사이즈 체크
					alert("용량 초과\n업로드 가능 용량 : " + uploadSize + " MB");
					break;
				} else {
					// 전체 파일 사이즈
					totalFileSize += fileSizeMb;
					// 파일 배열에 넣기
					fileList[fileIndex] = files[i];
					// 파일 사이즈 배열에 넣기
					fileSizeList[fileIndex] = fileSizeMb;
					// 업로드 파일 목록 생성
					addFileList(fileIndex, fileName, fileSizeStr);
					// 파일 번호 증가
					fileIndex++;
				}
			}
		} else {
			alert("ERROR");
		}
	}

	// 업로드 파일 목록 생성
	function addFileList(fIndex, fileName, fileSizeStr) {
		/* if (fileSize.match("^0")) {
			alert("start 0");
		} */

		var html = "";
		html += "<tr id='fileTr_" + fIndex + "'>";
		html += "    <td><input value='삭제' type='button' href='#' onclick='deleteFile(" + fIndex + "); return false;'></td>";
		html += "    <td id='dropZone' class='left' >";
		html += fileName + " (" + fileSizeStr +") " 
		html += "    </td>"
		html += "</tr>"

		$('#fileTableTbody').append(html);
	}

	// 업로드 파일 삭제
	function deleteFile(fIndex) {
		console.log("deleteFile.fIndex=" + fIndex);
		// 전체 파일 사이즈 수정
		totalFileSize -= fileSizeList[fIndex];
		// 파일 배열에서 삭제
		delete fileList[fIndex];
		// 파일 사이즈 배열 삭제
		delete fileSizeList[fIndex];
		// 업로드 파일 테이블 목록에서 삭제
		$("#fileTr_" + fIndex).remove();
		if (totalFileSize > 0) {
			$("#fileDragDesc").hide(); 
			$("fileListTable").show();
		} else {
			$("#fileDragDesc").show(); 
			$("fileListTable").hide();
		}
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />
