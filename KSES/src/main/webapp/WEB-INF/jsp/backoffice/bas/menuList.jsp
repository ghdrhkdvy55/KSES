<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<!-- JSTree -->
<link rel="stylesheet" href="/resources/css/style.min.css">
<script type="text/javascript" src="/resources/js/jstree.min.js"></script>
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div{
	outline-style: none;
	height: 30px;
}
.ui-jqgrid tr.jqgrow {
	outline-style: none;
	height: 30px;
}
.input_form input,textarea {
	width:500px;
}
</style>
<!-- //contents -->
<div class="breadcrumb">
  <ol class="breadcrumb-item">
    <li>기초 관리&nbsp;&gt;&nbsp;</li>
    <li class="active">메뉴 관리</li>
  </ol>
</div>
<h2 class="title">메뉴 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
		<div class="box_shadow custom_bg custom_bg02 xs-6">
			<div class="input_form">
				<div class="box_padding" id="jstree"></div>
			</div>
		</div>
		<div class="xs-6">
			<h2 id="detail_tit" class="pop_tit">메뉴 등록</h2>
			<div class="input_form">
			<form>
				<input type="hidden" name="mode" value="Ins">
				<table>
					<tbody>
						<tr>
							<th>메뉴아이디</th>
							<td>
								<input type="text" name="menuNo" style="width:410px;">
								<span id="sp_Unqi" style="display:none;">
	                            	<a href="javascript:fnIdCheck();" class="blueBtn">중복확인</a>
	                            	<input type="hidden" id="idCheck" value="N">
	                            </span>
							</td>
						</tr>
						<tr>
							<th>메뉴명</th>
							<td>
								<input type="text" name="menuNm">
							</td>
						</tr>
						<tr>
							<th>상위메뉴명</th>
							<td>
								<input type="hidden" name="upperMenuNo">
								<input type="text" name="upperMenuNm">
							</td>
						</tr>
						<tr>
							<th>메뉴순서</th>
							<td>
								<input type="text" name="menuOrdr">
							</td>
						</tr>
						<tr>
							<th>프로그램</th>
							<td>
								<input type="hidden" name="progrmFileNm">
								<input type="text" name="progrmKoreannm" readonly>
								<a href="javascript:fnProgramPopup();" class="grayBtn">검색</a>
							</td>
						</tr>
						<tr>
							<th>메뉴설명</th>
							<td>
								<textarea name="menuDc" style="height:120px;"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="top10" style="padding:10px 0 0 520px;border-top:1px solid #e4e4e4;">
					<button type="button" class="blueBtn">저장</button>
					<button type="button" onclick="fnJstreeRefresh();" class="grayBtn" style="display:none;">취소</button>
				</div>
				<div class="clear"></div>
			</form>
			</div>
		</div>
	</div>
</div>
<!-- 프로그램 추가 팝업 -->
<div data-popup="bas_progrm_create" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">프로그램 선택</h2>
		<div class="pop_wrap" style="width:620px;">
			<div class="whiteBox searchBox">
	            <div class="top">                    
	                <p>검색어</p>
	                <input type="text" id="searchKeyword" placeholder="검색어를 입력하세요." autocomplete="off">
	            </div>
	            <div class="inlineBtn">
	                <a href="javascript:fnProgramSearch(1);" class="grayBtn">검색</a>
	            </div>
	        </div>
			<div style="width:580px;">
				<table id="popGrid"></table>
				<div id="popPager" style="text-align:center;"></div>
			</div> 
		</div>
		<div class="right_box">
			<button type="button" class="blueBtn">선택</button>
			<button type="button" class="grayBtn b-close">닫기</button>
		</div>
		<div class="clear"></div>
	</div>
