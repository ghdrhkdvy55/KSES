<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/backoffice/cbp-spmenu.css">
<script type="text/javascript" src="/resources/js/classie.js"></script>
<script type="text/javascript" src="/resources/js/jquery.ui.rotatable.js"></script>
<div class="title">
    <h3>시즌 좌석 GUI 화면</h3>
</div>
<div class="back_map">
    <div class="box_shadow" style="width:1000px;">
        <div class="page">
            <div class="map_box_sizing">
                <div class="mapArea">
                    <ul id="seasonSeatLayer"></ul>
                </div>
            </div>
        </div>
    </div>
    <div class="box_shadow" style="width:680px;">
        <div class="custom_bg">
            <div class="txt_con">
                <p>시즌 대상 선택</p>
                <a href="javascript:void(0);" class="defaultBtn">검색</a>
            </div>
            <table class="search_tab">
                <tr>
                    <th>지점</th>
                    <td><select id="searchCenter"></select></td>
                    <th>층</th>
                    <td><select id="searchFloor"></select></td>
                    <th>구역</th>
                    <td><select id="searchPart"></select></td>
                </tr>
            </table>
        </div>
        <div class="gui_text">
            <div class="txt_con">
                <p>좌석 설정</p>
                <a href="javascript:SeasonSeatGui.seasonGuiUpdate();" class="defaultBtn">저장</a>
            </div>
            <div class="scroll_table" style="width:650px;height:508px;padding-top:0px;">
                <div style="width:652px;margin-right:15px;">
                    <table id="seasonSeatGrid"></table>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</div>
<div class="title" style="padding:12px 40px;">
    <div style="float:right;padding-right:56px;">
        <a href="javascript:SeasonSeatGui.open();" class="grayBtn">닫기</a>
    </div>
