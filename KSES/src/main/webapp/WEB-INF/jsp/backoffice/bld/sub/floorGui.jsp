<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/backoffice/cbp-spmenu.css">
<script type="text/javascript" src="/resources/js/classie.js"></script>
<script type="text/javascript" src="/resources/js/jquery.ui.rotatable.js"></script>
<div class="title">
    <h3><span id="centerNm"></span>점 <span id="floorNm"></span> GUI 화면</h3>
</div>
<div class="back_map">
    <div class="box_shadow" style="width:1000px;">
        <div class="page">
            <div class="map_box_sizing">
                <div class="mapArea">
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
                    <td><select id="searchFloor"></select></td>
                </tr>
            </table>
        </div>
        <div class="gui_text">
            <div class="txt_con">
                <p>구역 설정</p>
                <a href="javascript:FloorGui.save();" class="defaultBtn">저장</a>
            </div>
            <div class="scroll_table" style="width:650px;height:508px;padding-top:0px;">
                <div style="width:720px;margin-right:15px;">
                    <table id="guiGrid"></table>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</div>
<div class="title" style="padding:12px 40px;">
    <div style="float:right;padding-right:56px;">
        <a href="javascript:FloorGui.open();" class="grayBtn">닫기</a>
    </div>
</div>
<script type="text/javascript">
    const FloorGuiMinWidth = 60;
    const FloorGuiMinHeight = 80;
    const FloorGuiGridId = 'guiGrid';
    const FloorGuiGridSelector = '#'+ FloorGuiGridId;
    $.FloorGui = function() {
        EgovJqGridApi.popGrid(FloorGuiGridId, [
            { label: '구역코드', name: 'part_cd', key: true, hidden: true },
            { label: '구역명', name: 'part_nm', align: 'center', sortable: false },
            { label: 'TOP', name: 'part_mini_top', align: 'center', sortable: false, editable: true, editoptions: this.gridEditOptions(4) },
            { label: 'LEFT', name: 'part_mini_left', align: 'center', sortable: false, editable: true, editoptions: this.gridEditOptions(4) },
            { label: '넓이', name: 'part_mini_width', align: 'center', sortable: false, editable: true, editoptions: this.gridEditOptions(4) },
            { label: '높이', name: 'part_mini_height', align: 'center', sortable: false, editable: true, editoptions: this.gridEditOptions(4) },
            { label: '회전', name: 'part_mini_rotate', align: 'center', sortable: false, editable: true, editoptions: this.gridEditOptions(3) },
            { label: 'CSS', align: 'center', sortable: false, formatter: (c, o, row) => {
                    let colorText = 'transparent';
                    let innerHtml = '<option value="" style="background-color:transparent;">선택</option>';
                    for (let partColor of EgovIndexApi.partColorList) {
                        let classNm = partColor.split(',')[0];
                        let colorHx = partColor.split(',')[1];
                        if (row.part_css === classNm) {
                            innerHtml += '<option value="'+classNm+'" style="background-color:'+colorHx+'" selected>'+colorHx+'</option>';
                            colorText = colorHx;
                        } else {
                            innerHtml += '<option value="'+classNm+'" style="background-color:'+colorHx+'">'+colorHx+'</option>';
                        }
                    }
                    return '<select data-rowid="'+row.part_cd+'" style="background-color:'+colorText+'">'+innerHtml+'</select>';

                }
            },
        ], null, []).jqGrid('setGridParam', {
            cellEdit: true,
            cellsubmit: 'clientArray',
            beforeSaveCell: function(rowId, name, val) {
                switch (name) {
                    case 'part_mini_width':
                        if (val < FloorGuiMinWidth) {
                            return FloorGuiMinWidth;
                        }
                        break;
                    case 'part_mini_height':
                        if (val < FloorGuiMinHeight) {
                            return FloorGuiMinHeight;
                        }
                        break;
                    case 'part_mini_rotate':
                        if (val >= 360 || val < 0) {
                            return '0';
                        }
                        break;
                    default:
                }
            },
            afterSaveCell: function(rowId, name, val) {
                FloorGui.setFloorPart(rowId, name, val);
            }
        });
    };

    $.FloorGui.prototype = Object.create(ParentGUI);
    $.FloorGui.prototype.getGui = function() {
        return $('nav#cbp-spmenu-floor');
    };
    $.FloorGui.prototype.open = function() {
        classie.toggle(this.getGui()[0], 'cbp-spmenu-open');
    };

    $.FloorGui.prototype.initialize = function(floorCd) {
        let $panel = this.getGui();
        let centerGridSelectedRowId = $('#centerGrid').jqGrid('getGridParam', 'selrow');
        $('#centerNm', $panel).text($('#centerGrid').jqGrid('getRowData', centerGridSelectedRowId).center_nm);
        this.initMap($panel);
        this.setComboList(centerGridSelectedRowId, floorCd);
        this.getDetail('/backoffice/bld/floorInfoDetail.do', { floorCd: floorCd }, function(data) {
            $('#floorNm', $panel).text(data.floor_nm);
            FloorGui.setMap($panel, data.floor_map1);
        });
        this.initLayer($panel);
        this.getFloorPartList(floorCd, this.drawFloorPart);
        this.open();
    };

    $.FloorGui.prototype.setComboList = function(centerCd, floorCd) {
        let $panel = this.getGui();
        let $select = $('#searchFloor', $panel);
        $select.empty();
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/floorComboInfo.do', {
                centerCd: centerCd
            },
            null,
            function(json) {
                let list = json.resultlist;
                for (let item of list) {
                    let $option = $('<option value="'+ item.floor_cd +'">'+ item.floor_nm +'</option>').data('item', item).appendTo($select);
                    if (floorCd === item.floor_cd) {
                        $option.prop('selected', true);
                    }
                }
                $select.off('change').on('change', function() {
                    FloorGui.initialize($(this).find('option:selected').val());
                    FloorGui.open();
                });
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.FloorGui.prototype.getFloorPartList = function(floorCd, callback) {
        let jqGridParams = {
            url: '/backoffice/bld/partListAjax.do',
            postData: JSON.stringify({
                floorCd: floorCd,
                useYn: 'Y',
                pageIndex: '1',
                pageUnit: '20'
            }),
            loadComplete: function(data) {
                if (data.status === 'FAIL') {
                    toastr.error(data.message);
                    return false;
                }
                $('select', this).on('change', function() {
                    let rowId = $(this).data('rowid');
                    let cssClass = $('option:selected', this);
                    if (cssClass.val() === '') {
                        $(this).css('background-color', 'transparent');
                    } else {
                        $(this).css('background-color', cssClass.text());
                        FloorGui.setFloorPart(rowId, 'part_css', cssClass.val());
                        FloorGui.gridCellEdited(rowId);
                    }
                });
                callback(data.resultlist);
            }
        };
        $(FloorGuiGridSelector).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
    };

    $.FloorGui.prototype.setFloorPart = function(rowId, type, val) {
        let $panel = FloorGui.getGui();
        $.each($('#partLayer', $panel).find('li'), function() {
            let data = $(this).data('item');
            if (data.part_cd === rowId) {
                switch (type) {
                    case 'part_mini_top':
                        $(this).css('top', val+'px');
                        break;
                    case 'part_mini_left':
                        $(this).css('left', val+'px');
                        break;
                    case 'part_mini_width':
                        $(this).css('width', val+'px');
                        break;
                    case 'part_mini_height':
                        $(this).css('height', val+'px');
                        break;
                    case 'part_mini_rotate':
                        $(this).data('uiRotatable').angle(Math.PI * val / 180);
                        break;
                    case 'part_css':
                        $(this).find('span').attr('class', val);
                        break;
                }
                return false;
            }
        });
    };

    $.FloorGui.prototype.drawFloorPart = function(list) {
        let $panel = FloorGui.getGui();
        for (let item of list) {
            let part = $(
                '<li class="seat" style="opacity:0.7;display:inline-block;"></li>'
            ).data('item', item).css({
                top: item.part_mini_top +'px',
                left: item.part_mini_left +'px',
                width: item.part_mini_width +'px',
                height: item.part_mini_height +'px'
            }).appendTo($('#partLayer', $panel));
            $(part).resizable({
                containment: '#cbp-spmenu-floor .mapArea',
                aspectRatio: false,
                minWidth: FloorGuiMinWidth,
                minHeight: FloorGuiMinHeight,
                start: function() {
                    EgovJqGridApi.selection(FloorGuiGridId, $(this).data('item').part_cd);
                },
                stop: function() {
                    EgovJqGridApi.selection(FloorGuiGridId);
                },
                resize: function(e, ui) {
                    let rowId = $(FloorGuiGridSelector).jqGrid('getGridParam', 'selrow');
                    $(FloorGuiGridSelector).jqGrid('setCell', rowId, 'part_mini_width', Math.floor(ui.size.width))
                        .jqGrid('setCell', rowId, 'part_mini_height', Math.floor(ui.size.height));
                    FloorGui.gridCellEdited(rowId);
                }
            }).rotatable({
                degrees: item.part_mini_rotate,
                handle: $(document.createElement('img')).attr('src', '/resources/img/rotate.png'),
                wheelRotate: false,
                start: function() {
                    EgovJqGridApi.selection(FloorGuiGridId, $(this).data('item').part_cd);
                },
                stop: function() {
                    EgovJqGridApi.selection(FloorGuiGridId);
                },
                rotate: function(e, ui) {
                    let rowId = $(FloorGuiGridSelector).jqGrid('getGridParam', 'selrow');
                    $(FloorGuiGridSelector).jqGrid('setCell', rowId, 'part_mini_rotate', Math.floor(ui.angle.degrees));
                    FloorGui.gridCellEdited(rowId);
                }
            }).draggable({
                // 회전된 구역 drag 시 버그로 주석처리.
                // containment: '#cbp-spmenu-floor .mapArea',
                start: function() {
                    EgovJqGridApi.selection(FloorGuiGridId, $(this).data('item').part_cd);
                },
                stop: function() {
                    EgovJqGridApi.selection(FloorGuiGridId);
                },
                drag: function(e, ui) {
                    let rowId = $(FloorGuiGridSelector).jqGrid('getGridParam', 'selrow');
                    $(FloorGuiGridSelector).jqGrid('setCell', rowId, 'part_mini_top', Math.floor(ui.position.top))
                        .jqGrid('setCell', rowId, 'part_mini_left', Math.floor(ui.position.left));
                    FloorGui.gridCellEdited(rowId);
                }
            }).append(
                '<div class="section">'+
                    '<span class="'+ item.part_css +'">'+
                        item.part_nm +
                        '<em style="font-size:20px;">'+
                            (item.part_class_text !== '일반' ? '('+ item.part_class_text +')' : '')+
                        '</em>'+
                    '</span>'+
                '</div>'
            );
        }
    };

    $.FloorGui.prototype.save = function() {
        let changedArr = $(FloorGuiGridSelector).jqGrid('getChangedCells', 'all');
        if (changedArr.length === 0) {
            toastr.info('변경된 구역이 없습니다.');
            return;
        }
        let params = new Array();
        changedArr.forEach(x =>
            params.push({
                partCd: x.part_cd,
                partCss: $('select[data-rowid='+x.part_cd+']').val(),
                partMiniTop: x.part_mini_top,
                partMiniLeft: x.part_mini_left,
                partMiniWidth: x.part_mini_width,
                partMiniHeight: x.part_mini_height,
                partMiniRotate: x.part_mini_rotate
            })
        );
        bPopupConfirm('구역 변경', changedArr.length +'건에 대해 수정 하시겠습니까?', function() {
            EgovIndexApi.apiExecuteJson(
                'POST',
                '/backoffice/bld/partGuiUpdate.do',
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

    const FloorGui = new $.FloorGui();
</script>