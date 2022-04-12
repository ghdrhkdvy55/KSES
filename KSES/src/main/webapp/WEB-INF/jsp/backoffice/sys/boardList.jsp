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
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
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
	
	div[name=fileDragDesc] {
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
				<a href="javascript:fnSearch()" class="grayBtn">검색</a>
			</div>
		</div>
		<div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
		</div>
		<div class="right_box">
			<a href="javascript:fnBoardInfo('Ins', '0');" class="blueBtn">게시글 등록</a>
			<a href="javascript:fnBoardDelete();" class="grayBtn">삭제</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table id="mainGrid"></table>
			<div id="pager" class="scroll" style="text-align:center;"></div>  
		</div>
	</div>
</div>
<!-- contents//-->
<input type="hidden" id="boardCd" name="boardCd" value="${regist.board_cd }">
<input type="hidden" id="authorCd" name="authorCd" value="${loginVO.authorCd}">
<input type="hidden" id="mode">
<!-- //popup -->
<!--  -->
<div data-popup="bas_board_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit" name="h2_txt">게시물 등록</h2>
		<div class="pop_wrap">
			<form>
			<input type="hidden" name="boardSeq">
			<input type="hidden" name="boardClevel">
			<input type="hidden" name="boardGroup">
			<input type="hidden" name="boardCn">
			<table class="detail_table">
				<tbody>
					<tr>
						<th><span class="redText">*</span>제목</th>
						<td colspan="3">
							<input type="text" name="boardTitle" style="width:470px;" />
						</td>
					</tr>
					<tr>
						<th>공지기간</th>
						<td style="text-align:left" colspan="3">
							<input type="text" class="cal_icon" name="boardNoticeStartDay" style="width:200px" maxlength="20"/>
							~
							<input type="text" class="cal_icon" name="boardNoticeEndDay"  style="width:200px"  maxlength="20"/>	                        
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
					</tr>
					<c:choose>
						<c:when test="${loginVO.authorCd ne 'ROLE_ADMIN' && loginVO.authorCd ne 'ROLE_SYSTEM' }">
							<input type="hidden" name="boardCenterId" value="${loginVO.centerCd}">
							<input type="hidden" id="boardAllNotice" value="N">
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
								<button type="button" class="delete-btn" onClick="fnFileDel()" >삭제</button>
							</div>
							<table class="detail_table" id="tb_fileInfoList">
								<thead>
									<tr>
										<th><input type="checkbox" name="allCheck" onClick="fnFileCheck()"></th>
										<th>파일명</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
							<div id="dropZone" style="width: 700px; height: 100px; border-style: solid; border-color: black; ">
								<div id="fileDragDesc"> 파일을 드래그 해주세요. </div>
								<table id="fileListTable" width="100%" border="0px">
									<tbody id="fileTableTbody"></tbody>
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
		</form>
		<div class="right_box">
			<a href="javascript:fnUpdate()" class="blueBtn" id="btnUpdate">저장</a>
			<a href="javascript:void(0)" class="grayBtn b-close">취소</a>
		</div>
		<div class="clear"></div>
	</div>
</div>
<!-- popup// -->
<script type="text/javascript">
	var insertBoardCenterId = ""
	var insertBoardAllCk = ""
	$(document).ready(function() { 
		// 메인 JqGrid 정의
		EgovJqGridApi.mainGrid([
			{ label: '게시판 시퀀스', 	name:'board_seq',				align:'center', key: true, hidden:true},
			{ label: '제목', 		name:'board_title',				align:'left'},
			{ label: '공지기간', 		name:'board_notice_startday', 	align:'center',
				formatter: (c, o, row) => fn_emptyReplace(row.board_notice_start_day,"")+"~"+fn_emptyReplace(row.board_notice_end_day, "")},
			{ label: '조회수', 		name:'board_visit_cnt',			align:'center'},
			{ label: '최종 수정자', 	name:'last_updusr_id',			align:'center'},
			{ label: '최종 수정 일자', 	name:'last_updt_dtm',			align:'center', formatter: "date", formatoptions: { newformat: "Y-m-d"}},
			{ label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
	        	'<a href="javascript:fnBoardInfo(\'Edt\',\''+ row.board_seq +'\');" class="edt_icon"></a>'
			}	
		], false, false, fnSearch);
		 if($("#authorCd").val() != "ROLE_ADMIN" && $("#authorCd").val() != "ROLE_SYSTEM") {
			 insertBoardCenterId = $("#boardCenterId").val();
			 insertBoardAllCk = "N"
		 } else {
			 insertBoardAllCk =  $("#boardAllNotice").is(":checked") == true ? "Y" : "N";
		 }
		("${regist.board_file_upload_yn }" == "Y") ? $("#tr_fileUpload").show() : $("#tr_fileUpload").hide();
	});
	// 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
    		boardCd : $('#boardCd').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/sys/boardListAjax.do', params, fnSearch);
	}
	// 게시물 상세 팝업
	function fnBoardInfo(mode, boardSeq) {
		let $popup = $('[data-popup=bas_board_add]');
		let $form = $popup.find('form:first');
		
		$('#mode').val(mode);
		$form.find(':hidden[name=boardSeq]').val(boardSeq);
        
        $("#fileListTable > tbody").empty();
		if (mode == "Edt"){
			EgovIndexApi.apiExecuteJson(
				'GET',
				'/backoffice/sys/boardView.do', 
				{
					boardSeq : boardSeq,
					boardVisited: 0
				},
				function(xhr) {
					$popup.find('h2:first').text('게시물 수정');
					EgovJqGridApi.selection('mainGrid', boardSeq);
				},
				function(json) {
					//총 게시물 정리 하기
					let data = json.result;
					var allCheck = (data.board_all_notice == "Y") ? true : false;
					$('#boardAllNotice').prop("checked", allCheck); 	
					$form.find(':text[name=boardTitle]').val(data.board_title);
					$form.find('textarea[name=ir1]').val(data.board_cn);
					$form.find(':text[name=boardNoticeStartDay]').val(data.board_notice_start_day);
					$form.find(':text[name=boardNoticeEndDay]').val(data.board_notice_end_day);
					$form.find(':hidden[name=boardGroup]').val(data.board_group); //부모값
					var allCheck = (data.board_all_notice == "Y") ? true : false;
					$("input:checkbox[id='boardAllNotice']").prop("checked", allCheck);
					
					if ("${regist.board_cd }"  == 'Not'){
						var url = "/backoffice/bld/centerCombo.do"
						var returnVal = uniAjaxReturn(url, "GET", false, null, "lst");
						fn_checkboxListJsonOnChange("sp_boardCenter", returnVal,data.board_center_id, "boardCenterId", "fnBoardCheck()");   
				    }
					var fileViewCss = "";
					if($('#loginAuthorCd').val() != 'ROLE_ADMIN' && $('#loginAuthorCd').val() != 'ROLE_SYSTEM'){
						if (data.board_center_id == $('#loginCenterCd').val()){
							$("#btnUpdate").show();
							fileViewCss = "display:block;"
						}else {
							fileViewCss = "display:none;"; 
							$("#btnUpdate").hide(); 
						}
					}else {
						fileViewCss = "display:block;"
						$("#btnUpdate").show();
					}
				    toggleClick("useYn", data.use_yn);
					
					if (json.resultlist.length > 0){
						var sHtml = "";
						$form.find(':checkbox[name=allCheck]').prop("style", fileViewCss);
						$("#btn_FileDel").prop("style", fileViewCss);
						
						$("#tb_fileInfoList > tbody").empty();
						for (var i in json.resultlist){
							var listdata = json.resultlist[i];
						
							sHtml += "<tr>"
							      +  " <td><input type=\"checkbox\" id=\"fileInfo"+listdata.stre_file_nm+"\" name=\"fileInfo\" value=\""+listdata.stre_file_nm+"\" style='"+fileViewCss+"'></td>"
							      +  " <td colspan=\"2\"><a href=\"#\" onClick=\"fnFileDown('" + listdata.atch_file_id + "')\">"
							      +  " "+listdata.orignl_file_nm +" </a></td>"
							      +  "</tr>";
							
							$("#tb_fileInfoList > tbody:last").append(sHtml);
							sHtml = "";
						}
					    $('#tb_fileInfoList').show();
					}else {
						$('#tb_fileInfoList').hide();
					}
					$popup.bPopup();
				},
				function(json) {
				    toastr.warning(json.message);
				}
			);
		} else {
			$popup.find('h2[name=h2_txt]').text("게시글 등록");
			$form.find(':text').val('');
			$form.find(':hidden').val('');
			$('#boardAllNotice').prop("checked", false); 
			$("#btnUpdate").show();
			$('#ir1').val('');
			
			if ("${regist.board_cd }"  == "Not"){
				   var url = "/backoffice/bld/centerCombo.do"
				       var returnVal = uniAjaxReturn(url, "GET", false, null, "lst");
				   fn_checkboxListJsonOnChange("sp_boardCenter", returnVal, "", "boardCenterId", "fnBoardCheck()"); 
			}
			//여기 파일 정리 하기 
			$('#tb_fileInfoList').hide();
			$("#tb_fileInfoList > tbody").empty();
						
			toggleDefault("useYn");
			$popup.bPopup();
		}
	}
	
	// 게시물 삭제
	function fnBoardDelete() {
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		if (rowId === null || rowId === undefined) {
			toastr.warning('목록을 선택해 주세요.');
			return false;
		}
		bPopupConfirm('게시물 삭제', '삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/sys/boardDelete.do', 
				{
					boardSeq: rowId
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	//게시물 등록, 수정
	function fnUpdate(){
		let $popup = $('[data-popup=bas_board_add]');
		let $form = $popup.find('form:first');
	    var sHTML = oEditors.getById["ir1"].getIR();
	    $form.find(':hidden[name=boardCn]').val(sHTML);
        if ($form.find(':text[name=boardTitle]').val() === '') {
            toastr.warning('게시물 제목을 입력해 주세요.');
            return;
        }
	    //시작일 종료일 체크 
		if (dateIntervalCheck(fn_emptyReplace($form.find(':text[name=boardNoticeStartDay]').val(),"0"), 
							  fn_emptyReplace($form.find(':text[name=boardNoticeEndDay]').val(),"0") ,
							  "시작일이 종료일 보다 앞서 있습니다.") == false) return;
		
    	//체크 박스 체그 값 알아오기 
		var uploadFileList = Object.keys(fileList);
		let formData = new FormData($popup.find('form:first')[0]);
		for (var i = 0; i < uploadFileList.length; i++) {
			formData.append('files', fileList[uploadFileList[i]]);
		}
		//사용자 값에 따른 변경값
		boardCenterId = ($('#loginAuthorCd').val() != 'ROLE_ADMIN' && $('#loginAuthorCd').val() != 'ROLE_SYSTEM') 
			? insertBoardCenterId : ckeckboxValueNoPopup("boardCenterId");
		boardAllCk = ($('#loginAuthorCd').val() != 'ROLE_ADMIN' && $('#loginAuthorCd').val() != 'ROLE_SYSTEM')  
			? "N" : $('#boardAllNotice').is(":checked") == true ? "Y" : "N";
		
		formData.append('boardCd' , $('#boardCd').val());
		/* formData.append('boardCenterId' , boardCenterId); */
		formData.append('boardAllNotice' , boardAllCk);
	    formData.append('useYn' , fn_emptyReplace($("#useYn").val(),"N"));
	    formData.append('mode' , $('#mode').val());
		
	    console.log(formData);
		bPopupConfirm('게시물 '+ ($('#mode').val() === 'Ins' ? '등록' : '수정'), '저장 하시겠습니까?', function() {
			EgovIndexApi.apiExcuteMultipart(
				'/backoffice/sys/boardUpdate.do',
				formData,
				null,
				function(json) {
				    toastr.success(json.message);
				    $popup.bPopup().close();
				    fnSearch(1);
				},
				function(json) {
				    toastr.error(json.message);
				}
			);
		});
     }
	
	function fnBoardCheck(){
		let $popup = $('[data-popup=bas_board_add]');
		let $form = $popup.find('form:first');
		var checked = ($('#boardCenterId').length != $('#boardCenterId').length ) ? false : true;
		$('#boardAllNotice').prop("checked", checked);
	}
	// 파일 전체 선택
	function fnFileCheck(){
		var checked = $("input:checkbox[name=allCheck]").is(":checked");
		fn_CheckboxAllChange("fileInfo", checked);
    }
	// 파일 다운로드
	function fnFileDown(atchFileId) {
   	 location.href = "/backoffice/sys/fileDownload.do?atchFileId=" + atchFileId	
    }
	// 파일 삭제
	function fnFileDel(){
		let $popup = $('[data-popup=bas_board_add]');
		let $form = $popup.find('form:first');
		/* var files = ckeckboxValue("체크된 값이 없습니다.", "fileInfo", ""); */
		let checkboxvalue = "";
		if($('input:checkbox[name=fileInfo]:checked').length < 1 ){
			toastr.warning("체크된 값이 없습니다.");
			return;
		} else {
			$('input:checkbox[name=fileInfo]:checked').each(function(){
				checkboxvalue = checkboxvalue+","+ $(this).val();
			});	
   			files = checkboxvalue.substring(1);
   		}
		var params = {'fileSeqs' : files  };
   		bPopupConfirm('파일 삭제', '삭제하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'GET',
				'/backoffice/sys/boardFileDelete.do',
				{fileSeqs: files},
				null,
				function(json) {
					toastr.info(json.message);
				    fnBoardInfo("Edt",$form.find(':hidden[name=boardSeq]').val());
				},
				function(json) {
				    toastr.error(json.message);
				}
			);
		});
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
		$('#input_file').bind('change', function() {
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
		var dropZone = $('#dropZone');
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
				$("#fileListTable").show();
			} else {
				$("#fileDragDesc").show(); 
				$("#fileListTable").hide();
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
			$("#fileListTable").show();
		} else {
			$("#fileDragDesc").show(); 
			$("#fileListTable").hide();
		}
	}
</script>