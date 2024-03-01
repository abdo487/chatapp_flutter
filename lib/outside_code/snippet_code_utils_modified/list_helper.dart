library snippetcoder_utils;

import 'package:flutter/material.dart';

class ListUtils {
  static Widget buildDataTable<T>(
    BuildContext context,
    List<String> columns,
    List<String> fields,
    bool sortAscending,
    int? sortColumnIndex,
    dynamic listOfData,
    Function onEditTap,
    Function onDeleteTap, {
    Function? onSort,
    double headingRowHeight = 45,
    Color headingRowColor = Colors.redAccent,
    double columnTextFontSize = 15,
    bool columnTextBold = true,
    double columnSpacing = 30,
    Widget? actionWidget,
    Widget? actionEditWidget,
    Widget? actionDeleteWidget,
    Function? onActionTap,
    bool isScrollable = false,
    // bool refreshIndicator = false,
    // Key refreshkey,
    // Function onRefresh,
  }) {
    List<DataRow> rows = [];

    listOfData.forEach(
      (model) {
        rows.add(
          DataRow(
            cells: fields.map(
              (field) {
                if (field == "") {
                  List<Widget> actionWidgets = [];

                  if (actionEditWidget == null) {
                    actionWidgets.add(
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onTap: () {
                          return onEditTap(model);
                        },
                      ),
                    );
                  } else {
                    actionWidgets.add(
                      GestureDetector(
                        child: actionEditWidget,
                        onTap: () {
                          return onEditTap(model);
                        },
                      ),
                    );
                  }

                  if (actionDeleteWidget == null) {
                    actionWidgets.add(
                      GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          return onDeleteTap(model);
                        },
                      ),
                    );
                  } else {
                    actionWidgets.add(
                      GestureDetector(
                        child: actionDeleteWidget,
                        onTap: () {
                          return onDeleteTap(model);
                        },
                      ),
                    );
                  }

                  if (actionWidget != null) {
                    actionWidgets.add(
                      GestureDetector(
                        child: actionWidget,
                        onTap: () {
                          return onActionTap!(model);
                        },
                      ),
                    );
                  }

                  return DataCell(
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: actionWidgets,
                      ),
                    ),
                  );
                } else {
                  return DataCell(
                    Text(
                      _getValue(model.toJson(), field).toString(),
                    ),
                  );
                }
              },
            ).toList(),
          ),
        );
      },
    );

    // return refreshIndicator
    //     ? Container(
    //         child: RefreshIndicator(
    //           key: refreshkey,
    //           onRefresh: () {
    //             return onRefresh();
    //           },
    //           child: _dataTable<T>(
    //             context,
    //             columns,
    //             fields,
    //             sortAscending,
    //             sortColumnIndex,
    //             listOfData,
    //             onEditTap,
    //             onDeleteTap,
    //             rows,
    //             onSort: onSort,
    //             headingRowHeight: headingRowHeight,
    //             headingRowColor: headingRowColor,
    //             columnTextFontSize: columnTextFontSize,
    //             columnTextBold: columnTextBold,
    //             columnSpacing: columnSpacing,
    //           ),
    //         ),
    //       )
    return _dataTable<T>(
      context,
      columns,
      fields,
      sortAscending,
      sortColumnIndex,
      listOfData,
      onEditTap,
      onDeleteTap,
      rows,
      onSort: onSort!,
      headingRowHeight: headingRowHeight,
      headingRowColor: headingRowColor,
      columnTextFontSize: columnTextFontSize,
      columnTextBold: columnTextBold,
      columnSpacing: columnSpacing,
      isScrollable: isScrollable,
    );
  }

  static Widget _dataTable<T>(
    BuildContext context,
    List<String> columns,
    List<String> fields,
    bool sortAscending,
    int? sortColumnIndex,
    dynamic listOfData,
    Function onEditTap,
    Function onDeleteTap,
    List<DataRow> rows, {
    Function? onSort,
    double headingRowHeight = 45,
    Color headingRowColor = Colors.redAccent,
    double columnTextFontSize = 15,
    bool columnTextBold = true,
    double columnSpacing = 30,
    bool isScrollable = false,
  }) {
    Widget _table = DataTable(
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => headingRowColor,
      ),
      headingRowHeight: headingRowHeight,
      sortAscending: sortAscending,
      sortColumnIndex: sortColumnIndex,
      columns: columns.map(
        (columnName) {
          return DataColumn(
            label: Text(
              columnName,
              style: TextStyle(
                fontSize: columnTextFontSize,
                fontWeight: columnTextBold ? FontWeight.w900 : null,
              ),
            ),
            onSort: (columnIndex, ascending) {
              return onSort!(columnIndex, fields[columnIndex], ascending);
            },
          );
        },
      ).toList(),
      columnSpacing: columnSpacing,
      rows: rows,
    );

    return isScrollable
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _table,
            ),
          )
        : Container(width: MediaQuery.of(context).size.width, child: _table);
  }

  static dynamic _getValue(Map<String, dynamic> _mapRep, String propertyName) {
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName] ?? "";
    }
    throw ArgumentError('Propery not found : $propertyName');
  }
}
