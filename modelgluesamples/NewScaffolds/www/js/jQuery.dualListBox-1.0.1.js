/*
*       Developed by Justin Mead
*       ©2009 MeadMiracle
*		www.meadmiracle.com / meadmiracle@gmail.com
*       Version 1.0
*       Testing: IE7/Windows XP
*                Firefox/Windows XP
*       Licensed under the Creative Commons GPL http://creativecommons.org/licenses/GPL/2.0/
*
*       OPTIONS LISTING:
*           *box1View, box2View         - the id attributes of the VISIBLE listboxes
*           *box1Storage, box2Storage   - the id attributes of the HIDDEN listboxes (used for filtering)
*           *box1Filter, box2Filter     - the id attributes of the textboxes used to filter the lists
*           *box1Clear, box2Clear       - the id attributes of the elements used to clear/reset the filters
*           *box1Counter, box2Counter   - the id attributes of the elements used to display counts of visible/total items (used when filtering)
*           *to1, to2                   - the id attributes of the elements used to transfer only selected items between boxes
*           *allTo1, allTo2             - the id attributes of the elements used to transfer ALL (visible) items between boxes
*           *transferMode               - the type of transfer to perform on items (see heading TRANSFER MODES)
*           *sortBy                     - the attribute to use when sorting items (values: 'text' or 'value')
*           *useFilters                 - allow the filtering of items in either box (true/false)
*           *useCounters                - use the visible/total counters (true/false)
*           *useSorting                 - sort items after executing a transfer (true/false)
*
*       All options have default values, and as such, are optional.  Check the 'settings' JSON object below to see the defaults.
*
*       TRANSFER MODES:
*           * 'move' - In this mode, items will be removed from the box in which they currently reside and moved to the other box. This is the default.
*           * 'copy' - In this mode, items in box 1 will ALWAYS remain in box 1 (unless they are hidden by filtering).  When they are selected for transfer
*                      they will be copied to box 2 and will be given the class 'copiedOption' in box 1 (my default styling for this class is yellow background
*                      but you may choose whatever styling suits you).  If they are then transferred from box 2, they disappear from box 2, and the 'copiedOption'
*                      class is removed from the corresponding option in box 1.
*
*/

