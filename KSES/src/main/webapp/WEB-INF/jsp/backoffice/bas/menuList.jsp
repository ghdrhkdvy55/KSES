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
			<div class="input_form">
			<form>
				<input type="hidden" name="mode" value="Ins">
				<table>
					<tbody>
						<tr>
							<th>메뉴아이디</th>
							<td>
								<input type="text" name="menuId" style="width:410px;">
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
								<input type="text" name="progrmFileNm" readonly>
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
					<button class="blueBtn">저장</button>
				</div>
				<div class="clear"></div>
			</form>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function() {
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
					icon: 'jstree-folder'
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
							if (node.children.length > 0) {
								toastr.warning('하위 메뉴가 있는 메뉴는 제거할 수 없습니다.');
								return;
							}
							fnMenuInfoDelete(node.id);
						}
					}
				}
			},
			plugins : [ 'types', 'contextmenu', 'wholerow' ]
		}).on('refresh.jstree', function(e, data) {
			let rootId = data.instance.get_node('#').children[0];
			$(this).jstree('select_node', rootId);
		}).on('select_node.jstree', function(e, data) {
			let ret = data.node.data;
			let $form = $('.input_form form');
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':text[name=menuId]').prop('readonly', true).val(ret.menu_no);
			$form.find(':text[name=menuNm]').val($.trim(ret.menu_nm));
			$form.find(':hidden[name=upperMenuNo]').val(ret.upper_menu_no);
			$form.find(':text[name=upperMenuNm]').val('');
			$form.find(':text[name=menuOrdr]').val(ret.menu_ordr);
			$form.find(':text[name=progrmFileNm]').val(ret.progrm_file_nm);
			$form.find('textarea').val(ret.menu_dc);
			$form.find('.blueBtn').off('click').click(fnMenuInfoUpdate);
			$form.find('span#sp_Unqi').hide();
		}).on('rename_node.jstree', function(e, data, o) {
			let parent = data.instance.get_node(data.node.parent);
			let $form = $('.input_form form');
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':hidden#idCheck').val('N');
			$form.find(':text,textarea').val('');
			$form.find(':text[name=menuId]').removeAttr('readonly');
			$form.find(':text[name=menuNm]').val(data.text);
			$form.find(':hidden[name=upperMenuNo]').val(parent.id);
			$form.find(':text[name=upperMenuNm]').val(parent.text);
			$form.find('.blueBtn').off('click').click(fnMenuInfoInsert);
			$form.find('span#sp_Unqi').show();
		});
		fnJstreeRefresh();
	});
	
	function fnJstreeRefresh() {
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
	
	function fnMenuInfoInsert() {
		
	}
	
	function fnMenuInfoUpdate() {
		
	}
	
	function fnMenuInfoDelete(menuNo) {
		console.log(menuNo)
	}
	
</script>