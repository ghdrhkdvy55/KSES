<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/backoffice/cbp-spmenu.css">
<script type="text/javascript" src="/resources/js/classie.js"></script>
<script type="text/javascript" src="/resources/js/jquery.ui.rotatable.js"></script>
<div class="title">
    <h3><span id="centerNm"></span>점 <span name="floorNm"></span> <span id="partNm"></span> 구역 GUI 화면</h3>
</div>
<div class="back_map">
    <div class="box_shadow" style="width:1000px;">
        <div class="page">
            <div class="map_box_sizing">
                <div class="mapArea" style="background: url('/resources/img/no_image.png') center center no-repeat;">
                    <ul id="partLayer"></ul>
                </div>
            </div>
        </div>
    </div>
    <div class="box_shadow" style="width:680px;">
        <div class="custom_bg">
            <div class="txt_con">
                <p>층 선택</p>
            </div>
            <table class="search_tab">
                <tr>
                    <th>층</th>
                    <td><b><span name="floorNm"></span></b></td>
                    <th>구역</th>
                    <td><select id="searchPart"></select></td>
                </tr>
            </table>
        </div>
        <div class="gui_text">
            <div class="txt_con">
                <p>좌석 설정</p>
                <a href="javascript:void(0);" class="defaultBtn">저장</a>
            </div>
            <div class="scroll_table" style="width:650px;height:508px;padding-top:0px;">
                <div style="width:650px;margin-right:15px;">
                    <table id="guiPartGrid"></table>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</div>
<div class="title" style="padding:12px 40px;">
    <div style="float:right;padding-right:56px;">
        <a href="javascript:PartGui.open();" class="grayBtn">닫기</a>
    </div>
</div>
<script type="text/javascript">
    const PartGuiGridId = 'guiPartGrid';
    const PartGuiGridSelector = '#'+ PartGuiGridId;
    $.PartGui = function() {
        let _editoptions = function(num) {
            return {
                dataInit: function(el) {
                    EgovIndexApi.numberOnly(el);
                },
                size: num,
                maxlength: num
            }
        };
        EgovJqGridApi.popGrid(PartGuiGridId, [
            { label: '좌석코드', name: 'seat_cd', key: true, hidden: true },
            { label: '좌석명', name: 'seat_nm', align: 'center', sortable: false },
            { label: 'TOP', name: 'seat_top', align: 'center', sortable: false, editable: true, editoptions: _editoptions(4) },
            { label: 'LEFT', name: 'seat_left', align: 'center', sortable: false, editable: true, editoptions: _editoptions(4) },
        ], null, []).jqGrid('setGridParam', {
            cellEdit: true,
            cellsubmit: 'clientArray',
        });
    };
    
    $.PartGui.prototype.getGui = function() {
        return $('nav#cbp-spmenu-part');
    };
    
    $.PartGui.prototype.open = function(floorCd, floorName) {
        classie.toggle($('nav#cbp-spmenu-part')[0], 'cbp-spmenu-open');
    };
    
    $.PartGui.prototype.initialize = function(partCd) {
    	let $panel = this.getGui();
        let centerGridSelectedRowId = $('#centerGrid').jqGrid('getGridParam', 'selrow');
        $('#centerNm', $panel).text($('#centerGrid').jqGrid('getRowData', centerGridSelectedRowId).center_nm);
        this.getPart(partCd, function(data) {
            PartGui.getPartList(data.floor_cd, partCd);
            $('span[name=floorNm]', $panel).text(data.floor_nm);
            $('#partNm', $panel).text(data.part_nm);
            $('.mapArea', $panel).css({
                'background': 'url(/upload/'+ data.part_map1 +')',
                'background-repeat': 'no-repeat',
                'background-position': 'center'
            });
        });
    	this.open();
    };

    $.PartGui.prototype.getPart = function(partCd, callback) {
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/partDetail.do', {
                partCd: partCd
            },
            null,
            function(json) {
                callback(json.result);
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.PartGui.prototype.getPartList = function(floorCd, partCd) {
        let $panel = this.getGui();
        let $select = $('#searchPart', $panel);
        $select.empty();
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/partInfoComboList.do', {
                floorCd: floorCd
            },
            null,
            function(json) {
                let list = json.resultlist;
                for (let item of list) {
                    let $option = $('<option value="'+ item.part_cd +'">'+ item.part_nm +'</option>').appendTo($select);
                    if (partCd === item.part_cd) {
                        $option.prop('selected', true);
                    }
                }
                $select.off('change').on('change', function() {
                    PartGui.initialize($(this).find('option:selected').val());
                    PartGui.open();
                });
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    }
    
    const PartGui = new $.PartGui();
</script>