<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/backoffice/cbp-spmenu.css">
<script type="text/javascript" src="/resources/js/classie.js"></script>
<div class="title">
    <h3><span id="centerNm"></span>점 <span name="floorNm"></span> <span id="partNm"></span> 구역 GUI 화면</h3>
</div>
<div class="back_map">
    <div class="box_shadow" style="width:1000px;">
        <div class="page">
            <div class="map_box_sizing">
                <div class="mapArea" style="background: url('/resources/img/no_map.png') center center no-repeat;">
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
                <a href="javascript:PartGui.save();" class="defaultBtn">저장</a>
                <a href="javascript:void(0);" class="defaultBtn" style="margin-right:10px;">엑셀다운로드</a>
                <a href="javascript:void(0);" class="defaultBtn" style="margin-right:10px;">엑셀업로드</a>
                <a href="javascript:void(0);" class="defaultBtn" style="margin-right:10px;">좌석일괄등록</a>
            </div>
            <div class="scroll_table" style="width:650px;height:508px;padding-top:0px;">
                <div style="width:638px;">
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
            beforeSaveCell: function(rowId, name, val) {
                switch (name) {
                    case 'seat_top':
                    case 'seat_left':
                        if (val < 0) {
                            return 0;
                        }
                    default:
                }
            },
            afterSaveCell: function(rowId, name, val) {
                PartGui.setPartSeat(rowId, name, val);
            }
        });
    };
    
    $.PartGui.prototype.getGui = function() {
        return $('nav#cbp-spmenu-part');
    };
    
    $.PartGui.prototype.open = function(floorCd, floorName) {
        classie.toggle($('nav#cbp-spmenu-part')[0], 'cbp-spmenu-open');
    };
    
    $.PartGui.prototype.initialize = function(partCd, floorCd) {
    	let $panel = this.getGui();
        let centerGridSelectedRowId = $('#centerGrid').jqGrid('getGridParam', 'selrow');
        $('#centerNm', $panel).text($('#centerGrid').jqGrid('getRowData', centerGridSelectedRowId).center_nm);
        this.getPartList(floorCd, partCd);
        this.getPart(partCd, function(data) {
            $('span[name=floorNm]', $panel).text(data.floor_nm);
            $('#partNm', $panel).text(data.part_nm);
            $('.mapArea', $panel).css({
                'background': 'url(/upload/'+ data.part_map1 +')',
                'background-repeat': 'no-repeat',
                'background-position': 'center'
            }).data('item', data);
        });
        $('#partLayer', $panel).empty();
        this.getPartSeatList(centerGridSelectedRowId, floorCd, partCd, this.drawPartSeat);
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
                    let $option = $('<option value="'+ item.part_cd +'">'+ item.part_nm +'</option>').data('item', item).appendTo($select);
                    if (partCd === item.part_cd) {
                        $option.prop('selected', true);
                    }
                }
                $select.off('change').on('change', function() {
                    let data = $(this).find('option:selected').data('item');
                    PartGui.initialize(data.part_cd, data.floor_cd);
                    PartGui.open();
                });
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.PartGui.prototype.getPartSeatList = function(centerCd, floorCd, partCd, callback) {
        let jqGridParams = {
            url: '/backoffice/bld/seatListAjax.do',
            postData: JSON.stringify({
                searchCenter: centerCd,
                searchFloorCd: floorCd,
                searchPartCd: partCd,
                useYn: 'Y',
                pageIndex: '1',
                pageUnit: '500'
            }),
            rowNum: 500,
            loadComplete: function(data) {
                if (data.status === 'FAIL') {
                    toastr.error(data.message);
                    return false;
                }
                callback(data.resultlist);
            }
        };
        $(PartGuiGridSelector).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
    };

    $.PartGui.prototype.setPartSeat = function(rowId, type, val) {
        let $panel = PartGui.getGui();
        $.each($('#partLayer', $panel).find('li'), function() {
            let data = $(this).data('item');
            if (data.seat_cd === rowId) {
                switch (type) {
                    case 'seat_top':
                        $(this).css('top', val+'px');
                        break;
                    case 'seat_left':
                        $(this).css('left', val+'px');
                        break;
                    default:
                }
                return false;
            }
        });
    };

    $.PartGui.prototype.drawPartSeat = function(list) {
        let $panel = PartGui.getGui();
        let idx = 0;
        for (let item of list) {
            let seat = $(
                '<li class="seat" style="opacity:0.7;display:inline-block;width:30px;height:30px;"></li>'
            ).data('item', item).css({
                top: item.seat_top +'px',
                left: item.seat_left +'px',
            }).appendTo($('#partLayer', $panel));
            $(seat).draggable({
                containment: '#cbp-spmenu-part .mapArea',
                start: function() {
                    EgovJqGridApi.selection(PartGuiGridId, $(this).data('item').seat_cd);
                    let rowId = $(PartGuiGridSelector).jqGrid('getGridParam', 'selrow');
                    $(PartGuiGridSelector).closest('.scroll_table').scrollTop($('#'+$.jgrid.jqID(rowId))[0].offsetTop);
                },
                stop: function() {
                    EgovJqGridApi.selection(PartGuiGridId);
                },
                drag: function(e, ui) {
                    let rowId = $(PartGuiGridSelector).jqGrid('getGridParam', 'selrow');
                    $(PartGuiGridSelector).jqGrid('setCell', rowId, 'seat_top', Math.floor(ui.position.top))
                        .jqGrid('setCell', rowId, 'seat_left', Math.floor(ui.position.left));
                    $("#"+$.jgrid.jqID(rowId)).addClass("edited");
                }
            }).append(
                '<div class="section">'+ (++idx)+ '</div>'
            );
        }
    };

    $.PartGui.prototype.save = function() {
        let changedArr = $(PartGuiGridSelector).jqGrid('getChangedCells', 'all');
        if (changedArr.length === 0) {
            toastr.info('변경된 좌석이 없습니다.');
            return;
        }
        let params = new Array();
        changedArr.forEach(x =>
            params.push({
                seatCd: x.seat_cd,
                seatTop: x.seat_top,
                seatLeft: x.seat_left
            })
        );
        bPopupConfirm('좌석 위치 변경', changedArr.length +'건에 대해 수정 하시겠습니까?', function() {
            EgovIndexApi.apiExecuteJson(
                'POST',
                '/backoffice/bld/seatGuiUpdate.do',
                params,
                null,
                function(json) {
                    toastr.success(json.message);
                },
                function(json) {
                    toastr.error(json.message);
                }
            );
        });
    };
    
    const PartGui = new $.PartGui();
</script>