</div>
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 메뉴 트리 정의
		$('#jstree').jstree({
			core: {
				check_callback: true,
				themes: {
					icons: true,
					dots: true
				}
			},
			types: {
				valid_children: [ 'default' ],
				'default': {
					icon: '/resources/img/seat_icon_ui03.png'
				}
			},
			contextmenu: {
				items: {
					'create': {
						separator_before: false,
						separator_after: true,
						label: '하위메뉴 생성',
						icon: '/resources/img/sub_add.png',
						action: function(data) {
							let $tree = $.jstree.reference(data.reference);
							let node = $tree.get_selected(true)[0];
							if (node.data === null) {
								toastr.warning('저장된 메뉴만 하위메뉴를 생성할 수 있습니다.');
								return;
							}
							if (node.data.level === 3) {
								toastr.warning('더 이상 하위메뉴를 생성할 수 없습니다.');
								return;
							}
							node = $tree.create_node(node.id, { type: 'default' }, 'last');
							$tree.edit(node);
						}
					},
					'delete': {
						separator_before: false,
						separator_after: true,
						label: '해당메뉴 제거',
						icon: '/resources/img/sub_del.png',
						action: function(data) {
							let $tree = $.jstree.reference(data.reference);
							let node = $tree.get_selected(true)[0];
							if (node.data === null) {
								$tree.delete_node(node.id);
								return;
							}
							if (node.children.length > 0) {
								toastr.warning('하위 메뉴가 있는 메뉴는 제거할 수 없습니다.');
								return;
							}
							fnMenuInfoDelete(node);
						}
					}
				}
			},
			plugins : [ 'types', 'contextmenu', 'wholerow' ]
		}).on('refresh.jstree', function(e, data) { // 트리 새로고침 시 -> 루트 노드 선택
			let rootId = data.instance.get_node('#').children[0];
			$(this).jstree('select_node', rootId);
		}).on('select_node.jstree', function(e, data) { // 노드 선택 시 -> 메뉴 수정 
			let ret = data.node.data;
			if (data.node.data === null) {
				return;
			}
			let $form = $('.input_form form');
			$('#detail_tit').html('메뉴 수정');
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':text[name=menuNo]').prop('readonly', true).val(ret.menu_no);
			$form.find(':text[name=menuNm]').val($.trim(ret.menu_nm));
			$form.find(':hidden[name=upperMenuNo]').val(ret.upper_menu_no);
			$form.find(':text[name=upperMenuNm]').val(ret.upper_menu_nm);
			$form.find(':text[name=menuOrdr]').val(ret.menu_ordr);
			$form.find(':hidden[name=progrmFileNm]').val(ret.progrm_file_nm);
			$form.find(':text[name=progrmKoreannm]').val(ret.progrm_koreannm);
			$form.find('textarea').val(ret.menu_dc);
			$form.find('button.blueBtn').off('click').click(fnMenuInfoUpdate);
			$form.find('button.grayBtn').hide();
			$form.find('span#sp_Unqi').hide();
		}).on('rename_node.jstree', function(e, data, o) { // 노드 이름 변경 시 -> 메뉴 등록
			let parent = data.instance.get_node(data.node.parent);
			let $form = $('.input_form form');
			$('#detail_tit').html('메뉴 등록');
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':hidden#idCheck').val('N');
			$form.find(':text,textarea').val('');
			$form.find(':text[name=menuNo]').removeAttr('readonly');
			$form.find(':text[name=menuNm]').val(data.text);
			$form.find(':hidden[name=upperMenuNo]').val(parent.id);
			$form.find(':text[name=upperMenuNm]').val(parent.text);
			$form.find(':text[name=menuOrdr]').val('0');
			$form.find('button.blueBtn').off('click').click(fnMenuInfoInsert);
			$form.find('button.grayBtn').show();
			$form.find('span#sp_Unqi').show();
		});
		// 팝업 JqGrid 정의
		EgovJqGridApi.popGrid('popGrid', [
			{ label: '파일명', name: 'progrm_file_nm', align: 'left', sortable: false, key: true },
			{ label: '한글명',  name: 'progrm_koreannm', align: 'left', sortable: false },
			{ label: '저장경로', name: 'progrm_stre_path', align: 'left', sortable: false }
		], 'popPager').jqGrid('setGridParam', {
			ondblClickRow: function(rowId, iRow, iCol, e) {
				let rowData = $(this).jqGrid('getRowData', rowId);
				fnProgramSelect(rowData);
			}
		});
		// 프로그램 선택 팝업 [선택] 버튼 클릭 시 
		$('[data-popup=bas_progrm_create] .blueBtn').click(function(e) {
			let rowId = $('#popGrid').jqGrid('getGridParam', 'selrow');
			let rowData = $('#popGrid').jqGrid('getRowData', rowId);
			fnProgramSelect(rowData);
		});
		fnJstreeRefresh();
	});
	// 전체 메뉴 정보 얻기 -> 메뉴 트리 새로 고침
	function fnJstreeRefresh() {
		$('#jstree').jstree(true).deselect_all();
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/bas/menuListAjax.do',{
				pageIndex: '1',
				pageUnit: '1000'	
			},
			null,
			function(json) {
				let arr = new Array();
				for (var m of json.resultlist) {
					let obj = {
						id: m.menu_no,
						parent: m.upper_menu_no == null ? '#' : m.upper_menu_no,
						text: m.upper_menu_no == null ? '관리자' : $.trim(m.menu_nm),
						state: {
							opened: true
						},
						data: m
					};
					arr.push(obj);
				}
				$('#jstree').jstree(true).settings.core.data = arr;
				$('#jstree').jstree(true).refresh();
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
	// 메뉴아이디 중복 체크
	function fnIdCheck() {
		let $form = $('.input_form form');
		if ($form.find(':text[name=menuNo]').val() === '') {
			toastr.warning('메뉴아이디를 입력해 주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/bas/menuNoCheck.do', {
				'menuNo': $form.find(':text[name=menuNo]').val()
			},
			null,
			function(json) {
				$form.find(':hidden#idCheck').val('Y');
				toastr.info(json.message);
			},
			function(json) {
				toastr.warning(json.message);
			}
		);
	}
	// 메뉴 등록
	function fnMenuInfoInsert() {
		let $form = $('.input_form form');
		if ($form.find(':text[name=menuNo]').val() === '') {
			toastr.warning('메뉴아이디를 입력해 주세요.');
			return;
		}
		if ($form.find(':hidden#idCheck').val() === '') {
			toastr.warning('중복체크가 안되었습니다.');
			return;
		}
		if ($form.find(':hidden[name=progrmFileNm]').val() === '') {
			toastr.warning('선택된 프로그램 정보가 없습니다.');
			return;
		}
		bPopupConfirm('메뉴 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/menuInfoUpdate.do', 
				$form.serializeObject(),
				null,
				function(json) {
					toastr.success(json.message);
					fnJstreeRefresh();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 메뉴 수정
	function fnMenuInfoUpdate() {
		let $form = $('.input_form form');
		if ($form.find(':hidden[name=progrmFileNm]').val() === '') {
			toastr.warning('선택된 프로그램 정보가 없습니다.');
			return;
		}
		let node = $('#jstree').jstree('get_selected',true)[0];
		let nodeData = node.data;
		bPopupConfirm('메뉴 수정', '<b>'+ $.trim(nodeData.menu_nm) +'</b>을(를) 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/menuInfoUpdate.do', 
				$form.serializeObject(),
				null,
				function(json) {
					toastr.success(json.message);
					fnJstreeRefresh();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 메뉴 제거
	function fnMenuInfoDelete(node) {
		let nodeData = node.data;
		bPopupConfirm('메뉴 삭제', '<b>'+ $.trim(nodeData.menu_nm) +'</b>을(를) 삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/menuManageDelete.do', {
					menuNo: nodeData.menu_no	
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnJstreeRefresh();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 프로그램 선택 팝업 호출
	function fnProgramPopup() {
		let $popup = $('[data-popup=bas_progrm_create]');
		$popup.find('#searchKeyword').val('');
		fnProgramSearch(1);
		$popup.bPopup();
	}
	// 프로그램 선택 팝업 검색
	function fnProgramSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: '5',
			searchKeyword: $('[data-popup=bas_progrm_create] #searchKeyword').val()
		};
		EgovJqGridApi.popGridAjax('popGrid', '/backoffice/bas/progrmListAjax.do', params, fnProgramSearch);
	}
	// 프로그램 선택 시
	function fnProgramSelect(rowData) {
		let $popup = $('[data-popup=bas_progrm_create]');
		let $form = $('.input_form form');
		$form.find(':hidden[name=progrmFileNm]').val(rowData.progrm_file_nm);
		$form.find(':text[name=progrmKoreannm]').val(rowData.progrm_koreannm);
		$popup.bPopup().close();
	}
	
</script>