(function($) {
    var settings;
    var group1;
    var group2;
    var onSort;

    //the main method that the end user will execute to setup the DLB
    $.configureBoxes = function(options) {
        //define default settings
        settings = {
            box1View: 'box1View',
            box1Storage: 'box1Storage',
            box1Filter: 'box1Filter',
            box1Clear: 'box1Clear',
            box1Counter: 'box1Counter',
            box2View: 'box2View',
            box2Storage: 'box2Storage',
            box2Filter: 'box2Filter',
            box2Clear: 'box2Clear',
            box2Counter: 'box2Counter',
            to1: 'to1',
            allTo1: 'allTo1',
            to2: 'to2',
            allTo2: 'allTo2',
            transferMode: 'move',
            sortBy: 'text',
            useFilters: true,
            useCounters: true,
            useSorting: true
        };

        //merge default settings w/ user defined settings (with user-defined settings overriding defaults)
        $.extend(settings, options);

        //define box groups
        group1 = {
            view: settings.box1View,
            storage: settings.box1Storage,
            filter: settings.box1Filter,
            clear: settings.box1Clear,
            counter: settings.box1Counter
        };
        group2 = {
            view: settings.box2View,
            storage: settings.box2Storage,
            filter: settings.box2Filter,
            clear: settings.box2Clear,
            counter: settings.box2Counter
        };

        //define sort function
        if (settings.sortBy == 'text') {
            onSort = function(a, b) {
                var aVal = a.text.toLowerCase();
                var bVal = b.text.toLowerCase();
                if (aVal < bVal) { return -1; }
                if (aVal > bVal) { return 1; }
                return 0;
            };
        } else {
            onSort = function(a, b) {
                var aVal = a.value.toLowerCase();
                var bVal = b.value.toLowerCase();
                if (aVal < bVal) { return -1; }
                if (aVal > bVal) { return 1; }
                return 0;
            };
        }

        //configure events
        if (settings.useFilters) {
            $('#' + group1.filter).keyup(function() {
                Filter(group1);
            });
            $('#' + group2.filter).keyup(function() {
                Filter(group2);
            });
            $('#' + group1.clear).click(function() {
                ClearFilter(group1);
            });
            $('#' + group2.clear).click(function() {
                ClearFilter(group2);
            });
        }
        if (IsMoveMode()) {
            $('#' + group2.view).dblclick(function() {
                MoveSelected(group2, group1);
            });
            $('#' + settings.to1).click(function() {
                MoveSelected(group2, group1);
            });
            $('#' + settings.allTo1).click(function() {
                MoveAll(group2, group1);
            });
        } else {
            $('#' + group2.view).dblclick(function() {
                RemoveSelected(group2, group1);
            });
            $('#' + settings.to1).click(function() {
                RemoveSelected(group2, group1);
            });
            $('#' + settings.allTo1).click(function() {
                RemoveAll(group2, group1);
            });
        }
        $('#' + group1.view).dblclick(function() {
            MoveSelected(group1, group2);
        });
        $('#' + settings.to2).click(function() {
            MoveSelected(group1, group2);
        });
        $('#' + settings.allTo2).click(function() {
            MoveAll(group1, group2);
        });

        //initialize the counters
        if (settings.useCounters) {
            UpdateLabel(group1);
            UpdateLabel(group2);
        }

        //pre-sort item sets
        if (settings.useSorting) {
            SortOptions(group1);
            SortOptions(group2);
        }

        //hide the storage boxes
        $('#' + group1.storage + ',#' + group2.storage).css('display', 'none');
    };

    function UpdateLabel(group) {
        var showingCount = $("#" + group.view + " option").size();
        var hiddenCount = $("#" + group.storage + " option").size();
        $("#" + group.counter).text('Showing ' + showingCount + ' of ' + (showingCount + hiddenCount));
    }

    function Filter(group) {
        var filterLower;
        if (settings.useFilters) {
            filterLower = $('#' + group.filter).val().toString().toLowerCase();
        } else {
            filterLower = '';
        }
        $('#' + group.view + ' option').filter(function(i) {
            var toMatch = $(this).text().toString().toLowerCase();
            return toMatch.indexOf(filterLower) == -1;
        }).appendTo('#' + group.storage);
        $('#' + group.storage + ' option').filter(function(i) {
            var toMatch = $(this).text().toString().toLowerCase();
            return toMatch.indexOf(filterLower) != -1;
        }).appendTo('#' + group.view);
        try {
            $('#' + group.view + ' option').removeAttr('selected');
        }
        catch (ex) {
            //swallow the error for IE6
        }
        if (settings.useSorting) { SortOptions(group); }
        if (settings.useCounters) { UpdateLabel(group); }
    }

    function SortOptions(group) {
        var $toSortOptions = $('#' + group.view + ' option');
        $toSortOptions.sort(onSort);
        $('#' + group.view).empty().append($toSortOptions);
    }

    function MoveSelected(fromGroup, toGroup) {
        if (IsMoveMode()) {
            $('#' + fromGroup.view + ' option:selected').appendTo('#' + toGroup.view);
        } else {
            $('#' + fromGroup.view + ' option:selected:not([class*=copiedOption])').clone().appendTo('#' + toGroup.view).end().end().addClass('copiedOption');
        }
        try {
            $('#' + fromGroup.view + ' option,#' + toGroup.view + ' option').removeAttr('selected');
        }
        catch (ex) {
            //swallow the error for IE6
        }
        Filter(toGroup);
        if (settings.useCounters) { UpdateLabel(fromGroup); }
    }

    function MoveAll(fromGroup, toGroup) {
        if (IsMoveMode()) {
            $('#' + fromGroup.view + ' option').appendTo('#' + toGroup.view);
        } else {
            $('#' + fromGroup.view + ' option:not([class*=copiedOption])').clone().appendTo('#' + toGroup.view).end().end().addClass('copiedOption');
        }
        try {
            $('#' + fromGroup.view + ' option,#' + toGroup.view + ' option').removeAttr('selected');
        }
        catch (ex) {
            //swallow the error for IE6
        }
        Filter(toGroup);
        if (settings.useCounters) { UpdateLabel(fromGroup); }
    }

    function RemoveSelected(removeGroup, otherGroup) {
        $('#' + otherGroup.view + ' option.copiedOption').add('#' + otherGroup.storage + ' option.copiedOption').remove();
        try {
            $('#' + removeGroup.view + ' option:selected').appendTo('#' + otherGroup.view).removeAttr('selected');
        }
        catch (ex) {
            //swallow the error for IE6
        }
        $('#' + removeGroup.view + ' option').add('#' + removeGroup.storage + ' option').clone().addClass('copiedOption').appendTo('#' + otherGroup.view);
        Filter(otherGroup);
        if (settings.useCounters) { UpdateLabel(removeGroup); }
    }

    function RemoveAll(removeGroup, otherGroup) {
        $('#' + otherGroup.view + ' option.copiedOption').add('#' + otherGroup.storage + ' option.copiedOption').remove();
        try {
            $('#' + removeGroup.storage + ' option').clone().addClass('copiedOption').add('#' + removeGroup.view + ' option').appendTo('#' + otherGroup.view).removeAttr('selected');
        }
        catch (ex) {
            //swallow the error for IE6
        }
        Filter(otherGroup);
        if (settings.useCounters) { UpdateLabel(removeGroup); }
    }

    function ClearFilter(group) {
        $('#' + group.filter).val('');
        $('#' + group.storage + ' option').appendTo('#' + group.view);
        try {
            $('#' + group.view + ' option').removeAttr('selected');
        }
        catch (ex) {
            //swallow the error for IE6
        }
        if (settings.useSorting) { SortOptions(group); }
        if (settings.useCounters) { UpdateLabel(group); }
    }

    function IsMoveMode() {
        return settings.transferMode == 'move';
    }
})(jQuery);