</div>
<script type="text/javascript">
    const SeasonSeatGuiGridId = 'seasonSeatGrid';
    const SeasonSeatGuiGridSelector = '#'+ SeasonSeatGuiGridId;
    // const SeasonSeatInitialArray = new Array();
    $.SeasonSeatGui = function() {
        let $panel = this.getGui();
        $('#searchCenter', $panel).change(function() {
            SeasonSeatGui.getFloorComboList($(this).val());
        });
        $('#searchFloor', $panel).change(function() {
            SeasonSeatGui.getPartInfoComboList($(this).val());
        });
        EgovJqGridApi.defaultGrid(SeasonSeatGuiGridId, [
            { label: '좌석코드', name: 'season_seat_cd', key: true, hidden: true },
            { label: '좌석번호', name: 'season_seat_number', align: 'center', width: '100px', fixed:true, sortable: false },
            { label: '좌석명', name: 'season_seat_label', align: 'center', sortable: false },
            { label: 'TOP', name: 'season_seat_top', align: 'center', width: '100px', fixed:true, sortable: false },
            { label: 'LEFT', name: 'season_seat_left', align: 'center', width: '100px', fixed:true, sortable: false },
            { label: '사용여부', name: 'use_yn', hidden: true }
        ], true).jqGrid('setGridParam', {
            onSelectRow: function(rowId, status, e) {
                let $seasonSeatLayer = $('#seasonSeatLayer', $panel);
                if (status) {
                    $seasonSeatLayer.find('li#'+rowId).show();
                } else {
                    $seasonSeatLayer.find('li#'+rowId).hide();
                }
            }
        });
    };

    $.SeasonSeatGui.prototype.getGui = function() {
        return $('nav#cbp-spmenu-season');
    };
    $.SeasonSeatGui.prototype.open = function() {
        classie.toggle(this.getGui()[0], 'cbp-spmenu-open');
    };

    $.SeasonSeatGui.prototype.mapClear = function() {
        let $panel = this.getGui();
        $('.mapArea', $panel).css({
            'background': 'url(/resources/img/no_map.png)',
            'background-repeat': 'no-repeat',
            'background-position': 'center'
        });
        EgovJqGridApi.clearGrid(SeasonSeatGuiGridId);
        $('#seasonSeatLayer', $panel).empty();
        // SeasonSeatInitialArray.splice(0, SeasonSeatInitialArray.length);
    };

    $.SeasonSeatGui.prototype.initialize = function(seasonCd) {
        let $panel = this.getGui();
        $('.defaultBtn:eq(0)', $panel).attr('href', 'javascript:SeasonSeatGui.getSeasonSeatList(\''+ seasonCd +'\')');
        $('#searchCenter', $panel).val('').trigger('change');
        $('#searchFloor', $panel).trigger('change');
        this.mapClear();
        this.getSeasonCenterList(seasonCd);
        this.open();
    };

    $.SeasonSeatGui.prototype.getSeasonCenterList = function(seasonCd) {
        let $panel = this.getGui();
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/seasonCenterList.do',{
                seasonCd: seasonCd
            },
            function(xhr) {
                $panel.find('#searchCenter').empty();
            },
            function(json) {
                $('#searchCenter', $panel).append('<option value="">선택</option>');
                for (let item of json.resultlist) {
                    $('<option value="'+ item.center_cd +'">'+ item.center_nm +'</option>')
                        .data('item', item)
                        .appendTo($('#searchCenter', $panel));
                }
                switch ($('#loginAuthorCd').val()) {
                    case 'ROLE_ADMIN':
                    case 'ROLE_SYSTEM':
                        break;
                    default:
                        $('#searchCenter', $panel).find('option[value='+$('#loginCenterCd').val()+']').prop('selected', true);
                        $('#searchCenter', $panel).find('option:not([value='+$('#loginCenterCd').val()+'])').prop('disabled', true);
                        $('#searchCenter', $panel).trigger('change');
                }
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.SeasonSeatGui.prototype.getFloorComboList = function(centerCd) {
        let $panel = this.getGui();
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/floorComboInfo.do',{
                centerCd: centerCd
            },
            function(xhr) {
                $panel.find('#searchFloor').empty();
            },
            function(json) {
                for (let item of json.resultlist) {
                    $('<option value="'+ item.floor_cd +'">'+ item.floor_nm +'</option>')
                        .data('item', item)
                        .appendTo($('#searchFloor', $panel));
                }
                $('#searchFloor', $panel).trigger('change');
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.SeasonSeatGui.prototype.getPartInfoComboList = function(floorCd) {
        let $panel = this.getGui();
        if (floorCd === undefined || floorCd === null) {
            $panel.find('#searchPart').empty();
            return;
        }
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/partInfoComboList.do',{
                floorCd: floorCd
            },
            function(xhr) {
                $panel.find('#searchPart').empty();
            },
            function(json) {
                for (let item of json.resultlist) {
                    $('<option value="'+ item.part_cd +'">'+ item.part_nm +'</option>')
                        .data('item', item)
                        .appendTo($('#searchPart', $panel));
                }
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.SeasonSeatGui.prototype.getSeasonSeatList = function(seasonCd) {
        let $panel = this.getGui();
        if ($('#searchPart').val() === null) {
            return;
        }
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/partDetail.do',{
                partCd: $panel.find('#searchPart').val()
            },
            function(xhr) {
                SeasonSeatGui.mapClear();
            },
            function(json) {
                $('.mapArea', $panel).css({
                    'background': 'url(/upload/'+ json.result.part_map1 +')',
                    'background-repeat': 'no-repeat',
                    'background-position': 'center'
                });
                EgovJqGridApi.defaultGridAjax(SeasonSeatGuiGridId, '/backoffice/bld/seasonSeatListAjax.do', {
                    searchCenterCd: $panel.find('#searchCenter').val(),
                    searchFloorCd: $panel.find('#searchFloor').val(),
                    searchPartCd: $panel.find('#searchPart').val(),
                    seasonCd: seasonCd
                }, 500, SeasonSeatGui.drawSeasonSeat);
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.SeasonSeatGui.prototype.drawSeasonSeat = function(resultlist) {
        let $panel = SeasonSeatGui.getGui();
        for (let item of resultlist) {
            let seasonSeat = $(
                '<li class="seat" id="'+item.season_seat_cd+'" style="opacity:0.7;width:30px;height:30px;cursor:default;"></li>'
            ).data('item', item).css({
                top: item.season_seat_top +'px',
                left: item.season_seat_left +'px',
            }).appendTo($('#seasonSeatLayer', $panel));
            if (item.use_yn === 'Y') {
                $(SeasonSeatGuiGridSelector).jqGrid('setSelection', item.season_seat_cd);
            } else {
                seasonSeat.hide();
            }
            $(seasonSeat)
                .append(
                '<div class="section">'+ (item.season_seat_number === undefined ? '' : item.season_seat_number) +'</div>'
            );
            // SeasonSeatInitialArray.push(item);
        }
    };

    $.SeasonSeatGui.prototype.seasonGuiUpdate = function() {
        if ($(SeasonSeatGuiGridSelector).jqGrid('getGridParam', 'reccount') === 0) {
            return;
        }
        let arrParams = new Array();
        for (let rowId of $(SeasonSeatGuiGridSelector).jqGrid('getDataIDs')) {
            let rowData = EgovJqGridApi.getGridRowData(SeasonSeatGuiGridId, rowId);
            let useYn = $('#jqg_'+ SeasonSeatGuiGridId +'_'+rowId).prop('checked') ? 'Y' : 'N';
            if (rowData.use_yn !== useYn) {
                arrParams.push({
                    seasonSeatLabel: rowData.season_seat_label,
                    seasonSeatTop: rowData.season_seat_top,
                    seasonSeatLeft: rowData.season_seat_left,
                    'useYn': useYn,
                    seasonSeatCd: rowData.season_seat_cd
                })
            }
        }
        if (arrParams.length === 0) {
            toastr.warning('변경된 시즌 좌석 변경된 내용이 없습니다.');
            return;
        }
        bPopupConfirm('시즌좌석 저장', arrParams.length+'건에 대한 시즌좌석 설정을 저장 하시겠습니까?', function() {
            EgovIndexApi.apiExecuteJson(
                'POST',
                '/backoffice/bld/seasonGuiUpdate.do',
                arrParams,
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

    const SeasonSeatGui = new $.SeasonSeatGui();
</script>